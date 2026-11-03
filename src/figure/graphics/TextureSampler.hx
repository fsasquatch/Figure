package figure.graphics;

import frame.graphics.Sampler;

@:allow(figure.App)
class TextureSampler {
    public static var pointClamp:Sampler;
    public static var pointWrap:Sampler;
    public static var linearClamp:Sampler;
    public static var linearWrap:Sampler;
    public static var anisotropicClamp:Sampler;
    public static var anisotropicWrap:Sampler;

    private static function create() {
        pointClamp = new Sampler(Nearest, Nearest, ClampToEdge, 0);
        pointWrap = new Sampler(Nearest, Nearest, Repeat, 0);
        linearClamp = new Sampler(Linear, Linear, ClampToEdge, 0);
        linearWrap = new Sampler(Linear, Linear, Repeat, 0);
        anisotropicClamp = new Sampler(Linear, Linear, Repeat, 4);
        anisotropicWrap = new Sampler(Linear, Linear, Repeat, 4);
    }

    private static function destroy() {
        pointClamp.destroy();
        pointWrap.destroy();
        linearClamp.destroy();
        linearWrap.destroy();
        anisotropicClamp.destroy();
        anisotropicWrap.destroy();
    }
}
