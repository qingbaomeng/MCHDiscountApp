//
//  CommentCell.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/8/24.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "CommentCell.h"
#import "CommentFrame.h"
#import "UserComment.h"

#import "WebImage.h"

#define NameFont [UIFont systemFontOfSize:13]
#define TimeFont [UIFont systemFontOfSize:10]
#define ContentFont [UIFont systemFontOfSize:16]
#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define NickNameColor GetColor(0,122,255,1.0)
#define TimeColor GetColor(200,200,200,1.0)
#define ContentColor GetColor(100,100,100,1.0)
#define LineColor GetColor(230,230,230,1.0)

@interface CommentCell(){
    
}

@property (nonatomic, weak) UIImageView * ivHeader;
@property (nonatomic, weak) UILabel * lblNickName;
@property (nonatomic, weak) UILabel * lblCommentTime;
@property (nonatomic, weak) UILabel * lblContent;
@property (nonatomic, weak) UIButton * btnCommnet;
@property (nonatomic, weak) UIView * lineview;

@end


@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *identifer = @"commentlist";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.layer.cornerRadius = 30;
//        icon.layer.borderWidth = 0.5;
//        icon.layer.borderColor = [LineColor CGColor];
        [self.contentView addSubview:icon];
        self.ivHeader = icon;
        
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.font = NameFont;
        nicknameLabel.textColor = NickNameColor;
        nicknameLabel.numberOfLines = 1;
        [self.contentView addSubview:nicknameLabel];
        self.lblNickName = nicknameLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = TimeFont;
        timeLabel.textColor = TimeColor;
        timeLabel.numberOfLines = 1;
        [self.contentView addSubview:timeLabel];
        self.lblCommentTime = timeLabel;
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = ContentFont;
        contentLabel.textColor = ContentColor;
        contentLabel.numberOfLines = 1;
        [self.contentView addSubview:contentLabel];
        self.lblContent = contentLabel;
        
        UIButton *btndown = [[UIButton alloc] init];
        [self.contentView addSubview:btndown];
        self.btnCommnet = btndown;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self.contentView addSubview:line];
        self.lineview = line;
        
    }
    return self;
}

-(void) setCommentFrame:(CommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    
    [self setSubViewData];
    [self setSubViewFrame];
}


-(void) setSubViewData{
    UserComment *comment = self.commentFrame.commentInfo;
    [self.ivHeader sd_setImageWithURL:[NSURL URLWithString:comment.headerImage] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    [self.lblNickName setText:comment.nikeName];
    [self.lblCommentTime setText:comment.createtime];
    [self.lblContent setText:comment.content];
    
    [self.btnCommnet setBackgroundImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
    
}

-(void) setSubViewFrame{
    self.ivHeader.frame = self.commentFrame.imageFrame;
    self.lblNickName.frame = self.commentFrame.nickNameFrame;
    self.lblCommentTime.frame = self.commentFrame.timeFrame;
    self.lblContent.frame = self.commentFrame.contentFrame;
    self.btnCommnet.frame = self.commentFrame.replyBtnFrame;
    self.lineview.frame = self.commentFrame.lineFrame;

}

@end
