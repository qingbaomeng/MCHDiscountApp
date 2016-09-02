//
//  CommentStarCell.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/25.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "CommentStarCell.h"

#import "ScoreLineView.h"
#import "CommentStarFrame.h"
#import "AppCommentInfo.h"

#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(15)
#define VersionFont GetFont(12)
#define NumComFont GetFont(10)
#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define VersionColor GetColor(150,150,150,1.0)
#define ButtonBackColor GetColor(0,122,255,1.0)
#define LineColor GetColor(230,230,230,1.0)

@interface CommentStarCell(){
    
}

@property (nonatomic, weak) CWStarRateView *totalStar;
@property (nonatomic, weak) UILabel * totalStarText;
@property (nonatomic, weak) CWStarRateView *fiveStar;
@property (nonatomic, weak) ScoreLineView *fiveStarLine;
@property (nonatomic, weak) CWStarRateView *fourStar;
@property (nonatomic, weak) ScoreLineView *fourStarLine;
@property (nonatomic, weak) CWStarRateView *threeStar;
@property (nonatomic, weak) ScoreLineView *threeStarLine;
@property (nonatomic, weak) CWStarRateView *twoStar;
@property (nonatomic, weak) ScoreLineView *twoStarLine;
@property (nonatomic, weak) CWStarRateView *oneStar;
@property (nonatomic, weak) ScoreLineView *oneStarLine;
@property (nonatomic, weak) UILabel * addStarScoreText;
@property (nonatomic, weak) CWStarRateView *addStarScore;
@property (nonatomic, weak) UIButton * submitStarScore;
@property (nonatomic, weak) UIView * lineview;

@end

@implementation CommentStarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *identifer = @"commentstarlist";
    
    CommentStarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[CommentStarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        CWStarRateView *totalstar = [[CWStarRateView alloc] init];
//        [totalstar initStarConfig:StarStyle_Yellow numberOfStars:0];
        [self addSubview:totalstar];
        self.totalStar = totalstar;
        
        UILabel *lblStar = [[UILabel alloc] init];
        [lblStar setFont:VersionFont];
        [lblStar setTextColor:VersionColor];
        [lblStar setNumberOfLines:1];
//        NSString *txtInfo = [NSString stringWithFormat:@"%@%@ · %@%@", NSLocalizedString(@"VersionNumber", @""), @"", @"", NSLocalizedString(@"AppCommentScore", @"")];
//        [lblStar setText:txtInfo];
        [self addSubview:lblStar];
        self.totalStarText = lblStar;
        
        CWStarRateView *fivestar = [[CWStarRateView alloc] init];
//        [fivestar initStarConfig:StarStyle_Gray numberOfStars:0];
        [self addSubview:fivestar];
        self.fiveStar = fivestar;
        
        ScoreLineView *fivestarline = [[ScoreLineView alloc] init];
//        [fivestarline setStarNumber:0 totalstar:1];
        [self addSubview:fivestarline];
        self.fiveStarLine = fivestarline;
        
        CWStarRateView *fourstar = [[CWStarRateView alloc] init];
//        [fourstar initStarConfig:StarStyle_Gray numberOfStars:1];
        [self addSubview:fourstar];
        self.fourStar = fourstar;
        
        ScoreLineView *fourstarline = [[ScoreLineView alloc] init];
//        [fourstarline setStarNumber:0 totalstar:1];
        [self addSubview:fourstarline];
        self.fourStarLine = fourstarline;
        
        CWStarRateView *threestar = [[CWStarRateView alloc] init];
//        [threestar initStarConfig:StarStyle_Gray numberOfStars:2];
        [self addSubview:threestar];
        self.threeStar = threestar;
        
        ScoreLineView *threestarline = [[ScoreLineView alloc] init];
//        [threestarline setStarNumber:0 totalstar:1];
        [self addSubview:threestarline];
        self.threeStarLine = threestarline;
        
        CWStarRateView *twostar = [[CWStarRateView alloc] init];
//        [twostar initStarConfig:StarStyle_Gray numberOfStars:3];
        [self addSubview:twostar];
        self.twoStar = twostar;
        
        ScoreLineView *twostarline = [[ScoreLineView alloc] init];
//        [twostarline setStarNumber:0 totalstar:1];
        [self addSubview:twostarline];
        self.twoStarLine = twostarline;
        
        CWStarRateView *onestar = [[CWStarRateView alloc] init];
//        [onestar initStarConfig:StarStyle_Gray numberOfStars:0];
        [self addSubview:onestar];
        self.oneStar = onestar;
        
        ScoreLineView *onestarline = [[ScoreLineView alloc] init];
//        [onestarline setStarNumber:0 totalstar:1];
        [self addSubview:onestarline];
        self.oneStarLine = onestarline;
        
        UILabel *lbladdStarScore = [[UILabel alloc] init];
        [lbladdStarScore setText:NSLocalizedString(@"StarComment", @"")];
        [lbladdStarScore setFont:NumComFont];
        [lbladdStarScore setTextColor:VersionColor];
        [self addSubview:lbladdStarScore];
        self.addStarScoreText = lbladdStarScore;
        
        CWStarRateView *addstarscore = [[CWStarRateView alloc] init];
//        [addstarscore initStarConfig:StarStyle_Blue numberOfStars:5];
        [addstarscore setAllowTouch:YES];
        addstarscore.delegate = self;
        [self addSubview:addstarscore];
        self.addStarScore = addstarscore;
        
        UIButton *submitStarComment = [[UIButton alloc] init];
        submitStarComment.layer.cornerRadius = 5;
        [submitStarComment setBackgroundColor:ButtonBackColor];
        [submitStarComment setTitle:NSLocalizedString(@"ButtonSaveText", @"") forState:UIControlStateNormal];
        [submitStarComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitStarComment.titleLabel.font = TitleFont;
//        [submitStarComment addTarget:self action:@selector(submitStarNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submitStarComment];
        self.submitStarScore = submitStarComment;
        
        UIView *scrollLine = [[UIView alloc] init];
        [scrollLine setBackgroundColor:LineColor];
        [self addSubview:scrollLine];
        self.lineview = scrollLine;
        
        
    }
    return self;
}

