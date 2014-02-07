//
// Created by Krzysztof Siejkowski on 06/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "ResultViewController.h"
#import "Favourite.h"
#import "NetworkManager.h"

@interface ResultViewController ()

@property UITextView* songLyrics;
@property BOOL foundInDatabase;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    void (^notificationBlock)(NSNotification*) = ^(NSNotification* note) {
        [self.songLyrics setAttributedText:[self attributedStringForString:note.object]];
        UIBarButtonItem* addToFavorites = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(addToDatabase)];
        [self.navigationItem setRightBarButtonItem:addToFavorites];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:@"lyrics"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:notificationBlock];

    self.songLyrics = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.songLyrics.editable = NO;
    [self.view addSubview:self.songLyrics];

    self.trackId = self.trackId ?: [self.track valueForKeyPath:@"track_id"];
    NSArray* favourites = [Favourite MR_findByAttribute:@"trackId" withValue:self.trackId];
    if ([favourites count] > 0) {
        [self.songLyrics setAttributedText:[self attributedStringForString:[[favourites firstObject] lyrics]]];
        self.foundInDatabase = YES;
    } else
        [[NetworkManager sharedManager] lyricsForTrackWithId:self.trackId];
}

- (void)addToDatabase {
    Favourite* favourite = [Favourite MR_createEntity];
    favourite.trackId = [self.track valueForKeyPath:@"track_id"];
    favourite.artistName = [self.track valueForKeyPath:@"artist_name"];
    favourite.albumName = [self.track valueForKeyPath:@"album_name"];
    favourite.trackName = [self.track valueForKeyPath:@"track_name"];
    favourite.albumCover = [self.track valueForKeyPath:@"album_coverart_100x100"];
    favourite.lyrics = [self.songLyrics text];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (NSAttributedString*)attributedStringForString:(NSString*)string {
    return [[NSAttributedString alloc] initWithString:string attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:16.f]
    }];
}

@end