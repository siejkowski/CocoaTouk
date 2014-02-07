//
//  Favourite.h
//  CocoaTouk
//
//  Created by Krzysztof Siejkowski on 06/02/14.
//  Copyright (c) 2014 Touk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favourite : NSManagedObject

@property (nonatomic, retain) NSNumber * trackId;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSString * albumCover;
@property (nonatomic, retain) NSString * lyrics;

@end
