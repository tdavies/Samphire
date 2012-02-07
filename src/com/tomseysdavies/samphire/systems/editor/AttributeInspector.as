package com.tomseysdavies.samphire.systems.editor
{
import com.bit101.components.VBox;
import com.tomseysdavies.samphire.systems.editor.valueEditors.*;

import flash.utils.Dictionary;
import flash.utils.describeType;

import org.osflash.signals.Signal;

public class AttributeInspector extends VBox
	{
		
		private static const META_DATA:String = "Ember";
		private static const META_ARG_ARRAY:String = "DropDown";
		private static const META_ARG_SKIP:String = "skip";
        private static const EDIT_META_DATA:String = "Edit";
		
		private const _editors:Vector.<Editor> = new Vector.<Editor>();
		public const resize:Signal = new Signal();
        private var _arrays:Dictionary;
		
		public function AttributeInspector(valueObject:Object, arrays:Dictionary)
		{
			super();
            _arrays = arrays;

            spacing = 2;
			
			var data:Vector.<NameValuePairVO> = getNameValuePairs(valueObject);	
			
			for each(var valuePair:NameValuePairVO in data){	
				var editor:Editor = createEditor(valuePair);
				editor.resize.add(onEditorResize);
				_editors.push(editor);
				addChild(editor);
			}
			adjustHeight();
		}
		
		private function onEditorResize():void{
			adjustHeight();
			resize.dispatch();
		}
		
		private function adjustHeight():void{
			var totalHeight:int = 0;
			for each(var editor:Editor in _editors){
				totalHeight += editor.height + 4;
			}
			height = totalHeight;
		}
		
		private function createEditor(valuePair:NameValuePairVO,data:Object = null):Editor{
			var comp:Editor;
			switch(valuePair.type){
				case "Boolean":
					comp = new BooleanValueEditor(valuePair);
					break;
				case "Number":
					comp = new NumberValueEditor(valuePair);
					break;
				case "String":
					comp = new StringValueEditor(valuePair);
					break;
				case "DropDown":
					comp = new ComboBoxValueEditor(valuePair);
					break;					
				case "int":
					comp = new IntValueEditor(valuePair);
					break;
				default:
					comp = new UnsuportedValueEditor(valuePair);
			}
			return comp;
		}
		
		private function getNameValuePairs(component:Object):Vector.<NameValuePairVO>{	
			var data:Vector.<NameValuePairVO> = new Vector.<NameValuePairVO>();
			var classInfo:XML = describeType(component);		
			var attributes:XMLList = classInfo..variable;
			attributes +=  classInfo..accessor.(@access == "readwrite" );	
			for each(var attribute:XML in attributes) {
				var metaData:XML = attribute.metadata.(@name == META_DATA)[0];
				if(metaData){
					var skipArg:XMLList = metaData.arg.(@key == META_ARG_SKIP);
					if(skipArg.length() > 0){					
						if( skipArg[0].@value == "true") continue;
					}
				}
				
				data.push(generateNameValuePair(component,attribute));
			}
			return data;
		}
		
		private function generateNameValuePair(component:Object,xml:XML):NameValuePairVO{
            var data:Object;
			var type:String = xml.@type;
			var metaXML:XML = xml.metadata.(@name.toString().indexOf(EDIT_META_DATA) > -1)[0];
			if(metaXML){
				var typeArg:XMLList = metaXML.arg.(@key == META_ARG_ARRAY);
				if(typeArg.length() > 0){					
					type = META_ARG_ARRAY;
                    data = getArrayData(typeArg[0].@value);
				}
			}
			/*
			if(ClassUtils.isClassVector(type)) {
				type = "Vector";
			}
			*/
			var getName:String  = xml.@name;
			return new NameValuePairVO(getName,component[getName],component,type,data);
		}

        private function getArrayData(name:String):Array{
            var data:Array = [];
            var list:Vector.<String> = _arrays[name] as Vector.<String>;
            for each(var item:String in list){
                data.push(item);
            }
            return data;
        }
		
		public function dispose():void{
			for each(var editor:Editor in _editors){
				editor.resize.remove(onEditorResize);
			}
			_editors.length = 0;
			resize.removeAll();
		}
	}
}