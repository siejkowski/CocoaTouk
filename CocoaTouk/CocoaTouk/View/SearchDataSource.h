//
// Created by Krzysztof Siejkowski on 06/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDataSource : NSObject <UITableViewDataSource>
- (NSDictionary*)trackForIndexPath:(NSIndexPath*)path;
@end