//
//  InstallAppCell.m
//  MCHSecretary
//
//  Created by zhujin zhujin on 16/9/7.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "InstallAppCell.h"

#import "InstallAppInfo.h"
#import "InstallAppFrame.h"
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

@interface InstallAppCell()

@property (nonatomic, weak) UIImageView * ivAppIcon;
@property (nonatomic, weak) UILabel * lblName;
@property (nonatomic, weak) UILabel * lblMiddle;
@property (nonatomic, weak) UILabel * lblDescribe;
@property (nonatomic, weak) UIButton * btnDiscount;
@property (nonatomic, weak) UIButton * btnDownload;
@property (nonatomic, weak) UIView * lineview;

@end

@implementation InstallAppCell

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
    
    InstallAppCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[InstallAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
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
    }
    return self;
}

-(void) setFrame:(InstallAppFrame *)frame pos:(NSInteger)index{
    _installAppFrame = frame;
    
    [self setSubViewData:index];
    [self setSubViewFrame];
}

-(void) setSubViewData:(NSInteger)index{
    InstallAppInfo * info = self.installAppFrame.installAppInfo;
    
    [self.ivAppIcon sd_setImageWithURL:[NSURL URLWithString:info.iconUrl] placeholderImage:[UIImage imageNamed:@"tabbtn_choice_select"]];
    
    self.lblName.text = info.gameName;
    
    NSString *packetDown = [NSString stringWithFormat:@"%@MB", info.gameSize];
    NSString *packetSize = [NSString stringWithFormat:@"%@", info.gameType];
    self.lblMiddle.text = [NSString stringWithFormat:@"%@ | %@", packetDown, packetSize];
    
    self.lblDescribe.text = info.gameDescribe;
    
    [self.btnDownload setBackgroundImage:[UIImage imageNamed:@"apprepair.png"] forState:UIControlStateNormal];
    self.btnDownload.tag = index;
    [self.btnDownload addTarget:self action:@selector(downloadApp:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([StringUtils isBlankString:info.gameDiscount]) {
        [self.btnDiscount setHidden:YES];
    }else{
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", info.gameDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [self.btnDiscount setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    
}

-(void) setSubViewFrame{
    self.ivAppIcon.frame = self.installAppFrame.imageFrame;
    self.lblName.frame = self.installAppFrame.nameFrame;
    self.lblMiddle.frame = self.installAppFrame.middleFrame;
    self.lblDescribe.frame = self.installAppFrame.describeFrame;
    self.btnDiscount.frame = self.installAppFrame.discountFrame;
    self.btnDownload.frame = self.installAppFrame.downloadFrame;
    self.lineview.frame = self.installAppFrame.lineFrame;
}

-(void) downloadApp:(UIButton *)sender{
    //    NSLog(@"%ld", (long)currentSection);
    NSInteger index = sender.tag;
    if (_delegate) {
        [_delegate repairApp:index];
    }
}

@end
