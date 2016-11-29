//
//  EFEditMineProfileVC.m
//  demo
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFEditMineProfileVC.h"
#import "EFEditNicknameVC.h"
#import "EFMineProfileCell.h"
#import "EFEditCommonCell.h"
#import "EFUserAvatarCell.h"
#import "KYDatePickerView.h"
#import "EFLoginViewModel.h"
#import "UserModel.h"
static NSString *avatarCellId = @"accountSettingCell";
static NSString *commonCellId = @"commonCell";
static NSString *profileCellId = @"profileCellId";

@interface EFEditMineProfileVC()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**列表内容,只读，初始化从plist文件中加载*/
@property (nonatomic, strong ,readwrite) NSArray *settingArray;
@property (nonatomic, strong) UIActionSheet *actionSheetAvatar;
@property (nonatomic, strong) UIActionSheet *actionSheetSex;
@property (nonatomic, copy) NSString *sign;
@property (copy, nonatomic)NSString      * brithDay;
@property (copy, nonatomic)NSString      * gender;
@property (copy, nonatomic)NSString      * name;
@property (strong, nonatomic)UIImage     * headImage;
@property (nonatomic,strong)EFLoginViewModel *viewModel;
@end

@implementation EFEditMineProfileVC 
- (instancetype)init {
    
    if (self = [super init]) {
        
        NSString *plistPath = nil;
        plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
        //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
        if (plistPath == nil) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
        }
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        self.settingArray = [dictionary objectForKey:@"EditMineProfile"];
    }
    return self;
}

#pragma mark --- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[EFLoginViewModel alloc]initWithViewController:self];
    [self setupNavi];
    [self setupTableView];
    
}


- (void)setupNavi{
    self.title = @"编辑资料";
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.bounds = CGRectMake(0, 0, 60, 30);
    [finishBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_TextColorNavigation] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem = settingBarBtnItem;
}

- (void)setupTableView{
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled =YES;
    self.tableview.sectionFooterHeight = 0;
    self.tableview.backgroundColor = EF_BGColor_Primary;
    self.tableview.contentInset = UIEdgeInsetsMake(-30, 0, 44, 0);
    [self.tableview registerNib:[UINib nibWithNibName:@"EFUserAvatarCell" bundle:nil] forCellReuseIdentifier:avatarCellId];
    [self.tableview registerNib:[UINib nibWithNibName:@"EFEditCommonCell" bundle:nil] forCellReuseIdentifier:commonCellId];
    [self.tableview registerNib:[UINib nibWithNibName:@"EFMineProfileCell" bundle:nil] forCellReuseIdentifier:profileCellId];

}


