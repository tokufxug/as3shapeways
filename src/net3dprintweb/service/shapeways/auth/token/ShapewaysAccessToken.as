package net3dprintweb.service.shapeways.auth.token
{
	import org.iotashan.oauth.OAuthToken;

	public class ShapewaysAccessToken extends ShapewaysBaseToken
	{

		public function toOAuthAccessToken():OAuthToken {
			var ret:OAuthToken = new OAuthToken();
			ret.key = token;
			ret.secret = secret;
			return ret;
		}
	}
}