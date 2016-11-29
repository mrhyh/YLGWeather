//
//  RSMyInfoVC.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMyInfoVC.h"
#import "GW_EditNameVC.h"
#import "YJ_ImageVC.h"
#import "EFLoginViewModel.h"
#import "IQKeyboardManager.h"
#import "TZImagePickerController.h"
#import "RSHuanXinVC.h"

#define ChosePicker @"ChosePicker"
#define TakePhoto @"TakePhoto"

#define Regex @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*"

@interface RSMyInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic)KYTableView * table;
@property (copy, nonatomic)NSString      * name;
@property (strong, nonatomic)UIImage     * headImage;
@property (assign, nonatomic)BOOL        isChangeImage;
@property (nonatomic,strong)UIButton     * editBtn;

@property (nonatomic, strong)  UITextField *tf;

@property (nonatomic,strong) KYMHImageView * imageView;

@property(nonatomic,strong)EFLoginViewModel * viewModel;


@property (strong, nonatomic) TZImagePickerController *tzImagePickerController;

@end

@implementation RSMyInfoVC


- (instancetype)initWithCallBack:(EditVCCallBack)_callBack{
    if (self = [super init]) {
        callBack = _callBack;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基本资料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    
    if ([UserModel ShareUserModel].nickname) {
        _name = [UserModel ShareUserModel].nickname;
    }else {
        _name = @"昵称";
    }
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [_editBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:0];
    _editBtn.frame = CGRectMake(0, 0, 60, 44);
//    _editBtn.selected = NO;
    [_editBtn addTarget:self action:@selector(changeMyInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    WS(weakSelf);
    self.table = [[KYTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) andUpBlock:^{
        [weakSelf.table endLoading];
    } andDownBlock:^{
        [weakSelf.table endLoading];
    }];
    [self.view addSubview:self.table];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = EF_BGColor_Primary;
    self.table.separatorStyle = UITableViewCellAccessoryNone;
    self.table.scrollEnabled = NO;
}

- (void)changeMyInfo {
//    if (!_editBtn.selected) {
//        //修改资料
//        self.table.allowsSelection = YES;
//        _editBtn.selected = YES;
//        
//    }else {
        //保存修改
        
//        if ([_name isEqualToString:[UserModel ShareUserModel].nickname]) {
//            [UIUtil alert:@"请修改信息后再保存"];
//            return;
//        }
    
    [_tf resignFirstResponder];
    
    if ([UIUtil isEmptyStr:_name] ) {
        [UIUtil alert:@"您尚未输入昵称！"];
        return;
    }
    
    if ([self isPureInt:_name]) {
        [UIUtil alert:@"姓名不能是纯数字"];
        return;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if (![pred evaluateWithObject:_name]) {
        [UIUtil alert:@"姓名只能由汉字、英文字母和数字组成,且不能以数字开头"];
        return;
    }
    
    _editBtn.userInteractionEnabled = NO;
    [SVProgressHUD show];
    if (!_headImage) {
        [self.viewModel SaveMyProfileWithName:_name Sex:@"" BirthDate:@"" Sign:@"" HeadKey:@""];
    }else {
        NSArray * a = @[_headImage];
        [self.viewModel Upload:a];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber * fontNormal = EF_FontSizeNormal;
    NSNumber * fontMiddle = EF_FontSizeMiddle;
    UIColor * color = EF_TextColor_TextColorPrimary;
    UIColor * color1 = EF_TextColor_TextColorSecondary;
    UIColor * color2 = EF_TextColor_TextColorDisable;
    UIColor * colorLine = HEX_COLOR(@"#f6f6f6");
    
    WS(weakSelf)
        NSArray * array;
        NSArray * titleArray;
        array = @[@"头像",@"昵称"];
        titleArray = @[_name];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = array[indexPath.row];
        
        UIImage * img;
        if (_headImage) {
            img = _headImage;
        }
        if (indexPath.row != 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            _tf = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 0, 130, 45)];
            _tf.textColor = EF_TextColor_TextColorPrimary;
            _tf.delegate = self;
            _tf.backgroundColor = [UIColor whiteColor];
            _tf.font = [UIFont systemFontOfSize:17];
            _tf.textAlignment = NSTextAlignmentRight;
            _tf.text = titleArray[indexPath.row-1];
            _tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_tf setValue:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary] forKeyPath:@"_placeholderLabel.textColor"];
            [cell addSubview:_tf];
            
            _tf.sd_layout
            .topSpaceToView(cell, 10)
            .bottomSpaceToView(cell, 10)
            .rightSpaceToView (cell, 10)
            .widthIs(SCREEN_WIDTH/1.5);
            
//            KYMHLabel * label = [[KYMHLabel alloc] initWithTitle:titleArray[indexPath.row-1] BaseSize:CGRectMake(SCREEN_WIDTH-140, 0, 130, 45) LabelColor:[UIColor clearColor] LabelFont:[fontNormal floatValue] LabelTitleColor:color1 TextAlignment:NSTextAlignmentRight];
//            [cell addSubview:label];
            
        }else{
            CGFloat imageViewWH = 60;
            _imageView = [[KYMHImageView alloc] initWithImage:img BaseSize:CGRectMake(SCREEN_WIDTH-70, 10, imageViewWH, imageViewWH) ImageViewColor:[UIColor clearColor]];
            UIColor * sideColor = HEX_COLOR(@"#a2a2a2");
            [_imageView RectSize:5 SideWidth:0.5 SideColor:sideColor];
            _imageView.layer.masksToBounds = YES;
            _imageView.layer.cornerRadius = imageViewWH/2;
            [cell addSubview:_imageView];
            
            
            if (!_isChangeImage) {
                NSString * url = @"";
                if ([UserModel ShareUserModel].head.url) {
                    url = [UserModel ShareUserModel].head.url;
                }
                
                [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:Img(@"ic_defaultavatar") options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        weakSelf.imageView.contentMode =  UIViewContentModeScaleAspectFill;
                        weakSelf.imageView.clipsToBounds = YES;
                        weakSelf.imageView.image = image;
                        weakSelf.headImage = image;
                    }else{
                        weakSelf.imageView.image = Img(@"ic_defaultavatar");
                        
                    }
                    
                }];
            }
        }
        UIView * line = [[UIView alloc]init];
        line.backgroundColor = EF_TextColor_TextColorDisable;
        [cell addSubview:line];
        if (indexPath.row == 0) {
            line.frame = CGRectMake(10, 79.5, SCREEN_WIDTH-10, 0.5);
        }else if (indexPath.row == 1 || indexPath.row == 2) {
            line.frame = CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5);
        }else{
            line.frame = CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5);
        }
    
     return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = EF_BGColor_Primary;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = EF_TextColor_TextColorDisable;
    [headView addSubview:line];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = EF_TextColor_TextColorDisable;
    [headView addSubview:line1];
    return headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 80;
    }
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf)
    
    if (indexPath.row  ==  0) {
//        [self addImage];
        
//        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.allowsEditing = NO;//是否允许编辑
//        picker.sourceType = sourceType;
//        
//        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
//        [popover presentPopoverFromRect:_imageView.bounds inView:_imageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        TZImagePickerController * imagePickerVC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        
        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray * assets, BOOL isSuccess) {
            
            weakSelf.headImage = [[photos[0] rotateImage] imageCorrectInSize:CGSizeMake(400, 400)];
            weakSelf.isChangeImage = YES;
            [weakSelf.table reloadData];
        }];
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }else if (indexPath.row == 1){
//        GW_EditNameVC * vc = [[GW_EditNameVC alloc] initWithCallBack:^(NSString *name) {
//            _name = name;
//            [self.table reloadData];
//        }];
//        vc.nameStr = _name;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)addImage{
    
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:@"修改头像"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"照相机", @"相册", @"查看全图",nil];
    
    [mySheet showInView:self.view];
    
}

