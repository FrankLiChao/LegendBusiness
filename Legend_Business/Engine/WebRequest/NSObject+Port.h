//
//  NSObject+Port.h
//  legend_business_ios
//
//  Created by heyk on 16/2/25.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettleModel.h"
#import "SaveEngine.h"
#import "UserInfoModel.h"
#import "GoodsCategoryModel.h"
#import "ProductModel.h"
#import "OrderListModel.h"
#import "SellerAfterListModel.h"
#import "CommentsModel.h"
#import "MaskListModel.h"
#import "PromotionModel.h"
#import "Order.h"
#import "BankListVO.h"
#import "PacketModel.h"


#define SYS_WEB_API_SENDMSG             @"/utility/message/sendMsg"
#define SYS_WEB_API_CHECK_MSG           @"/utility/message/checkMsgCode"

#define SYS_WEB_API_UPLOAD_IMAGE        @"/utility/upload_img.php"

//用户协议
#define SYS_WEB_USER_ARGREEMENT         @"/public/comm/agreement.html"
//关于我们
#define SYS_WEB_ABOUT_US                @"/public/comm/aboutUs.html"

#define SYS_WEB_API_INIT                @"/api/init/index"
#define SYS_WEB_API_LOGIN               @"/api/seller/login"
#define SYS_WEB_API_REGISTER            @"/api/seller/register"
#define SYS_WEB_API_REGISTER_Set_PWD    @"/api/seller/registerSetPassword"
#define SYS_WEB_API_Find_PWD            @"/api/seller/findPwd"
#define SYS_WEB_API_GET_SETTLE          @"/api/seller/getSettle"
#define SYS_WEB_API_GET_USERINFO        @"/api/seller/getSellerInfo"
#define SYS_WEB_API_SET_SETTLE          @"/api/seller/setSettle"
#define SYS_WEB_API_CHECK_SETTLE        @"/api/seller/checkSettle"
#define SYS_WEB_API_GET_GOODS_CATEGORY_LIST         @"/api/goods/getGoodsCategoryList"
#define SYS_WEB_API_ADD_GOODS                       @"/api/goods/addGoods"
#define SYS_WEB_API_EDITE_GOODS                     @"/api/goods/editGoods"
#define SYS_WEB_API_GET_SELLER_GOODS_LIST           @"/api/goods/getSellerGoodsList"
#define SYS_WEB_API_CHANGE_GOODS_STATUS             @"/api/goods/changeGoodsStatus"
#define SYS_WEB_API_GET_GOODS_INFO                  @"/api/goods/getGoodsDetail"

//订单
#define SYS_WEB_API_GET_ORDER_LIST                  @"/api/order/getOrderList"
#define SYS_WEB_API_MODIFY_ORDER_STATUS             @"/api/order/modifyOrderStatus"
#define SYS_WEB_API_GET_ORDER_DETAIL                @"/api/order/getOrderDetail"
#define SYS_WEB_API_VERIFY_EXCHANGE_CODE            @"/api/order/verifyExchangeCode"


//售后
#define SYS_WEB_API_GET_SELLER_AFTER_LIST   @"/api/After/getSellerAfterList"
#define SYS_WEB_API_REFUSE_AFTER            @"/api/After/sellerRefuseAfter"
#define SYS_WEB_API_VERIFY_AFTET_GOODS      @"/api/After/sellerVerifyGoods"
#define SYS_WEB_API_AFTET_AGREE_AFTER       @"/api/After/sellerAgreeAfter"

//评论
#define SYS_WEB_API_GET_COMMENT_LIST        @"/api/GoodsComment/getCommentList"
#define SYS_WEB_API_ADD_COMMENTS_REPLAY     @"/api/GoodsComment/addReplyList"

//任务
#define SYS_WEB_API_GET_MASK_LIST           @"/api/mission/getOwnMissionList"
#define SYS_WEB_API_RELEASE_MASK            @"/api/mission/releaseMission"
#define SYS_WEB_API_MASK_PAY                @"/api/mission/missionPay"
#define SYS_WEB_API_GET_MASK_DETAIL         @"/api/mission/getOwnMissionInfo"

//设置
#define SYS_WEB_API_CHANGE_USERINFO         @"/api/seller/changeSellerInfo"
#define SYS_WEB_API_GET_SELLER_CATEGORY     @"/api/seller/getSellerCategory"
#define SYS_WEB_MODIFY_PASSWORD             @"/api/seller/modifyPassword"

