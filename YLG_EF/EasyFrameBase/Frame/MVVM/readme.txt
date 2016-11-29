//MVVM Model View   主体布局管理  V1.0
—Created by Jack 2016-03-03




----------框架说明--------------------

MVVM是Model-View-ViewModel的简写，是模型(model)－视图(view)－视图模型(ViewModel)

MVVM模式和MVC模式一样，主要目的是分离视图（View）和模型（Model）

1. 低耦合。视图（View）可以独立于Model变化和修改，一个ViewModel可以绑定到不同的"View"上，当View变化的时候Model可以不变，当Model变化的时候View也可以不变。
2. 可重用性。你可以把一些视图逻辑放在一个ViewModel里面，让很多view重用这段视图逻辑。
3. 独立开发。数据开发人员可以专注于业务逻辑和数据的开发（ViewModel），页面开发人员可以专注于页面开发。
4. 可测试。数据开发人员测试和对接的对象是服务端，页面开发人员测试和对接的对象是设计部。
双剑合并，方可决胜千里之外。


EFRequestManager 请求服务器类
EFRequestManager->EFNetworkModel 服务器返回数据传输对象
EFRequestManager->EFNetworkModel-> Model 获取解析服务器返回数据传输对象成Model
EFRequestManager->EFNetworkModel-> Model -> ViewModel ViewModel构建view和model之间的逻辑，如网络请求，验证显示等。
EFRequestManager->EFNetworkModel-> Model -> ViewModel -> View 从ViewModel层获取数据

-----------end----------------------


----------逻辑说明--------------------

MVVM模式

第一步，模型(model)

获取模型，就多数应用而言是通过服务器获取数据。本地数据库暂不举例。

1 通过 继承EFRequestManager的子类 请求得到数据
2 通过 Model层获取并解析数据 （学过java的小伙伴的话，对JavaBean应该不陌生）

第二步，视图模型(ViewModel)

ViewModel层，就是View和Model层的粘合剂，他是一个放置用户输入验证逻辑，视图显示逻辑，发起网络请求和其他各种各样的代码的极好的地方。
说白了，就是把原来ViewController层的业务逻辑和页面逻辑等剥离出来放到ViewModel层。

第三步，视图（View）
ViewController层，任务就是从ViewModel层获取数据并显示

-----------end----------------------



----------使用说明--------------------

<1>EFRequestManager 请求服务器类

这里举例说明，登录请求。LoginRequest

（1）头文件h

第一步。引用框架请求类。方便继承
#import "EFRequestManager.h"

第二步。声明LoginRequest继承。LoginRequest所需要用到的参数。
@interface LoginRequest : EFRequestManager
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *password;
@end

（2）执行文件m

#import "LoginRequest.h"

@implementation LoginRequest

- (void)startCallBack:(EFRequestCallBackBlock)_callBack{
//请求路径
    self.PATH = @"/rest/security/login";
//请求方法
    self.METHOD = @"POST";
//请求参数
    self.params = @{@"username":self.username,@"password":self.password,@"type":@"1"};
//请求头参数
    self.httpHeaderFields = @{@"Version":@"1.0"};
//调用EFRequestManager父类方法
    [super startCallBack:_callBack];
}

@end

-----------end----------------------

MVVM简单的这么一说，想要好好理解并深入研究，还得实战演练。
