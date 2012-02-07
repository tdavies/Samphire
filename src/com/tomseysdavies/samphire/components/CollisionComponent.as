package com.tomseysdavies.samphire.components
{
public class CollisionComponent{


    private var _groupID:String = "";

    [Ember(skip = "true")]
    public var groupInvalidated:Boolean;

    [Ember(skip = "true")]
    public var oldGroup:String = "";

    public function CollisionComponent(groupID:String =""){
        _groupID = groupID;
    }

    [Edit(DropDown="collision")]
    public function get groupID():String {
        return _groupID;
    }

    public function set groupID(value:String):void {
        oldGroup =  _groupID;
        groupInvalidated = true;
        _groupID = value;
    }
}
}