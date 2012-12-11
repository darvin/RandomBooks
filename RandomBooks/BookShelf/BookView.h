
#import <UIKit/UIKit.h>
#import "GSBookView.h"
#import "Book.h"
@interface BookView : UIButton <GSBookView> {
    UIImageView *_checkedImageView;
}

- (void) configureWithBook:(Book*) book;

@end
