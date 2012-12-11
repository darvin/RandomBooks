/*
 ViewController.m
 BookShelf
 
 Created by Xinrong Guo on 12-2-22.
 Copyright (c) 2012 FoOTOo. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 Neither the name of the project's author nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "ViewController.h"
#import "Book.h"
#import "MyBookView.h"
#import "BookShelfCellView.h"
#import "BelowBottomView.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT 139.0f

@implementation ViewController {
    NSFetchedResultsController* _frc;
}

/*
- (void)initBooks {
    NSInteger numberOfBooks = 100;
    _bookArray = [[NSMutableArray alloc] initWithCapacity:numberOfBooks];
    _bookStatus = [[NSMutableArray alloc] initWithCapacity:numberOfBooks];
    for (int i = 0; i < numberOfBooks; i++) {
        NSNumber *number = [NSNumber numberWithInt:i % 4 + 1];
        [_bookArray addObject:number];
        [_bookStatus addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    
    _booksIndexsToBeRemoved = [NSMutableIndexSet indexSet];
}*/

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
  
    
    for (MyBookView *bookView in [_bookShelfView visibleBookViews]) {
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
    //[_belowBottomView.layer setBorderWidth:2.0];
    //[_belowBottomView.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    //MyBelowBottomView *belowBottom = [[MyBelowBottomView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT * 2)];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _bookShelfView = [[GSBookShelfView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 460 - 44)];
    [_bookShelfView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_bookShelfView setDataSource:self];
    //[_bookShelfView.layer setBorderWidth:2.0];
    //[_bookShelfView.layer setBorderColor:[[UIColor greenColor] CGColor]];
    //[_bookShelfView setShelfViewDelegate:self];
    
    [self.view addSubview:_bookShelfView];
    
    //[self performSelector:@selector(testScrollToRow) withObject:self afterDelay:3];
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
    return [[_frc fetchedObjects] count];
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
    MyBookView *bookView = (MyBookView *)[bookShelfView dequeueReuseableBookViewWithIdentifier:identifier];
    if (bookView == nil) {
        bookView = [[MyBookView alloc] initWithFrame:CGRectZero];
        bookView.reuseIdentifier = identifier;
        [bookView addTarget:self action:@selector(bookViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [bookView setIndex:index];
    Book* book = [_frc objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    [bookView.bookImage setImageWithURL:[book imageURL]];
    [bookView setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", 2]] forState:UIControlStateNormal];
    return bookView;
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView cellForRow:(NSInteger)row {
    static NSString *identifier = @"cell";
    /*MyCellView *cellView = (MyCellView *)[bookShelfView dequeueReuseableCellViewWithIdentifier:identifier];
    if (cellView == nil) {
        cellView = [[MyCellView alloc] initWithFrame:CGRectZero];
        cellView.reuseIdentifier = identifier;
        [cellView.layer setBorderColor:[[UIColor redColor] CGColor]];
        [cellView.layer setBorderWidth:2.0f];
    }
    [cellView.label setText:[NSString stringWithFormat:@"row:%d", row]];
    return cellView;*/
    
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
    MyBookView *bookView = (MyBookView *)button;
    
    if (_editMode) {
        NSNumber *status = [NSNumber numberWithInt:bookView.selected];

    }
    else {
        [bookView setSelected:NO];
    }
}

@end