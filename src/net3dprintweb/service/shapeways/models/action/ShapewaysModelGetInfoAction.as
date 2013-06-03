package net3dprintweb.service.shapeways.models.action
{
	import net3dprintweb.service.shapeways.base.action.ShapewaysBaseAction;
	import net3dprintweb.service.shapeways.models.category.ShapewaysCategory;
	import net3dprintweb.service.shapeways.models.code.ShapewaysModelForSale;
	import net3dprintweb.service.shapeways.models.code.ShapewaysModelMaterialActiveCode;
	import net3dprintweb.service.shapeways.models.code.ShapewaysModelPublicCode;
	import net3dprintweb.service.shapeways.models.material.ShapewaysModelMaterial;
	import net3dprintweb.service.shapeways.models.model.ShapewaysModel;

	import org.httpclient.events.HttpDataEvent;

	public class ShapewaysModelGetInfoAction extends ShapewaysBaseAction
	{
		private static const FRAGMENT:String = "/models/{modelId}/info/v1";
		private var _modelId:String;
		private var _isResponse:Boolean = false;

		public function ShapewaysModelGetInfoAction(modelId:String)
		{
			super();
			_modelId = modelId;
		}

		protected  override function onData(event:HttpDataEvent):void {
			if (_isResponse) {
				_isResponse = false;
				return;
			}
			var data:String = event.readUTFBytes();
			var model:ShapewaysModel = toModel(data);
			_isResponse = true;
		}

		protected function toModel(data:String):ShapewaysModel {
			var model:ShapewaysModel = new ShapewaysModel();

			var materialKey:String = ",\"materials\":";
			var mtrlFirstIndex:int = data.indexOf(materialKey);
			var modelObj:Object = JSON.parse(data.substring(0, mtrlFirstIndex) + "}");

			model.modelId = modelObj.modelId;
			model.modelVersion = int(modelObj.modelVersion);
			model.title = modelObj.title;
			model.description = modelObj.description;
			model.isPublic = modelObj.isPublic == ShapewaysModelPublicCode.YES;
			model.isForSale = model.isForSale == ShapewaysModelForSale.YES;

			var secretKey:String = ",\"secretKey\":";
			var nextActionKey:String = ",\"nextActionSuggestions\":";

			var scrtFirstIndex:int = data.indexOf(secretKey);
			var nxtActionIndex:int = data.indexOf(nextActionKey);

			var materialStr:String = data.substring(mtrlFirstIndex, scrtFirstIndex);
			model.materials = toMaterials(materialStr);

			modelObj = JSON.parse("{" + data.substring(scrtFirstIndex + 1, nxtActionIndex) + "}");
			model.secretKey = modelObj.secretKey;
			model.defaultMaterialId = modelObj.defaultMaterialId;
			var categories:Object = modelObj.categories;
			if (categories) {
				var shapewaysCategorys:Object = new Object();
				for each (var category:Object in categories) {

					var shapewaysCategory:ShapewaysCategory = new ShapewaysCategory();
					shapewaysCategory.categoryId = category.categoryId;
					shapewaysCategory.level = category.level;
					shapewaysCategory.parentId = category.parentId;
					shapewaysCategory.title = category.title;

					shapewaysCategorys[category.categoryId] = shapewaysCategory;
				}
				model.categories = shapewaysCategorys;
			}
			return model;
		}

		private function toMaterials(data:String):Object {
			var mtlStr:String = data;
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

				var material:ShapewaysModelMaterial = new ShapewaysModelMaterial();
				material.materialId = m.materialId;
				material.markUp = m.markup;
				material.isActive = m.isActive == ShapewaysModelMaterialActiveCode.YES;

				ret[m.materialId] = material;
			}while(lastIndex > 0);
			return ret;
		}

		protected override function getURL():String {
			return "http://" + BASE_URL + FRAGMENT.replace("{modelId}", _modelId);
		}
	}
}