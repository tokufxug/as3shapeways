package net3dprintweb.service.shapeways.printers.action
{
	import com.adobe.net.URI;

	import flash.net.URLRequestMethod;

	import net3dprintweb.service.shapeways.base.action.ShapewaysBaseAction;
	import net3dprintweb.service.shapeways.printers.events.ShapewaysPrintersEvent;
	import net3dprintweb.service.shapeways.printers.printer.ShapewaysPrinter;

	import org.httpclient.HttpClient;
	import org.httpclient.HttpRequest;
	import org.httpclient.events.HttpDataEvent;

	public class ShapewaysPrintersAction extends ShapewaysBaseAction
	{
		private static const FRAGMENT:String = "/printers/v1";
		private var _isResponse:Boolean = false;

		protected  override function onData(event:HttpDataEvent):void {
			if (_isResponse) {
				_isResponse  = false;
				return;
			}
			var data:String = event.readUTFBytes();
			var printers:Object = toPrinters(data);
			var printersEvent:ShapewaysPrintersEvent = new ShapewaysPrintersEvent(
				ShapewaysPrintersEvent.RESULT);

			printersEvent.printers = printers;
			dispatchEvent(printersEvent);
			_isResponse  = true;
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}

		private function toPrinters(data:String):Object {
			var prtStr:String = data.replace("{\"result\":\"success\",\"printers\":", "");
			var firstIndex:int = 0;
			var lastIndex:int = 0;
			var ret:Object = new Object();
			do {
				firstIndex = prtStr.indexOf("{\"printerId\"", lastIndex);
				lastIndex = prtStr.indexOf("}", lastIndex) + 1;
				if (firstIndex < 0 || lastIndex < firstIndex) {
					break;
				}
				var data:String = prtStr.substring(firstIndex, lastIndex);
				var m:Object = JSON.parse(data);

				var printer:ShapewaysPrinter= new ShapewaysPrinter();
				printer.printerId = m.printerId;
				printer.title = m.title;
				printer.xBoundMin = m.xBoundMin;
				printer.xBoundMax = m.xBoundMax;
				printer.yBoundMin = m.yBoundMin;
				printer.yBoundMax = m.yBoundMax;
				printer.zBoundMin = m.zBoundMin;
				printer.zBoundMax = m.zBoundMax;
				printer.json = data;

				ret[m.printerId] = printer;
			}while(lastIndex > 0);
			return ret;
		}
	}
}