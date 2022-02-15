/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header containing types and enum constants shared between Metal shaders and C/ObjC source
*/

#ifndef RRShaderTypes_h
#define RRShaderTypes_h

#include <simd/simd.h>

typedef enum RRVertexInputIndex
{
    RRVertexInputIndexVertices = 0,
    RRVertexInputIndexUniforms = 1,
} RRVertexInputIndex;

typedef enum RRTextureIndex
{
    RRTextureIndexBaseColor = 0,
} RRTextureIndex;

typedef struct
{
    // Positions in pixel space (i.e. a value of 100 indicates 100 pixels from the origin/center)
    vector_float2 position;

    // 2D texture coordinate
    vector_float3 color;
    vector_float2 textureCoordinate;
} RRVertex;

typedef struct
{
    float scale;
    vector_uint2 viewportSize;
} RRUniforms;

#endif /* RRShaderTypes_h */
