import router from '@ohos.router'
import webSocket from '@ohos.net.webSocket'
import media from '@ohos.multimedia.media'
import audio from '@ohos.multimedia.audio'
import util from '@ohos.util'
import { BusinessError } from '@ohos.base'

// 消息类型定义
interface ServerMessage {
  DataType: string
  Data: string
}

interface TTSData {
  Text: string
  AudioData: string
}

// 聊天消息定义
interface ChatMessage {
  type: 'user' | 'ai' | 'system'
  content: string
}

interface WebSocketConfig {
  systemMessage: string
  voiceType: string
}

interface SystemPromptData {
  Text: string
}

@Entry
@Component
struct ChatPage {
  @State showTextInput: boolean = false
  @State inputMessage: string = ''
  @State message3: string = '智慧运维数字人\n很高兴与您对话'
  @State chatMessages: ChatMessage[] = []
  @State isRecording: boolean = false
  @State isAISpeaking: boolean = false

  private videoController: VideoController = new VideoController()
  private socket: webSocket.WebSocket | null = null
  private audioPlayer: media.AVPlayer | null = null
  private audioCapturer: audio.AudioCapturer | null = null
  private audioQueue: ArrayBuffer[] = []
  private isPlaying: boolean = false
  private currentAIMessage: string = ''

  aboutToAppear() {
    this.connectWebSocket()
    this.initAudioPlayer()
  }

  aboutToDisappear() {
    this.disconnectWebSocket()
    this.releaseAudioResources()
  }

  // ==================== WebSocket 连接管理 ====================

  connectWebSocket() {
    try {
      this.socket = webSocket.createWebSocket()
      this.socket.connect('ws://10.128.37.164:19465/recognition?isSendConfig=true')

      // 连接成功
      this.socket.on('open', (err: BusinessError | undefined, value: Object | undefined): void => {
        if (!err) {
          console.log('WebSocket连接成功')
          this.message3 = '智慧运维数字人\n连接成功，可以开始对话'

          // 发送初始配置
          const config: WebSocketConfig = {
            systemMessage: "我是宁夏大学智能助手小青",
            voiceType: "BV700_streaming"
          }
          this.socket?.send(JSON.stringify(config))

          // 启动语音识别
          this.startVoiceRecognition()
        } else {
          console.error('WebSocket连接失败:', err)
          this.message3 = '智慧运维数字人\n连接失败，请检查网络'
        }
      })

      // 接收消息
      this.socket.on('message', (err: BusinessError | undefined, value: string |ArrayBuffer): void => {
        if (!err && typeof value === 'string') {
          this.handleServerMessage(value)
        }
      })

      // 连接关闭
      this.socket.on('close', (err: BusinessError | undefined, value: webSocket.CloseResult | undefined) => {
        console.log('WebSocket连接已关闭')
        this.message3 = '智慧运维数字人\n连接已断开'
      })

      // 错误处理
      this.socket.on('error', (err: BusinessError): void => {
        console.error('WebSocket错误:', err)
      })

    } catch (error) {
      console.error('创建WebSocket失败:', error)
    }
  }

  disconnectWebSocket() {
    if (this.socket) {
      this.socket.close()
      this.socket = null
    }
  }

  // ==================== 消息处理 ====================

  handleServerMessage(message: string) {
    try {
      const jsonData: ServerMessage = JSON.parse(message)

      switch (jsonData.DataType) {
        case 'TTS':
          // 处理 TTS 音频数据
          this.handleTTSData(jsonData.Data)
          break

        case 'StartLLM':
          // LLM 开始处理
          this.handleStartLLM(jsonData.Data)
          break

        case 'SystemPrompt':
          // 系统提示
          this.handleSystemPrompt(jsonData.Data)
          break
      }
    } catch (error) {
      console.error('解析消息失败:', error)
    }
  }

  // 处理 TTS 数据
  handleTTSData(data: string) {
    try {
      const ttsData: TTSData = JSON.parse(data)

      // 添加文本到当前 AI 消息
      if (ttsData.Text && ttsData.Text.trim() !== '') {
        this.currentAIMessage += ttsData.Text

        // 更新最后一条 AI 消息
        if (this.chatMessages.length > 0 &&
          this.chatMessages[this.chatMessages.length - 1].type === 'ai') {
          this.chatMessages[this.chatMessages.length - 1].content = this.currentAIMessage
        }
      }

      // 处理音频数据
      if (ttsData.AudioData && ttsData.AudioData.trim() !== '') {
        const audioBuffer = this.base64ToArrayBuffer(ttsData.AudioData)
        this.audioQueue.push(audioBuffer)
        this.playNextAudio()
      }

    } catch (error) {
      console.error('处理TTS数据失败:', error)
    }
  }

