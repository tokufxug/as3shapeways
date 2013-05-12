package net3dprintweb.service.shapeways.models.action
{
	import com.adobe.net.URI;

	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	import net3dprintweb.service.shapeways.auth.token.ShapewaysAccessToken;
	import net3dprintweb.service.shapeways.auth.token.ShapewaysConsumer;
	import net3dprintweb.service.shapeways.base.action.ShapewaysBaseAction;

	import org.httpclient.HttpClient;
	import org.httpclient.HttpRequest;
	import org.httpclient.events.HttpDataEvent;
	import org.httpclient.events.HttpErrorEvent;
	import org.httpclient.events.HttpResponseEvent;
	import org.httpclient.events.HttpStatusEvent;
	import org.httpclient.http.Post;

	public class ShapewaysModelUploadAction extends ShapewaysBaseAction
	{
		private static const FRAGMENT:String = "/models/v1";

		public function ShapewaysModelUploadAction()
		{
			super();
		}

		public function send(data:ByteArray):void {
			var authObj:Object = createAuthorization(URLRequestMethod.POST);
			var authHeadName:String;
			var authHeadValue:String;
			for (authHeadName in authObj) {
				authHeadValue = authObj[authHeadName];
			}
			var req:HttpRequest = new Post();
			req.addHeader(authHeadName, authHeadValue);
			req.addHeader("Accept", "application/json");
			req.body = data;

			var uri:URI = new URI(getURL());
			var client:HttpClient = new HttpClient();
			client.listener.onData = onData;
			client.listener.onStatus = onStatus;
			client.listener.onComplete = onComp;
			client.listener.onError = onError;
			client.request(uri, req);
		}

		private function onData(event:HttpDataEvent):void {
			if (event.bytes) {
				trace(event.readUTFBytes());
			}
		}
		private function onStatus(event:HttpStatusEvent):void {
			trace(event);
		}
		private function onComp(event:HttpResponseEvent):void {
			//trace(event);
			trace(event.toString());
		}
		private function onError(event:HttpErrorEvent):void {
			trace(event);
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}
	}
}