struct Input {
    float4 Position : TEXCOORD0;
    float2 TexCoord : TEXCOORD1;
    float4 Color : TEXCOORD2;
    float4 Type : TEXCOORD4;
};

struct Output {
    float2 TexCoord : TEXCOORD0;
    float4 Color :TEXCOORD1;
    float4 Type : TEXCOORD4;
    float4 Position : SV_Position;
};

cbuffer UniformBlock : register(b0, space1) {
    float4x4 ViewProjectionMatrix : packoffset(c0);
};

Output main(Input input) {
    Output output;
    output.TexCoord = input.TexCoord;
    output.Color = input.Color;
    output.Position = mul(ViewProjectionMatrix, input.Position);
    return output;
}