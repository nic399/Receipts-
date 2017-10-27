//
//  Receipt+CoreDataClass.m
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//
//

#import "Receipt+CoreDataClass.h"

@implementation Receipt

-(NSComparisonResult)compare:(Receipt *)otherReceipt {
    return [self.note compare:otherReceipt.note];
}

@end