//钱包
#define SYS_WEB_API_BANK_LIST               @"/api/Cash/getBankList"
#define SYS_WEB_API_ADD_BANK_CARD           @"/api/cash/addCard"
#define SYS_WEB_API_GET_MY_BANK_LIST        @"/api/cash/getCardList"
#define SYS_WEB_API_UNLOCK_CARD             @"/api/cash/unlockCard"
#define SYS_WEB_API_GET_MODIFY_MONEY        @"/api/cash/modifyCard"
#define SYS_WEB_API_GET_MY_INCOME           @"/api/cash/getMyIncome"
#define SYS_WEB_API_TAKE_CASH               @"/api/cash/takeCash"
#define SYS_WEB_API_CASH_HISTORY_LIST       @"/api/cash/getWithdrawalList"
#define SYS_WEB_API_MY_INCOME_LIST          @"/api/cash/getIncomeList"
#define SYS_WEB_API_GET_DEALING_LIST        @"/api/cash/getGoingMoney"

//广告
#define SYS_WEN_API_GET_ADV_LIST            @"/api/advert/getTaskList"
#define SYS_WEN_API_REALEASE_ADV            @"/api/advert/releaseAd"
#define SYS_WEN_API_ADV_PAY                 @"/api/advert/taskPay"

//邀请商家
#define SYS_WEB_API_INVITE_SELLER           @"/api/seller/invite"

typedef enum {

    SMSType_Login = 1,
    SMSType_Register = 2,
    SMSType_ModfyPWD = 3,
    SMSType_Cash = 4,
    SMSType_ModifyPhone = 5,
    SMSType_Cash_BackGround = 6,
    SMSType_CleanUser = 7,
    SMSType_ActivityUser = 8,
    SMSType_SetPayPWD = 9,
    SMSType_Seller_Regist = 10,
    SMSType_Seller_ForeGetPassword = 11,
    
}SMSType;


typedef enum {
    
    UploadImageType_Undefine = 0,
    UploadImageType_Edit = 1,//添加编辑商品的图片
    UploadImageType_Commont = 2, //商品评论的图片
    UploadImageType_Settle = 3, //商家认证
    UploadImageType_SellerLogo= 4, //商家Logo
}UploadImageType;

typedef enum {
    
    PayType_Yue = 1,//1:账户支付
    PayType_Alipay = 2,//2支付宝支付
    PayType_Wechat = 3, //3微信支付

}PayType;

@interface NSObject(Port)
//网络接口
- (void)requestHTTPData:(NSString *)urlString parameters:(NSDictionary *)parameter success:(void (^)(id response))success failed:(void (^)(NSDictionary *errorDic))failed;

/**
 *  发送短信验证码
 *
 *  @param phone       电话号码
 *  @param type        验证码类型
 *  @param compleBlock 请求结束回调
 */
- (void)sendMsg:(NSString*)phone
           type:(SMSType)type
         comple:(void (^)(BOOL bSuccess,NSString *des))compleBlock;

/**
 *  校验短信验证码
 *
 *  @param phone   电话号码
 *  @param type    验证码类型
 *  @param smsCode 短信验证码
 *  @param success 成功返货短信验证token
 *  @param failed  失败返回失败提示
 */
- (void)checkMsgCode:(NSString*)phone
                type:(SMSType)type
                code:(NSString*)smsCode
             success:(void(^)(NSString* smsToken))success
              failed:(void(^)(NSString* errorDes))failed;



/**
 *  上传图片
 * 如果是添加编辑商品的图片,URL地址需要传一个GET参数, img_type=1
   如果是商品评论的图片,URL地址需要传一个GET参数, img_type=2
    如果是商家资质认证的图片,需要post传一个参数, img_type=3
 *  @param image       图片
 *  @param compleBlock
 */


- (void)uploadImage:(UIImage *)image
               type:(UploadImageType)img_type
           progress:(void (^)(NSProgress* progress))progress
            success:(void(^)(NSString* imageURL))success
             failed:(void(^)(NSString* errorDes))failed;






/**
 *  初始化 获取 版本信息等
 *
 *  @param compleBlock
 */
- (void)initRequst:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock;


/**
 *  登录
 *
 *  @param userName 用户名
 *  @param pwd      密码
 *  @param success  成功返回认证状态
 *  @param failed   失败返回失败提示
 */
- (void)loginRequst:(NSString*)userName
                pwd:(NSString*)pwd
            success:(void(^)(SettleType Settle))success
             failed:(void(^)(NSString* errorDes))failed;


