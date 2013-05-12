package net3dprintweb.service.shapeways.base.action
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;

	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	import net3dprintweb.service.shapeways.auth.token.ShapewaysAccessToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysConsumer;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysOAuthTokenManager;

	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;

	public class ShapewaysBaseAction extends EventDispatcher
	{
		protected const BASE_URL:String = "api.shapeways.com";

		public function ShapewaysBaseAction()
		{
		}

		protected function createQueryObject(query:String):Object {

			var params:Array = query.split('&');
			var length:int = params.length;
			var queryObj:Object = new Object();
			for (var i:int=0; i < length; i++) {
				var param:String = params[i];
				var index:int = param.indexOf("=");
				queryObj[param.substring(0, index)] = param.substring(index + 1);
			}
			return queryObj;
		}

		protected function encodeURI(value:String):String
		{
			var oAuthCharacterEncode:Function = function (matchedSubstring:String, capturedMatch1:String, index:int, str:String):String
			{
				var charCode:String = capturedMatch1.charCodeAt(0).toString(16).toUpperCase();

				if (charCode.length == 1)  {
					charCode = "0" + charCode;
				}
				return "%" + charCode;
			}
			var replacePattern:RegExp = /([\!\*\'\(\)])/gi;
			var newValue:String = encodeURIComponent(value).replace(replacePattern, oAuthCharacterEncode);
			return newValue;
		}

		protected function createSignature(
			queryString:String, consumerSecret:String, aSecret:String = "", method:String = URLRequestMethod.GET):String {

			var base:String =
				encodeURI(method.toUpperCase()) + "&"
				+ encodeURI(getURL()) + "&"
				+ encodeURI(queryString);

			var hmac:HMAC = Crypto.getHMAC("sha1");
			var key:ByteArray = Hex.toArray(
				Hex.fromString(encodeURI(consumerSecret) + "&" + encodeURI(aSecret)));

			var data:ByteArray = Hex.toArray(Hex.fromString(base));
			return "&oauth_signature=" + encodeURI(Base64.encodeByteArray(hmac.compute(key, data)));
		}

		protected function getURL():String {
			return null;
		}

		protected function createQueryVector(key:String):Vector.<String> {

			var queryVector:Vector.<String> = new Vector.<String>();
			queryVector.push("oauth_callback=oob");
			queryVector.push( "oauth_consumer_key=" + key);
			queryVector.push("oauth_nonce=" + Math.floor(Math.random() * int.MAX_VALUE));
			queryVector.push( "oauth_signature_method=HMAC-SHA1");
			queryVector.push( "oauth_timestamp=" + Math.round(new Date().getTime() / 1000).toString());
			queryVector.push( "oauth_version=1.0");
			return queryVector;
		}

		protected function addAuthTokenQueryVector(authToken:String, queryVector:Vector.<String>):void {
			queryVector.push("oauth_token=" + authToken);
		}

		protected function createQueryString(queryVector:Vector.<String>):String {
			var query:String = "";
			var len:int = queryVector.length;
			queryVector = queryVector.sort(Array.CASEINSENSITIVE);

			for (var i:int = 0; i < len; i++) {
				var and:String = i == 0 ? "" : "&";
				query += (and + queryVector[i]);
			}
			return query;
		}

		protected function createAuthorization(method:String):Object {

			var consumer:ShapewaysConsumer = ShapewaysOAuthTokenManager.instance.consumer;
			var accessToken:ShapewaysAccessToken = ShapewaysOAuthTokenManager.instance.accessToken;

			var c:OAuthConsumer = new OAuthConsumer();
			c.key = consumer.key;
			c.secret = consumer.secret;

			var a:OAuthToken = new OAuthToken();
			a.key = accessToken.token;
			a.secret = accessToken.secret;

			var oAuthReq:OAuthRequest = new OAuthRequest(method, getURL(),	{}, c, a);
			var authHeader:URLRequestHeader = oAuthReq.buildRequest(
				new OAuthSignatureMethod_HMAC_SHA1(), OAuthRequest.RESULT_TYPE_HEADER);

//			var qv:Vector.<String> = createQueryVector(consumer.key);
//			addAuthTokenQueryVector(accessToken.token, qv);
//			var q:String = createQueryString(qv);

			var ret:Object = new Object();
			ret.Authorization = authHeader.value; //createSignature(q, consumer.secret, accessToken.secret, URLRequestMethod.POST);
			return ret;
		}
	}
}