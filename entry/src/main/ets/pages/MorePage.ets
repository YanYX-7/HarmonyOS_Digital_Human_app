import {router} from '@kit.ArkUI';
//import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Choose {
  @State message: string = 'More digital avatars to choose from here';

  build(){
    Stack({ alignContent: Alignment.Top}) {
      Column() {

      }
      .width('100%')
      .height('18%')
      .backgroundColor('#ff42a07e')

      Column() {
        Text('MORE')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffffffff')  // 黑色
          .textAlign(TextAlign.Start)
          .margin({ top: 20, bottom: 2 })
          .textShadow({
            radius: 2,
            color: 'rgba(0, 123, 255, 0.3)',
            offsetX: 1,
            offsetY: 1
          })

        Text(this.message)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffffffff')  // 黑色
          .textAlign(TextAlign.Start)
          .margin({ top:20, bottom: 20 })
          .textShadow({
            radius: 2,
            color: 'rgba(0, 123, 255, 0.3)',
            offsetX: 1,
            offsetY: 1
          })

        // 按钮1 - 智慧运维数字人
        Button() {
          Row() {
            Image($r('app.media.people_1'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('智慧运维数字人')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#666666')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Second' });
        })

        // 按钮2 - 宁夏葡萄酒推荐官
        Button() {
          Row() {
            Image($r('app.media.people_2'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('宁夏葡萄酒推荐官')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#800080')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Third' });
        })

        // 按钮3 - 宁夏大学智慧助手
        Button() {
          Row() {
            Image($r('app.media.people_3'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('宁夏大学智慧助手')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#4CAF50')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Third' });
        })

        Button() {
          Row() {
            Image($r('app.media.people_5'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('贺兰山导游数字人')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#ff8a8a7c')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Third' });
        })

        Button() {
          Row() {
            Image($r('app.media.people_6'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('宪法科普教育数字人')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#ffc4213c')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Third' });
        })

        // 按钮4 - 个性化定制
        Button() {
          Row() {
            Image($r('app.media.people_4'))
              .width(50)
              .height(50)
              .borderRadius(25)
              .margin({ right: 15 })
              .objectFit(ImageFit.Cover)

            Text('个性化定制')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#1e40e9')
        .width('85%')
        .height(55)
        .onClick(() => {
          router.pushUrl({ url: 'pages/personal' });
        })


        Button() {
          Text('Back')
            .fontSize(20)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.White)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#333333')
        .width('85%')
        .height(45)
        .onClick(() => {
          router.back();
        })

        // 在按钮下方添加图片
        Image($r('app.media.button_back_2'))
          .width('100%')
          .height(120) // 设置合适的高度
          .objectFit(ImageFit.Cover)
          .margin({ top: 30 }) // 与最后一个按钮的间距

      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center) // This centers all children horizontally
    }
    .width('100%')
    .height('100%')
  }
}