  // 处理 LLM 开始
  handleStartLLM(userInput: string) {
    // 添加用户消息
    this.chatMessages.push({
      type: 'user',
      content: userInput
    })

    // 创建新的 AI 消息占位
    this.currentAIMessage = ''
    this.chatMessages.push({
      type: 'ai',
      content: ''
    })

    // 清空音频队列
    this.audioQueue = []
    this.isAISpeaking = true
    this.isRecording = false
  }

  // 处理系统提示
  handleSystemPrompt(data: string): void {
    try {
      const promptData: SystemPromptData = JSON.parse(data) as SystemPromptData
      const systemMessage: ChatMessage = {
        type: 'system',
        content: promptData.Text
      }
      this.chatMessages.push(systemMessage)

    } catch (error) {
      console.error('处理系统提示失败:', error)
    }
  }

  // ==================== 音频播放 ====================

  async initAudioPlayer(): Promise<void> {
    try {
      this.audioPlayer = await media.createAVPlayer()

      this.audioPlayer.on('stateChange', (state: media.AVPlayerState, reason: media.StateChangeReason): void => {
        console.log('播放器状态:', state)

        if (state === 'completed') {
          this.onAudioPlayEnd()
        }
      })

    } catch (error) {
      console.error('初始化音频播放器失败:', error)
    }
  }

  async playNextAudio() {
    if (this.isPlaying || this.audioQueue.length === 0) {
      return
    }

    this.isPlaying = true
    const audioData = this.audioQueue.shift()

    if (audioData && this.audioPlayer) {
      try {
        // 将 ArrayBuffer 转换为可播放的格式
        // 注意：这里需要根据实际音频格式进行调整
        // 可能需要写入临时文件或使用其他方式
        await this.playAudioBuffer(audioData)

      } catch (error) {
        console.error('播放音频失败:', error)
        this.isPlaying = false
        this.playNextAudio()
      }
    }
  }

  async playAudioBuffer(buffer: ArrayBuffer): Promise<void> {
    // TODO: 实现音频播放逻辑
    // HarmonyOS 的音频播放需要文件路径或 FD
    // 可能需要先将 buffer 写入临时文件

    // 临时模拟播放完成
    setTimeout((): void => {
      this.onAudioPlayEnd()
    }, 1000)
  }

  onAudioPlayEnd() {
    this.isPlaying = false

    if (this.audioQueue.length > 0) {
      this.playNextAudio()
    } else {
      this.isAISpeaking = false
      if (!this.showTextInput) {
        this.isRecording = true
      }
    }
  }

  // ==================== 语音识别 ====================

