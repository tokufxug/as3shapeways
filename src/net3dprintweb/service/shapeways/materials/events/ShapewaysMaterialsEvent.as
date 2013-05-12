package net3dprintweb.service.shapeways.materials.events
{
	import flash.events.Event;

	public class ShapewaysMaterialsEvent extends Event
	{
		public static const RESULT:String = "net3dprintweb.service.shapeways.materials.events.ShapewaysMaterialsEvent.RESULT";
		public var materials:Object;
		public function ShapewaysMaterialsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}