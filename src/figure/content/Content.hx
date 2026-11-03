package figure.content;

import frame.graphics.GraphicsPipeline;

class Content {
    public static var contentFolder = "content";
    public static var spritesheets:Map<String, Spritesheet> = [];
    public static var shaders:Map<String, GraphicsPipeline> = [];

    public static function load() {
    }

    public static function unload() {
    }
}