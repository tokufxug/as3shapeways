package net3dprintweb.service.shapeways.auth.token
{
	import net3dprintweb.service.shapeways.auth.controller.ShapewaysOAuthController;

	public class ShapewaysOAuthTokenManager
	{
		private static var _instance:ShapewaysOAuthTokenManager;
		public var consumer:ShapewaysConsumer;
		public var accessToken:ShapewaysAccessToken;
		public function ShapewaysOAuthTokenManager(singleton:ShapewaysOAuthTokenManagerSingleton)
		{
		}

		public static function get instance():ShapewaysOAuthTokenManager {
			if (!_instance) {
				_instance = new ShapewaysOAuthTokenManager(new ShapewaysOAuthTokenManagerSingleton())
			}
			return _instance;
		}
	}
}
class ShapewaysOAuthTokenManagerSingleton {

}