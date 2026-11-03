package figure.graphics;

import frame.graphics.Color;

abstract Sprite(Array<Float>) to Array<Float> {
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var z(get, set):Float;
    public var rotation(get, set):Float;
    public var width(get, set):Int;
    public var height(get, set):Int;
    public var offsetX(get, set):Float;
    public var offsetY(get, set):Float;
    public var textureX(get,set):Float;
    public var textureY(get, set):Float;
    public var textureWidth(get, set):Float;
    public var textureHeight(get, set):Float;
    public var color(get, set):Color;

    public inline function new(x:Float, y:Float, z:Float, width:Int = 64, height:Int = 64, color:Color = Color.WHITE) {
        this = [x, y, z, 0, width, height, 0, 0, 0, 0, 1, 1, color.rF, color.gF, color.bF, color.aF];
    }

    inline function get_x() {
        return this[0];
    }

    inline function set_x(v:Float) {
        return this[0] = v;
    }

    inline function get_y() {
        return this[1];
    }

    inline function set_y(v:Float) {
        return this[1] = v;
    }

    inline function get_z() {
        return this[2];
    }

    inline function set_z(v:Float) {
        return this[2] = v;
    }

    inline function get_rotation() {
        return this[3];
    }

    inline function set_rotation(v:Float) {
        return this[3] = v;
    }

    inline function get_width() {
        return Std.int(this[4]);
    }

    inline function set_width(v:Int) {
        return cast this[4] = (v); 
    }

    inline function get_height() {
        return Std.int(this[5]);
    }

    inline function set_height(v:Int) {
        return cast this[5] = v;
    }

    inline function get_offsetX() {
        return this[6];
    }

    inline function set_offsetX(v:Float) {
        return this[6] = v;
    }

    inline function get_offsetY() {
        return this[7];
    } 

    inline function set_offsetY(v:Float) {
        return this[7] = v;
    }

    inline function get_textureX() {
        return this[8];
    }

    inline function set_textureX(v:Float) {
        return this[8] = v;
    }

    inline function get_textureY() {
        return this[9];
    }

    inline function set_textureY(v:Float) {
        return this[9] = v;
    }

    inline function get_textureWidth() {
        return this[10];
    }

    inline function set_textureWidth(v:Float) {
        return this[10] = v;
    }

    inline function get_textureHeight() {
        return this[11];
    }

    inline function set_textureHeight(v:Float) {
        return this[11] = v;
    }

    inline function get_color() {
        return Color.FloatRGBA(this[12], this[13], this[14], this[15]);
    }

    inline function set_color(v:Color) {
        this[12] = v.rF; this[13] = v.gF; this[14] = v.bF; this[15] = v.aF;
        return color;
    }
}