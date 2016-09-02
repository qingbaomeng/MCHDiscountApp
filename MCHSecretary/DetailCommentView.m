//
//  DetailCommentView.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/19.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "DetailCommentView.h"

#import "CurrentAppUtils.h"
#import "ScoreLineView.h"
#import "TitleHeaderView.h"

#import "UserCommentRequest.h"
#import "AppCommentInfo.h"

#import "CommentCell.h"
#import "CommentFrame.h"
#import "CommentStarCell.h"
#import "CommentStarFrame.h"

#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define GetFont(s) [UIFont systemFontOfSize:s]
#define TitleFont GetFont(15)
#define VersionFont GetFont(12)
#define NumComFont GetFont(10)
#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define VersionColor GetColor(150,150,150,1.0)
#define ButtonBackColor GetColor(0,122,255,1.0)
#define LineColor GetColor(230,230,230,1.0)

@interface DetailCommentView(){
    UILabel *lblStar;
    UITableView *commentTable;
    
    CGFloat starAreaY;
    
    ScoreLineView *fiveStarLine;
    ScoreLineView *fourStarLine;
    ScoreLineView *threeStarLine;
    ScoreLineView *twoStarLine;
    ScoreLineView *oneStarLine;
    
    
    CommentStarFrame * startFrame;
}

@end

@implementation DetailCommentView

-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initData];
        
//        [self initSubView];
        
//        CGFloat tableY = CGRectGetMaxY(lblcomPoint.frame) + padding;
        commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [commentTable setBackgroundColor:[UIColor whiteColor]];
        commentTable.separatorStyle = UITableViewCellSelectionStyleNone;
        commentTable.delegate = self;
        commentTable.dataSource = self;
        
        [self addSubview:commentTable];
        
    }
    return self;
}

-(void) initData{
    selectStar = 0;
    commentArray = [[NSArray alloc] init];
    
    startFrame = [[CommentStarFrame alloc] init];
    [startFrame setCommentInfo:[[AppCommentInfo alloc] init]];
    
}

-(void) initSubView{
    int padding = 15;
    UIImageView *ivPoint = [[UIImageView alloc] initWithFrame:CGRectMake(5, padding + 5, 5, 5)];
    [ivPoint setImage:[UIImage imageNamed:@"signpoint.png"]];
    [self addSubview:ivPoint];
    
    UILabel *lblDescribe = [[UILabel alloc] init];
    [lblDescribe setFrame:CGRectMake(15, padding, 100, 15)];
    [lblDescribe setFont:TitleFont];
    [lblDescribe setTextColor:[UIColor blackColor]];
    [lblDescribe setNumberOfLines:1];
    [lblDescribe setText:NSLocalizedString(@"CurrentComment", @"")];
    [self addSubview:lblDescribe];
    
    CGFloat starY = CGRectGetMaxY(lblDescribe.frame) + padding - 5;
    
    CWStarRateView *fixStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(15, starY + 2, 60, 8)];
    [fixStar initStarConfig:StarStyle_Yellow numberOfStars:2];
