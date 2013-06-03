//
//  CTView.h

#import <UIKit/UIKit.h>
#import "CTColumnView.h"

@interface CTView : UIView {

    float frameXOffset;
    float frameYOffset;

    NSMutableAttributedString* attString;
    
    NSMutableArray* frames;
//    NSArray* images;
}

@property (retain, nonatomic) NSMutableAttributedString* attString;
@property (retain, nonatomic) NSMutableArray* frames;
//@property (retain, nonatomic) NSArray* images;

-(void)buildFrames;
//-(void)setAttString:(NSAttributedString *)attString;// withImages:(NSArray*)imgs;
//-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;

@end