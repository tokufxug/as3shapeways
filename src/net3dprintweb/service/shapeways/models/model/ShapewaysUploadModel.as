package net3dprintweb.service.shapeways.models.model
{
	import com.hurlant.util.Base64;

	import flash.utils.ByteArray;

	import net3dprintweb.service.shapeways.models.code.ShapewaysModelAcceptTermsAndConditionsCode;
	import net3dprintweb.service.shapeways.models.code.ShapewaysModelHasRightsToModelCode;

	public class ShapewaysUploadModel
	{
		public var fileName:String = "";
		public var file:String = "";
		public var uploadScale:String;
		public var hasRightsToModel:Boolean = true;
		public var acceptTermsAndConditions:Boolean = true;
		public var description:String;
		public var isPublic:Boolean = false;
		public var isForSale:Boolean = false;
		public var tags:Array;
		public var defualtMaterialId:int;

		public function ShapewaysUploadModel()
		{
		}

		public function get data():ByteArray {
			var o:Object = new Object();
			o.fileName = fileName;
			o.file = Base64.encode(file);
			o.uploadScale = uploadScale.toString();

			o.file = o.file.replace(/\n/g, "");
			o.file = o.file.replace(/=/g, "");
			o.file = o.file.replace(/+/g, "-");
			o.file = o.file.replace(/\//g, "_");

			o.hasRightsToModel = hasRightsToModel ? ShapewaysModelHasRightsToModelCode.YES.toString()  :
				ShapewaysModelHasRightsToModelCode.NO.toString();
			o.acceptTermsAndConditions = acceptTermsAndConditions ? ShapewaysModelAcceptTermsAndConditionsCode.YES.toString() :
				ShapewaysModelAcceptTermsAndConditionsCode.NO.toString();

			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(JSON.stringify(o));
			data.position = 0;
			return data;
		}
	}
}