-(void) setStarFrame:(CommentStarFrame *)starFrame {
    _starFrame = starFrame;
    
    [self setSubViewFrame];
    [self setSubViewData];
    
}

-(void) setSubViewData{
    AppCommentInfo *commentInfo = self.starFrame.commentInfo;
    
    [self.totalStar initStarConfig:StarStyle_Yellow numberOfStars:commentInfo.averagestar];
    
    [self.fiveStar initStarConfig:StarStyle_Gray numberOfStars:0];
    [self.fourStar initStarConfig:StarStyle_Gray numberOfStars:1];
    [self.threeStar initStarConfig:StarStyle_Gray numberOfStars:2];
    [self.twoStar initStarConfig:StarStyle_Gray numberOfStars:3];
    [self.oneStar initStarConfig:StarStyle_Gray numberOfStars:4];
    
    NSLog(@"fivestar:%d, totalstar:%d", commentInfo.fivestar, commentInfo.totalstar);
    
    [self.fiveStarLine setStarNumber:commentInfo.fivestar totalstar:commentInfo.totalstar];
    [self.fourStarLine setStarNumber:commentInfo.fourstar totalstar:commentInfo.totalstar];
    [self.threeStarLine setStarNumber:commentInfo.threestar totalstar:commentInfo.totalstar];
    [self.twoStarLine setStarNumber:commentInfo.twostar totalstar:commentInfo.totalstar];
    [self.oneStarLine setStarNumber:commentInfo.onestar totalstar:commentInfo.totalstar];
    
    [self.addStarScore initStarConfig:StarStyle_Yellow numberOfStars:5];
    
    
}

-(void) setSubViewFrame{
    
    self.totalStar.frame = self.starFrame.totalStarFrame;
    self.totalStarText.frame = self.starFrame.totalStarFrame;
    self.fiveStar.frame = self.starFrame.fiveStarFrame;
//    NSLog(@"Frame:%@", NSStringFromCGRect(self.starFrame.fiveStarLineFrame));
//    self.fiveStarLine.frame = self.starFrame.fiveStarLineFrame;
    [self.fiveStarLine setFrame:self.starFrame.fiveStarLineFrame];
    self.fourStar.frame = self.starFrame.fourStarFrame;
    self.fourStarLine.frame = self.starFrame.fourStarLineFrame;
    self.threeStar.frame = self.starFrame.threeStarFrame;
    self.threeStarLine.frame = self.starFrame.threeStarLineFrame;
    self.twoStar.frame = self.starFrame.twoStarFrame;
    self.twoStarLine.frame = self.starFrame.twoStarLineFrame;
    self.oneStar.frame = self.starFrame.oneStarFrame;
    self.oneStarLine.frame = self.starFrame.oneStarLineFrame;
    self.addStarScoreText.frame = self.starFrame.addStarScoreTextFrame;
    self.addStarScore.frame = self.starFrame.addStarScoreFrame;
    self.submitStarScore.frame = self.starFrame.submitStarScoreFrame;
    self.lineview.frame = self.starFrame.lineFrame;
    
}

#pragma CWStarRateViewdelegate

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
}

- (void) currentSelectStarIndex:(NSInteger)index{
//    NSInteger selectStar = index;
}


@end
