
#import <UIKit/UIKit.h>
#import "GSBookShelfView.h"

@class MyBelowBottomView;
@class BelowBottomView;

typedef enum {
    BOOK_UNSELECTED,
    BOOK_SELECTED
}BookStatus;

@interface BookShelfViewController : UIViewController <GSBookShelfViewDelegate, GSBookShelfViewDataSource>{
    GSBookShelfView *_bookShelfView;
    
//    NSMutableArray *_bookStatus;
    
//    NSMutableIndexSet *_booksIndexsToBeRemoved;
    
    BOOL _editMode;
    
    UIBarButtonItem *_editBarButton;
    UIBarButtonItem *_cancleBarButton;
    UIBarButtonItem *_trashBarButton;
    UIBarButtonItem *_addBarButton;
    
    BelowBottomView *_belowBottomView;
    UISearchBar *_searchBar;
}

@end
