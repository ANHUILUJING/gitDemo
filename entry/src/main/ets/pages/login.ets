// entry/src/main/ets/pages/login/Login.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { UserService } from '../utils/UserService';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Login {
  @State login: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;

  aboutToAppear() {
    // 初始化Preferences
    PreferencesUtil.initPreferences(getContext(this));
  }

  build() {
    Column() {
      // 标题
      Text('MyTodo')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 80, bottom: 60 })

      // 登录输入框
      TextInput({ placeholder: '用户名/手机/邮箱' })
        .width('90%')
        .height(50)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          this.login = value;
        })

      // 密码输入框
      TextInput({ placeholder: '密码' })
        .width('90%')
        .height(50)
        .type(InputType.Password)
        .margin({ bottom: 30 })
        .onChange((value: string) => {
          this.password = value;
        })

      // 登录按钮
      Button('登录', { type: ButtonType.Capsule })
        .width('90%')
        .height(45)
        .backgroundColor('#007DFF')
        .fontColor(Color.White)
        .margin({ bottom: 20 })
        .enabled(!this.isLoading && !!this.login && !!this.password)
        .onClick(() => {
          this.handleLogin();
        })

      // 注册链接
      Row() {
        Text('还没有账号？')
          .fontSize(14)
          .fontColor('#666')
        Text('立即注册')
          .fontSize(14)
          .fontColor('#007DFF')
          .onClick(() => {
            router.pushUrl({ url: 'pages/register' });
          })
      }
      .margin({ top: 20 })

      // 加载指示器
      if (this.isLoading) {
        LoadingProgress()
          .color('#007DFF')
          .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }

  // 在 login.ets 的 handleLogin 方法中修改跳转部分
  // private async handleLogin() {
  //   if (!this.login || !this.password) {
  //     promptAction.showToast({ message: '请输入用户名和密码', duration: 3000 });
  //     return;
  //   }
  //
  //   this.isLoading = true;
  //   try {
  //     const result = await UserService.login(this.login, this.password);
  //     if (result.code === '200') {
  //       // 保存token
  //       if (result.data) {
  //         console.info("4")
  //
  //         await PreferencesUtil.setToken(result.data.token);
  //         console.info("5")
  //
  //         // promptAction.showToast({ message: '登录成功', duration: 2000 });
  //         // 跳转到欢迎页面
  //         console.info("6")
  //
  //         setTimeout(() => {
  //           router.replaceUrl({
  //             url: 'pages/welcome'
  //           });
  //         }, 2000);
  //         console.info("7")
  //       } else {
  //         promptAction.showToast({ message: '登录响应数据为空', duration: 3000 });
  //       }
  //     } else {
  //       promptAction.showToast({ message: result.msg, duration: 3000 });
  //     }
  //   } catch (error) {
  //     console.error('Login error:', JSON.stringify(error));
  //     promptAction.showToast({ message: '网络请求失败，请检查服务器地址', duration: 3000 });
  //   } finally {
  //     this.isLoading = false;
  //   }
  // }

  private async handleLogin() {
    if (!this.login || !this.password) {
      // 可以保留这个Toast，因为它在错误情况下
      promptAction.showToast({ message: '请输入用户名和密码', duration: 3000 });
      return;
    }

    this.isLoading = true;

    try {
      const result = await UserService.login(this.login, this.password);
      if (result.code === '200' && result.data) {
        await PreferencesUtil.setToken(result.data.token);

        router.replaceUrl({ url: 'pages/welcome' });

      } else {
        promptAction.showToast({ message: result.msg || '登录失败', duration: 3000 });
      }
    } catch (error) {
      console.error('Login error:', JSON.stringify(error));
      promptAction.showToast({ message: '网络请求失败', duration: 3000 });
    } finally {
      this.isLoading = false;
    }
  }
}