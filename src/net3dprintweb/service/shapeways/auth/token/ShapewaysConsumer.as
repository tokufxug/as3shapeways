package net3dprintweb.service.shapeways.auth.token
{
	import org.iotashan.oauth.OAuthConsumer;

	public class ShapewaysConsumer
	{
		private var _key:String;
		private var _secret:String;

		public function set key(value:String):void {
			_key = value;
		}

		public function set secret(value:String):void {
			_secret = value;
		}

		public function get key():String {
			return _key;
		}

		public function get secret():String {
			return _secret;
		}
	}
}