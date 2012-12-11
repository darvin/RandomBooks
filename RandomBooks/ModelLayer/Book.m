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
        
        
        // create a new UUID which you own
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        
        // create a new CFStringRef (toll-free bridged to NSString)
        // that you own
        NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        
        
        // release the UUID
        CFRelease(uuid);
        
        book.imageLink = [NSString stringWithFormat:@"http://getkitten-darvin.rhcloud.com/kitten.png?nonsense=%@", uuidString];
        book.favoriteValue = (arc4random()%5==1);
        
    }
}
-(NSURL*) imageURL {
    return [NSURL URLWithString:self.imageLink];
}
@end
