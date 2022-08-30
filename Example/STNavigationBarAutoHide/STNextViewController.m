//
//  STNextViewController.m
//  STNavigationBarAutoHide_Example
//
//  Created by talon on 2022/8/30.
//  Copyright © 2022 talon. All rights reserved.
//

#import "STNextViewController.h"
#import <UIViewController+NavigationBarAutoHide.h>

@interface STNextViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation STNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Next VC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = ({
        UITableView *view = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.dataSource = self;
        view.delegate = self;
        [self.view addSubview:view];
        view;
    });
    
    [self st_navigationBarAutoHideConfigureScrollView:_tableView];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"AutoHideOff" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - ButtonAction
- (void)rightItemAction
{
    bool enabled = [self st_navigationBarAutoHideEnabled];
    enabled = !enabled;
    [self st_setNavigationBarAutoHideEnabled:enabled];
    
    NSString *title = enabled ? @"AutoHideOff" : @"AutoHideOn";
    self.navigationItem.rightBarButtonItem.title = title;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = @"Click the rightBarButtonItem to change AutoHideEnabled";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