/**
 *  注册
 *
 *  @param phoneNum
 *  @param code          短信验证码
 *  @param recommendCode 推荐码
 *  @param success       成功返货短信验证token
 *  @param failed        失败返回提示语
 */
- (void)registerRequst:(NSString*)phoneNum
               smsCode:(NSString*)code
         recommendCode:(NSString*)recommendCode
               success:(void(^)(NSString* smsToken))success
                failed:(void(^)(NSString* errorDes))failed;
/**
 *  注册后设置密码接口
 *
 *  @param smsToken    注册时的短信验证码token
 *  @param pwd         密码
 *  @param compleBlock 请求结束回调
 */
- (void)setRegisterPWD:(NSString*)smsToken
               passowd:(NSString*)pwd
                comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock;

/**
 *  找回密码
 *
 *  @param phone       电话号码
 *  @param password    密码
 *  @param smsToken    短信验证token
 *  @param compleBlock 请求结束回调
 */
- (void)findPassword:(NSString*)phone
                 pwd:(NSString*)password
             smsToke:(NSString*)smsToken
              comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock;

/**
 *  获取商家认证资料
 *
 *  @param success
 *  @param failed
 */
- (void)getSettle:(void(^)(SettleModel* model))success
           failed:(void(^)(NSString* errorDes))failed;


- (void)checkSettleStatus:(void(^)(SettleType Settle, NSString* errorDes ))success
                   failed:(void(^)(NSString* errorDes))failed;

/**
 *  设置商家认证
 *
 *  @param model 需要 company  contact_phone operate operate id_img license apitude other_apitude
 *  @param compleBlock 请求结束回调
 */
- (void)setSettle:(NSString*)companyName
    contact_phone:(NSString*)contact_phone
          operate:(NSString*)operate
           id_img:(NSArray*)id_img
          license:(NSArray*)license
          apitude:(NSArray*)apitude
    other_apitude:(NSArray*)other_apitude
           comple:(void (^)(BOOL bSuccess,NSString *errorDes))compleBlock;

/**
 *  获取商家信息
 *
 *  @param success
 *  @param failed
 */
- (void)getUserInfo:(void(^)(UserInfoModel* model))success
             failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取商品分类列表
 *
 *  @param success
 *  @param failed
 */
- (void)getGoodCategoryList:(void(^)(NSArray<GoodsCategoryModel*>* array))success
                     failed:(void(^)(NSString* errorDes))failed;


/**
 *  添加商品
 *
 *  @param goodsName       商品名称
 *  @param catId           商品分类ID
 *  @param shopPrice       商品价格
 *  @param goodsNum        库存
 *  @param shareMoney      商品价格
 *  @param des             商品描述
 *  @param picUrlArray     图文详情
 *  @param galleryImageURL 封面图
 *  @param goodsImageURL   首页图
 *  @param attrs           规格
 *  @param bPrepare        是否预售
 *  @param dates           预售时间，单位为秒
 *  @param tip             商家提示
 *  @param success         成功返货产品ID
 *  @param failed          失败返回失败原因
 */
- (void)addGoods:(NSString*)goodsName
      categoryId:(NSString*)catId
           price:(float)shopPrice
        goodsNum:(int)goodsNum
      shareMoney:(float)shareMoney
      goodsBrief:(NSString*)des
     goodsPicDes:(NSArray*)picUrlArray
    galleryImage:(NSArray*)galleryImageURLArray
      goodsImage:(NSString*)goodsImageURL
      goodsThumb:(NSString*)goodsthumb
        attrList:(NSArray<NSDictionary *> *)attrs
       isPrepare:(BOOL)bPrepare
     prepareTime:(NSTimeInterval)dates
       sellerTip:(NSString*)tip
       isEndorse:(BOOL)isEndorse
     shippingFee:(NSString *)shippingFee
    shippingFree:(NSString *)shippingFree
         success:(void(^)(NSString* goodId))success
          failed:(void(^)(NSString* errorDes))failed;

/**
 *  编辑商品
 *

 */
