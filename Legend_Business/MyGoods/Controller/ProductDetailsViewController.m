//
//  ProductDetailsViewController.m
//  legend
//
//  Created by heyk on 16/1/11.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "DefineKey.h"
#import "PrudctHeaderInfoCell.h"
#import "ProudctPropertySelectView.h"
#import "ProductDetailListViewController.h"
#import "UIViewController+HUD.h"    
#import "legend_business_ios-swift.h"


@interface ProductDetailsViewController ()<ProductDetailListViewControllerDelegate>

@property (nonatomic,strong)ProductModel *currentModel;

@end

@implementation ProductDetailsViewController{
    
    BOOL bAddFootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButton];
    self.title = @"商品详情";
    self.buyButton.hidden = YES;
    [self setUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //[((CustomNavigationController*)self.navigationController) setAlph:self.aTableView.contentOffset.y];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 //   [((CustomNavigationController*)self.navigationController) setAlph:1];
}
#pragma mark custom methods
-(void)setUI{
    
    //
    //    self.buyButtonHeight.constant = SYS_UI_SCALE_WIDTH_SIZE(60);
    //    self.buyButton.titleLabel.font = [UIFont fontWithName:SYS_UI_FONT_BASE size:SYS_UI_SCALE_WIDTH_SIZE(20)];
    //
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak ProductDetailsViewController *weakSelf = self;
    
    [_aTableView addRefreshFooter:^(MJRefreshFooter * view) {
          [weakSelf reloadPicAndTextInfoView];
    }];
}

-(void)loadData{

    //[self showHudInView:self.view hint:nil];
 //   __weak ProductDetailsViewController *weakSelf = self;
//    [[WebEngine shareInstance] getGoodsDetail:self.googsID
//                                      success:^(ProductModel *model) {
//                                          [weakSelf hideHud];
//                                          weakSelf.currentModel = model;
//                                          [weakSelf.aTableView reloadData];
//                                          self.buyButton.hidden = NO;
//                                          
//                                      } failed:^(NSString *errorDes) {
//                                          [weakSelf hideHud];
//                                          [weakSelf showHint:errorDes];
//                                          
//                                      }];
}

-(void)reloadPicAndTextInfoView{
    

    _aTableView.scrollEnabled = NO;
    bAddFootView = YES;
    [_aTableView  reloadData];
    [_aTableView  beginUpdates];
    
    [self scroolToBottom];
    
    [_aTableView endUpdates];

}

-(void)scroolToBottom{
    
  //  [_aTableView.infiniteScrollingView stopAnimating];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_aTableView numberOfRowsInSection:0]-1 inSection:0];
    [_aTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
}

-(IBAction)clickBuyButton:(id)sender{
    
    
    [[ProudctPropertySelectView getInstanceWithNib] showWithProudctID:self.currentModel selectBuy:^( ProductModel *model) {
  
        [self dealBuy:model];
    }];
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//行高
    
    if (indexPath.row == 1) {
        return [UIScreen mainScreen].bounds.size.height;
    }
    
    return  [PrudctHeaderInfoCell cellHeightWithModel:_currentModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//行数
    if (bAddFootView) {
        return 2;
    }
    return 1;// [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BusinessStore" bundle:nil];
            ProductDetailListViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"ProductDetailListViewController"];
            vc.currentModel = self.currentModel;
            [self addChildViewController:vc];
            vc.delegate = self;
            vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);
//            
            [cell.contentView addSubview:vc.view];
        }
        
        return cell;
    }
    NSString *identifierStr = @"PrudctHeaderInfoCell";
    PrudctHeaderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr forIndexPath:indexPath];
    
    [cell setUIWithMode:_currentModel];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   // [((CustomNavigationController*)self.navigationController) setAlph:scrollView.contentOffset.y/64];
}

#pragma mark  PrudctHeaderInfoCellDelegate
-(void)buyAction:(ProductModel*)model{
    
    [self dealBuy:model];
}

/**
 *  点击购买
 *
 *  @param model 要购买的商品信息
 */
-(void)dealBuy:(ProductModel*)model{
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BusinessStore" bundle:nil];
//    OrderConfirmViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"OrderConfirmViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    [vc getInfoWithProucts:@[model]];

}

#pragma mark ProductDetailListViewControllerDelegate
-(void)pullToShowProudctDetail:(UIViewController*)vc{

    bAddFootView = NO;
    _aTableView.scrollEnabled = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_aTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
    
    [_aTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.01];
  
    
}



@end
