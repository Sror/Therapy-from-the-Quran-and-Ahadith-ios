//
//  LineLayer.m
//  iGitpad
//
//  Created by Johannes Lund on 2012-12-17.
//
//

#import "TextLineCell.h"

@implementation TextLineCell {
    CTLineRef _line;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.geometryFlipped = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.geometryFlipped = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.geometryFlipped = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextPosition(context, MARGIN, MARGIN/2);
   //modified line justified line
    CGRect lineRect =  CTLineGetBoundsWithOptions(self.line, kCTLineBoundsUseGlyphPathBounds);
    if (lineRect.size.width<rect.size.width-80)
        CTLineDraw( self.line, context);
    else
        CTLineDraw( CTLineCreateJustifiedLine(self.line, 1.0, rect.size.width-30), context);
}

- (UIView *)backgroundView
{
    return nil;
}

- (UIView *)contentView
{
    return nil;
}
@end
