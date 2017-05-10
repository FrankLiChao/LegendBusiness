//
//  GoodsPictureViewController.m
//  legend_business_ios
//
//  Created by heyk on 16/3/2.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import "GoodsPictureViewController.h"


@interface GoodsPictureViewController ()<UploadImageCellDelegate,UploadUpdateDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end

@implementation GoodsPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self addRightBarItemWithTitle:@"完成" method:@selector(clickDone:)];
    self.title = @"添加图文详情";
    
}

- (void)setCurrentPicsView:(NSMutableArray *)currentPicsView{
    _currentPicsView = currentPicsView;
    
    for (CustomUploadImageView *view in _currentPicsView) {
        
        view.delegate = self;
    }
}

- (void)clickDone:(UIButton*)button{

    for (CustomUploadImageView *view in _currentPicsView) {
        
        if (view.status == ImageUploadStatus_Uploading) {
            [self showHint:@"请稍后，还有图片正在上传"];
            return;
        }
        else if(view.status == ImageUploadStatus_Failed){
        
            [self showHint:@"有图片上传失败，请删除上传图片重新上传"];
            return;
        }
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGoodsPic:)]) {
        [self.delegate addGoodsPic:self.currentPicsView];
    }
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableVIew delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}




#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    UploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadImageCell"];
    

    if (cell == nil){
        cell =  [[UploadImageCell alloc] initWithReuseIdentifier:@"UploadImageCell" leadEdge:0];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.cellIndex = indexPath;
    
    [cell setUIWithData:self.currentPicsView];
    
    return cell;
}

#pragma mark UploadImageCellDelegate
- (void)clickAddNewImageButton:(UploadImageCell *)cell cellIndex:(NSIndexPath *)cellIndex {

   // [UitlCommon showPicAction:self delegate:self];
    
    __weak typeof(self) weakSelf = self;
    
    [self takeNormalPic:^(UIImage *image) {
        
        
    
        CustomUploadImageView *view = [CustomUploadImageView createUploadImageView:image
                                                                              type:UploadImageType_Edit
                                                                               tag:nil
                                                                        uploadDone:^(NSString *url, UIImage *image, id tag) {
                                                                            
                                                                        }];
        view.delegate = weakSelf;
        
        [weakSelf.currentPicsView addObject:view];
        
        [weakSelf.tableView reloadData];
        
        
    }];
    
}
- (void)deleteImage:(UploadImageCell * __nonnull)cell cellIndex:(NSIndexPath * __nullable)cellIndex selectIndex:(NSInteger)selectIndex{

}

#pragma mark
- (void)deleteUploadImage:(CustomUploadImageView*)view{

    [self.currentPicsView removeObject:view];
    [self.tableView reloadData];
}

@end
