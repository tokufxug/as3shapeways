package net3dprintweb.service.shapeways.api.info
{
	import org.httpclient.HttpRequest;

	public class ShapewaysApiInfo
	{
		public var retryInSeconds:int;
		public var windowInMinutes:int;
		public var limit:int;
		public var remaining:int;
		public var retryTimestamp:int;
		public var history:Object;

		public function ShapewaysApiInfo()
		{
		}
	}
}