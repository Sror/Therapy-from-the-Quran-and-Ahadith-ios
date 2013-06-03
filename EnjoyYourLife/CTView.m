//
//  CTView.m


#import "CTView.h"
#import <CoreText/CoreText.h>
#import "CTColumnView.h"

@implementation CTView

@synthesize attString;
@synthesize frames;
//@synthesize images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)buildFrames
{
    frameXOffset = 20;
    frameYOffset = 20;
   
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    CGRect textFrame = CGRectInset(bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
//    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), 15.0, NULL);
//
//    
//    [attString addAttribute:(id)kCTFontAttributeName
//                      value:(__bridge id)helvetica
//                      range:NSMakeRange(0, [attString length])];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);

    int textPos = 0; //3
    int columnIndex = 0;
    
    if (textPos < [attString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*frameXOffset + columnIndex*(textFrame.size.width), 20 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width, textFrame.size.height );
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);

        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
		//set the column view contents and add it as subview
        [content setCTFrame:(__bridge id)frame];  //6
        [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }

    /*
         //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
               
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame:textFrame] ;
        content.backgroundColor = [UIColor clearColor];
     //   content.frame = CGRectMake(0, 0, 280, 500) ;
        
		//set the column view contents and add it as subview
    
        [content setCTFrame:(__bridge id)frame];
        if(frame)
            [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];
        
       // CFRelease(frame);
     */
        CFRelease(path);
     
}

//-(void)setAttString:(NSAttributedString *)string //withImages:(NSArray*)imgs
//{
//    self.attString = string;
////    self.images = imgs;
//}
/*
-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col
{
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
	            runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
	            runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x, colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject: //11
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ]; 
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}
*/
-(void)dealloc
{
    self.attString = nil;
    self.frames = nil;
//    self.images = nil;
}

@end
