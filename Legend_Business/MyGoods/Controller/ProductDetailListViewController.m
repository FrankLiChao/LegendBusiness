//
//  ProductDetailListViewController.m
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProductDetailListViewController.h"
#import "DKScrollingTabController.h"
#import "UIImageView+WebCache.h"
#import "ProductPicCell.h"
#import "ProductPropertyCell.h"
#import "legend_business_ios-swift.h"


@interface ProductDetailListViewController ()<DKScrollingTabControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>


@property (nonatomic,strong)DKScrollingTabController *tabBarView;
@property (nonatomic,strong)NSMutableDictionary *cellDict;


@end

@implementation ProductDetailListViewController{

    float desHeight;//图文详情高度
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButton];
    self.title = @"商品详情";
    
    self.cellDict = [NSMutableDictionary dictionary];
  
    [self initCustomSeg];
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
-(void)initCustomSeg{
    
    NSLog(@"---view = %f",self.view.frame.size.height);
    
    
   /*
    self.tabBarView = [[DKScrollingTabController alloc] initWithFrame:CGRectMake(0, 64, SYS_UI_WINSIZE_WIDTH, 44)];
    
    
    
    _tabBarView.delegate = self;
    
    [self.view addSubview:_tabBarView];
    
    
    _tabBarView.backgroundColor = [UIColor whiteColor];
    // tabController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, customTableBarHeight);
    
    // controller customization
    _tabBarView.selectionFont =  [UIFont systemFontOfSize:14];
    _tabBarView.buttonInset = 0;
    _tabBarView.firstButtonInset = 0;
    _tabBarView.buttonPadding = SYS_UI_WINSIZE_WIDTH/2;
    _tabBarView.unselectedTextColor = SYS_UI_COLOR_TEXT_BLACK;
    
    _tabBarView.translucent = NO; // experimental, this overrides background colors
    [_tabBarView setUnselectedBackgroundColor:[UIColor whiteColor]];//未选中的背景色
    [_tabBarView setSelectedBackgroundColor:[UIColor whiteColor]];//选中了的背景色
    
    [UitlCommon setFlat:_tabBarView radius:0 color:SYS_UI_COLOR_LINE_IN_LIGHT borderWith:1];
    
    _tabBarView.buttonsScrollView.showsHorizontalScrollIndicator = NO;
    
    //add indicator
    _tabBarView.selectedTextColor = SYS_UI_COLOR_TEXT_BLACK;
    _tabBarView.selectIndexColor = SYS_UI_COLOR_BG_ORANGE;
    
    _tabBarView.underlineIndicator = YES; // the color is from selectedTextColor property
    
    _tabBarView.selection  = @[@"图文详情",@"尺寸规格"];*/
}

-(void)initUI{
    
    float height = [UIScreen mainScreen].bounds.size.height - 108 - 50;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,50+64, [UIScreen mainScreen].bounds.size.width, height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.tag = 100;
    _scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*_tabBarView.selection.count, 0);

    desHeight = height;
    
    //UITableView *lastTabl = nil;
    for (int i =0; i<_tabBarView.selection.count; i++) {
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width,
                                                                           0,
                                                                           [UIScreen mainScreen].bounds.size.width,
                                                                           height)];
        
        [self.scrollView addSubview:table];
        
        
        
        //lastTabl = table;
        
        table.tag = i+1;
        
        table.delegate =self;
        table.dataSource =self;
        
        table.backgroundColor = [UIColor clearColor];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
//        __weak ProductDetailListViewController *weakSelf = self;
//        
//        __block UITableView *tempTable = table;
//        
//        [table addPullToRefreshWithActionHandler:^{
//            
//            [weakSelf pullDetail:tempTable];
//        }];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
//        label.text = @"下拉显示商品详情";
//        label.textColor = SYS_UI_COLOR_TEXT_GRAY;
//        label.font = [UIFont fontWithName:SYS_UI_FONT_BASE size:14];
//        label.backgroundColor = SYS_UI_COLOR_BG_COLOR;
//        [table.pullToRefreshView addSubview:label];
//        label.textAlignment = NSTextAlignmentCenter ;
    }
    
}

-(void)pullDetail:(UITableView*)table{
    
//    [table.pullToRefreshView stopAnimating];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(pullToShowProudctDetail:)]) {
//        [self.delegate pullToShowProudctDetail:self];
//    }
}

