package frame.backend;

class Backend {
    public static var system:SystemApi;
    public static var gpu:GpuApi;
    public static var audio:AudioApi;

    public static function setup(opengl:Bool = false) {
        system = new System();
        gpu = new Gpu();
        audio = new Audio();
    }
}
