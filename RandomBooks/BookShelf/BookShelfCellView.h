
#import <UIKit/UIKit.h>
#import "GSBookShelfCell.h"

typedef enum {
    WOOD_PART_1,
    WOOD_PART_2
}WoodPart;

@interface BookShelfCellView : UIView <GSBookShelfCell> {
    
}

@property (nonatomic, strong) NSString *reuseIdentifier;

@end
