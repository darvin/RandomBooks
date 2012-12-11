#import "Book.h"


@interface Book ()

// Private interface goes here.

@end


@implementation Book

+(void) populate {
    for (int i =0; i<arc4random()%20+8; i++) {
        Book* book = [Book createEntity];
        book.title = [NSString stringWithFormat:@"Book #%d", i];
        book.author = [NSString stringWithFormat:@"Author #%d", i];
        book.imageLink = @"http://getkitten-darvin.rhcloud.com/kitten.png";
        book.favoriteValue = (arc4random()%5==1);
        
    }
}
-(NSURL*) imageURL {
    return [NSURL URLWithString:self.imageLink];
}
@end