//    [fixStar setScorePercent:1];
    [self addSubview:fixStar];
    
    CGFloat totalCommentX = CGRectGetMaxX(fixStar.frame) + padding;
    lblStar = [[UILabel alloc] init];
    [lblStar setFrame:CGRectMake(totalCommentX, starY, kScreenWidth - totalCommentX, 12)];
    [lblStar setFont:VersionFont];
    [lblStar setTextColor:VersionColor];
    [lblStar setNumberOfLines:1];
    NSString *txtInfo = [NSString stringWithFormat:@"%@%@ · %@%@", NSLocalizedString(@"VersionNumber", @""), @"", @"", NSLocalizedString(@"AppCommentScore", @"")];
    [lblStar setText:txtInfo];
    [self addSubview:lblStar];
    
    starAreaY = CGRectGetMaxY(lblStar.frame) + padding - 5;
    [self addStarArea:starAreaY totalstar:1 fivestar:0 fourstar:0 threestar:0 twostar:0 onestar:0];
    
    CGFloat lblCommentStarY = starAreaY + 5 * 12 + padding;
    CGFloat lblCommentStarW = kScreenWidth - 15;
    UILabel *lblCommentStar = [[UILabel alloc] initWithFrame:CGRectMake(15, lblCommentStarY, lblCommentStarW, 10)];
    [lblCommentStar setText:NSLocalizedString(@"StarComment", @"")];
    [lblCommentStar setFont:NumComFont];
    [lblCommentStar setTextColor:VersionColor];
    
    [self addSubview:lblCommentStar];
    
    CGFloat clickStarY = CGRectGetMaxY(lblCommentStar.frame) + 10;
    CGFloat clickStarW = lblCommentStarW - 80;
    CWStarRateView *clickStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(15, clickStarY, clickStarW, 20)];
    [clickStar initStarConfig:StarStyle_Blue numberOfStars:5];
    [clickStar setAllowTouch:YES];
    clickStar.delegate = self;
    
    [self addSubview:clickStar];
    
    CGFloat submitX = CGRectGetMaxX(clickStar.frame);
    UIButton *submitStarComment = [[UIButton alloc] initWithFrame:CGRectMake(submitX, clickStarY - 5, 55, 30)];
    submitStarComment.layer.cornerRadius = 5;
    [submitStarComment setBackgroundColor:ButtonBackColor];
    [submitStarComment setTitle:NSLocalizedString(@"ButtonSaveText", @"") forState:UIControlStateNormal];
    [submitStarComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitStarComment.titleLabel.font = TitleFont;
    [submitStarComment addTarget:self action:@selector(submitStarNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:submitStarComment];
    
    CGFloat sLineY = CGRectGetMaxY(submitStarComment.frame) + 5;
    UIView *scrollLine = [[UIView alloc] initWithFrame:CGRectMake(0, sLineY, kScreenWidth, 1)];
    [scrollLine setBackgroundColor:LineColor];
    [self addSubview:scrollLine];
    
    //评论
    CGFloat comPointY = CGRectGetMaxY(scrollLine.frame) + padding;
    UIImageView *ivComPoint = [[UIImageView alloc] initWithFrame:CGRectMake(5, comPointY + 7, 5, 5)];
    [ivComPoint setImage:[UIImage imageNamed:@"signpoint.png"]];
    [self addSubview:ivComPoint];
    
    UILabel *lblcomPoint = [[UILabel alloc] init];
    [lblcomPoint setFrame:CGRectMake(15, comPointY, kScreenWidth - 15, 15)];
    [lblcomPoint setFont:TitleFont];
    [lblcomPoint setTextColor:[UIColor blackColor]];
    [lblcomPoint setNumberOfLines:1];
    NSString *totalComment = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"AppCommentTotalPre", @""), @"10", NSLocalizedString(@"AppCommentTotal", @"")];
    [lblcomPoint setText:totalComment];
    [self addSubview:lblcomPoint];
    
    
    CGFloat tableY = CGRectGetMaxY(lblcomPoint.frame) + padding;
    commentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, kScreenWidth, kScreenHeight)];
    [commentTable setBackgroundColor:[UIColor whiteColor]];
    commentTable.separatorStyle = UITableViewCellSelectionStyleNone;
    commentTable.delegate = self;
    commentTable.dataSource = self;
    
    [self addSubview:commentTable];
    
}

