package net3dprintweb.service.shapeways.auth.action
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	import net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthRequestTokenEvent;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysAuthToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysConsumer;

	public class ShapewaysOAuthRequestAction extends ShapewaysOAuthAction
	{
		private static const FRAGMENT:String = "/oauth1/request_token/v1";

		public  function send(consumer:ShapewaysConsumer):void {

			var qv:Vector.<String> = createQueryVector(consumer.key);
			var q:String = createQueryString(qv);
			var url:String =	getURL() + "?"+ q +  createSignature(q, consumer.secret);
			var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.method = URLRequestMethod.GET;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(urlRequest);
		}

		private function onComplete(event:Event):void {
			var data:String = unescape(event.currentTarget.data);
			var url:String = decodeURI(data.replace("authentication_url=", ""));

			var queryObj:Object =
					createQueryObject(url.replace("http://api.shapeways.com/login?", ""));

			var authToken:ShapewaysAuthToken = new ShapewaysAuthToken();
			authToken.token = queryObj.oauth_token;
			authToken.secret = queryObj.oauth_token_secret;

			var tokenEvent:ShapewaysOAuthRequestTokenEvent = new ShapewaysOAuthRequestTokenEvent(
				ShapewaysOAuthRequestTokenEvent.RESULT);

			tokenEvent.url = url;
			tokenEvent.authToken = authToken;

			dispatchEvent(tokenEvent);
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}
	}
}