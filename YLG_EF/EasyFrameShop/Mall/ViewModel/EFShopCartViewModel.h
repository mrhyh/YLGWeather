//
//  EFShopCartModel.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/20.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFBaseViewModel.h"
#import "EFCartModel.h"
#import "EFOrderListModel.h"
#import "EFOrderDetailModel.h"
#import "ReturnOfGoodsModel.h"


typedef NS_ENUM(EFViewControllerCallBackAction, EFMailShopCart) {
    /****************商城-购物车信息管理******************/
    EFMailShopCart_ClearItems         = 1<<0,//清空我的购物车
    EFMailShopCart_Items              = 1<<1,//返回购物车购物项
    EFMailShopCart_RemoveItems        = 1 << 2 ,//从我的购物车当中删除购物项
    EFMailShopCart_UpdateItemQuantity = 1 << 3,//修改购物项目数量

    /****************商城-订单管理服务rest接口**************/
    EFMailShopCart_CreateOrder        = 1 <<11,//创建订单
    EFMailShopCart_MyOrderList        = 1 <<12,//返回我的订单列表
    EFMailShopCart_CancelOrder        = 1 <<13,//取消订单
    EFMailShopCart_ConfirmOrder       = 1 <<14,// 确认订单
    EFMailShopCart_DeleteOrder        = 1 <<15,//刪除订单
    EFMailShopCart_FinishOrder        = 1 <<16,//完成订单
    EFMailShopCart_PayOrder           = 1 <<17,// 支付订单
    EFMailShopCart_ReceivedOrder           = 1 <<18,// 确认收货
    EFMailShopCart_GetOrderById           = 1 <<19,// 根据订单id返回订单详情
    EFMailShopCart_AliPay           = 1 <<20,// 支付订单
    EFMailShopCart_BalancePay           = 1 <<21,// 支付订单
    EFMailShopCart_WeChatPay           = 1 <<22,// 支付订单
    
    /****************商城-退货单信息管理rest接口**************/
    EFMailShopCart_ApplyReturnGood           = 1 <<23,// 申请退货
    EFMailShopCart_ReturnMyList           = 1 <<24,// 返回我的退货单
    EFMailShopCart_ApplyReturnMoney          = 1 <<25,// 申请退款
    EFMailShopCart_FindByOrder          = 1 <<26,// 根据订单id返回我的退货单
    
    EFMailShopCart_WalletInfo = 1 <<27,//获取钱包信息
};

#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCallBackBlock)(CallBackStatus callBackStatus,NetworkModel * result);
#endif

@interface EFShopCartViewModel : EFBaseViewModel

/*购物车模型*/
@property (nonatomic, strong) EFCartModel *cartModel;
/*购物车数组模型（没按店铺分组）*/
@property (nonatomic, strong) NSMutableArray *cartModelContentArray;
/*购物车按店铺分类,每个店铺的商品放一个数组（二维数组）*/
@property (nonatomic, strong) NSMutableArray *cartClassifyModelArray;

/*增减商品数量回调*/
@property (nonatomic, weak) RequestCallBackBlock requestCallBackBlock;

/*订单列表模型*/
@property (nonatomic, strong) EFOrderListModel *orderListModel;
@property (nonatomic, strong) NSMutableArray<OrderModel *> *orderModelArray;
@property (nonatomic, strong) EFOrderDetailModel *orderDetailModel;

/*退货单模型*/
@property (nonatomic, strong) ReturnOfGoodsModel *returnOfGoodsModel;


/****************商城-购物车信息管理******************/

/*清空我的购物车*/
- (void)EFClearItems;

/*返回购物车购物项*/
- (void)EFGetShopCartItems:(int)_page Size:(int) _size;

/*从我的购物车当中删除购物项*/
- (void)EFRemoveItemsWithProductIds:(NSString *)_productIds callBackBlock:(RequestCallBackBlock )callBackBlock;
/* 修改购物项目数量*/
- (void)UpdateItemQuantityWithProductId:(NSInteger)_productIds Quantity:(NSInteger)_quantity callBackBlock:(RequestCallBackBlock )callBackBlock;


/****************商城-订单管理服务rest接口**************/
/***  创建订单*/
- (void)createOrder:(NSString *)_consigneeRegionId ConsigneeName:(NSString *)_consigneeName ConsigneeMobile:(NSString *)_consigneeMobile ConsigneeAddress:(NSString *)_consigneeAddress ConsigneeZipCode:(NSString *)_consigneeZipCode isInvoice:(NSUInteger)_isInvoice invoiceTitle:(NSString *)_invoiceTitle orderProductId:(NSString *)_orderProductId orderProductCount:( NSString *)_orderProductCount shippingMethodId:(NSInteger)_shippingMethodId  notes:(NSString *)_notes andIsWalletPay:(BOOL)isWalletPay andPayPassword:(NSString *)password;

/***  返回我的订单列表*/
- (void)getMyOrderList:(NSInteger)_page Size: (NSInteger)_size Status:(NSString *)_statusString;
/***  取消订单*/
- (void)cancelOrder:(NSInteger)_orderId Caulse:(NSString *)_caulse callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  确认订单*/
- (void)confirmOrder:(NSInteger )_orderId;
/***  刪除订单*/
- (void)DeleteOrder:(NSInteger)_orderId;
/***  完成订单*/
- (void)FinishOrder:(NSInteger)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  支付订单*/
- (void)PayOrder:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  支付宝支付*/
- (void)AliPay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  余额支付*/
- (void)BalancePay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  微信支付*/
- (void)WeChatPay:(NSString *)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  确认收货*/
- (void)ReceivedOrder:(NSInteger)_orderId callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  根据订单id返回订单详情*/
- (void)GetOrderById:(NSInteger)_orderId;

    /****************商城-退货单信息管理rest接口**************/
/***  申请退货*/
- (void)ApplyReturnGood:(NSInteger)_orderId andReason:(NSString *)reason callBackBlock:(RequestCallBackBlock )callBackBlock;
/***  申请退款*/
- (void)ApplyReturnMoney:(NSInteger)_orderId andReason:(NSString *)reason callBackBlock:(RequestCallBackBlock )callBackBlock;
/*** 返回我的退货单*/
- (void)ReturnMyList:(int)_page Size:(int) _size;
/*** 根据订单id返回我的退货单*/
- (void)FindByOrder:(NSInteger)_orderId;

/***  获取我的钱包的信息 */
- (void)getMyWalletInfo;
@end
