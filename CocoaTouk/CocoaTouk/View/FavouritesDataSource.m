//
// Created by Krzysztof Siejkowski on 07/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "FavouritesDataSource.h"
#import "Favourite.h"
#import "ResultViewController.h"

@interface FavouritesDataSource ()
@property NSArray* results;
@end

@implementation FavouritesDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _results = [NSArray array];
    }
    return self;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];

    cell = cell ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];

    cell.textLabel.text = [[self.results objectAtIndex:(NSUInteger) indexPath.row] trackName];
    cell.detailTextLabel.text = [[self.results objectAtIndex:(NSUInteger) indexPath.row] artistName];

    return cell;
}

- (NSNumber*)trackIdForIndexPath:(NSIndexPath*)path {
    return [[self.results objectAtIndex:(NSUInteger) path.row] trackId];
}

- (void)loadDataFromDatabase {
    self.results = [Favourite MR_findAll];
    self.loadingBlock ? self.loadingBlock() : ({});
}

@end