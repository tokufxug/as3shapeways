package net3dprintweb.service.shapeways.models.model
{
	import net3dprintweb.service.shapeways.materials.material.ShapewaysMaterial;

	public class ShapewaysModel
	{
		public var modelId:String;
		public var modelVersion:int;
		public var title:String;
		public var description:String;
		public var isPublic:Boolean;
		public var isForSale:Boolean;
		public var materials:Object;
		public var secretKey:String;
		public var defaultMaterialId:String;
		public var action:ShapewaysNextActionSuggestions;
	}
}