package net3dprintweb.service.shapeways.printers.events
{
	import flash.events.Event;

	public class ShapewaysPrintersEvent extends Event
	{
		public static const RESULT:String = "net3dprintweb.service.shapeways.printers.events.ShapewaysPrintersEvent.RESULT";
		public var printers:Object;
		public function ShapewaysPrintersEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}