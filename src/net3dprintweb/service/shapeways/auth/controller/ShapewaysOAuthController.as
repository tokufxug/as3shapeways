package net3dprintweb.service.shapeways.auth.controller
{
	import flash.events.EventDispatcher;

	import net3dprintweb.service.shapeways.auth.action.ShapewaysOAuthAccessAction;
	import net3dprintweb.service.shapeways.auth.action.ShapewaysOAuthRequestAction;
	import net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthAccessTokenEvent
	import net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthRequestTokenEvent;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysAccessToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysAuthToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysConsumer;

	public class ShapewaysOAuthController extends EventDispatcher
	{
		private var _accessToken:ShapewaysAccessToken;
		private var _authToken:ShapewaysAuthToken;
		private var _consumerToken:ShapewaysConsumer;

		public function ShapewaysOAuthController(
			consumerKey:String, consumerSecret:String) {

			_consumerToken = new ShapewaysConsumer();
			_consumerToken.key = consumerKey;
			_consumerToken.secret = consumerSecret;
		}

		public function requestAction():void {
			var request:ShapewaysOAuthRequestAction = new ShapewaysOAuthRequestAction();
			request.addEventListener(ShapewaysOAuthRequestTokenEvent.RESULT,
					onRequestTokenResultHandler);
			request.send(_consumerToken);
		}

		public function accessAction(pin:String):void {
			var access:ShapewaysOAuthAccessAction = new ShapewaysOAuthAccessAction();
			access.addEventListener(ShapewaysOAuthAccessTokenEvent.RESULT,
				onAccessTokenResultHandler);
			access.send(_consumerToken, _authToken, pin);
		}

		private function onRequestTokenResultHandler(
				event:ShapewaysOAuthRequestTokenEvent):void {
				_authToken = event.authToken;

				var requestEvent:ShapewaysOAuthRequestTokenEvent =
					new ShapewaysOAuthRequestTokenEvent(ShapewaysOAuthRequestTokenEvent.RESULT);
				requestEvent.url = event.url;
				dispatchEvent(requestEvent);
		}

		private function onAccessTokenResultHandler(
			event:ShapewaysOAuthAccessTokenEvent):void {
			_accessToken = event.accessToken;

			var accessEvent:ShapewaysOAuthAccessTokenEvent =
				new ShapewaysOAuthAccessTokenEvent(ShapewaysOAuthAccessTokenEvent.RESULT);
			dispatchEvent(accessEvent);
		}
	}
}