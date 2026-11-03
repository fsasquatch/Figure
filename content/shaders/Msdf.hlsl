Texture2D<float4> Texture : register(t0, space2);
SamplerState Sampler : register(s0, space2);

cbuffer UniformBlock : register(b0, space1) {
    float DistanceRange : packoffset(c0);
};

struct Input {
    float2 TexCoord : TEXCOORD0;
    float4 Color : TEXCOORD1;
    float4 Position : SV_Position;
};

float median(float x, float y, float z) {
    return max(min(x, y), min(max(x, y), z));
}

float4 main(Input input) : SV_Target0 {
    float3 msd = Texture.Sample(Sampler, input.TexCoord).rgb;

    float2 textureSize;
    Texture.GetDimensions(textureSize.x, textureSize.y);
    float size = (1.0 / fwidth(input.TexCoord).x);

    float dist = median(msd.r, msd.g, msd.b);
    float2 unit = DistanceRange / textureSize;
    float screenPixelRange = max(0.5 * dot(unit, size), 1.0);
    float value = screenPixelRange * (dist - 0.5);
    float alpha = clamp(value + 0.5f, 0, 1);
    return input.Color * alpha;
}