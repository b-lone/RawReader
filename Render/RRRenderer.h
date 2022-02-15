/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Metal Renderer for Metal View. Acts as the update and render delegate for the view controller and performs rendering.
*/

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@class RawImage;

@interface RRRenderer : NSObject

- (nonnull instancetype)initWithMetalDevice:(nonnull id<MTLDevice>)device
                        drawablePixelFormat:(MTLPixelFormat)drawabklePixelFormat
                                      image:(RawImage* _Nonnull)image;

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer;

@end
