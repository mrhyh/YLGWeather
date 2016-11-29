//KingYon LTD EasyFrameForIOS V1.0
—Created by Jack 2016-03-03

------------------------------------
参考文档
KingYon LTD 移动规范 iOS V1.0.doc
KingYon LTD iOS开发 Xcode插件安装文档 1.1.pdf

------------------------------------

1、框架组成说明
    APP基础配置
    皮肤主题管理
    启动页管理
    介绍引导页管理
    主体布局管理
    MVVM设计模式

    Tools:

    Libs:
        Jpush库 - JPush_Lib
        侧滑库 - YRSideViewController


2、公共组件说明
    登录
    注册
    忘记密码
    个人中心
    设置


------------------------------------
依赖CocoaPods库：

pod 'libWeChatSDK', '~> 1.5'
pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk"
pod 'TencentOpenApiSDK'
platform :ios, "6.0"

pod 'AFNetworking', '~> 2.5.4’
pod 'SDAutoLayout'
pod 'IQKeyboardManager'
pod 'YYModel'
pod 'SFHFKeychainUtils'
pod 'MJRefresh', '~> 3.1.0’
pod 'SDWebImage', '~> 3.7.2'
pod 'Reachability',  '~> 3.0.0'

platform :ios, "7.0"
pod 'FDFullscreenPopGesture'


------------------------------------