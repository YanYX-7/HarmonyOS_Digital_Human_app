import router from '@ohos.router'

@Entry
@Component
struct ChatPage {
  @State showTextInput: boolean = false
  @State inputMessage: string = ''
  @State message3: string = '宁夏葡萄酒推荐官\n很高兴与您对话'
  private videoController: VideoController = new VideoController()

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 全屏数字人视频
      Video({
        src: $rawfile('digital_human_putaojiu.mp4'),
        controller: this.videoController
      })
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .autoPlay(true)
        .loop(true)
        .controls(false)
        .backgroundColor(Color.Black)

      // 顶部标题
      Column() {
        Text(this.message3)  // 修正：去掉单引号，使用变量
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .textShadow({
            radius: 2,
            color: Color.Black,
            offsetX: 1,
            offsetY: 1
          })
      }
      .position({ x: 0, y: 80 })
      .width('100%')
      .justifyContent(FlexAlign.Center)

      // 右下角文字输入切换按钮
      if (!this.showTextInput) {
        Button('文本输入')
          .width(100)
          .height(40)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .borderRadius(20)
          .backgroundColor('#4A4A4A')
          .position({ x: '75%', y: '80%' })
          .onClick(() => {
            this.showTextInput = true
          })
          .shadow({
            radius: 8,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 2
          })

        Button('返  回')
          .width(100)
          .height(40)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .borderRadius(20)
          .backgroundColor('#4A4A4A')
          .position({ x: '75%', y: '88%' })
          .onClick(() => {
            router.back();
          })
          .shadow({
            radius: 8,
            color: 'rgba(0, 0, 0, 0.3)',
            offsetX: 0,
            offsetY: 2
          })
      }

      // 底部文字输入区域
      if (this.showTextInput) {
        Column() {
          Row() {
            // 文字输入框
            TextInput({
              placeholder: '请输入您的问题...',
              text: this.inputMessage
            })
              .layoutWeight(1)
              .height(45)
              .borderRadius(22.5)
              .padding({ left: 15, right: 15 })
              .backgroundColor('rgba(255, 255, 255, 0.9)')
              .placeholderColor('#999999')
              .onChange((value: string) => {
                this.inputMessage = value
              })

            // 发送按钮
            Button('发送')
              .width(80)
              .height(45)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .borderRadius(22.5)
              .backgroundColor('#4A4A4A')
              .margin({ left: 10 })
              .enabled(this.inputMessage.trim() !== '')
              .onClick(() => {
                this.sendMessage()
              })
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
        }
        .width('100%')
        .backgroundColor('rgba(0, 0, 0, 0.8)')
        .padding({ top: 15, bottom: 30 })
        .position({ x: 0, y: '100%' })
        .translate({ x: 0, y: -60 })
      }

      // 文本输入模式下的右侧按钮组
      if (this.showTextInput) {
        Column() {
          // 语音交流按钮
          Button('语音交流')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#6c757d')  // 蓝色表示切换功能
            .margin({ bottom: 10 })
            .onClick(() => {
              this.showTextInput = false  // 切换回语音模式
              this.inputMessage = ''       // 清空输入内容
            })
            .shadow({
              radius: 8,
              color: 'rgba(0, 123, 255, 0.3)',
              offsetX: 0,
              offsetY: 2
            })

          // 返回按钮
          Button('返  回')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#6c757d')  // 灰色表示退出功能
            .onClick(() => {
              router.back()
            })
            .shadow({
              radius: 8,
              color: 'rgba(0, 0, 0, 0.3)',
              offsetX: 0,
              offsetY: 2
            })
        }
        .position({ x: '75%', y: '65%' })  // 右侧靠下位置
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  // 发送消息方法
  sendMessage() {
    if (this.inputMessage.trim() === '') return

    console.log('发送消息:', this.inputMessage)

    // 这里添加与数字人交互的逻辑

    // 清空输入框
    this.inputMessage = ''

    // 可以选择发送后自动隐藏文字输入框
    // this.showTextInput = false
  }
}