- (void)editGoods:(NSString*)goodsId
        goodsName:(NSString*)goodsName
       categoryId:(NSString*)catId
            price:(float)shopPrice
         goodsNum:(int)goodsNum
       shareMoney:(float)shareMoney
       goodsBrief:(NSString*)des
      goodsPicDes:(NSArray*)picUrlArray
     galleryImage:(NSArray*)galleryImageURLArray
       goodsImage:(NSString*)goodsImageURLs
       goodsThumb:(NSString*)goodsthumb
         attrList:(NSArray<NSDictionary *> *)attrs
        isPrepare:(BOOL)bPrepare
      prepareTime:(NSTimeInterval)dates
        sellerTip:(NSString*)tip
        isEndorse:(BOOL)isEndorse
      shippingFee:(NSString *)shippingFee
     shippingFree:(NSString *)shippingFree
          success:(void(^)(NSString* goodId))success
           failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取商品列表
 *
 *  @param page     请求第几页
 *  @param listType
 *  @param success
 *  @param failed
 */
- (void)getGoodsList:(NSInteger)page
           goodsType:(ProuductListType)listType
             success:(void(^)(NSArray<ProductListModel*>* array ,NSInteger totalPage, NSInteger saleCount, NSInteger downCount))success
              failed:(void(^)(NSString* errorDes))failed;

/**
 *  下架或者删除商品
 *
 *  @param goodId  商品ID
 *  @param status  1:商品下架2：商品删除,3：商品上架
 *  @param success
 *  @param failed
 */
- (void)changeGoodsStatus:(int)status
                  goodsID:(NSString*)goodId
                  success:(void(^)())success
                   failed:(void(^)(NSString* errorDes))failed;

//获取goodInfo
- (void)getGoodInfo:(NSString*)goodId
            success:(void(^)(ProductDetailModel *model))success
             failed:(void(^)(NSString* errorDes))failed;


#pragma mark 订单
//获取订单列表
- (void)getOrderList:(NSString*)lastOrderId
         orderStatus:(OrderStatusType)oderType
             success:(void(^)(NSArray<OrderListModel*>* array))success
              failed:(void(^)(NSString* errorDes))failed;

//搜索订单
- (void)searchOrderList:(NSString*)lastOrderId
         orderStatus:(OrderStatusType)oderType
            keywords:(NSString*)keywords
            success:(void(^)(NSArray<OrderListModel*>* array))success
              failed:(void(^)(NSString* errorDes))failed;


//验证码兑换
- (void)orderVerifyExchangeCode:(NSString*)code
                        success:(void(^)(NSString *orderId))success
                         failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取订单详情
 *
 *  @param orderId
 *  @param success
 *  @param failed
 */
- (void)getOrderDetail:(NSString*)orderId
               success:(void(^)(OrderModel* model))success
                failed:(void(^)(NSString* errorDes))failed;



/**
 *  修改订单状态
 *
 *  @param orderId 订单号
 *  @param status  1.发货
 *  @param success
 *  @param failed
 */
- (void)modifyOrderStatus:(NSString*)orderId
                expressId:(NSString *)expressId
                   status:(int)status
                  success:(void(^)())success
                   failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取商家售后列表
 *
 *  @param lastId  当前页最后个的ID，不返回则显示的第一页
 *  @param status  处理状态（未处理返回1；处理中返回2）
 *  @param success
 *  @param failed
 */
- (void)getSellerAfterList:(NSString*)lastId
                    status:(int)status
                   success:(void(^)(NSArray<SellerAfterListModel*>* array,NSString *returnAddr, int status))success
                    failed:(void(^)(NSString* errorDes,int status))failed;


/**
 *  拒绝买家售后请求
 *
 *  @param afterId
 *  @param reason
 *  @param compleBlock
 */
- (void)refuseAfter:(NSString*)afterId
             reason:(NSString*)reason
             comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;


/**
 *  售后确认收货
 *
 *  @param afterId     售后ID
 *  @param compleBlock
 */
- (void)afterSureRecive:(NSString*)afterId
                 comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;

/**
 *  确认收到换货，并且发出新货
 *
 *  @param afterId
 *  @param compleBlock
 */
- (void)afterSureAndSendRecive:(NSString*)afterId
                   postCompany:(NSString*)name
                       postNum:(NSString*)num
                 comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;


/**
 *  同意买家售后申请
 *
 *  @param afterId     售后ID
 *  @param addr        收货地址
 *  @param compleBlock
 */
- (void)sellerAgreeAfter:(NSString*)afterId
          recieveAddress:(NSString*)addr
                  comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;

/**
 *  获取评价列表
 *
 *  @param lastId  最后一条评论ID,默认为0
 *  @param success
 *  @param failed
 */
