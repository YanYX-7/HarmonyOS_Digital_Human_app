import { router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit';
import promptAction from '@ohos.promptAction'

import dataPreferences from '@ohos.data.preferences';
import { User } from '../Data_Model/UserInfo';

@Entry
@Component

struct Sign_In_page {
  //用于存储用户输入的账号，密码,确认密码,注册邮箱，电话号码
  @State newAccount: string = '';
  @State newPassword: string = '';
  @State confirmPassword: string = '';
  @State email: string = '';
  @State telephone: string = '';


  build(){
    Row(){
      Column(){

        Text('Create New Account')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30})

        TextInput({ placeholder: 'Enter new Username' })
          .type(InputType.Normal)
          .width('70%')
          .height('7%')
          .onChange((value: string) => {
            this.newAccount = value;
          })

        TextInput({ placeholder: 'Enter new password' })
          .type(InputType.Password)
          .width('70%')
          .height('7%')
          .margin( { top: 15})
          .onChange((value: string) => {
            this.newPassword = value;
          })

        TextInput({ placeholder: 'Confirm  password' })
          .type(InputType.Password)
          .width('70%')
          .height('7%')
          .margin( { top: 15})
          .onChange((value: string) => {
            this.confirmPassword = value;
          })

        TextInput({ placeholder: 'Enter your Email' })
          .type(InputType.Email)
          .width('70%')
          .height('7%')
          .margin( { top: 15})
          .onChange((value: string) => {
            this.email = value;
          })

        TextInput({ placeholder: 'Enter your telephone' })
          .type(InputType.PhoneNumber)
          .width('70%')
          .height('7%')
          .margin( { top: 15})
          .onChange((value: string) => {
            this.telephone = value;
          })

        //注册按钮
        Button(){
          Text('Register')
            .fontSize(15)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.White)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 40} )
        .backgroundColor('#333333')
        .width('40%')
        .height('5%')
        .onClick(() => {
          this.handleRegistration();
        })

        Button(){
          Text('Back')
            .fontSize(15)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.White)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 40} )
        .backgroundColor('#333333')
        .width('40%')
        .height('5%')
        .onClick(() => {
          router.back();
        })

      }
      .width('100%')
    }
    .height('100%')
  }

  //handleRegistration注册逻辑处理函数
  async handleRegistration() {
    //如果验证密码不一致
    if (this.newPassword !== this.confirmPassword) {
      promptAction.showToast({
        message: 'Passwords do not match',
        duration: 2000
      });
      return;
    }
    //检查用户名和密码，邮箱，电话是否为空
    if (this.newAccount.trim() === '' || this.newPassword.trim() === '' || this.email.trim() === '' ||
      this.telephone.trim() === '') {
      promptAction.showToast({
        message: 'Information connot be empty .',
        duration: 2000
      });
      return;
    }

    try {
      let preferences = await dataPreferences.getPreferences(getContext(), 'user_info');
      //读取已保存的用户列表
      let usersJson = await preferences.get('users', '[]') as string;
      let users: User[] = JSON.parse(usersJson);

      //检查账号是否已存在
      const isAccountExist = users.some(user => user.account === this.newAccount);
      if (isAccountExist) {
        promptAction.showToast({ message: 'Account already exists!', duration: 2000 });
        return;
      }

      //将用户添加到列表中
      const newUser: User = { account: this.newAccount, password: this.newPassword };
      users.push(newUser);

      //将更新后的列表转换回JSON字符串并保存
      await preferences.put('users', JSON.stringify(users));
      await preferences.flush();

      console.info(`New user registered and saved: ${this.newAccount}`);
      promptAction.showToast({
        message: 'Registration successful',
        duration: 2000
      });
      router.back();
    } catch(err){
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      console.error(`Failed to register. Code: ${code}, Message: ${message}`);
      promptAction.showToast({ message: 'Registration failed!', duration: 2000});
    }


  }
}
