//
//  MainViewController.m
//  GNCustomTransition
//
//  Created by zhanggenning on 16/2/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "MainViewController.h"
#import "CrossFirstViewController.h"
#import "SwipeFirstViewController.h"
#import "CustomPresentationFirstViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *tableName;
    NSArray *detailName;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableName = @[@"淡入淡出", @"滑动返回", @"自定义"];
    detailName = @[@"简单的自定义转场", @"交互的自定义转场", @"自定义动画"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = tableName[indexPath.row];
    cell.detailTextLabel.text = detailName[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self.navigationController pushViewController:[CrossFirstViewController new] animated:YES];
    }
    else if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[SwipeFirstViewController new] animated:YES];
    }
    else if (indexPath.row == 2)
    {
        [self.navigationController pushViewController:[CustomPresentationFirstViewController new] animated:YES];
    }
}

@end
