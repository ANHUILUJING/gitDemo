// entry/src/main/ets/pages/index/Index.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Index {
  @State message: string = 'MyTodo App';
  @State showWelcome: boolean = false;

  onPageShow() {
    // 页面显示时检查是否需要显示欢迎信息
    this.checkAndShowWelcome();
  }

  async checkAndShowWelcome() {
    try {
      const token = await PreferencesUtil.getToken();
      if (token) {
        // 有token说明是登录后跳转过来的
        this.showWelcome = true;
        promptAction.showToast({ message: '欢迎使用MyTodo!', duration: 3000 });

        // 3秒后隐藏欢迎状态
        setTimeout(() => {
          this.showWelcome = false;
        }, 3000);
      }
    } catch (error) {
      console.error('Check welcome error:', JSON.stringify(error));
    }
  }

  build() {
    Column() {
      if (this.showWelcome) {
        Text('欢迎回来！')
          .fontSize(24)
          .fontColor('#007DFF')
          .margin({ bottom: 20 })
      }

      Text(this.message)
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 50 })

      Button('去登录')
        .width('60%')
        .height(50)
        .fontSize(18)
        .backgroundColor('#007DFF')
        .fontColor(Color.White)
        .onClick(() => {
          router.pushUrl({ url: 'pages/login' });
        })

      Button('去注册')
        .width('60%')
        .height(50)
        .fontSize(18)
        .backgroundColor('#34C759')
        .fontColor(Color.White)
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/register' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}