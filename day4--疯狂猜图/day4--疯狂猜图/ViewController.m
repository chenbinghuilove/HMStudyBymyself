//
//  ViewController.m
//  day4--疯狂猜图
//
//  Created by chen on 15/6/24.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak) IBOutlet UIButton *iconButton;
@property (nonatomic,assign) CGFloat xFont;
@property (nonatomic,assign) CGFloat yFont;

@property (nonatomic,strong) UIButton *conver;
@property (nonatomic,strong) NSArray *question;
@property (weak, nonatomic) IBOutlet UILabel *numTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentTitel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
//题目索引
@property (nonatomic,assign) int index;
@end

#define kButtonWidth 35
#define kButtonHeight 35
#define kButtonMargin 10
#define kTotolCol 7
@implementation ViewController
-(NSArray *)question{
    if (_question==nil) {
        _question=[Question questions];
    }
    return _question;
}
-(UIButton *)conver{
    if (_conver==nil) {
        _conver=[[UIButton alloc] initWithFrame:self.view.bounds];
        _conver.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
        [self.view addSubview:_conver];
        
        _conver.alpha=0.0;
        
        [_conver addTarget:self action:@selector(bigImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conver;
}
//块代码方法体
-(void)blockAction{
    NSArray *array=@[@(1),@(4),@(5),@(8)];
    for (NSNumber *num in array) {
        NSLog(@"%@",num);
    }
    //推荐使用块代码进行输出，效率很高
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx==2) {
            *stop=YES;
        }
        NSLog(@"%@",obj);
    }];
}
//块代码排序
-(void)blockSort{
    NSArray *array=@[@(5),@(4),@(3),@(8),@(6)];
    array=[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //升序排列
        //return [obj1 compare:obj2];
        //降序排列
        //return [obj2 compare:obj1];
        //乱序排序
        //arc4random_uniform(10) ==>0~9之间的随机数
        int seed=arc4random_uniform(2);
        if (seed) {
            return [obj1 compare:obj2];
        }else{
            return [obj2 compare:obj1];
        }
    }];
    NSLog(@"%@",array);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self blockAction];
    //[self blockSort];
   // NSLog(@"%@",[Question questions]);//[Question questions];
    // Do any additional setup after loading the view, typically from a nib.
    self.index=-1;
    [self nextQuestion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 UIStatusBarStyleDefault 暗色                                    = 0, // Dark content, for use on light backgrounds
 UIStatusBarStyleLightContent 亮色
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/**
 改变图片大小
 1.添加一个蒙版
 2.将图片按钮弄到最前面
 3.动画放大图片
 */
#pragma mark - 图片切换
- (IBAction)bigImage {
    //1.添加一个蒙版（遮罩）
//    UIButton *conver=[[UIButton alloc] initWithFrame:self.view.bounds];
//    conver.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
//    [self.view addSubview:conver];
//    
//    conver.alpha=0.0;
//    
//    [conver addTarget:self action:@selector(smallImage:) forControlEvents:UIControlEventTouchUpInside];
    if (self.conver.alpha==0.0) {
        //[self conver];
        //2.将图像按钮弄到最前面
        //bringSubviewToFront将视图前置
        [self.view bringSubviewToFront:self.iconButton];
        self.xFont=self.iconButton.frame.origin.x;
        self.yFont=self.iconButton.frame.origin.y;
        //3.动画放大图片
        CGFloat w=self.view.bounds.size.width;
        CGFloat h=w;
        CGFloat y=(self.view.bounds.size.height-h)*0.5;
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame=CGRectMake(0, y, w, h);
            _conver.alpha=1.0;
        }];
    }else{
        [UIView animateWithDuration:1.0f animations:^{
            self.iconButton.frame=CGRectMake(self.xFont,self.yFont, 160, 160);
            self.conver.alpha=0.0;
        }];
    }
    
}
#pragma mark - 设置基本信息
/**
 设置基本信息
 */