- (void)getCommentsList:(NSString*)lastId
                success:(void(^)(NSArray<CommentsModel*>* array))success
                 failed:(void(^)(NSString* errorDes))failed;


/**
 *  回复评价
 *
 *  @param commentID 评价ID
 *  @param content   回复内容
 *  @param success
 *  @param failed
 */
- (void)addCmmentsReply:(NSString*)commentID
                replyContent:(NSString*)content
                success:(void(^)())success
                 failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取正在进行的任务列表
 *
 *  @param page    页数
 *  @param success
 *  @param failed
 */
- (void)getDoingMaskList:(int)page
                 success:(void(^)(NSArray<MaskListModel*>* array, NSInteger totalPage))success
                  failed:(void(^)(NSString* errorDes))failed;

/**
 *  已完成的任务列表
 *
 *  @param page    页数
 *  @param success
 *  @param failed  
 */
- (void)getFinishMaskList:(int)page
                 success:(void(^)(NSArray<MaskListModel*>* array, NSInteger totalPage))success
                   failed:(void(^)(NSString* errorDes))failed;


/**
 *  发布任务
 *
 *  @param title    任务标题
 *  @param des      任务描述
 *  @param num      目标数量
 *  @param price    任务单价
 *  @param timeLime 有效完成时间(单位秒)
 *  @param damand   每个用户完成任务需分享数量
 *  @param goodsId
 *  @param success
 *  @param failed
 */

- (void)addMask:(NSString*)title
            des:(NSString*)des
      targetnum:(int)num
     uinitPrice:(float)price
      timeLimit:(float)timeLime
         damand:(int)damand
        goodsId:(NSString*)goodsId
        success:(void(^)(NSString *orderId,NSNumber *myMoney,NSNumber *oderPrice ))success
         failed:(void(^)(NSString* errorDes))failed;



/**
 *  用微信付任务
 *
 *  @param payWay   支付方式 1:账户支付，2支付宝支付，3微信支付
 *  @param orderNo  订单号
 *  @param success
 *  @param failed
 */

- (void)maskPay:(PayType)payType
    password:(NSString*)password
        orderNo:(NSString*)orderNo
        success:(void(^)(Order *order,PayType type))success
         failed:(void(^)(NSString* errorDes))failed;

/**
 *  发布任务时获取商品详情
 *
 *  @param page    当前请求的页数
 *  @param success
 *  @param failed
 */
- (void)getMaskInfo:(NSString*)maskId
                 success:(void(^)(MaskInfoModel *model))success
                  failed:(void(^)(NSString* errorDes))failed;


/**
 *  修改商家资料
 *
 *  @param type        修改的信息类型
 *  @param value       修改的新内容
 *  @param compleBlock 
 */
- (void)changeUsrInfo:(ChangeUserInfoType)type
                value:(id)value
               comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;

//获取商家经营类目
- (void)getSellerCategoryList:(void(^)(NSArray<SellerCategoryModel *> *array))success
                       failed:(void(^)(NSString* errorDes))failed;

/**
 *  修改密码
 *
 *  @param password    密码
 *  @param oldPassword 修改登录密码时需要传的旧登录密码 非必传项
 *  @param smsToken    短信验证码token
 *  @param type        type=1修改登录密码，type=2修改交易密码
 *  @param compleBlock
 */
- (void)modifyPassword:(NSString*)password
           oldPassword:(NSString*)oldPassword
              smsToken:(NSString*)smsToken
                  type:(int)type
                comple:(void (^)(BOOL bSuccess,NSString *message))compleBlock;

/**
 *  获取银行列表
 *
 *  @param success 成功返回银行卡列表
 *  @param failed  失败返回原因
 */
- (void)getBankList:(void(^)(NSArray<BankListVO *> *array))success
             failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取我的银行卡列表
 *
 *  @param success
 *  @param failed  ］
 */
- (void)getMyBankCardList:(void(^)(NSArray<MyBankListVO *> *array))success
                   failed:(void(^)(NSString* errorDes))failed;
/**
 *  绑定银行卡
 *
 *  @param bankId
 *  @param bankNo  bankNo description
 *  @param name
 *  @param success
 *  @param failed
 */
- (void)addBankCard:(NSString*)bankId
             bankNo:(NSString*)bankNo
          ownerName:(NSString*)name
               success:(void(^)(NSString *msg))success
        failed:(void(^)(NSString* errorDes))failed;

/**
 *  解绑银行卡
 *
 *  @param bankId  银行id
 *  @param success
 *  @param failed
 */
