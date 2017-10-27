//
//  Receipt+CoreDataClass.h
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

NS_ASSUME_NONNULL_BEGIN

@interface Receipt : NSManagedObject

-(NSComparisonResult)compare:(Receipt *)otherReceipt;

@end

NS_ASSUME_NONNULL_END

#import "Receipt+CoreDataProperties.h"
