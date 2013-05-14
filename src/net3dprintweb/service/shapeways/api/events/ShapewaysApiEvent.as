package net3dprintweb.service.shapeways.api.events
{
	import flash.events.Event;

	import net3dprintweb.service.shapeways.api.info.ShapewaysApiInfo;

	public class ShapewaysApiEvent extends Event
	{
		public static const RESULT:String = "net3dprintweb.service.shapeways.api.events.ShapewaysApiEvent.RESULT";
		public var api:ShapewaysApiInfo;
		public function ShapewaysApiEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}