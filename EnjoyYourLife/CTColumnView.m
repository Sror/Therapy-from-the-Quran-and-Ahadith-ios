//inside CTColumnView.m
#import "CTColumnView.h"

@implementation CTColumnView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
    }
    return self;
}

-(void)setCTFrame: (id) f
{
    ctFrame = f;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((__bridge CTFrameRef)ctFrame, context);
}

@end