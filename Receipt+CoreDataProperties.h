//
//  Receipt+CoreDataProperties.h
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//
//

#import "Receipt+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSDecimalNumber *amount;
@property (nullable, nonatomic, retain) NSSet<Tag *> *hasTag;

@end

@interface Receipt (CoreDataGeneratedAccessors)

- (void)addHasTagObject:(Tag *)value;
- (void)removeHasTagObject:(Tag *)value;
- (void)addHasTag:(NSSet<Tag *> *)values;
- (void)removeHasTag:(NSSet<Tag *> *)values;

@end

NS_ASSUME_NONNULL_END
