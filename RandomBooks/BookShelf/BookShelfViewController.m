

#import "BookShelfViewController.h"
#import "Book.h"
#import "BookView.h"
#import "BookShelfCellView.h"
#import "BelowBottomView.h"
#import <QuartzCore/QuartzCore.h>
#define CELL_HEIGHT 139.0f
#import "ReaderViewController.h"
#import "RandomChooserViewController.h"


@implementation BookShelfViewController {
    NSFetchedResultsController* _frc;
}

- (void)initBarButtons {
    _editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    _cancleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleButtonClicked:)];
    
    _trashBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonClicked:)];
    _addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
}

- (void)switchToNormalMode {
    _editMode = NO;
    
    [self.navigationItem setLeftBarButtonItem:_editBarButton];
    [self.navigationItem setRightBarButtonItem:_addBarButton];
}

- (void)switchToEditMode {
    _editMode = YES;
    [self.navigationItem setLeftBarButtonItem:_cancleBarButton];
    [self.navigationItem setRightBarButtonItem:_trashBarButton];
  
    
    for (BookView *bookView in [_bookShelfView visibleBookViews]) {
        [bookView setSelected:NO];
    }
}

#pragma mark - View lifecycle

- (void)testScrollToRow {
    [_bookShelfView scrollToRow:34 animate:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBarButtons];
    [self switchToNormalMode];
    
	_frc = [Book fetchAllSortedBy:BookAttributes.title ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"%K = YES", BookAttributes.favorite] groupBy:nil delegate:self];
    
    //AboveTopView *aboveTop = [[AboveTopView alloc] initWithFrame:CGRectMake(0, 0, 320, 164)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _belowBottomView = [[BelowBottomView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT * 2)];
    [_belowBottomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
   
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _bookShelfView = [[GSBookShelfView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 460 - 44)];
    [_bookShelfView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_bookShelfView setDataSource:self];
    
    [self.view addSubview:_bookShelfView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"will rotate from %u to %u", [[UIDevice currentDevice] orientation], toInterfaceOrientation);
    // TODO:only set orientation change flag when protrait to landscape and reverse
    [_bookShelfView oritationChangeReloadData];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"will animate rotate");
    /*if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        [_bookShelfView setFrame:CGRectMake(0, 0, 480, 320 - 44)];
    }
    else {
        [_bookShelfView setFrame:CGRectMake(0, 0, 320, 460 - 44)];
    }*/
    NSLog(@"bookShelfViewFrame:%@", NSStringFromCGRect(_bookShelfView.frame));
    //[_bookShelfView reloadData];
    //[_bookShelfView oritationChangeReloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didRotate");
    NSLog(@"bookShelfViewFrame:%@", NSStringFromCGRect(_bookShelfView.frame));
    /*for (UIView *cell in [_bookShelfView visibleCells]) {
        CGRect frame = cell.frame;
        [cell.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [cell setFrame:frame];
    }*/
}

#pragma mark GSBookShelfViewDataSource

- (NSInteger)numberOfBooksInBookShelfView:(GSBookShelfView *)bookShelfView {
    return [[_frc fetchedObjects] count]+1;
}

- (NSInteger)numberOFBooksInCellOfBookShelfView:(GSBookShelfView *)bookShelfView {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        return 10;
    }
    else {
        return 6;
    }
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView bookViewAtIndex:(NSInteger)index {
    static NSString *identifier = @"bookView";
    BookView *bookView = (BookView *)[bookShelfView dequeueReuseableBookViewWithIdentifier:identifier];
    if (bookView == nil) {
        bookView = [[BookView alloc] initWithFrame:CGRectZero];
        bookView.reuseIdentifier = identifier;
        [bookView addTarget:self action:@selector(bookViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    Book* book = index?[_frc objectAtIndexPath:[NSIndexPath indexPathForRow:index-1 inSection:0]]:nil;
    [bookView configureWithBook:book];
    return bookView;
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView cellForRow:(NSInteger)row {
    static NSString *identifier = @"cell";
    BookShelfCellView *cellView = (BookShelfCellView *)[bookShelfView dequeueReuseableCellViewWithIdentifier:identifier];
    if (cellView == nil) {
        cellView = [[BookShelfCellView alloc] initWithFrame:CGRectZero];
        [cellView setReuseIdentifier:identifier];
        //[cellView.layer setBorderColor:[[UIColor redColor] CGColor]];
        //[cellView.layer setBorderWidth:2.0f];
    }
    return cellView;
}

- (UIView *)aboveTopViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return nil;
}

- (UIView *)belowBottomViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return _belowBottomView;
}

- (UIView *)headerViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return _searchBar;
}

- (CGFloat)cellHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return CELL_HEIGHT;
}

- (CGFloat)cellMarginOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 20.0f;
}

- (CGFloat)bookViewHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 88.0f;
}

- (CGFloat)bookViewWidthOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 74.0f;
}

- (CGFloat)bookViewBottomOffsetOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 123.0f;
}

- (CGFloat)cellShadowHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    //return 0.0f;
    return 55.0f;
}

- (void)bookShelfView:(GSBookShelfView *)bookShelfView moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

}

#pragma mark - BarButtonListener 

- (void)editButtonClicked:(id)sender {
    [self switchToEditMode];
}

- (void)cancleButtonClicked:(id)sender {
    [self switchToNormalMode];
}


#pragma mark - BookView Listener

- (void)bookViewClicked:(UIButton *)button {
    BookView *bookView = (BookView *)button;
    if (!bookView.book) {
        [self presentModalViewController:[[RandomChooserViewController alloc] initWithNibName:@"RandomChooserViewController" bundle:nil] animated:YES];
    } else {
        
            [self presentModalViewController:[[ReaderViewController alloc] initWithNibName:@"ReaderViewController" bundle:nil] animated:YES];
    }
}

@end
