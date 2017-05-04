//
//  ViewController.m
//  xfyunDemo
//
//  Created by zzy on 2017/4/10.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import "ViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
@interface ViewController ()<IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>{
    IFlyRecognizerView *_iflyRecognizerView;
    IFlySpeechSynthesizer *_iflySpeechSynthesizer;
    IFlySpeechRecognizer *_f;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [IFlySetting showLogcat:NO];
    _f.delegate=self;
    NSString *initString = [NSString stringWithFormat:@"appid=%@",@"58eb36f7"];
    //讯飞APPID
    [IFlySpeechUtility createUtility:initString];

    [self creatflyView];
    
    }


#pragma mark -----合成
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast;{
    NSLog(@"%@",results);
}
-(void)creatflyMsc{
    _iflySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iflySpeechSynthesizer.delegate =self;
    [IFlySetting showLogcat:NO];
    [_iflySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量
    [_iflySpeechSynthesizer setParameter:@"100" forKey:[IFlySpeechConstant VOLUME]];
    //合成语速
    [_iflySpeechSynthesizer setParameter:@"1" forKey:[IFlySpeechConstant SPEED]];
    //设置发音人
    [_iflySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    //采样率
    [_iflySpeechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //设置合成文件名(nil则不保存)
    [_iflySpeechSynthesizer setParameter:@"tta.pcm" forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
    //需要合成的话
    [_iflySpeechSynthesizer startSpeaking:@"今天，天气；晴转多云。"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
   // [_iflySpeechSynthesizer synthesize:@"今天，天气；晴转多云。" toUri:[NSString stringWithFormat:@"%@/ttt.pcm",documentsDirectory]];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[_iflySpeechSynthesizer pauseSpeaking];//暂停
    //[_iflySpeechSynthesizer resumeSpeaking];//恢复
    //[_iflySpeechSynthesizer stopSpeaking];//停止
    NSLog(@"%@",[_iflySpeechSynthesizer isSpeaking]?@"YES":@"NO");
}
//结束回调和错误代码
- (void) onCompleted:(IFlySpeechError*) error;{
    NSLog(@"======Error%d",error.errorCode);
}
//播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos;{
    NSLog(@"%d",progress);
    
}
//开始合成回调
-(void)onSpeakBegin{
    NSLog(@"开始合成");
}
//缓冲进度回调
-(void)onBufferProgress:(int)progress message:(NSString *)msg{
    NSLog(@"缓冲%d",progress);
}
//暂停播放回调
- (void) onSpeakPaused;{
    NSLog(@"我被暂停了");
}
//恢复播放回调
- (void) onSpeakResumed;{
    NSLog(@"恢复了");
}
-(void)onSpeakCancel{
    NSLog(@"正在取消");
}
- (void) onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData;{
    
}

#pragma mark -----识别 view
-(void)creatflyView{
    _iflyRecognizerView =[[IFlyRecognizerView alloc]initWithCenter:self.view.center];
    
    _iflyRecognizerView.delegate=self;
    //设置引擎参数
    [_iflyRecognizerView setParameter:@"asr" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //前端静音超时
    //[_iflyRecognizerView setParameter:@"50000" forKey:[IFlySpeechConstant VAD_BOS]];
    
    //后端静音超时
   // [_iflyRecognizerView setParameter:@"50000" forKey:[IFlySpeechConstant VAD_EOS]];
    //采样率
    [_iflyRecognizerView setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    //标点符号设置
    [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
    //返回结果类型
    [_iflyRecognizerView setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iflyRecognizerView setParameter:@"yyy.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    //设置为在线合成
    [_iflyRecognizerView setParameter:@"cloud" forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //保存到文件的名字
    [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [self.view addSubview:_iflyRecognizerView];
    
    _iflyRecognizerView.hidden=YES;
}

//回调返回识别结果
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast;
{
    //返回结果可设置为json，xml，plain，默认为json
    
    NSDictionary *resultDict = [NSDictionary dictionary];
    
    resultDict = resultArray[0];
    NSLog(@"%@",resultDict);

}

//识别结束错误码
- (void)onError: (IFlySpeechError *) error;
{
    NSLog(@"======Error:%d",error.errorType);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)speakNow:(UIButton *)sender {
    [self creatflyMsc];
    
}

- (IBAction)listenNow:(UIButton *)sender {
    _iflyRecognizerView.hidden=NO;
    NSLog(@"%@",[_iflyRecognizerView parameterForKey:[IFlySpeechConstant IFLY_DOMAIN]]);//获取引擎参数
    [_iflyRecognizerView start];

}
@end
