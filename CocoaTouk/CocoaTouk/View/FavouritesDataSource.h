//
// Created by Krzysztof Siejkowski on 07/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FavouritesDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, copy) void (^loadingBlock)();
- (NSNumber*)trackIdForIndexPath:(NSIndexPath*)path;
- (void)loadDataFromDatabase;
@end