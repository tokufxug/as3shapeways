package net3dprintweb.service.shapeways.auth.action
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthAccessTokenEvent;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysAccessToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysAuthToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysConsumer;

	public class ShapewaysOAuthAccessAction extends ShapewaysOAuthAction
	{
		private static const FRAGMENT:String = "/oauth1/access_token/v1";

		public function ShapewaysOAuthAccessAction()
		{
			super();
		}

		public  function send(consumer:ShapewaysConsumer, authToken:ShapewaysAuthToken, pin:String):void {

			var qv:Vector.<String> = createQueryVector(consumer.key);
			qv.push("oauth_token=" + authToken.token);
			qv.push("oauth_verifier=" + pin);

			var q:String = createQueryString(qv);
			var url:String =	getURL() + "?"+ q +  createSignature(q, consumer.secret, authToken.secret);
			var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.method = URLRequestMethod.GET;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(urlRequest);
		}

		private function onComplete(event:Event):void {
			var data:String = unescape(event.currentTarget.data);
			var queryObj:Object = createQueryObject(data);

			var accessToken:ShapewaysAccessToken = new ShapewaysAccessToken();
			accessToken.token = queryObj.oauth_token;
			accessToken.secret = queryObj.oauth_token_secret;

			var tokenEvent:ShapewaysOAuthAccessTokenEvent = new ShapewaysOAuthAccessTokenEvent(
				ShapewaysOAuthAccessTokenEvent.RESULT);
			tokenEvent.accessToken = accessToken;

			dispatchEvent(tokenEvent);
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}
	}
}