#pragma mark  UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                
                UIImagePickerController *pic = [[UIImagePickerController alloc] init];
                pic.sourceType = UIImagePickerControllerSourceTypeCamera;
                pic.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                pic.delegate = self;
                pic.allowsEditing = YES;
                [self presentViewController:pic animated:YES completion:nil];
            }
        }
            break;
            
        case 1:
        {
            //for iphone
//            UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
//            if ([UIImagePickerController isSourceTypeAvailable:
//                 UIImagePickerControllerSourceTypePhotoLibrary]) {
//                m_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                m_imagePicker.delegate = self;
//                m_imagePicker.allowsEditing = YES;
//                [self presentViewController:m_imagePicker animated:YES completion:nil];
//               
//            }
            
            
            //for ipod
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;//是否允许编辑
            picker.sourceType = sourceType;
            
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:_imageView.bounds inView:_imageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
            break;
            
        case 2:
        {
            if (!_headImage) {
//                [UIUtil alert:@"您还没设置头像!"];
                return;
            }
            YJ_ImageVC * vc = [[YJ_ImageVC alloc] initWithImage:_headImage];
            [self presentViewController:vc animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
        
    
}

//修改了取消按钮位置
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    UIColor * color = [UIColor whiteColor];
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        UIButton* btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [btn setTitle:@"取消" forState:0];
        [btn setTitleColor:color forState:0];
        [btn addTarget:self action:@selector(cancelImagePicker) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [viewController.navigationItem setRightBarButtonItem:barBtnItem];
    }
}

- (void)cancelImagePicker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    _headImage = [[image rotateImage] imageCorrectInSize:CGSizeMake(400, 400)];
    _isChangeImage = YES;
    [self.table reloadData];
}


#pragma mark Other Action

#pragma mark --- viewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action & LoginCallBackActionUpload) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            
            NSArray * arr = result.jsonDict[@"content"];
            NSDictionary * dic = arr[0];
            NSString * headKey = [dic objectForKey:@"key"];
            [self.viewModel SaveMyProfileWithName:_name Sex:@"" BirthDate:@"" Sign:@"" HeadKey:headKey];
        }else {
            [SVProgressHUD dismiss];
        }
    }
    if (action & LoginCallBackActionSaveMyProfile) {
        if ([result.jsonDict[@"status"] intValue] == 200) {
            [UIUtil alert:@"保存成功"];
            _isChangeImage = NO;
            [UserModel LoginWithModel:result.jsonDict[@"content"] andToken:[UserModel ShareUserModel].token];
            if (callBack) {
                callBack(YES);
                callBack = nil;
            }
            
            [RSHuanXinVC rs_asyncSetApnsNickname];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [UIUtil alert:@"保存个人资料失败"];
        }
        [SVProgressHUD dismiss];
        _editBtn.userInteractionEnabled = NO;
    }
    
}

#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _name = textField.text;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (string.length == 0)
        return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength + selectedLength + replaceLength > 10) {
        [UIUtil alert:@"最多输入10个字"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 判断字符串 是否为中文
- (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fff]{2,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark - 判断 用户名
- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

#pragma amrk - 判断 密码
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

#pragma mark - 判断输入是否为全数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


@end
