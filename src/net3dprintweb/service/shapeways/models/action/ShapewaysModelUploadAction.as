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

			var req:HttpRequest = createRequest(URLRequestMethod.POST);
			req.addHeader("Accept", "application/json");
			req.body = data;
			request(req);
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT;
		}
	}
}