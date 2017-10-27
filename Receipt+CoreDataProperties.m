//
//  Receipt+CoreDataProperties.m
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//
//

#import "Receipt+CoreDataProperties.h"

@implementation Receipt (CoreDataProperties)

+ (NSFetchRequest<Receipt *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Receipt"];
}

@dynamic timestamp;
@dynamic note;
@dynamic amount;
@dynamic hasTag;

@end