#pragma mark DKScrollingTabControllerDelegate
- (void)ScrollingTabController:(DKScrollingTabController*)controller selection:(NSUInteger)selection{
    
  //  [_scrollView setContentOffset:CGPointMake(selection*SYS_UI_WINSIZE_WIDTH, 0) animated:YES];
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrol
{
//    if (aScrol.tag == 100) {
//        
//        CGFloat pageWidth = SYS_UI_WINSIZE_WIDTH;
//        int page = floor((aScrol.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//        
//        if (page<0 || page> _tabBarView.selection.count-1) {
//            return;
//        }
//        
//        if (_tabBarView.selectSection == page) {
//            return;
//        }
//        
//        [_tabBarView selectButtonWithIndex:page];
//        
//    }
    
}


#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 1://图文详情
        {
            
            return desHeight;
            
            //
            //            ProductPicCell *cell = [self.cellDict objectForKey:@"ProductPicCell"];
            //            if (!cell) {
            //                cell =  [[ProductPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductPicCell"];
            //                [self.cellDict setObject:cell forKey:@"ProductPicCell"];
            //
            //            }
            //
            //            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[_picArray  objectAtIndex:indexPath.row]] placeholderImage:nil];
            //
            //            [cell setNeedsUpdateConstraints];
            //            [cell updateConstraintsIfNeeded];
            //
            //            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
            //
            //
            //            [cell setNeedsLayout];
            //            [cell layoutIfNeeded];
            //
            //            // 得到cell的contentView需要的真实高度
            //            CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            //            return height;
        }
            break;
        case 2://规格尺寸
        {
            
                        ProductPropertyCell *cell = [self.cellDict objectForKey:@"ProductPropertyCell"];
                        if (!cell) {
                            cell =  [[ProductPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductPropertyCell"];
                        }
            
                        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:_currentModel.size_img] placeholderImage:[UIImage imageNamed:@"默认"]];
            
                        [cell setNeedsUpdateConstraints];
                        [cell updateConstraintsIfNeeded];
            
                        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
            
            
                        [cell setNeedsLayout];
                        [cell layoutIfNeeded];
            
                        // 得到cell的contentView需要的真实高度
                        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                        return height;
            
            //return 41;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == 2) {
//        return 41;
//    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (tableView.tag) {
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
            return 1;
            break;
        case 2:{
            return 1;
            //return _currentModel.not_buy_attr_list.count;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 1://图文详情
        {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myProductPicCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myProductPicCell"];
                
                UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tableView.frame.size.height)];
                web.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                web.scrollView.scrollEnabled = NO;
                [cell.contentView addSubview:web];
                [web  loadHTMLString:_currentModel.goods_desc baseURL:nil];
            }
            
            
            
            
            //            ProductPicCell *cell = (ProductPicCell*)[tableView dequeueReusableCellWithIdentifier:@"ProductPicCell"];
            //            if (!cell) {
            //                cell =  [[ProductPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductPicCell"];
            //                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            }
            //
            //            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[_picArray  objectAtIndex:indexPath.row]] placeholderImage:nil];
            //
            //
            //            [cell setNeedsUpdateConstraints];
            //            [cell updateConstraintsIfNeeded];
            
            return cell;
        }
            break;
        case 2://规格尺寸
        {
            
            
            
           // ProductNotBuyAttrListModel *model = [_currentModel.not_buy_attr_list objectAtIndex:indexPath.row];
            
            
            ProductPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductPropertyCell"];
            if (!cell) {
                cell =  [[ProductPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductPropertyCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:_currentModel.size_img] placeholderImage:[UIImage imageNamed:@"默认"]];
            
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
//            NSString *name = model.attr_name;
//            NSString *content = model.attr_value;
//            
//            cell.propertyContentLabel.text = content;
//            cell.propertyNameLabel.text = name;
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SYS_UI_WINSIZE_WIDTH, 41)];
//    label.backgroundColor =  SYS_UI_COLOR_BG_COLOR;
//    
//    label.textColor = SYS_UI_COLOR_TEXT_GRAY;
//    label.font = [UIFont fontWithName:SYS_UI_FONT_BASE size:13];
//    
//    
//    NSString *str =  @"基本信息";
//    if (str) {
//        NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString :str];
//        NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
//        
//        paragraphStyle. alignment = NSTextAlignmentLeft ;
//        [paragraphStyle setFirstLineHeadIndent :12 ];
//        
//        [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , str.length)];
//        [attributedString addAttribute:NSForegroundColorAttributeName  value:SYS_UI_COLOR_TEXT_GRAY range:NSMakeRange(0, str.length)];
//        [attributedString addAttribute:NSFontAttributeName  value:[UIFont fontWithName:SYS_UI_FONT_BASE size:SYS_UI_SCALE_WIDTH_SIZE(14)] range:NSMakeRange(0, str.length)];
//        label.attributedText = attributedString;
//        
//    }
//    
//    
//    return label;
//    
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(CircleListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *currentDataArray = [_dataDic objectForKey:[NSString stringWithFormat:@"%d",selectSegIndex]];
//    if (currentDataArray && currentDataArray.count>indexPath.row) {
//        [cell setCellWithVO:[currentDataArray objectAtIndex:indexPath.row] cellStyle:CellStyle_None showDetail:YES];
//    }
//
//}


#pragma mark UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *height_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    float webheight = [height_str floatValue];
    
    desHeight = webheight;
    CGRect webframe = webView.frame;
    webframe.size.height = webheight;
    webView.frame = webframe;
    webView.scrollView.scrollEnabled = NO;
    
    UITableView *tab = [_scrollView viewWithTag:1];
    [tab reloadData];
}

@end
