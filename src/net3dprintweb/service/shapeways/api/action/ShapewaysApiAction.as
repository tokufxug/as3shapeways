package net3dprintweb.service.shapeways.api.action
{
	import flash.net.URLRequestMethod;

	import net3dprintweb.service.shapeways.api.events.ShapewaysApiEvent;
	import net3dprintweb.service.shapeways.api.info.ShapewaysApiInfo;
	import net3dprintweb.service.shapeways.base.action.ShapewaysBaseAction;

	import org.httpclient.events.HttpDataEvent;

	public class ShapewaysApiAction extends ShapewaysBaseAction
	{
		private static const FRAGMENT:String = "/api/v1";

		protected  override function onData(event:HttpDataEvent):void {

			var data:String = event.readUTFBytes();
			var infoObj:Object = JSON.parse(data);
			var apiInfo:ShapewaysApiInfo = new ShapewaysApiInfo();

			apiInfo.retryInSeconds = infoObj.rateLimit.retryInSeconds;
			apiInfo.windowInMinutes = infoObj.rateLimit.windowInMinutes;
			apiInfo.limit = infoObj.rateLimit.limit;
			apiInfo.remaining = infoObj.rateLimit.remaining;
			apiInfo.retryTimestamp = infoObj.rateLimit.retryTimestamp;
			apiInfo.history = infoObj.rateLimit.history;

			var apiEvent:ShapewaysApiEvent = new ShapewaysApiEvent(
				ShapewaysApiEvent.RESULT);
			apiEvent.api = apiInfo;
			dispatchEvent(apiEvent);
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}
	}
}