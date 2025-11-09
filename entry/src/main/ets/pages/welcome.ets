// entry/src/main/ets/pages/welcome/Welcome.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Welcome {
  @State username: string = '';
  @State token: string = '';

  aboutToAppear() {
    this.loadUserInfo();
  }

  async loadUserInfo() {
    try {
      // 从本地存储获取token（在实际应用中，这里应该调用API获取用户信息）
      this.token = await PreferencesUtil.getToken();
      this.username = '用户'; // 临时写死，实际应该从API获取

      promptAction.showToast({
        message: `欢迎回来，${this.username}! Token: ${this.token.substring(0, 10)}...`,
        duration: 3000
      });
    } catch (error) {
      console.error('Load user info error:', JSON.stringify(error));
    }
  }

  build() {
    Column() {
      // 头部
      Text('欢迎使用 MyTodo')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 100, bottom: 50 })

      // 用户信息卡片
      Column() {
        Text('登录成功！')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007DFF')
          .margin({ bottom: 20 })

        Text(`用户名: ${this.username}`)
          .fontSize(16)
          .margin({ bottom: 10 })
      }
      .width('90%')
      .padding(20)
      .backgroundColor('#F8F9FA')
      .borderRadius(12)

      // 功能按钮区域
      Column() {
        Button('查看任务列表')
          .width('100%')
          .height(45)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .margin({ bottom: 15 })
          .onClick(() => {
            promptAction.showToast({ message: '跳转到任务列表（待开发）', duration: 2000 });
          })

        Button('个人中心')
          .width('100%')
          .height(45)
          .backgroundColor('#34C759')
          .fontColor(Color.White)
          .margin({ bottom: 15 })
          .onClick(() => {
            promptAction.showToast({ message: '跳转到个人中心（待开发）', duration: 2000 });
          })

        Button('退出登录')
          .width('100%')
          .height(45)
          .backgroundColor('#FF3B30')
          .fontColor(Color.White)
          .onClick(() => {
            this.handleLogout();
          })
      }
      .width('90%')
      .margin({ top: 50 })

      // 底部信息
      Text('MyTodo v1.0.0')
        .fontSize(12)
        .fontColor('#999')
        .margin({ top: 80 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }

  private async handleLogout() {
    try {
      await PreferencesUtil.clearToken();
      //promptAction.showToast({ message: '已退出登录', duration: 2000 });

      // 跳转回登录页面
      setTimeout(() => {
        router.replaceUrl({ url: 'pages/login' });
      }, 2000);
    } catch (error) {
      console.error('Logout error:', JSON.stringify(error));
      promptAction.showToast({ message: '退出登录失败', duration: 3000 });
    }
  }
}