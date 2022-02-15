/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Metal shaders used for this sample
*/

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

// Include header shared between this Metal shader code and C code executing Metal API commands
#include "RRShaderTypes.h"

// Vertex shader outputs and per-fragment inputs
struct RasterizerData
{
    float4 clipSpacePosition [[position]];
    float2 textureCoordinate;
};

vertex RasterizerData
vertexShader(uint vertexID [[ vertex_id ]],
             constant RRVertex *vertexArray [[ buffer(RRVertexInputIndexVertices) ]],
             constant RRUniforms &uniforms  [[ buffer(RRVertexInputIndexUniforms) ]])

{
    RasterizerData out;

    float2 pixelSpacePosition = vertexArray[vertexID].position.xy;

    out.clipSpacePosition.xy = pixelSpacePosition;
    out.clipSpacePosition.z = 0.0;
    out.clipSpacePosition.w = 1.0;
    
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;

    return out;
}

fragment half4
grayFragmentShader(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture [[ texture(RRTextureIndexBaseColor) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);
    return half4(half3(colorSample.r), 1.);
}

fragment half4
bgraFragmentShader(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture [[ texture(RRTextureIndexBaseColor) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    const half4 colorSample = colorTexture.sample(textureSampler, in.textureCoordinate);
    return half4(colorSample.b, colorSample.g, colorSample.r, colorSample.a);
}

fragment half4
rgbaFragmentShader(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture [[ texture(RRTextureIndexBaseColor) ]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    return colorTexture.sample(textureSampler, in.textureCoordinate);
}

