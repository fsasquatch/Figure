package figure;

abstract class Module {
    public function new() {}
    abstract public function create():Void;
    abstract public function destroy():Void;
    abstract public function update(dt:Float):Void;
    abstract public function fixedUpdate():Void;
    abstract public function draw():Void;
}