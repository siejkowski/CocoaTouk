//
// Created by Krzysztof Siejkowski on 05/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkManager : NSObject
+ (instancetype)sharedManager;

- (void)searchForSongWithLyrics:(NSString*)lyrics;

- (void)searchForSongByArtist:(NSString*)artist;

- (void)searchForSongByTrack:(NSString*)track;

- (void)searchForSongMatchingString:(NSString*)string;

- (void)lyricsForTrackWithId:(NSNumber*)number;
@end