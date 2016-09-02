//
//  ScoreLineView.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/23.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "ScoreLineView.h"

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BottmColor GetColor(210,210,210,1.0)
#define TopColor GetColor(110,110,110,1.0)
#define VersionColor GetColor(150,150,150,1.0)
#define GetFont(s) [UIFont systemFontOfSize:s]
#define NumComFont GetFont(10)

@interface ScoreLineView(){
    UIView *bottomView;
    
    int currentStar;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *lblNum;

@end

@implementation ScoreLineView

#pragma mark - Init Methods
- (instancetype)init {
//    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    if(self = [super init]){
        _score = 0;
    }
    return self;
}

//-(instancetype) initWithFrame:(CGRect)frame{
//    if(self = [super initWithFrame:frame]){
////        [self initLineView];
//    }
//    return self;
//}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
//    NSLog(@"Frame:%@", NSStringFromCGRect(self.frame));
    CGFloat w = self.frame.size.width;
    if(w != 0){
        [self initLineView];
    }
    
}

-(void)initLineView{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    currentStar = 0;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, self.bounds.size.width, 2)];
    [bottomView setBackgroundColor:BottmColor];
    [self addSubview:bottomView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 0, 2)];
    [self.topView setBackgroundColor:TopColor];
    [self addSubview:self.topView];
    
    CGFloat numX = CGRectGetMaxX(bottomView.frame) + 4;
    self.lblNum = [[UILabel alloc] initWithFrame:CGRectMake(numX, 0, 45, 10)];
    [self.lblNum setText:[NSString stringWithFormat:@"%d", currentStar]];
    [self.lblNum setFont:NumComFont];
    [self.lblNum setTextColor:VersionColor];
    
    [self addSubview:self.lblNum];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak ScoreLineView *weakSelf = self;
//    weakSelf.topView.frame = CGRectMake(0, 4, weakSelf.bounds.size.width * weakSelf.score, 2);
    
    [weakSelf.lblNum setText:[NSString stringWithFormat:@"%d", currentStar]];
    
//    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    if(_score <= 0){
        return;
    }
    [UIView animateWithDuration:1 animations:^{
        
        weakSelf.topView.frame = CGRectMake(0, 4, weakSelf.bounds.size.width * _score, 2);
    }];
}


-(void) setScore:(float)score{
    if(score == _score){
        return;
    }
    if(score < 0){
        _score = 0;
    }else if(score >= 1){
        _score = 1;
    }else{
        _score = score;
    }
    
    [self setNeedsLayout];
}

-(void) setStarNumber:(int)curstar totalstar:(int)totalstar{
    float curScore = (float) curstar / (float) totalstar;
    if(curScore == _score){
        return;
    }
    currentStar = curstar;
    
    if(curScore < 0){
        _score = 0;
    }else if(curScore >= 1){
        _score = 1;
    }else{
        _score = curScore;
    }
    NSLog(@"Frame11111:%@", NSStringFromCGRect(self.frame));
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
