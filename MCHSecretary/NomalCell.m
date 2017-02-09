//
//  NomalCell.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "NomalCell.h"

#import "OpenServerEntity.h"
#import "HomeGameInfo.h"
#import "NomalFrame.h"
#import "WebImage.h"
#import "StringUtils.h"

#define GetFont(s) [UIFont systemFontOfSize:s]
#define ServerFont GetFont(10)
#define NameFont [UIFont systemFontOfSize:15]
#define MiddleFont [UIFont systemFontOfSize:10]
#define DescribeFont [UIFont systemFontOfSize:12]
#define LineColor [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]
#define MiddleTextColor [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1.0]
#define DescribeColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1.0]

@interface NomalCell(){
    NSInteger currentSection;
}

@property (nonatomic, weak) UIImageView * ivAppIcon;
@property (nonatomic, weak) UILabel * lblName;
@property (nonatomic, weak) UILabel * lblMiddle;
@property (nonatomic, weak) UILabel * lblDescribe;
@property (nonatomic, weak) UIButton * btnDiscount;
@property (nonatomic, weak) UIButton * btnDownload;
@property (nonatomic, weak) UIButton * btnDownloadText;
@property (nonatomic, weak) UIView * lineview;

//开服
@property(nonatomic,weak)UILabel *timeLab;

@end



@implementation NomalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *identifer = @"nomallist";
    
    NomalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[NomalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImageView *icon = [[UIImageView alloc] init];
        icon.layer.cornerRadius = 13;
        icon.layer.borderWidth = 0.5;
        icon.layer.borderColor = [LineColor CGColor];
        [self.contentView addSubview:icon];
        self.ivAppIcon = icon;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NameFont;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.numberOfLines = 1;
        [self.contentView addSubview:nameLabel];
        self.lblName = nameLabel;
        
        UILabel *middleLabel = [[UILabel alloc] init];
        middleLabel.font = MiddleFont;
        middleLabel.textColor = MiddleTextColor;
        middleLabel.numberOfLines = 1;
        [self.contentView addSubview:middleLabel];
        self.lblMiddle = middleLabel;
        
        UIButton *discount = [[UIButton alloc] init];
        [discount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        discount.titleLabel.font = ServerFont;
        [discount setBackgroundImage:[UIImage imageNamed:@"discount.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:discount];
        self.btnDiscount = discount;
        
        UILabel *describeLabel = [[UILabel alloc] init];
        describeLabel.font = DescribeFont;
        describeLabel.textColor = DescribeColor;
        describeLabel.numberOfLines = 1;
        [self.contentView addSubview:describeLabel];
        self.lblDescribe = describeLabel;
        
        UIButton *btndown = [[UIButton alloc] init];
        [self.contentView addSubview:btndown];
        self.btnDownload = btndown;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self.contentView addSubview:line];
        self.lineview = line;
        
        //开服时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = MiddleFont;
        timeLabel.textColor = MiddleTextColor;
        timeLabel.numberOfLines = 1;
        [self.contentView addSubview:timeLabel];
        self.timeLab = timeLabel;;
    }
    return self;
}

-(void) setNomalFrame:(NomalFrame *)nomalFrame section:(NSInteger)section pos:(NSInteger)index{
    _nomalFrame = nomalFrame;
    
    [self setSubViewData:section pos:index];
    [self setSubViewFrame];
}

-(void) setSubViewData:(NSInteger)section pos:(NSInteger)index{
    
    HomeGameInfo * packInfo = self.nomalFrame.packetInfo;

    currentSection = section;
    
    [self.ivAppIcon sd_setImageWithURL:[NSURL URLWithString:packInfo.gameIconUrl] placeholderImage:[UIImage imageNamed:@"load_fail"]];
    
    self.lblName.text = packInfo.gameName;
    
    NSString *middleTxt = @"";
    if(![StringUtils isBlankString:packInfo.packetSize]){
        middleTxt = [middleTxt stringByAppendingString:[NSString stringWithFormat:@"%@", packInfo.packetSize]];
    }
    if(![StringUtils isBlankString:packInfo.packetSize] &&
       ![StringUtils isBlankString:packInfo.game_type_name]){
        middleTxt = [middleTxt stringByAppendingString:@" | "];
    }
    if(![StringUtils isBlankString:packInfo.game_type_name]){
        middleTxt = [middleTxt stringByAppendingString:packInfo.game_type_name];
    }
    self.lblMiddle.text = middleTxt;
    
    self.lblDescribe.text = packInfo.introduction;
    
    [self.btnDownload setBackgroundImage:[UIImage imageNamed:@"appinstall"] forState:UIControlStateNormal];
    self.btnDownload.tag = index;
    [self.btnDownload addTarget:self action:@selector(downloadApp:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([StringUtils isBlankString:packInfo.appDiscount]) {
        [self.btnDiscount setHidden:YES];
    }
    else if ([packInfo.appDiscount floatValue] > 0 || [packInfo.appDiscount floatValue]<10)
    {
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", packInfo.appDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [self.btnDiscount setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    else{
        [self.btnDiscount setHidden:YES];
    }
}

-(void) setSubViewFrame{
    self.ivAppIcon.frame = self.nomalFrame.imageFrame;
    self.lblName.frame = self.nomalFrame.nameFrame;
    self.lblMiddle.frame = self.nomalFrame.middleFrame;
    self.lblDescribe.frame = self.nomalFrame.describeFrame;
    self.btnDiscount.frame = self.nomalFrame.discountFrame;
    self.btnDownload.frame = self.nomalFrame.downloadFrame;
    self.btnDownloadText.frame = self.nomalFrame.downloadTextFrame;
    self.lineview.frame = self.nomalFrame.lineFrame;
    
    self.timeLab.frame = self.nomalFrame.middleFrame;
}

-(void) downloadApp:(UIButton *)sender{
//    NSLog(@"%ld", (long)currentSection);
    NSInteger index = sender.tag;
    if (_delegate) {
        [_delegate startDownloadApp:currentSection index:index];
    }
}


-(void) openServerSetNomalFrame:(NomalFrame *)nomalFrame section:(NSInteger)section pos:(NSInteger)index
{
    _nomalFrame =nomalFrame;
    [self openServerSetSubViewData:section pos:index];
    [self setSubViewFrame];
}

-(void) openServerSetSubViewData:(NSInteger)section pos:(NSInteger)index{
    
    [self.btnDownload setHidden:YES];
    
    OpenServerEntity *openInfo = self.nomalFrame.openServerInfo;
 
    currentSection = section;
    
    [self.ivAppIcon sd_setImageWithURL:[NSURL URLWithString:openInfo.smallImageUrl] placeholderImage:[UIImage imageNamed:@"load_fail"]];
    
    self.lblName.text = openInfo.packetName;
    
    if ([StringUtils isBlankString:openInfo.appDiscount]) {
        [self.btnDiscount setHidden:YES];
    }else{
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", openInfo.appDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [self.btnDiscount setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    
    self.timeLab.text = [openInfo.openServerArray objectAtIndex:0];
    
    self.lblDescribe.text = openInfo.serverDesc;
}

@end
