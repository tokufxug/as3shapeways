package net3dprintweb.service.shapeways.auth.events
{
	import flash.events.Event;

	import net3dprintweb.service.shapeways.auth.token.ShapewaysAccessToken;
	public class ShapewaysOAuthAccessTokenEvent extends Event
	{
		public static const RESULT:String  = "net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthAccessTokenEvent.RESULT";
		public var accessToken:ShapewaysAccessToken;

		public function ShapewaysOAuthAccessTokenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}