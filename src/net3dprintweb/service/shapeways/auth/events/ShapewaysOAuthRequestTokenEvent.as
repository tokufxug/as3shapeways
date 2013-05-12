package net3dprintweb.service.shapeways.auth.events
{
	import flash.events.Event;

	import net3dprintweb.service.shapeways.auth.token.ShapewaysAuthToken;

	public class ShapewaysOAuthRequestTokenEvent extends Event
	{
		public static const RESULT:String  = "net3dprintweb.service.shapeways.auth.events.ShapewaysOAuthRequestTokenEvent.RESULT";
		public var url:String;
		public var authToken:ShapewaysAuthToken;

		public function ShapewaysOAuthRequestTokenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}