#pragma mark ---<UITableViewDelegate,UITableViewDataSource>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settingArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dictArray = self.settingArray[indexPath.section];
    NSDictionary *mineProfileDict = dictArray[indexPath.row];
    NSString *title = mineProfileDict[@"title"];
    if ([title isEqualToString:@"头像"]) {
        
        return 90;
    }else if([title isEqualToString:@"个人简介"]){

        return 160;
    }else{
    
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dictArray = self.settingArray[indexPath.section];
    NSDictionary *mineProfileDict = dictArray[indexPath.row];
    NSString *title = mineProfileDict[@"title"];
    if ([title isEqualToString:@"头像"]) {
        EFUserAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:avatarCellId];
        cell.avatarDict = mineProfileDict;
        NSString * url = @"";
        if ([UserModel ShareUserModel].head.url) {
            url = [UserModel ShareUserModel].head.url;
        }
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:Img(@"resource.bundle/reg_weixin.png") options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.avatarImageView.image = image;
                _headImage = image;
            }else{
                cell.avatarImageView.image = Img(@"resource.bundle/reg_weixin.png");
            }
            
        }];
        return cell;
    }else if([title isEqualToString:@"个人简介"]){
        EFMineProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellId];
        cell.profileDict = mineProfileDict;
        
        return cell;
    }

    
    EFEditCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCellId];
    cell.commonDict = mineProfileDict;
    if([title isEqualToString:@"昵称"]){
//        _name = @" ";
//        if ([UserModel ShareUserModel].nickname) {
//            _name = [UserModel ShareUserModel].nickname;
//        }
//        cell.result = _name;
    }else if([title isEqualToString:@"性别"]){
        _gender = @" ";
        if ([UserModel ShareUserModel].sex) {
            _gender = [UserModel ShareUserModel].sex;
            if ([_gender isEqualToString:@"M"]) {
                _gender = @"男";
            }else{
                _gender = @"女";
            }
        }
        cell.result = _gender;
    }else if ([title isEqualToString:@"生日"]){
        _brithDay = @"";
        if ([UserModel ShareUserModel].birthDate) {
            _brithDay = [UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",[UserModel ShareUserModel].birthDate]];
        }
        cell.result = _brithDay;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *dictArray = self.settingArray[indexPath.section];
//    NSDictionary *mineProfileDict = dictArray[indexPath.row];
//    NSString *title = mineProfileDict[@"title"];
//    if([title isEqualToString:@"昵称"]){
//        __block EFEditCommonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        EFEditNicknameVC *vc = [[EFEditNicknameVC alloc] initWithCompleteBlock:^(NSString *nickName) {
//            cell.result = nickName;
//            self.name = nickName;
//        }];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if([title isEqualToString:@"性别"]){
//        UIActionSheet *actionSheetSex = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女" ,nil];
//        [actionSheetSex showInView:self.view];
//        self.actionSheetSex = actionSheetSex;
//
//    }else if ([title isEqualToString:@"生日"]){
//        __block EFEditCommonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        KYDatePickerView *datePicker = [KYDatePickerView openDatePickerWithSure:^(NSDate *date) {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            dateFormatter.dateFormat = @"yyyy-MM-dd";
//            NSString *birthday = [dateFormatter stringFromDate:date];
//            cell.result = birthday;
//            self.brithDay = birthday;
//        } Cancel:^{
//            
//        } Changed:^(NSDate *date) {
//            
//        }];
//        
//        datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
//    }else if ([title isEqualToString:@"头像"]){
//        UIActionSheet *actionSheetAvatar = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
//        [actionSheetAvatar showInView:self.view];
//        self.actionSheetAvatar = actionSheetAvatar;
//    }
}

#pragma mark --- <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSIndexPath *indexPath =  [self.tableview indexPathForSelectedRow];
    if (actionSheet == self.actionSheetSex) {
        EFEditCommonCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        if (buttonIndex == 0) {
            cell.result = @"男";
            self.gender = @"男";
        }else if (buttonIndex == 1){
            cell.result = @"女";
            self.gender = @"女";
        }
    }else{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"设备不支持相机!");
                return;
            }
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark --- <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSIndexPath *indexPath =  [self.tableview indexPathForSelectedRow];
    EFUserAvatarCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    cell.avatarImage = [[image rotateImage] imageCorrectInSize:CGSizeMake(400, 400)];
    self.headImage = [[image rotateImage] imageCorrectInSize:CGSizeMake(400, 400)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- event response
- (void)finishBtnClick{
    if (!_headImage) {
        [UIUtil alert:@"您还没设置头像!"];
        return;
    }
    [self.viewModel Upload:_headImage];
}

#pragma mark --- viewModel 回调
- (void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    if (action & LoginCallBackActionUpload) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            NSString * sex;
            if ([_gender isEqualToString:@"男"]) {
                sex = @"M";
            }else{
                sex = @"F";
            }
            NSIndexPath *indexPath =  [NSIndexPath indexPathForItem:0 inSection:1];;
            EFMineProfileCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
            NSString * sign = @"";
            if (![cell.profileInputView.text isEqualToString:@"介绍一下自己吧"]&&![UIUtil isEmptyStr:cell.profileInputView.text]) {
                sign = cell.profileInputView.text;
            }
            NSArray * arr = result.jsonDict[@"content"];
            NSDictionary * dic = arr[0];
            [self.viewModel SaveMyProfileWithName:_name Sex:sex BirthDate:_brithDay Sign:sign HeadKey:[dic objectForKey:@"key"]];
        }
    }
    if (action & LoginCallBackActionSaveMyProfile) {
        if (result.status == NetworkModelStatusTypeSuccess) {
            [UIUtil alert:@"修改成功"];
            [UserModel LoginWithModel:result.jsonDict[@"content"] andToken:[UserModel ShareUserModel].token];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



@end
