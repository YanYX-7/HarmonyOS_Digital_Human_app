import router from '@ohos.router';

@Entry
@Component
struct PersonalCustomPage {
  @State name: string = '';
  @State description: string = '';
  @State avatarUri: string = ''; // 存储用户选择的图片URI

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Image($r('app.media.personal_back'))
          .width(60)
          .height(56)
          .onClick(() => {
            router.back();
          })

        Text('定制我的数字人')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row().width(24).height(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 20 })
      .backgroundColor('#ff6768d6')

      // 主内容区（可滚动）
      Scroll() {
        Column() {
          // 头像上传区
          Column() {
            // 头像预览/上传按钮
            Stack() {
              if (this.avatarUri) {
                // 如果已选择图片，显示预览
                Image(this.avatarUri)
                  .width(200)
                  .height(200)
                  .borderRadius(20)  // 小圆角
                  .objectFit(ImageFit.Cover)
              } else {
                Column() {
                  Image($r('app.media.people_4')) // 相机图标
                    .width(40)
                    .height(40)
                    .fillColor('#999999')

                  Text('点击添加形象')
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ top: 8 })
                }
                .width(200)
                .height(100)
                .borderRadius(10)  // 小圆角矩形
                .borderRadius(60)
                .backgroundColor('#f5f5f5')
                .justifyContent(FlexAlign.Center)
              }
            }
            .border({ width: 4, color: Color.White })
            .borderRadius(60)
            .shadow({ radius: 16, color: '#33000000' })
            .onClick(() => {
              // 打开图片选择器
              this.selectImage();
            })

            // 操作提示
            Row() {
              Button('📷 拍照')
                .fontSize(14)
                .fontColor('#6366f1')
                .backgroundColor('#e0e7ff')
                .height(36)
                .borderRadius(18)
                .margin({ right: 12 })
                .onClick(() => {
                  this.takePhoto();
                })

              Button('🖼️ 相册')
                .fontSize(14)
                .fontColor('#6366f1')
                .backgroundColor('#e0e7ff')
                .height(36)
                .borderRadius(18)
                .onClick(() => {
                  this.selectImage();
                })
            }
            .margin({ top: 16 })
          }
          .width('100%')
          .padding(32)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 20 })

          // 名称输入卡片
          Column() {
            Text('数字人名称')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '例如：小智助手' })
              .backgroundColor('#f5f5f5')
              .borderRadius(8)
              .height(48)
              .onChange((value: string) => {
                this.name = value;
              })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 16 })
          .alignItems(HorizontalAlign.Start)

          // 描述输入卡片
          Column() {
            Text('角色描述')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .margin({ bottom: 8 })

            TextArea({ placeholder: '描述这个数字人的特点和用途...' })
              .backgroundColor('#f5f5f5')
              .borderRadius(8)
              .height(120)
              .onChange((value: string) => {
                this.description = value;
              })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 16 })
          .alignItems(HorizontalAlign.Start)

          // 特性选择卡片
          Column() {
            Text('特性标签')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .margin({ bottom: 12 })

            Flex({ wrap: FlexWrap.Wrap }) {
              this.TagButton('专业知识')
              this.TagButton('亲切友好')
              this.TagButton('幽默风趣')
              this.TagButton('严谨认真')
              this.TagButton('创意无限')
              this.TagButton('耐心细致')
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ top: 16 })
          .alignItems(HorizontalAlign.Start)

          // 创建按钮
          Button('创建数字人')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .backgroundColor('#6366f1')
            .width('100%')
            .height(52)
            .borderRadius(26)
            .margin({ top: 32, bottom: 32 })
            .enabled(this.avatarUri !== '' && this.name !== '')
            .opacity(this.avatarUri !== '' && this.name !== '' ? 1 : 0.5)
            .onClick(() => {
              console.info('创建数字人:', this.name, this.description, this.avatarUri);
              router.back();
            })
        }
        .width('90%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#f8f9fa')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f8f9fa')
  }

  @Builder TagButton(text: string) {
    Text(text)
      .fontSize(14)
      .fontColor('#6366f1')
      .backgroundColor('#e0e7ff')
      .borderRadius(16)
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .margin({ right: 8, bottom: 8 })
  }

  // 选择图片
  private selectImage() {
    // TODO: 调用系统相册选择器
    // 示例代码（需要导入相关模块）
    /*
    import picker from '@ohos.file.picker';

    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    }).then((result) => {
      if (result.photoUris.length > 0) {
        this.avatarUri = result.photoUris[0];
      }
    });
    */

    // 临时演示（实际使用时删除）
    this.avatarUri = 'file://path/to/image.jpg';
  }

  // 拍照
  private takePhoto() {
    // TODO: 调用系统相机
    // 示例代码
    /*
    import camera from '@ohos.multimedia.camera';
    // 实现拍照逻辑
    */

    // 临时演示
    this.avatarUri = 'file://path/to/photo.jpg';
  }
}
