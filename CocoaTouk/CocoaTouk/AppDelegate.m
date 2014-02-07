//
//  AppDelegate.m
//  CocoaTouk
//
//  Created by Krzysztof Siejkowski on 05/02/14.
//  Copyright (c) 2014 Touk. All rights reserved.
//

#import "AppDelegate.h"
#import "DCIntrospect.h"
#import "PDDebugger.h"
#import "RootViewControllersProvider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    UITabBarController* rootTabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = rootTabBarController;

    [rootTabBarController
            setViewControllers:@[
                    [RootViewControllersProvider provideSearchViewController],
                    [RootViewControllersProvider provideFavouritesViewController]
            ] animated:NO];

    [self.window makeKeyAndVisible];

    [MagicalRecord setupAutoMigratingCoreDataStack];

    [self addDebugTools];
    return YES;
}

- (void)addDebugTools {
    #if TARGET_IPHONE_SIMULATOR
        [[DCIntrospect sharedIntrospector] start];
        PDDebugger *debugger = [PDDebugger defaultInstance];
        [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
        [debugger enableViewHierarchyDebugging];
        [debugger enableNetworkTrafficDebugging];
    #endif
}

- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation {
    if ([[url baseURL] isEqual:@"touk://"])
        return YES;
    return NO;
}

@end