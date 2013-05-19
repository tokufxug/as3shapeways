package net3dprintweb.service.shapeways.materials.action
{
	import com.adobe.net.URI;

	import flash.net.URLRequestMethod;

	import net3dprintweb.service.shapeways.base.action.ShapewaysBaseAction;
	import net3dprintweb.service.shapeways.materials.code.ShapewaysSupportsColorFilesCode;
	import net3dprintweb.service.shapeways.materials.events.ShapewaysMaterialsEvent;
	import net3dprintweb.service.shapeways.materials.material.ShapewaysMaterial;

	import org.httpclient.HttpClient;
	import org.httpclient.HttpRequest;
	import org.httpclient.events.HttpDataEvent;
	import org.httpclient.events.HttpErrorEvent;
	import org.httpclient.events.HttpResponseEvent;
	import org.httpclient.events.HttpStatusEvent;
	import org.httpclient.http.Get;

	public class ShapewaysMaterialsAction extends ShapewaysBaseAction
	{
		private static const FRAGMENT:String = "/materials/v1";
		private var _isResponse:Boolean = false;

		public function ShapewaysMaterialsAction()
		{
			super();
		}

		public override function doGet():void {
			var req:HttpRequest =  createRequest(URLRequestMethod.GET);
			var client:HttpClient = new HttpClient();
			client.listener.onData = onData;
			request(req);
		}

		protected override function onData(event:HttpDataEvent):void {
			if (_isResponse) {
				_isResponse  = false;
				return;
			}
			var data:String = event.readUTFBytes();

			var materials:Object = toMaterials(data);
			var materialsEvent:ShapewaysMaterialsEvent = new ShapewaysMaterialsEvent(
				ShapewaysMaterialsEvent.RESULT);

			materialsEvent.materials = materials;
			dispatchEvent(materialsEvent);
			_isResponse = true;
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}

		private function toMaterials(data:String):Object {
			var mtlStr:String = data.replace("{\"result\":\"success\",\"materials\":", "");
			var firstIndex:int = 0;
			var lastIndex:int = 0;
			var ret:Object = new Object();
			do {
				firstIndex = mtlStr.indexOf("{\"materialId\"", lastIndex);
				lastIndex = mtlStr.indexOf("}", lastIndex) + 1;
				if (firstIndex < 0 || lastIndex < firstIndex) {
					break;
				}
				var data:String = mtlStr.substring(firstIndex, lastIndex);
				var m:Object = JSON.parse(data);

				var material:ShapewaysMaterial = new ShapewaysMaterial();
				material.materialId = m.materialId;
				material.title = m.title;
				material.swatch = m.swatch;
				material.printerId = m.printerId;
				material.isSupporColor =
					m.supportsColorFiles == ShapewaysSupportsColorFilesCode.YES;
				material.json = data;

				ret[m.materialId] = material;
			}while(lastIndex > 0);
			return ret;
		}
	}
}