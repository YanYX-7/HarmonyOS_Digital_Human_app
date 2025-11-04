import {router} from '@kit.ArkUI';
//import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Choose {
  @State message: string = 'Which character would you like to talk to?';

  build(){
    Stack({ alignContent: Alignment.Top}) {
      Column() {

      }
      .width('100%')
      .height('20%')
      .backgroundColor('#ff793c3c')

      Column() {
        Text('MENU')
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

        Grid() {
          // 第一个卡片 - 智慧运维数字人
          GridItem() {
            Column() {
              Image($r('app.media.people_1'))
                .width('100%')
                .height(120)
                .borderRadius({ topLeft: 12, topRight: 12 })
                .objectFit(ImageFit.Cover)

              Column() {
                Text('智慧运维数字人')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Text('在线工业运维助手')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .alignItems(HorizontalAlign.Start)
              .padding(12)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({ radius: 8, color: '#1F000000', offsetY: 2 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Second' });
            })
          }

          // 第二个卡片 - 宁夏葡萄酒推荐官
          GridItem() {
            Column() {
              Image($r('app.media.people_2'))
                .width('100%')
                .height(120)
                .borderRadius({ topLeft: 12, topRight: 12 })
                .objectFit(ImageFit.Cover)

              Column() {
                Text('宁夏葡萄酒推荐官')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Text('宁夏葡萄酒推荐大使')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .alignItems(HorizontalAlign.Start)
              .padding(12)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({ radius: 8, color: '#1F000000', offsetY: 2 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Third' });
            })
          }

          // 第三个卡片 - 宁夏大学智慧助手
          GridItem() {
            Column() {
              Image($r('app.media.people_3'))
                .width('100%')
                .height(120)
                .borderRadius({ topLeft: 12, topRight: 12 })
                .objectFit(ImageFit.Cover)

              Column() {
                Text('宁夏大学智慧助手')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Text('AI FOR NXU')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .alignItems(HorizontalAlign.Start)
              .padding(12)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({ radius: 8, color: '#1F000000', offsetY: 2 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Third' });
            })
          }

          // 第四个卡片 - 个性化定制
          GridItem() {
            Column() {
              Image($r("app.media.people_4"))
                .width('100%')
                .height(120)
                .borderRadius({ topLeft: 12, topRight: 12 })
                .objectFit(ImageFit.Cover)

              Column() {
                Text('个性化定制')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Text('PERSONAL')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .alignItems(HorizontalAlign.Start)
              .padding(12)
              .width('100%')
            }
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({ radius: 8, color: '#1F000000', offsetY: 2 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/personal' });
            })
          }
        }
        .columnsTemplate('1fr 1fr') // 2列布局
        .rowsTemplate('1fr 1fr') // 2行布局
        .columnsGap(12) // 列间距
        .rowsGap(12) // 行间距
        .width('90%')
        .height(400)
        .margin({ top: 30 })


        Row() {
          // Back 按钮
          Button() {
            Text('Back')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .backgroundColor('#333333')
          .width('45%')
          .height(35)
          .onClick(() => {
            router.back();
          })

          // More 按钮
          Button() {
            Text('More')
              .fontSize(20)
              .fontWeight(FontWeight.Normal)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .backgroundColor('#666666') // 可以用不同颜色区分
          .width('45%')
          .height(35)
          .onClick(() => {
            // 添加 More 按钮的点击事件
             router.pushUrl({ url: 'pages/MorePage' });
          })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween) // 两个按钮分居两端
        .margin({ top: 10 })

        // 在按钮下方添加图片
        Image($r('app.media.button_back'))
          .width('100%')
          .height(150) // 设置合适的高度
          .objectFit(ImageFit.Cover)
          .margin({ top:20 }) // 与最后一个按钮的间距

      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center) // This centers all children horizontally
    }
    .width('100%')
    .height('100%')
  }
}
