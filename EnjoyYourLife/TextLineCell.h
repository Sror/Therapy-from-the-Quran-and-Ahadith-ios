//
//  LineLayer.h
//  iGitpad
//
//  Created by Johannes Lund on 2012-12-17.
//
//

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define MARGIN 10

@interface TextLineCell : UITableViewCell

@property (nonatomic, assign) CTLineRef line;
@end
