//
// Created by Krzysztof Siejkowski on 05/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSDictionary+Appendable.h"

static NSString* const c_BASE_URL = @"http://api.musixmatch.com/ws/1.1/";
static NSString* const c_API_KEY = @"20f500c2cfe6c44d4c784ad3adf0c306";

static NSString* const trackSearchEndpoint = @"track.search";

static NSString* const lyricsGetEndpoint = @"track.lyrics.get";

@interface NetworkManager ()
@property (nonatomic) AFHTTPRequestOperationManager* musixmatchAPIManager;
@property (nonatomic, copy) void (^successBlock)(AFHTTPRequestOperation*, id);
@property (nonatomic, copy) void (^failureBlock)(AFHTTPRequestOperation*, NSError*);
@property(nonatomic, strong) NSDictionary* parameters;
@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static NetworkManager* instance;
    dispatch_once(&onceToken, ^{
       instance = [[NetworkManager alloc] initNetworkManager];
    });
    return instance;
}

- (instancetype)initNetworkManager {
    self = [super init];
    if (self) {
        _musixmatchAPIManager = [[AFHTTPRequestOperationManager alloc]
                initWithBaseURL:[[NSURL alloc] initWithString:c_BASE_URL]];
        _musixmatchAPIManager.responseSerializer.acceptableContentTypes =
                [NSSet setWithArray:@[@"application/json", @"text/plain"]];
        _successBlock = ^(AFHTTPRequestOperation* operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchResults"
                                                                object:responseObject];
        };
        _failureBlock = ^(AFHTTPRequestOperation* operation, NSError* error) {
            NSLog(@"%@", error);
        };
        _parameters = @{
                @"apikey" : c_API_KEY,
                @"page_size" : @100
        };
    }
    return self;
}

- (void)searchForSongWithLyrics:(NSString*)lyrics {
  [self performSearchRequestWithParameters:@{
            @"q_lyrics" : lyrics ?: @""
    }];
}

- (void)searchForSongByArtist:(NSString*)artist {
    [self performSearchRequestWithParameters:@{
            @"q_artist" : artist ?: @""
    }];
}

- (void)searchForSongByTrack:(NSString*)track {
    [self performSearchRequestWithParameters:@{
            @"q_track" : track ?: @""
    }];
}

- (void)searchForSongMatchingString:(NSString*)string {
    [self performSearchRequestWithParameters:@{
            @"q" : string ?: @""
    }];
}

- (void)performSearchRequestWithParameters:(NSDictionary*)parameters {
    [self.musixmatchAPIManager GET:trackSearchEndpoint
                        parameters:[self.parameters dictionaryFromAppendingDictionary:parameters]
                           success:self.successBlock
                           failure:self.failureBlock];
}

- (void)lyricsForTrackWithId:(NSNumber*)number {
    [self.musixmatchAPIManager GET:lyricsGetEndpoint
                        parameters:[self.parameters dictionaryFromAppendingDictionary:@{
                                @"track_id" : number,
                                @"format" : @"json"
                        }] success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lyrics"
                                                            object:[responseObject valueForKeyPath:@"message.body.lyrics.lyrics_body"]];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"%@", error);
    }];
}
@end