  async startVoiceRecognition() {
    if (this.showTextInput || this.isRecording) {
      return
    }

    try {
      // 创建音频采集器
      const audioStreamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
        channels: audio.AudioChannel.CHANNEL_1,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      }

      const audioCapturerInfo: audio.AudioCapturerInfo = {
        source: audio.SourceType.SOURCE_TYPE_MIC,
        capturerFlags: 0
      }

      const audioCapturerOptions: audio.AudioCapturerOptions = {
        streamInfo: audioStreamInfo,
        capturerInfo: audioCapturerInfo
      }

      this.audioCapturer = await audio.createAudioCapturer(audioCapturerOptions)

      // 监听音频数据
      this.audioCapturer.on('readData', (buffer: ArrayBuffer): void => {
        if (this.isRecording && this.socket) {
          // 发送音频数据到服务器
          this.socket.send(buffer, (err: BusinessError | undefined): void => {
            if (err) {
              console.error('发送音频数据失败:', err)
            }
          })
        }
      })

      // 开始录音
      await this.audioCapturer.start()
      this.isRecording = true

    } catch (error) {
      console.error('启动语音识别失败:', error)
    }
  }

  async stopVoiceRecognition() {
    if (this.audioCapturer) {
      try {
        await this.audioCapturer.stop()
        this.isRecording = false
      } catch (error) {
        console.error('停止语音识别失败:', error)
      }
    }
  }

  // ==================== 工具函数 ====================

  base64ToArrayBuffer(base64: string): ArrayBuffer {
    try {
      // 使用 HarmonyOS 的 Base64 解码
      const helper = new util.Base64Helper()
      const uint8Array: Uint8Array = helper.decodeSync(base64)
      return uint8Array.buffer
    } catch (error) {
      console.error('Base64解码失败:', error)
      // 返回空的 ArrayBuffer
      return new ArrayBuffer(0)
    }
  }

  releaseAudioResources() {
    if (this.audioPlayer) {
      this.audioPlayer.release()
      this.audioPlayer = null
    }

    if (this.audioCapturer) {
      this.audioCapturer.release()
      this.audioCapturer = null
    }
  }

  // ==================== 文本消息发送 ====================

  sendMessage(): void {
    if (this.inputMessage.trim() === '') return

    // 停止语音识别
    this.stopVoiceRecognition()

    const userMessage: ChatMessage = {
      type: 'user',
      content: this.inputMessage
    }
    this.chatMessages.push(userMessage)

    // 发送文本到服务器
    if (this.socket) {
      this.socket.send(this.inputMessage, (err: BusinessError | undefined): void => {
        if (err) {
          console.error('发送消息失败:', err)
        } else {
          console.log('消息发送成功:', this.inputMessage)
        }
      })
    }

    this.inputMessage = ''
  }

  // ==================== UI 构建 ====================

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
        Text(this.message3)
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
      .position({ x: 0, y: 90 })
      .width('100%')
      .justifyContent(FlexAlign.Center)

      // 聊天消息列表（可选）
      if (this.chatMessages.length > 0) {
        List({ space: 10 }) {
          ForEach(this.chatMessages, (msg: ChatMessage, index: number) => {
            ListItem() {
              this.MessageBubble(msg)
            }
          })
        }
        .width('90%')
        .height('20%')
        .position({ x: '5%', y: '70%' })
        .backgroundColor('rgba(0, 0, 0, 0.3)')
        .borderRadius(12)
        .padding(10)
      }

      // 右下角按钮
      if (!this.showTextInput) {
        Column() {
          // 录音状态指示
          if (this.isRecording) {
            Row() {
              Text('🎤')
                .fontSize(20)
                .margin({ right: 8 })
              Text('正在聆听...')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .padding(10)
            .backgroundColor('rgba(255, 0, 0, 0.6)')
            .borderRadius(20)
            .margin({ bottom: 10 })
          }

          Button('文本输入')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#4A4A4A')
            .margin({ bottom: 10 })
            .onClick((): void => {
              this.showTextInput = true
              this.stopVoiceRecognition()
            })

          Button('返  回')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#4A4A4A')
            .onClick((): void => {
              router.back()
            })
        }
        .position({ x: '75%', y: '80%' })
      }

      // 底部文字输入区域
      if (this.showTextInput) {
        Column() {
          Row() {
            TextInput({
              placeholder: '请输入您的问题...',
              text: this.inputMessage
            })
              .layoutWeight(1)
              .height(45)
              .borderRadius(22.5)
              .padding({ left: 15, right: 15 })
              .backgroundColor('rgba(255, 255, 255, 0.9)')
              .onChange((value: string): void => {
                this.inputMessage = value
              })

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
              .onClick((): void => {
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

      // 文本输入模式下的右侧按钮
      if (this.showTextInput) {
        Column() {
          Button('语音交流')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#6c757d')
            .margin({ bottom: 10 })
            .onClick(() => {
              this.showTextInput = false
              this.startVoiceRecognition()
            })

          Button('返  回')
            .width(100)
            .height(40)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .borderRadius(20)
            .backgroundColor('#6c757d')
            .onClick(() => {
              router.back()
            })
        }
        .position({ x: '75%', y: '65%' })
      }
    }
    .width('100%')
    .height('100%')
  }

  // 消息气泡组件
  @Builder MessageBubble(msg: ChatMessage) {
    Row() {
      if (msg.type === 'user') {
        Blank()
      }

      Text(msg.content)
        .fontSize(14)
        .fontColor(Color.White)
        .padding(10)
        .borderRadius(8)
        .backgroundColor(
          msg.type === 'user' ? '#007AFF' :
            msg.type === 'ai' ? '#34C759' :
              '#FF9500'
        )
        .maxLines(10)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (msg.type === 'ai' || msg.type === 'system') {
        Blank()
      }
    }
    .width('100%')
  }
}
