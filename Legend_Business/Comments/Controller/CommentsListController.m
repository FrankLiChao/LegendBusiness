//
//  CommentsListController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/4.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "CommentsListController.h"
#import "CommentsCell.h"
#import "EnterRefuseReasonController.h"
#import "CheckBigImageController.h"

@interface CommentsListController ()<CommentsCellDelgate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation CommentsListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"评价管理";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveAddCommentNotify:) name:SYS_NOTI_ADD_COMMNET_REPLY object:nil];
    
    self.tableView.tableFooterView = [UIView new];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addRefreshHeader:^(MJRefreshHeader * header) {
        if (weakSelf.tableView.mj_footer.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            weakSelf.tableView.mj_header.state = MJRefreshStateIdle;
        } else {
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [weakSelf refreshData];
        }
    }];
    [self.tableView addRefreshFooter:^(MJRefreshFooter * footer) {
        if (weakSelf.tableView.mj_header.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
            weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        } else {
            [weakSelf loadData];
        }
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYS_NOTI_ADD_COMMNET_REPLY object:nil];
}

#pragma mark custom methods
- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    [self getCommentsList:@"0"
                  success:^(NSArray<CommentsModel *> *array) {
                      weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                      [weakSelf.tableView reloadData];
                      [weakSelf.tableView.mj_header endRefreshing];
                      weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
                  } failed:^(NSString *errorDes) {
                      [self showHint:errorDes];
                      [weakSelf.tableView.mj_header endRefreshing];
                  }];
}

- (void)loadData{
    __weak typeof(self) weakSelf = self;
    CommentsModel *model = [self.dataArray lastObject];
    if (model) {
        [self getCommentsList:model.comment_id
                      success:^(NSArray<CommentsModel *> *array) {
                          if (!array || array.count <=0) {
                              [weakSelf.tableView.mj_footer endRefreshing];
                              weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                          } else {
                              [weakSelf.dataArray addObjectsFromArray: array];
                              [weakSelf.tableView reloadData];
                              [weakSelf.tableView.mj_footer endRefreshing];
                          }
                      } failed:^(NSString *errorDes) {
                          [self showHint:errorDes];
                          [weakSelf.tableView.mj_footer endRefreshing];
                      }];
    } else {
        weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [weakSelf.tableView.mj_footer endRefreshing];
    }
}

#pragma mark -  UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return [CommentsCell cellHeight:model];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    cell.delegate = self;
    CommentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

#pragma mark CommentsCellDelgate
- (void)replyComments:(CommentsCell*)cell{
    NSIndexPath *index = [_tableView  indexPathForCell:cell];
    CommentsModel *model = [self.dataArray objectAtIndex:index.row];
    EnterRefuseReasonController *vc = [[EnterRefuseReasonController alloc] initWithNibName:@"EnterRefuseReasonController" bundle:nil];
    vc.ID = model.comment_id;
    vc.type = InPutTextViewType_Comments;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkImageDetail:(NSString*)imageUrl{
    CheckBigImageController *vc = [[CheckBigImageController alloc] initWithURL:imageUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark notify
- (void)reciveAddCommentNotify:(NSNotification*)notify{
    NSDictionary *dic = [notify object];
    NSString *replayContent = [dic objectForKey:@"content"];
    NSString *commentId = [dic objectForKey:@"ID"];
    
    [self.dataArray enumerateObjectsUsingBlock:^(CommentsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.comment_id integerValue] == [commentId integerValue]) {
            obj.reply_content = replayContent;
            [self.tableView reloadData];
            *stop = YES;
        }
    }];
}
@end