- (void)unLockBankCard:(NSString*)bankId
               success:(void(^)( ))success
                failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取正在交易的金额
 *
 *  @param lastId  最后一条订单id
 *  @param success
 *  @param failed
 */
- (void)getGoingMoney:(NSString*)lastId
               success:(void(^)(NSArray<PacketOrderModel *> *array ))success
                failed:(void(^)(NSString* errorDes))failed;

/**
 *  我的收入记录
 *
 *  @param page    要请求的 page
 *  @param success
 *  @param failed
 */
- (void)getMyIncomeList:(NSString*)lastId
                success:(void(^)(NSArray <CashHistoryModel*> *model,int count))success
                 failed:(void(^)(NSString* errorDes))failed;


/**
 *  提现记录
 *
 *  @param last_id 最后一条提现id
 *  @param success
 *  @param failed
 */
- (void)getCashHistory:(NSString*)last_id
               success:(void(^)(NSArray <CashHistoryModel*> *msg,int count))success
                failed:(void(^)(NSString* errorDes))failed;

/**
 *  交易中的金额记录
 *
 *  @param last_id 最后一跳id
 *  @param success
 *  @param failed
 */
- (void)getDealingMoneyList:(NSString*)last_id
                    success:(void(^)(NSArray <CashHistoryModel*> *msg,int count))success
                     failed:(void(^)(NSString* errorDes))failed;

/**
 *  获取我的收入
 *
 *  @param success
 *  @param failed
 */
- (void)getMyIncome:(void(^)(PacketModel *model))success
               failed:(void(^)(NSString* errorDes))failed;





/**
 *  提现
 *
 *  @param bankId   提现的银行卡id
 *  @param money    提现的金额
 *  @param password 提现密码
 *  @param success  成功
 *  @param failed   失败
 */
- (void)takeCash:(NSString*)bankId
           money:(float)money
        password:(NSString*)password
         success:(void(^)(NSString *msg,NSString* myMoney))success
          failed:(void(^)(NSString* errorDes))failed;



/**
 *  获取商家广告列表
 *
 *  @param page    当前要请求的页数
 *  @param success 成功返回广告列表 和 总共页数
 *  @param failed  失败返回失败原因
 */
- (void)getMyAdvList:(int)page
             success:(void(^)(NSArray <PromotionListModel*> *advList, int totoalPage))success
              failed:(void(^)(NSString* errorDes))failed;


/**
 *  发布广告
 *
 *  @param title         string	是	50	标题
 *  @param desc          string	是	50	广告描述
 *  @param goodsId       int	是	10	推广商品id
 *  @param unit_price    float	是	10	广告单价
 *  @param target_number int	是	10	广告数量
 *  @param target_money  float	否	10	预算金额
 *  @param start_time    string	是	20	开始时间 2015-12-02 12:00:00格式
 *  @param end_time      string	是	20	结束时间
 *  @param tpl_type      int	是	2	广告类型：2回答4分享
 *  @param share_desc    string	否	50	分享描述
 *  @param extra         string	否	200	问题类问题 {question:123;answer:123;}问题和答案一一对应，json后传过来
 *  @param success       成功返回 	myMoney,用户账户金额  oderPrice,订单金额  orderId,订单号
 *  @param failed        失败返回失败原因
 */
- (void)relaseAdver:(NSString*)title
               desc:(NSString*)desc
            goodsId:(NSString*)goodsId
          unitPrice:(float)unit_price
          targetNum:(int)target_number
        targetMoney:(float)target_money
          startTime:(NSString*)start_time
            endTime:(NSString*)end_time
           tplType:(int)tpl_type
          shareDesc:(NSString*)share_desc
              extra:(NSArray*)extra
             success:(void(^)(NSString *orderId,NSNumber *myMoney,NSNumber *oderPrice ))success
              failed:(void(^)(NSString* errorDes))failed;

/**
 *  广告支付
 *
 *  @param type    1:账户支付，2支付宝支付，3微信支付
 *  @param orderId 订单号
 *  @param success
 *  @param failed
 */
- (void)advPay:(PayType)type
      password:(NSString*)password
       orderID:(NSString*)orderId
       success:(void(^)(Order *order,int type))success
        failed:(void(^)(NSString* errorDes))failed;

//邀请商家
- (void)inviteSeller:(void(^)(NSString* imageUrl, NSString *code,NSString *link,NSString *recommend))success
              failed:(void(^)(NSString* errorDes))failed;
@end
