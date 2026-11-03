// Implemented using: https://iquilezles.org/articles/distfunctions2d/
struct Input {
    float2 TexCoord : TEXCOORD0;
    float4 Color : TEXCOORD1;
    float4 Position : SV_Position;
    float4 ShapeOne : TEXCOORD2;
    float4 ShapeTwo : TEXCOORD3;
};

float sdCircle(float2 p, float r) {
    return length(p) - r; 
}

float sdBox(float2 p, float2 b) {
    float2 d = abs(p) - b;
    return length(max(d, 0)) + min(max(d.x, d.y), 0);
}

float sdTriangle(float2 p, float2 p0, float2 p1, float2 p2) {
    float2 e0 = p1 - p0;
    float2 e1 = p2 - p1;
    float2 e2 = p0 - p2;

    float2 v0 = p - p0;
    float2 v1 = p - p1;
    float2 v2 = p - p2;

    float2 pq0 = v0 - e0 * clamp(dot(v0, e0) / dot(e0, e0), 0, 1); 
    float2 pq1 = v1 - e1 * clamp(dot(v1, e1) / dot(e1, e1), 0, 1); 
    float2 pq2 = v2 - e2 * clamp(dot(v2, e2) / dot(e2, e2), 0, 1); 

    float s = sign(e0.x * e2.y - e0.y * e2.x);
    float2 d = min(min(float2(dot(pq0,pq0), s*(v0.x*e0.y-v0.y*e0.x)),
                       float2(dot(pq1,pq1), s*(v1.x*e1.y-v1.y*e1.x))),
                       float2(dot(pq2,pq2), s*(v2.x*e2.y-v2.y*e2.x)));
    return -sqrt(d.x) * sign(d.y);
}

float4 main(Input input) : SV_Target0 {
    float2 uv = input.TexCoord;
    float2 center = float2(0.5, 0.5);

    float dist = -1;
    if(input.ShapeOne.r == 0) dist = sdCircle(uv - center, 0.5);
    else if(input.ShapeOne.r == 1) dist = sdBox(uv - center, float2(1, 1));
    else if(input.ShapeOne.r == 2) dist = sdTriangle(uv, float2(input.ShapeOne.b, input.ShapeOne.a), float2(input.ShapeTwo.r, input.ShapeTwo.g), float2(input.ShapeTwo.b, input.ShapeTwo.a));

    // larger number is softer, smaller is harder
    float edge = 0.005;
    float finalShape = 1.0 - smoothstep(-edge, edge, dist);

    float4 color = input.Color * finalShape;

    return color;
}