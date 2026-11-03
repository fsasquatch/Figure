package figure.graphics;

import frame.graphics.Color;

class Shapes {
    public static var batch:ShapeBatch;

    public static function rectangle(x:Float, y:Float, width:Int, height:Int, color:Color = Color.WHITE) {
        batch.push(new Sprite(x, y, 0, width, height, color), new glm.Vec4(1), new glm.Vec4());
    }

    public static function circle(x:Float, y:Float, r:Int, color:Color = Color.WHITE) {
        batch.push(new Sprite(x, y, 0, r*2, r*2, color), new glm.Vec4(1), new glm.Vec4());
    }

    public static function triangle() {
        var p1 = {x: 50, y: 0};
        var p2 = {x: 0, y: 40};
        var p3 = {x: 100, y: 100};
        var points = [p1, p2, p3];
        var minx = p1.x;
        var miny = p1.y;
        var maxx = p1.y;
        var maxy = p1.y;
        for(p in points) {
            if(p.x > maxx) maxx = p.x;
            else if(p.x < minx) minx = p.x;
        
            if(p.y > maxy) maxy = p.y;
            else if(p.y < miny) miny = p.y;
        }
        
        // calculate the width & height of the triangle
        var width = maxx - minx;
        var height = maxy - miny;

        var x1 = p1.x  / width;
        var y1 = p1.y / height;
        var x2 = p2.x / width;
        var y2 = p2.y  / height;
        var x3 = p3.x / width;
        var y3 = p3.y / height;

        batch.push(new Sprite(100, 100, 0, width, height, frame.graphics.Color.WHITE), new glm.Vec4(2, 0, x1, y1), new glm.Vec4(x2, y2, x3, y3));
    }

    public static function line() {
        // just a rectangle with height 1 rotated and stuff :D
    }
}