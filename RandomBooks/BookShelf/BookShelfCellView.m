

#import "BookShelfCellView.h"

@implementation BookShelfCellView

@synthesize reuseIdentifier;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 125)];
        
        [imageView setImage:[UIImage imageNamed:@"BookShelfCell.png"]];
        [self addSubview:imageView];
    }
    return self;
}


@end
