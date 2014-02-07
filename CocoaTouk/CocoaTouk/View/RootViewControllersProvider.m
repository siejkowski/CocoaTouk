//
// Created by Krzysztof Siejkowski on 05/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "RootViewControllersProvider.h"
#import "SearchViewController.h"
#import "FavouritesViewController.h"
#import "MiscViewController.h"


@implementation RootViewControllersProvider {

}
+ (id)provideSearchViewController {

    UIViewController* loginViewController = [[SearchViewController alloc] init];
    loginViewController.title = @"Search";
    UINavigationController* loginNavigationController =
            [[UINavigationController alloc] initWithRootViewController:loginViewController];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1];
    tabBarItem.tag = 1;
    [loginNavigationController setTabBarItem:tabBarItem];
    return loginNavigationController;
}

+ (id)provideFavouritesViewController {
    UIViewController* resultsViewController = [[FavouritesViewController alloc] init];
    resultsViewController.title = @"Favorites";
    UINavigationController* resultsNavigationController =
            [[UINavigationController alloc] initWithRootViewController:resultsViewController];
    UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    [resultsNavigationController setTabBarItem:tabBarItem];

    return resultsNavigationController;
}

@end