//
//  ViewController.m
//  CellEmbedTableView
//
//  Created by huangyibiao on 16/3/1.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "HYBTestCell.h"
#import "HYBTestModel.h"
#import "HYBCommentModel.h"
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, HYBTestCellDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:tableView];
  self.tableView = tableView;
  
  for (NSUInteger i = 0; i < 100; ++i) {
    HYBTestModel *testModel = [[HYBTestModel alloc] init];
    testModel.title = @"标哥的技术博客";
    testModel.desc = @"由标哥的技术博客出品，学习如何在cell中嵌套使用tableview并自动计算行高。同时演示如何通过HYBMasonryAutoCellHeight自动计算行高，关注博客：http://www.henishuo.com";
    testModel.headImage = @"head";
    testModel.uid = [NSString stringWithFormat:@"testModel%ld", i + 1];
    NSUInteger randCount = arc4random() % 10 + 1;
    for (NSUInteger j = 0; j < randCount; ++j) {
      HYBCommentModel *model = [[HYBCommentModel alloc] init];
      model.name = @"标哥";
      model.reply = @"标哥的技术博客";
      model.comment = @"可以试试HYBMasonryAutoCellHeight这个扩展，自动计算行高的";
      model.cid = [NSString stringWithFormat:@"commonModel%ld", j + 1];
      [testModel.commentModels addObject:model];
    }
    
    [self.datasource addObject:testModel];
  }
  
  tableView.delegate = self;
  tableView.dataSource = self;
  [tableView reloadData];
}

- (NSMutableArray *)datasource {
  if (_datasource == nil) {
    _datasource = [[NSMutableArray alloc] init];
  }
  
  return _datasource;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  if (!cell) {
    cell = [[HYBTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.delegate = self;
  }
  
  HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
  [cell configCellWithModel:model indexPath:indexPath];
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
  
  CGFloat h = [HYBTestCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
    HYBTestCell *cell = (HYBTestCell *)sourceCell;
    [cell configCellWithModel:model indexPath:indexPath];
  } cache:^NSDictionary *{
    NSDictionary *cache = @{kHYBCacheUniqueKey : model.uid,
             kHYBCacheStateKey  : @"",
             kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
    model.shouldUpdateCache = NO;
    return cache;
  }];

  return h;
}

#pragma mark - HYBTestCellDelegate
- (void)reloadCellHeightForModel:(HYBTestModel *)model atIndexPath:(NSIndexPath *)indexPath {
  [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
