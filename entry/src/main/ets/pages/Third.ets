import router from '@ohos.router'

@Entry
@Component
struct WelcomePage {
  private videoController: VideoController = new VideoController()

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 全屏背景视频（数字人）
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
        Text('宁夏葡萄酒推荐官')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textShadow({
            radius: 2,
            color: Color.Black,
            offsetX: 1,
            offsetY: 1
          })
      }
      .position({ x: 0, y: 120 })
      .width('100%')
      .justifyContent(FlexAlign.Center)

      // 底部开始按钮
      Column() {
        Button('Start')
          .width(120)
          .height(50)
          .fontSize(25)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#007bff')
          .fontColor(Color.White)
          .borderRadius(25)
          .shadow({
            radius: 10,
            color: 'rgba(0, 123, 255, 0.3)',
            offsetX: 0,
            offsetY: 4
          })
          .onClick(() => {
            // 跳转到对话页面
            router.pushUrl({
              url: 'pages/Third_ChatPage'
            })
          })

        Button('Back')
          .width(120)
          .height(50)
          .fontSize(25)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#007bff')
          .fontColor(Color.White)
          .borderRadius(25)
          .margin({ top: 10 })
          .shadow({
            radius: 10,
            color: 'rgba(0, 123, 255, 0.3)',
            offsetX: 0,
            offsetY: 4
          })
          .onClick(() => {
            // 跳转到对话页面
            router.back();
          })
      }
      .position({ x: 0, y: '85%' })
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}