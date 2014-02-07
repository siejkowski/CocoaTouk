//
// Created by Krzysztof Siejkowski on 05/02/14.
// Copyright (c) 2014 Touk. All rights reserved.
//

#import "SearchViewController.h"
#import "UIView+KeepLayout.h"
#import "KeepAttribute.h"
#import "NetworkManager.h"
#import "NSArray+KeepLayout.h"
#import "SearchDataSource.h"
#import "ResultViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate>
@property (nonatomic) UISearchBar* searchBar;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) SearchDataSource* dataSource;
@property (nonatomic) UISegmentedControl* segmentedControl;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [self allocSubviews];
    [self addSubviews];
    [self positionSubviews];
    [self setupSubviews];
}

- (void)allocSubviews {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Lyrics", @"Artist", @"Track", @"Any"]];
    self.searchBar = [[UISearchBar alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.dataSource = [[SearchDataSource alloc] init];
}

- (void)addSubviews {
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)positionSubviews {
    [self.searchBar keepHorizontallyCenteredWithPriority:KeepPriorityHigh];
    [[self.segmentedControl keepTopInset] setEqual:KeepHigh(5.f)];
    [[self.segmentedControl keepLeftInset] setEqual:KeepHigh(10.f)];
    [[self.segmentedControl keepRightInset] setEqual:KeepHigh(10.f)];
    [[self.tableView keepBottomInset] setEqual:KeepHigh(0.f)];
    [[@[self.searchBar, self.tableView] keepLeftInset] setEqual:KeepHigh(0.f)];
    [[@[self.searchBar, self.tableView] keepRightInset] setEqual:KeepHigh(0.f)];
    [@[self.segmentedControl, self.searchBar] keepVerticalOffsets:KeepHigh(5.f)];
    [@[self.searchBar, self.tableView] keepVerticalOffsets:KeepHigh(0.f)];
}

- (void)setupSubviews {
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.dataSource addObserver:self forKeyPath:@"results" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    [self.tableView reloadData];
}

- (void)dealloc {
    [self.dataSource removeObserver:self forKeyPath:@"results"];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
    switch ([self.segmentedControl selectedSegmentIndex]) {
        case 0:
            [[NetworkManager sharedManager] searchForSongWithLyrics:[searchBar text]];
            break;
        case 1:
            [[NetworkManager sharedManager] searchForSongByArtist:[searchBar text]];
            break;
        case 2:
            [[NetworkManager sharedManager] searchForSongByTrack:[searchBar text]];
            break;
        case 3:
            [[NetworkManager sharedManager] searchForSongMatchingString:[searchBar text]];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResultViewController* resultViewController = [[ResultViewController alloc] init];
    resultViewController.track = [self.dataSource trackForIndexPath:indexPath];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end