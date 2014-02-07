//
// Created by Krzysztof Siejkowski on 06/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "SearchDataSource.h"

@interface SearchDataSource ()
@property NSArray* results;
@end

@implementation SearchDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _results = [NSArray array];
        void (^notificationBlock)(NSNotification*) = ^(NSNotification* note) {
            NSMutableArray* results = [NSMutableArray array];
            [[note.object valueForKeyPath:@"message.body.track_list"] enumerateObjectsUsingBlock:
                    ^(NSDictionary* obj, NSUInteger idx, BOOL* stop) {
                        [results addObject:[obj valueForKey:@"track"]];
                    }];
            self.results = [results copy];
        };
        [[NSNotificationCenter defaultCenter] addObserverForName:@"searchResults"
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:notificationBlock];
    }

    return self;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];

    cell = cell ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];

    cell.textLabel.text = [[self.results objectAtIndex:(NSUInteger) indexPath.row] valueForKeyPath:@"track_name"];
    cell.detailTextLabel.text = [[self.results objectAtIndex:(NSUInteger) indexPath.row] valueForKeyPath:@"artist_name"];

    return cell;
}

- (NSDictionary*)trackForIndexPath:(NSIndexPath*)path {
    return [self.results objectAtIndex:(NSUInteger) path.row];
}

@end