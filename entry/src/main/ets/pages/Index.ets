//Index.ets
//导入页面路由模块
import {router} from '@kit.ArkUI';
import {BusinessError} from '@kit.BasicServicesKit';
import promptAction from '@ohos.promptAction';
import dataPreferences from '@ohos.data.preferences';
import { User } from '../Data_Model/UserInfo';
@Entry
@Component
struct Index {
  @State message: string = 'Please Enter the following';
  @State message2: string = 'If you don`t have an account\nclick Sign In  to register.'
  @State message4: string = 'Hello! \nWelcome To The Digital World'
  //账号和密码的状态变量
  @State account: string = '';
  @State password: string = '';
  build(){
    Row(){
      Column(){
        //添加头像
        Image($r('app.media.avatar'))
          .width(100)
          .height(100)
          .borderRadius(40)
          .margin({top:5,bottom:20})
          .objectFit(ImageFit.Cover)

        Text(this.message4)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007bff')  // 蓝色
          .textAlign(TextAlign.Start)
          .margin({ top: 10, bottom: 80 })
          .textShadow({
            radius: 2,
            color: 'rgba(0, 123, 255, 0.3)',
            offsetX: 1,
            offsetY: 1
          })

        // 添加横线分隔符，中间有"Log in"文字
        Row() {
          // 左侧横线
          Divider()
            .vertical(false)
            .color('#FFFFFF')
            .strokeWidth(1)
            .lineCap(LineCapStyle.Round)
            .layoutWeight(1) // 占据剩余空间

          // 中间文字
          Text('Log in')
            .fontSize(18)
            .fontColor('#666666')
            .margin({ left: 10, right: 10 })

          // 右侧横线
          Divider()
            .vertical(false)
            .color('#FFFFFF')
            .strokeWidth(1)
            .lineCap(LineCapStyle.Round)
            .layoutWeight(1) // 占据剩余空间
        }
        .width('90%') // 设置横线的宽度
        .margin({ top: -60, bottom: 40 }) // 调整位置，向上移动并留出底部间距

        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        //账号输入框
        TextInput({placeholder:'Username'})
          .type(InputType.Normal)
          .width('70%')
          .height('7%')
          .margin({top:30})
          .onChange((value:string) => {
            this.account = value;
          })


        //密码输入框
        TextInput({placeholder:'Password'})
          .type(InputType.Password)
          .width('70%')
          .height('7%')
          .margin({top:15})
          .onChange((value:string) => {
            this.password = value;
          })


        Row() {
          //添加按钮，以响应用户点击
          Button() {
            Text('Log in')
              .fontSize(15)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#333333')
          .width('40%')
          .height('5%')
          //跳转按钮绑定OnClick事件，点击时跳转到第二页
          .onClick(async() => {
            console.info(`Succeeded in clicking the 'Log in' button.`)
            try {
              let preferences = await dataPreferences.getPreferences(getContext(), 'user_info');
              //读取已保存的用户列表
              let usersJson = await preferences.get('users', '[]') as string;
              let users: User[] = JSON.parse(usersJson);

              //在用户列表中查找匹配的账号密码,验证账号密码
              const loggedInUser = users.find(user => user.account === this.account && user.password === this.password);

              if(loggedInUser) {
                //验证成功
                router.pushUrl( {url: 'pages/Choose' });
                console.info(`Login successful! User: ${loggedInUser.account}`);
              }else{
                //验证失败
                promptAction.showToast({
                  message: 'Incorrect username or password',
                  duration: 2000
                });
                console.error('Login failed: Incorrect username or password.')
              }
            }catch(err){
              let code = (err as BusinessError).code;
              let message = (err as BusinessError).message;
              console.error(`Failed to register. Code: ${code}, Message: ${message}`);
            }

          })

          //添加Sign in 按钮
          Button() {
            Text('Sign in')
              .fontSize(15)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#333333')
          .width('40%')
          .height('5%')
          //点击Sign In按钮响应事件
          .onClick(() => {
            console.info(`Succeesed in clicking the 'Sign in' button.`)
            //页面跳转
            router.pushUrl({ url: 'pages/Sign_In_page' }).then(() => {
              console.info(`Succeed in clicking the 'Sign_In_page'.`)
            }).catch((err:BusinessError) => {
              console.error(`Failed to jump to the Sign_In_page. Code is ${err.code},message is ${err.message}`)
            })
          })

        }

        .width('70%') // 控制 Row 的总宽度
        .margin({ top: 0 }) // 调整 Row 的顶部外边距
        .justifyContent(FlexAlign.SpaceAround) // 在主轴方向（水平）上均匀分布子组件

        //添加注册说明信息
        Text(this.message2)
          .fontSize(15)
          .fontWeight(FontWeight.Normal)
          .margin({
            top:30
          })
          .textAlign(TextAlign.Center)
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.first_page_background_2'))
    .layoutWeight(1)
  }
}