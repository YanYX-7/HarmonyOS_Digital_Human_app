import router from '@ohos.router'
import webSocket from '@ohos.net.webSocket'//导入webSocket

@Entry
@Component
struct ChatPage {
  @State showTextInput: boolean = false
  @State inputMessage: string = ''
  @State message3: string = '智慧运维数字人\n很高兴与您对话'
  private videoController: VideoController = new VideoController()
  private socket: webSocket.WebSocket | null = null

  aboutToAppear() {
    this.connectWebSocket()
  }

  aboutToDisappear() {
    this.connectWebSocket()
  }

  // 连接WebSocket
  connectWebSocket() {
    try {
      // 创建WebSocket连接
      this.socket = webSocket.createWebSocket()

      // 连接到后端服务
      this.socket.connect('ws://127.0.0.1:19465/recognition?isSendConfig=true')

      // 连接成功回调
      this.socket.on('open', (err, value) => {
        if (!err) {
          console.log('WebSocket连接成功')
          this.message3 = '智慧运维数字人\n连接成功，可以开始对话'
        } else {
          console.error('WebSocket连接失败:', err)
          this.message3 = '智慧运维数字人\n连接失败，请检查网络'
        }
      })

      // 接收消息回调
      this.socket.on('message', (err, value) => {
        if (!err) {
          console.log('收到服务器消息:', value)
          // 这里可以处理从服务器返回的识别结果
          this.handleServerMessage(value)
        }
      })

      // 连接关闭回调
      this.socket.on('close', (err, value) => {
        console.log('WebSocket连接已关闭')
        this.message3 = '智慧运维数字人\n连接已断开'
      })

      // 错误回调
      this.socket.on('error', (err) => {
        console.error('WebSocket错误:', err)
        this.message3 = '智慧运维数字人\n连接出现错误'
      })

    } catch (error) {
      console.error('创建WebSocket失败:', error)
    }
  }

  // 断开WebSocket连接
  disconnectWebSocket() {
    if (this.socket) {
      this.socket.close()
      this.socket = null
    }
  }

  //处理服务器消息
  handleServerMessage(message: string | ArrayBuffer) {
    if (typeof message === 'string') {
      try {
        // 直接使用object类型
        const data: object = JSON.parse(message)
        console.log('解析后的数据:', data)

        // 简单的类型检查
        const messageObj = data as Record<string, string>
        if (messageObj.type && messageObj.content) {
          this.message3 = `收到消息: ${messageObj.content}`
        }
      } catch (e) {
        console.log('处理文本消息:', message)
        this.message3 = `文本消息: ${message}`
      }
    } else {
      // 处理ArrayBuffer类型
      console.log('收到二进制数据')
    }
  }
  // 发送消息到服务器
  sendToServer(message: string) {
    if (this.socket) {
      this.socket.send(message, (err) => {
        if (err) {
          console.error('发送消息失败:', err)
        } else {
          console.log('消息发送成功:', message)
        }
      })
    }
  }

  //修改后的发送消息方法
  sendMessage() {
    if (this.inputMessage.trim() === '') return

    console.log('发送消息:', this.inputMessage)

    // 发送消息到WebSocket服务器
    this.sendToServer(this.inputMessage)

    // 清空输入框
    this.inputMessage = ''
  }


  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 全屏数字人视频
      Video({
        src: $rawfile('digital_human.mp4'),
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
  sendMessag2() {
    if (this.inputMessage.trim() === '') return

    console.log('发送消息:', this.inputMessage)

    // 这里添加与数字人交互的逻辑

    // 清空输入框
    this.inputMessage = ''

    // 可以选择发送后自动隐藏文字输入框
    // this.showTextInput = false
  }
}