-(void) addStarArea:(CGFloat)startY totalstar:(int)totalstar fivestar:(int)fivestar fourstar:(int)fourstar threestar:(int)threestar twostar:(int)twostar onestar:(int)onestar{
    
    for (NSInteger i = 0; i < 5; i++) {
        CWStarRateView *star = [[CWStarRateView alloc] initWithFrame:CGRectMake(15, startY + 12 * i, 60, 8)];
        [star initStarConfig:StarStyle_Gray numberOfStars:i];
        
        [self addSubview:star];
    }
    
    fiveStarLine = [[ScoreLineView alloc] initWithFrame:CGRectMake(90, startY, kScreenWidth - 110, 10)];
    [fiveStarLine setStarNumber:fivestar totalstar:totalstar];
    [self addSubview:fiveStarLine];
    
    fourStarLine = [[ScoreLineView alloc] initWithFrame:CGRectMake(90, startY + 12 * 1, kScreenWidth - 110, 10)];
    [fourStarLine setStarNumber:fourstar totalstar:totalstar];
    [self addSubview:fourStarLine];
    
    threeStarLine = [[ScoreLineView alloc] initWithFrame:CGRectMake(90, startY + 12 * 2, kScreenWidth - 110, 10)];
    [threeStarLine setStarNumber:threestar totalstar:totalstar];
    [self addSubview:threeStarLine];
    
    twoStarLine = [[ScoreLineView alloc] initWithFrame:CGRectMake(90, startY + 12 * 3, kScreenWidth - 110, 10)];
    [twoStarLine setStarNumber:twostar totalstar:totalstar];
    [self addSubview:twoStarLine];
    
    oneStarLine = [[ScoreLineView alloc] initWithFrame:CGRectMake(90, startY + 12 * 4, kScreenWidth - 110, 10)];
    [oneStarLine setStarNumber:onestar totalstar:totalstar];
    [self addSubview:oneStarLine];
    
}

-(void) submitStarNumber:(UIButton *)sender{
    if(selectStar != 0){
        NSLog(@"DetailCommentView:%ld", selectStar);
    }
}

-(void) requestAppComment{
    UserCommentRequest *commentRequest = [[UserCommentRequest alloc] init];
    [commentRequest commentInfo:^(AppCommentInfo *commentinfo) {
        [self initCommentView:commentinfo];
        
    } failure:^(NSURLResponse *response, NSError *error, NSDictionary *dic) {
        
    }];
    
}

-(void) initCommentView:(AppCommentInfo *)commentInfo{
    NSString *txtInfo = [NSString stringWithFormat:@"%@%@ · %d%@", NSLocalizedString(@"VersionNumber", @""), commentInfo.version, commentInfo.totalstar, NSLocalizedString(@"AppCommentScore", @"")];
    [lblStar setText:txtInfo];
    
    [fiveStarLine setStarNumber:commentInfo.fivestar totalstar:commentInfo.totalstar];
    [fourStarLine setStarNumber:commentInfo.fourstar totalstar:commentInfo.totalstar];
    [threeStarLine setStarNumber:commentInfo.threestar totalstar:commentInfo.totalstar];
    [twoStarLine setStarNumber:commentInfo.twostar totalstar:commentInfo.totalstar];
    [oneStarLine setStarNumber:commentInfo.onestar totalstar:commentInfo.totalstar];
    
    commentArray = commentInfo.commentArray;
    if(commentTable){
        [commentTable reloadData];
    }
}

#pragma UITableViewdelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    NSLog(@"count:%lu", (unsigned long)commentArray.count);
    return commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CommentStarCell *starcell = [CommentStarCell cellWithTableView:tableView];
        starcell.starFrame = startFrame;
        
        return starcell;
    }else{
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.commentFrame = commentArray[indexPath.row];
        
        return cell;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return startFrame.cellHeight;
    }else{
        CommentFrame *commentFrame = commentArray[indexPath.row];
        return commentFrame.cellHeight;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TitleHeaderView *titleView = [TitleHeaderView headerWithTableView:tableView];
    
    NSString *titel = @"";
    if(section == 0){
        titel = NSLocalizedString(@"CurrentComment", @"");
    }else{
        titel = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"AppCommentTotalPre", @""), @"10", NSLocalizedString(@"AppCommentTotal", @"")];
    }
    [titleView setTitleContent:titel];
    return titleView;
}

#pragma CWStarRateViewdelegate

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
}

- (void) currentSelectStarIndex:(NSInteger)index{
    selectStar = index;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
