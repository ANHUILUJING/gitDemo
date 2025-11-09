// entry/src/main/ets/pages/register/Register.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { UserService, RegisterRequest } from '../utils/UserService';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State avatarUrl: string = '';
  @State telephone: string = '';
  @State email: string = '';
  @State isLoading: boolean = false;
  @State showPassword: boolean = false;
  @State showConfirmPassword: boolean = false;

  // 表单验证状态
  @State usernameError: string = '';
  @State passwordError: string = '';
  @State confirmPasswordError: string = '';
  @State telephoneError: string = '';
  @State emailError: string = '';

  aboutToAppear() {
    // 初始化Preferences
    PreferencesUtil.initPreferences(getContext(this));
  }

  build() {
    Column() {
      // 头部导航
      Row() {
        Text('< 返回')
          .fontSize(16)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back();
          })
        Text('注册账号')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })

        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .alignItems(VerticalAlign.Center)

      // 表单内容
      Scroll() {
        Column() {
          // 用户名输入
          this.buildInputItem('用户名', '请输入用户名', this.username, (value: string) => {
            this.username = value;
            this.validateUsername();
          }, this.usernameError)

          // 密码输入
          this.buildPasswordItem('密码', '请输入密码', this.password, (value: string) => {
            this.password = value;
            this.validatePassword();
            this.validateConfirmPassword();
          }, this.passwordError, this.showPassword, () => {
            this.showPassword = !this.showPassword;
          })

          // 确认密码输入
          this.buildPasswordItem('确认密码', '请再次输入密码', this.confirmPassword, (value: string) => {
            this.confirmPassword = value;
            this.validateConfirmPassword();
          }, this.confirmPasswordError, this.showConfirmPassword, () => {
            this.showConfirmPassword = !this.showConfirmPassword;
          })

          // 头像URL输入（可选）
          this.buildInputItem('头像链接', '请输入头像URL（可选）', this.avatarUrl, (value: string) => {
            this.avatarUrl = value;
          }, '')  // 添加空字符串作为第五个参数

          // 手机号输入（可选）
          this.buildInputItem('手机号', '请输入手机号（可选）', this.telephone, (value: string) => {
            this.telephone = value;
            this.validateTelephone();
          }, this.telephoneError)

          // 邮箱输入（可选）
          this.buildInputItem('邮箱', '请输入邮箱（可选）', this.email, (value: string) => {
            this.email = value;
            this.validateEmail();
          }, this.emailError)

          // 注册按钮
          Button('注册', { type: ButtonType.Capsule })
            .width('90%')
            .height(45)
            .backgroundColor(this.canRegister() ? '#007DFF' : '#CCCCCC')
            .fontColor(Color.White)
            .margin({ top: 40, bottom: 20 })
            .enabled(this.canRegister() && !this.isLoading)
            .onClick(() => {
              this.handleRegister();
            })

          // 加载指示器
          if (this.isLoading) {
            LoadingProgress()
              .color('#007DFF')
              .margin({ top: 10 })
          }

          // 用户协议提示
          Text('注册即表示同意《用户协议》和《隐私政策》')
            .fontSize(12)
            .fontColor('#666')
            .margin({ top: 20 })
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 构建输入项组件
  @Builder
  buildInputItem(label: string, placeholder: string, value: string,
    onChange: (value: string) => void, error: string) {
    Column() {
      // 标签
      Row() {
        Text(label)
          .fontSize(16)
          .fontColor('#333')
        if (label === '用户名' || label === '密码') {
          Text('*')
            .fontSize(16)
            .fontColor('#FF0000')
            .margin({ left: 2 })
        }
      }
      .width('90%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 8 })

      // 输入框
      TextInput({ placeholder: placeholder, text: value })
        .width('90%')
        .height(50)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          onChange(value);
        })

      // 错误提示
      if (error) {
        Text(error)
          .fontSize(12)
          .fontColor('#FF0000')
          .width('90%')
          .textAlign(TextAlign.Start)
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .margin({ top: 16 })
  }

  // 构建密码输入项组件
  @Builder
  buildPasswordItem(label: string, placeholder: string, value: string,
    onChange: (value: string) => void, error: string,
    showPassword: boolean, onToggle: () => void) {
    Column() {
      // 标签
      Row() {
        Text(label)
          .fontSize(16)
          .fontColor('#333')
        Text('*')
          .fontSize(16)
          .fontColor('#FF0000')
          .margin({ left: 2 })
      }
      .width('90%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 8 })

      // 输入框和眼睛图标
      Row() {
        TextInput({ placeholder: placeholder, text: value })
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 12, right: 12 })
          .type(showPassword ? InputType.Normal : InputType.Password)
          .onChange((value: string) => {
            onChange(value);
          })

        // 显示/隐藏密码按钮
        if (value) {
          // Image(showPassword ? $r('app.media.ic_public_eye_open') : $r('app.media.ic_public_eye_close'))
          //   .width(20)
          //   .height(20)
          //   .margin({ right: 12 })
          //   .onClick(() => {
          //     onToggle();
          //   })
          Text(this.showPassword ? '隐藏' : '显示')
            .fontSize(14)
            .fontColor('#007DFF')
            .margin({ right: 12 })
            .onClick(() => {
              this.showPassword = !this.showPassword;
            })
        }
      }
      .width('90%')
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .alignItems(VerticalAlign.Center)

      // 错误提示
      if (error) {
        Text(error)
          .fontSize(12)
          .fontColor('#FF0000')
          .width('90%')
          .textAlign(TextAlign.Start)
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .margin({ top: 16 })
  }

  // 表单验证方法
  private validateUsername(): void {
    if (!this.username) {
      this.usernameError = '用户名不能为空';
    } else if (this.username.length < 3) {
      this.usernameError = '用户名至少3个字符';
    } else if (this.username.length > 50) {
      this.usernameError = '用户名不能超过50个字符';
    } else {
      this.usernameError = '';
    }
  }

  private validatePassword(): void {
    if (!this.password) {
      this.passwordError = '密码不能为空';
    } else if (this.password.length < 6) {
      this.passwordError = '密码至少6个字符';
    } else {
      this.passwordError = '';
    }
  }

  private validateConfirmPassword(): void {
    if (!this.confirmPassword) {
      this.confirmPasswordError = '请确认密码';
    } else if (this.password !== this.confirmPassword) {
      this.confirmPasswordError = '两次输入的密码不一致';
    } else {
      this.confirmPasswordError = '';
    }
  }

  private validateTelephone(): void {
    if (this.telephone && !/^1[3-9]\d{9}$/.test(this.telephone)) {
      this.telephoneError = '请输入正确的手机号格式';
    } else {
      this.telephoneError = '';
    }
  }

  private validateEmail(): void {
    if (this.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
      this.emailError = '请输入正确的邮箱格式';
    } else {
      this.emailError = '';
    }
  }

  // 检查是否可以注册
  private canRegister(): boolean {
    return !this.usernameError &&
      !this.passwordError &&
      !this.confirmPasswordError &&
      !this.telephoneError &&
      !this.emailError &&
      this.username.length >= 3 &&
      this.password.length >= 6 &&
      this.password === this.confirmPassword;
  }

  // 注册处理函数
  // 在 register.ets 的 handleRegister 方法中修改跳转部分
  private async handleRegister() {
    if (!this.canRegister()) {
      promptAction.showToast({ message: '请完善表单信息', duration: 3000 });
      return;
    }

    this.isLoading = true;

    try {
      const registerData = {
        username: this.username,
        password: this.password,
        avatarUrl: this.avatarUrl || undefined,
        telephone: this.telephone || undefined,
        email: this.email || undefined
      } as RegisterRequest;

      const result = await UserService.register(registerData);

      if (result.code === '200') {
        // 移除Toast，直接进行自动登录
        console.info('注册成功，请登录');

        // 注册成功后自动登录
        const loginResult = await UserService.login(this.username, this.password);
        if (loginResult.code === '200' && loginResult.data) {
          await PreferencesUtil.setToken(loginResult.data.token);
          // 直接跳转到首页，在首页显示欢迎信息
          router.replaceUrl({
            url: 'pages/login'
          });
        } else {
          // 自动登录失败，跳转到登录页面
          console.warn('自动登录失败，跳转到登录页面');
          router.replaceUrl({
            url: 'pages/login'
          });
        }
      } else {
        // 注册失败时仍然显示错误Toast
        promptAction.showToast({ message: result.msg, duration: 3000 });
      }
    } catch (error) {
      console.error('Register error:', JSON.stringify(error));
      promptAction.showToast({ message: '注册失败，请检查网络连接', duration: 3000 });
    } finally {
      this.isLoading = false;
    }
  }
}