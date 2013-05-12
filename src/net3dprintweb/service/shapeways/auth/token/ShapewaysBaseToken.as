package net3dprintweb.service.shapeways.auth.token
{

	public class ShapewaysBaseToken
	{
		private var _token:String;
		private var _secret:String;

		public function set token(value:String):void {
				_token = value;
		}

		public function set secret(value:String):void {
				_secret = value;
		}

		public function get token():String {
			return _token;
		}

		public function get secret():String {
			return _secret;
		}
	}
}