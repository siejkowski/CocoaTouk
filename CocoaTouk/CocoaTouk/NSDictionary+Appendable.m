//
// Created by Krzysztof Siejkowski on 07/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "NSDictionary+Appendable.h"


@implementation NSDictionary (Appendable)

- (NSDictionary*)dictionaryFromAppendingDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary* result = [self mutableCopy];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        result[key] = obj;
    }];
    return [result copy];
}

@end