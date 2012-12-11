

#import "BookView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BookView {
    UIImageView *_bookImage;
}
@synthesize reuseIdentifier = _reuseIdentifier;


- (void) configureWithBook:(Book*) book {
    [_bookImage setImageWithURL:[book imageURL]];
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", 2]]  forState: UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        

        _checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookViewChecked.png"]];
        _bookImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
        [_checkedImageView setHidden:YES];
        [self addSubview:_checkedImageView];
        [self addSubview:_bookImage];
        
    }
    return self;
}


@end
