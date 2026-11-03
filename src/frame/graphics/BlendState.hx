package frame.graphics;

enum abstract BlendFactor(Int) to Int {
    var Invalid = 0;
    var Zero = 1;
    var One = 2;
    var SrcColor = 3;
    var OneMinusSrcColor = 4;
    var DstColor = 5;
    var OneMinusDstColor = 6;
    var SrcAlpha = 7;
    var OneMinusSrcAlpha = 8;
    var DstAlpha = 9;
    var OneMinusDstAlpha = 10;
    var ConstantColor = 11;
    var OneMinusConstantColor = 12;
    var SrcAlphaSaturate = 13;
}

enum abstract BlendOp(Int) to Int {
    var Invalid = 0;
    var Add = 1;
    var Subtract = 2;
    var ReverseSubtract = 3;
    var Min = 4;
    var Max = 5;
}

@:structInit
class BlendState {
    public var enable = true;
    public var srcColorBlendFactor:BlendFactor;
    public var dstColorBlendFactor:BlendFactor;
    public var colorBlendOp:BlendOp;
    public var srcAlphaBlendFactor:BlendFactor;
    public var dstAlphaBlendFactor:BlendFactor;
    public var alphaBlendOp:BlendOp;
}
