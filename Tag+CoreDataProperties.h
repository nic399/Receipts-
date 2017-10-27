//
//  Tag+CoreDataProperties.h
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//
//

#import "Tag+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tag (CoreDataProperties)

+ (NSFetchRequest<Tag *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *tagName;
@property (nullable, nonatomic, retain) NSSet<Receipt *> *receiptHasTag;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addReceiptHasTagObject:(Receipt *)value;
- (void)removeReceiptHasTagObject:(Receipt *)value;
- (void)addReceiptHasTag:(NSSet<Receipt *> *)values;
- (void)removeReceiptHasTag:(NSSet<Receipt *> *)values;

@end

NS_ASSUME_NONNULL_END
