//
// Created by Krzysztof Siejkowski on 05/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "FavouritesViewController.h"
#import "ResultViewController.h"
#import "FavouritesDataSource.h"

@interface FavouritesViewController () <UITableViewDelegate>
@property UITableView* tableView;
@property FavouritesDataSource* dataSource;
@end

@implementation FavouritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.dataSource = [[FavouritesDataSource alloc] init];

    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;

    __weak typeof(self) bself = self;
    self.dataSource.loadingBlock = ^{
        [bself.tableView reloadData];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dataSource loadDataFromDatabase];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResultViewController* resultViewController = [[ResultViewController alloc] init];
    resultViewController.trackId = [self.dataSource trackIdForIndexPath:indexPath];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end