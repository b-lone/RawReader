/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of renderer class which performs Metal setup and per-frame rendering
*/
#import "AAPLRenderer.h"
#import "AAPLShaderTypes.h"
#import "AAPLConfig.h"

static const int imageWidth = 320;
static const int imageHeight = 180;

@implementation AAPLRenderer
{
    // renderer global ivars
    id <MTLDevice>              _device;
    id <MTLCommandQueue>        _commandQueue;
    id <MTLRenderPipelineState> _pipelineState;
    id <MTLBuffer>              _vertices;
    id <MTLTexture>             _texture;

    // Render pass descriptor which creates a render command encoder to draw to the drawable
    // textures
    MTLRenderPassDescriptor *_drawableRenderDescriptor;
}

- (nonnull instancetype)initWithMetalDevice:(nonnull id<MTLDevice>)device
                        drawablePixelFormat:(MTLPixelFormat)drawabklePixelFormat
{
    self = [super init];
    if (self)
    {
        _device = device;

        _commandQueue = [_device newCommandQueue];

        _drawableRenderDescriptor = [MTLRenderPassDescriptor new];
        _drawableRenderDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        _drawableRenderDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        _drawableRenderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);

        {
            id<MTLLibrary> shaderLib = [_device newDefaultLibrary];
            if(!shaderLib)
            {
                NSLog(@" ERROR: Couldnt create a default shader library");
                // assert here because if the shader libary isn't loading, nothing good will happen
                return nil;
            }

            id <MTLFunction> vertexProgram = [shaderLib newFunctionWithName:@"vertexShader"];
            if(!vertexProgram)
            {
                NSLog(@">> ERROR: Couldn't load vertex function from default library");
                return nil;
            }

            id <MTLFunction> fragmentProgram = [shaderLib newFunctionWithName:@"fragmentShader"];
            if(!fragmentProgram)
            {
                NSLog(@" ERROR: Couldn't load fragment function from default library");
                return nil;
            }
            
            [self loadTexture:@"0" withExtension:@"raw"];

            // Set up a simple MTLBuffer with the vertices, including position and texture coordinates
            static const AAPLVertex quadVertices[] =
            {
                // Pixel positions, Color coordinates
                { {  1.f, -1.f },  { 1.f, 0.f, 0.f }, { 1.f, 1.f } },
                { { -1.f, -1.f },  { 0.f, 1.f, 0.f }, { 0.f, 1.f } },
                { { -1.f,  1.f },  { 0.f, 0.f, 1.f }, { 0.f, 0.f } },

                { {  1.f, -1.f },  { 1.f, 0.f, 0.f }, { 1.f, 1.f } },
                { { -1.f,  1.f },  { 0.f, 0.f, 1.f }, { 0.f, 0.f } },
                { {  1.f,  1.f },  { 1.f, 0.f, 1.f }, { 1.f, 0.f } },
            };

            // Create a vertex buffer, and initialize it with the vertex data.
            _vertices = [_device newBufferWithBytes:quadVertices
                                             length:sizeof(quadVertices)
                                            options:MTLResourceStorageModeShared];

            _vertices.label = @"Quad";

            // Create a pipeline state descriptor to create a compiled pipeline state object
            MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];

            pipelineDescriptor.label                           = @"MyPipeline";
            pipelineDescriptor.vertexFunction                  = vertexProgram;
            pipelineDescriptor.fragmentFunction                = fragmentProgram;
            pipelineDescriptor.colorAttachments[0].pixelFormat = drawabklePixelFormat;

            NSError *error;
            _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor
                                                                     error:&error];
            if(!_pipelineState)
            {
                NSLog(@"ERROR: Failed aquiring pipeline state: %@", error);
                return nil;
            }
        }
    }
    return self;
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer
{
    // Create a new command buffer for each render pass to the current drawable.
    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];

    id<CAMetalDrawable> currentDrawable = [metalLayer nextDrawable];

    // If the current drawable is nil, skip rendering this frame
    if(!currentDrawable)
    {
        return;
    }

    _drawableRenderDescriptor.colorAttachments[0].texture = currentDrawable.texture;
    
    id <MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:_drawableRenderDescriptor];


    [renderEncoder setRenderPipelineState:_pipelineState];

    [renderEncoder setVertexBuffer:_vertices
                            offset:0
                           atIndex:AAPLVertexInputIndexVertices ];

    {
        AAPLUniforms uniforms;

        [renderEncoder setVertexBytes:&uniforms
                               length:sizeof(uniforms)
                              atIndex:AAPLVertexInputIndexUniforms ];
    }
    
    [renderEncoder setFragmentTexture:_texture
                              atIndex:AAPLTextureIndexBaseColor];

    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];

    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:currentDrawable];

    [commandBuffer commit];
}

- (void)loadTexture:(NSString *)fileName withExtension:(NSString *) extension {
    NSURL* url = [[NSBundle mainBundle] URLForResource:fileName withExtension:extension];
    
    NSError * error;
    NSData* fileData = [[NSData alloc] initWithContentsOfURL:url options:0x0 error:&error];
    
    if (!fileData)
    {
        NSLog(@"Could not open File:%@", error.localizedDescription);
        return;
    }
    
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatR8Unorm;
    
    textureDescriptor.width = imageWidth;
    textureDescriptor.height = imageHeight;
    
    _texture = [_device newTextureWithDescriptor:textureDescriptor];
    NSUInteger bytesPerRow = imageWidth;
    MTLRegion region = {
        { 0, 0, 0 },                 // MTLOrigin
        {imageWidth, imageHeight, 1} // MTLSize
    };
    [_texture replaceRegion:region
                mipmapLevel:0
                  withBytes:fileData.bytes
                bytesPerRow:bytesPerRow];
}

@end
