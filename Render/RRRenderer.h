/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Metal Renderer for Metal View. Acts as the update and render delegate for the view controller and performs rendering.
*/

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import "RawReader-Swift.h"

//typedef enum
//{
//    RawImageFormatGray = 0,
//    RawImageFormatBGRA = 1,
//    RawImageFormatRGBA = 1,
//} RRRawImageFormat;
//
//typedef struct
//{
//    int width;
//    int height;
//    RRRawImageFormat format;
//    NSURL* _Nonnull url;
//} RRRawImage;

@interface RRRenderer : NSObject

- (nonnull instancetype)initWithMetalDevice:(nonnull id<MTLDevice>)device
                        drawablePixelFormat:(MTLPixelFormat)drawabklePixelFormat
                                      image:(RawImage* _Nonnull)image;

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer;

@end