-(void)setBasicInfo:(Question *)question{
    self.numTitle.text=[NSString stringWithFormat:@"%d/%lu",self.index+1,self.question.count];
    self.contentTitel.text=question.title;
    [self.iconButton setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    self.nextButton.enabled=(self.index<self.question.count-1);
}
#pragma mark - 设置答案按钮信息
/**
 设置答案按钮信息
 */
-(void)setAnswerInfo:(Question *)question{
    for (UIButton *btn in self.answerView.subviews) {
        [btn removeFromSuperview];
    }
    //设置答案按钮
    CGFloat answerW=self.answerView.bounds.size.width;
    int answerLength=question.answer.length;
    CGFloat answerX=(answerW-kButtonWidth*answerLength-kButtonMargin*(answerLength-1))*0.5;
    for (int i=0; i<answerLength; i++) {
        CGFloat x=answerX+i*(kButtonMargin+kButtonWidth);
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(x, 0, kButtonWidth, kButtonHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [self.answerView addSubview:btn];
        [btn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - 设置备选区按钮信息
/**
 设置备选区按钮信息
 */
-(void)setOptionInfo:(Question *)question{
    for (UIButton *btn in self.optionView.subviews) {
        [btn removeFromSuperview];
    }
    //设置备选区按钮
    //9宫格画图
    CGFloat optionW=self.optionView.bounds.size.width;
    CGFloat optionX=(optionW-kTotolCol*kButtonWidth-kButtonMargin*(kTotolCol-1))*0.5;
    for (int i=0; i<question.options.count; i++) {
        //row
        int row=i/kTotolCol;
        //col
        int col=i%kTotolCol;
        CGFloat x=optionX+col*(kButtonMargin+kButtonWidth);
        CGFloat y=row*(kButtonHeight+kButtonMargin);
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, kButtonWidth, kButtonHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitle:question.options[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.optionView addSubview:btn];
        [btn addTarget:self action:@selector(clickOption:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
#pragma mark - 下一题
/**
 下一题动作
 1.当前答题的索引，索引递增。
 2.数组中按照索引引出题目模型数据
 3.设置基本信息
 4.设置答案按钮
 5.设置备选区按钮
 */
-(IBAction)nextQuestion{
    //1.当前答题的索引，索引递增
    self.index++;
    if (self.index==self.question.count) {
        NSLog(@"通过了");
        return;
    }
    //2.从数组中按照索引取出题目模型数据
    Question *question=self.question[self.index];
    //3.设置基本信息，设置答案按钮，设置按钮
    [self setBasicInfo:question];
    //首先清除掉答案区的所有按钮
    [self setAnswerInfo:question];
    //设置被选区按钮
    //首先删除备选区的所有过期按钮
    [self setOptionInfo:question];
}
/**
 备选区按钮点击操作
 */
-(void)clickOption:(UIButton *)button{
    //1.找到答案区没有填值的按钮
    UIButton *btn=[self firstAnswerButton];
    if (btn==nil)return;
    //2.将备选区的按钮title赋值给答案区按钮
    [btn setTitle:button.currentTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //3.将备选区的按钮隐藏
    button.hidden=YES;
    //4.判断答案是否正确，
    [self judge];
}
-(UIButton *)firstAnswerButton{
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            return btn;
        }
    }
    return nil;
}
-(void)judge{
    //1.判断如果所有的按钮有值，才需要判断结果
    //2.设置一个标志位来进行判断
    BOOL isFull=YES;
    //3.需要一个可变长度的string字符来存放字符串信息
    NSMutableString *strM=[NSMutableString string];
    for (UIButton *btn in self.answerView.subviews) {
        if (btn.currentTitle.length==0) {
            isFull=NO;
            break;
        }else{
            [strM appendString:btn.currentTitle];
        }
    }
    if (isFull) {
        NSLog(@"都有字了");
        //判断是否和答案一致
        Question *question=self.question[self.index];
        if ([strM isEqualToString:question.answer]) {
            NSLog(@"答对了");
            [self setAnswerButtonsColor:[UIColor blueColor]];
            [self performSelector:@selector(nextQuestion) withObject:nil afterDelay:0.5];
            [self changeSore:1000];
        }else{
            NSLog(@"打错了");
            [self setAnswerButtonsColor:[UIColor redColor]];
        }
    }
}
-(void)setAnswerButtonsColor:(UIColor *)color{
    for (UIButton *btn in self.answerView.subviews) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
-(void)answerClick:(UIButton *)button{
    if (button.currentTitle.length==0) return;
    //1.如果有文字，清除文字，在候选区显示
    UIButton *btn=[self optionButtonWithTitle:button.currentTitle];
    //2.显示对应按钮
    btn.hidden=NO;
    //3.清除button的文字
    [button setTitle:@"" forState:UIControlStateNormal];
    //4.设置答案区的按钮颜色
    [self setAnswerButtonsColor:[UIColor blackColor]];
}
-(UIButton *)optionButtonWithTitle:(NSString *)title{
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:title]) {
            return btn;
        }
    }
    return nil;
}
-(IBAction)tipButtonClick{
    //1.把答题区中所有的按钮清空
    for (UIButton *btn in self.answerView.subviews) {
        [self answerClick:btn];
    }
    Question *question=self.question[self.index];
    NSString *firstAnswer=[question.answer substringToIndex:1];
    //NSLog(@"%@,%d",[question.answer substringToIndex:1],self.index);
    //2.把正确的第一个字，设置到答题区中
    for (UIButton *btn in self.optionView.subviews) {
        if ([btn.currentTitle isEqualToString:firstAnswer]) {
            [self clickOption:btn];
        }
    }
    [self changeSore:-1000];
    //3.扣分
    
}
#pragma mark - 分数处理
-(void)changeSore:(int)score{
    //取出当前的分数
    int currentScore=self.scoreButton.currentTitle.intValue;
    //使用score调整分数
    currentScore+=score;
    //重置设置分数
    [self.scoreButton setTitle:[NSString stringWithFormat:@"%d",currentScore] forState:UIControlStateNormal];
}
@end
