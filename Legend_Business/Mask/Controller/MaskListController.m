//
//  MaskListController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/5.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "MaskListController.h"
#import "MaskListCell.h"
#import "MaskDetailController.h"

@interface MaskListController (){
    
    
}
@property (nonatomic,strong) UISegmentedControl   * seg;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIButton *addNewMaskButton;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)int currentPage;
@end

@implementation MaskListController

- (void)dealloc{


    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveAddNewMasSuccess) name:SYS_ADD_MASK_SUCESS_NOTIFY object:nil];
    
    _tableView.tableFooterView = [UIView new];
    

    _seg = [[UISegmentedControl alloc] initWithItems:@[@"进行中",@"已完成"]];
    [_seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _seg;
    
    CGRect frame = _seg.frame;
    frame.size.width = 200;
    _seg.frame = frame;

    _seg.selectedSegmentIndex = 0;
    
    [UitlCommon setFlatWithView:_addNewMaskButton radius:[Configure SYS_CORNERRADIUS]];
    
    
    self.dataArray = [NSMutableArray array];
    
    _tableView.tableFooterView = [UIView new];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addRefreshHeader:^(MJRefreshHeader * header) {
        
        
        if (weakSelf.tableView.mj_footer.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_header.state = MJRefreshStateIdle;
        }
        else {
            
            weakSelf.currentPage = 1;
            weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            if (weakSelf.seg.selectedSegmentIndex == 0) {
                [weakSelf refreshDingData];
            }
            else{
                [weakSelf refreshFinshData];
            }
            
            
        }
    }];
    [self.tableView addRefreshFooter:^(MJRefreshFooter * footer) {
        if (weakSelf.tableView.mj_header.state == MJRefreshStatePulling ||
            weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        else{
            weakSelf.currentPage++;
            if (weakSelf.seg.selectedSegmentIndex == 0) {
                [weakSelf loadDoingData];
            }
            else{
                [weakSelf loadFinshData];
            }
        }
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
- (void)refreshDingData{
    
    __weak typeof(self) weakSelf = self;
    [self getDoingMaskList:_currentPage
                   success:^(NSArray<MaskListModel *> *array, NSInteger totalPage) {
                       
                       if (weakSelf.seg.selectedSegmentIndex == 0) {
                           
                           
                           if (totalPage<=weakSelf.currentPage) {
                               weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                           }
                           
                           weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                           [weakSelf.tableView reloadData];
                           
                           [weakSelf.tableView.mj_header endRefreshing];
                       }
                   } failed:^(NSString *errorDes) {
                       if (weakSelf.seg.selectedSegmentIndex == 0) {
                           
                           [weakSelf showHint:errorDes];
                           [weakSelf.tableView.mj_header endRefreshing];
                       }
                   }];
    
}

- (void)refreshFinshData{
    
    __weak typeof(self) weakSelf = self;
    [self getFinishMaskList:_currentPage
                   success:^(NSArray<MaskListModel *> *array, NSInteger totalPage) {
                       if (weakSelf.seg.selectedSegmentIndex == 1) {
                 
                           
                           weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                           [weakSelf.tableView reloadData];
                           
                           [weakSelf.tableView.mj_header endRefreshing];
                           
                           
                           if (totalPage<=weakSelf.currentPage) {
                               weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                           }
                       }
                       
                   } failed:^(NSString *errorDes) {
                       if (weakSelf.seg.selectedSegmentIndex == 1) {
                           
                       [weakSelf showHint:errorDes];
                       [weakSelf.tableView.mj_header endRefreshing];
                       }
                   }];
}

- (void)loadDoingData{
    
    __weak typeof(self) weakSelf = self;
    [self getDoingMaskList:_currentPage
                   success:^(NSArray<MaskListModel *> *array, NSInteger totalPage) {
                       
                       if (weakSelf.seg.selectedSegmentIndex == 0) {
                           
                           [weakSelf.dataArray addObjectsFromArray:array];
                           [weakSelf.tableView reloadData];
                           [weakSelf.tableView.mj_footer endRefreshing];
                           
                           if (totalPage<=weakSelf.currentPage) {
                               weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                           }
                       }
                       
                       
                   } failed:^(NSString *errorDes) {
                       if (weakSelf.seg.selectedSegmentIndex == 0) {
                           
                           [weakSelf showHint:errorDes];
                           [weakSelf.tableView.mj_footer endRefreshing];
                       }
                   }];
}
- (void)loadFinshData{
    
    __weak typeof(self) weakSelf = self;
    [self getFinishMaskList:_currentPage
                   success:^(NSArray<MaskListModel *> *array, NSInteger totalPage) {
                       
                       if (weakSelf.seg.selectedSegmentIndex == 1) {
                           
                           [weakSelf.dataArray addObjectsFromArray:array];
                           [weakSelf.tableView reloadData];
                           [weakSelf.tableView.mj_footer endRefreshing];
                           
                           if (totalPage<=weakSelf.currentPage) {
                               weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                           }
                       }
                       
                   } failed:^(NSString *errorDes) {
                       if (weakSelf.seg.selectedSegmentIndex == 1) {
                           
                           [weakSelf showHint:errorDes];
                           [weakSelf.tableView.mj_footer endRefreshing];
                       }
                   }];
}



- (void)segValueChanged:(UISegmentedControl*)seg{
    
    [_tableView.mj_header beginRefreshing];
    
}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 91;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return  [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MaskListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MaskListCell"];
    
    MaskListModel *model =  model =[_dataArray objectAtIndex:indexPath.row];
    
    [cell.headImageV sd_setImageWithURL:[[NSURL alloc] initWithString:model.list_img] placeholderImage:[UIImage imageNamed:@"默认"]];
    cell.desLabel.text = model.desc;
    cell.percentLabel.text = [NSString stringWithFormat:@"%@",model.finish_number];
    cell.totalNumLabel.text =  [NSString stringWithFormat:@"/%@",model.target_number];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MaskListModel *model =  model =[_dataArray objectAtIndex:indexPath.row];
    
    MaskDetailController *vc = [[MaskDetailController alloc] initWithNibName:@"MaskDetailController" bundle:nil];
    vc.maskId = model.mission_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark notify
- (void)recieveAddNewMasSuccess{

      [self.tableView.mj_header beginRefreshing];
}

@end
