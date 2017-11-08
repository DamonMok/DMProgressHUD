# 一、简介
DMProgressHUD是一款用于显示异步操作任务进度状态的视图工具。
该工具包含了目前较为主流的加载状态视图类型，后续会根据具体情况或需求进行迭代。
DMProgressHUD从设计层次的角度来看，其包含了5种展示模式：
1. Loading(加载中相关)；
2. Progress(进度具体值相关)；
3. Status(状态相关，例如成功、失败等提示)；
4. Text(文字提示相关)；
5. Custom(自定义视图相关)。

# 二、导入(Platform : ios >= 8.0)
### 方案1：CocoaPods
1. 在Podfile文件加入 ```pod 'DMProgressHUD'```;
2. 在终端输入 ```pod install```;
3. 在需要使用的地方导入头文件 ```#import <DMProgressHUD.h>```。

### 方案2：直接导入到工程
1. 把DMProgressHUD.h、DMProgressHUD.m和DMProgressImgs.bundle(图片资源bundle)导入到工程目录下；
2. 在需要使用的地方导入头文件 ```#import "DMProgressHUD.h"```。

# 三、快捷调用
*注意：快捷调用使用默认的样式(Style-Dark)、动画(Animation-gradient)、遮盖(Mask-None)。*
### 1.Loading Mode
##### 1.1 Loading-Indicator

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-5f20a0e786b6e984.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showLoadingHUDAddedTo:self.view];
    //hud.loadingType = DMProgressHUDLoadingTypeIndicator;//默认
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

##### 1.2 Loading-Circle

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-b790e61acbf5a21b.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showLoadingHUDAddedTo:self.view];
    hud.loadingType = DMProgressHUDLoadingTypeCircle;
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

### 2.Progress Mode
##### 2.1 Progress-Circle

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-64d982348d733f0e.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showProgressHUDAddedTo:self.view];
    //hud.progressType = DMProgressHUDProgressTypeCircle;//默认
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

##### 2.2 Progress-Sector

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-c8d6130b5c9d7df4.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showProgressHUDAddedTo:self.view];
    hud.progressType = DMProgressHUDProgressTypeSector;
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

### 3.Status Mode
##### 3.1 Success

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-f526257eab425217.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeSuccess];
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

##### 3.2 Fail

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-de216791acd17664.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

##### 3.3 Warning

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-71eba2b5d88f4bc5.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeWarning];
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

### 4.Text Mode
##### 4.1 Text

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-a2eb00f51359c10d.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showTextHUDAddedTo:self.view];
    hud.text = @"Here's info";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

### 5.Custom Mode
##### 5.1 Custom

<p align="center"> 
<img src="http://upload-images.jianshu.io/upload_images/6955515-ad40ede50af4f46f.gif">
</p>

```
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeCustom;//指定模式为自定义模式
    hud.text = @"Here's info";
    UIView *custom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [hud setCustomView:custom width:180.0 height:180.0];//自定义View
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步耗时操作
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回主线程隐藏HUD
            [hud dismiss];
        });
    });
```

# 四、更多
1. ***关于调用***：DMProgressHUD为调用者提供了快捷调用的方法，另外还提供了一些与额外功能相关的初始化方法供调用者使用；
1. ***关于外观***：DMProgressHUD提供两种外观样式，对应分别是Dark/Light;
2. ***关于动画***：DMProgressHUD默认使用颜色渐变(alpha)动画进行显示/隐藏，另外还有增量式动画和弹性动画供使用者选择；
3. ***关于遮盖***：DMProgressHUD默认不使用遮盖，另外提供透明遮盖和灰色遮盖供使用者选择；

以上所列举关于DMProgressHUD的功能介绍，用户可以通过 *运行Demo* 查看到相应的效果。除此之外，用户还可以对HUD的 *图文间距、颜色等* 进行自定义，可以在 *DMProgressHUD.h* 文件查看更多的API详细介绍。

联系方式(Email): damonmok1216@gmail.com。

