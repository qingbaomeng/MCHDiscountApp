//
//  NomalCell.m
//  MCHSecretary
//
//  Created by 朱进 on 16/8/9.
//  Copyright © 2016年 朱进. All rights reserved.
//

#import "OpenServerSearchCell.h"

#import "OpenServerEntity.h"
#import "OpenServerSearchFrame.h"
#import "WebImage.h"
#import "StringUtils.h"
#import "OpenServerPostion.h"

#define kScreesWidth [[UIScreen mainScreen] bounds].size.width

#define GetFont(s) [UIFont systemFontOfSize:s]
#define ServerFont GetFont(10)
#define NameFont GetFont(15)
#define MiddleFont GetFont(10)
#define DescribeFont GetFont(12)
#define OpenServerFont GetFont(12)
#define ButtonShowFont GetFont(13)
#define LineColor [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]
#define MiddleTextColor [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1.0]
#define DescribeColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1.0]

#define GetColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TopBackColor GetColor(18,205,176,1.0)

@interface OpenServerSearchCell(){
    BOOL isdShowAll;
}

@property (nonatomic, weak) UIImageView * ivAppIcon;
@property (nonatomic, weak) UILabel * lblName;
@property (nonatomic, weak) UILabel * lblMiddle;
@property (nonatomic, weak) UILabel * lblDescribe;
@property (nonatomic, weak) UIButton * btnDiscount;
@property (nonatomic, weak) UIButton * btnDownload;
@property (nonatomic, weak) UIButton * btnDownloadText;
@property (nonatomic, weak) UIView * lineview;
@property (nonatomic, weak) UIButton *btnShowAll;

@end



@implementation OpenServerSearchCell

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
    
    OpenServerSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[OpenServerSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    isdShowAll = false;
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
        
        //        UIButton *btndowntext = [[UIButton alloc] init];
        //        [btndowntext setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //        btndowntext.titleLabel.font = DescribeFont;
        //        btndowntext.titleLabel.numberOfLines = 1;
        //        btndowntext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //        [self.contentView addSubview:btndowntext];
        //        self.btnDownloadText = btndowntext;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self.contentView addSubview:line];
        self.lineview = line;
    }
    return self;
}

-(void) setOpenServerSearchFrame:(OpenServerSearchFrame *)openServerSearchFrame{
    [self setOpenServerSearchFrame:openServerSearchFrame pos:0 openserver:NO];
}

-(void) setOpenServerSearchFrame:(OpenServerSearchFrame *)openServerSearchFrame pos:(NSInteger)index openserver:(BOOL)isshow{
    _openServerSearchFrame = openServerSearchFrame;
    
    [self setSubViewData:index];
    [self setSubViewFrame];
    
    if(isshow){
        [self addOpenServerList:index];
    }
    
}

-(void) setSubViewData:(NSInteger)index{
    OpenServerEntity * packInfo = self.openServerSearchFrame.packetInfo;
    
    [self.ivAppIcon sd_setImageWithURL:[NSURL URLWithString:packInfo.smallImageUrl] placeholderImage:[UIImage imageNamed:@"tabbtn_choice_select"]];
    
    self.lblName.text = packInfo.packetName;
    
//    NSString *packetDown = [NSString stringWithFormat:@"%@%@", packInfo.appDownloadNum, NSLocalizedString(@"AppDownNumber", @"")];
//    NSString *packetSize = [NSString stringWithFormat:@"%@MB", packInfo.packetSize];
//    self.lblMiddle.text = [NSString stringWithFormat:@"%@ · %@", packetDown, packetSize];
    
    self.lblDescribe.text = packInfo.serverDesc;
    
    [self.btnDownload setBackgroundImage:[UIImage imageNamed:@"appinstall"] forState:UIControlStateNormal];
    self.btnDownload.tag = index;
    [self.btnDownload addTarget:self action:@selector(downloadApp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnDownloadText setTitle:NSLocalizedString(@"AppDownload", @"") forState:UIControlStateNormal];
    
    if ([StringUtils isBlankString:packInfo.appDiscount]) {
        [self.btnDiscount setHidden:YES];
    }else{
        NSString *leftdiscountStr = [NSString stringWithFormat:@"%@%@", packInfo.appDiscount, NSLocalizedString(@"AppDiscount", @"")];
        [self.btnDiscount setTitle:leftdiscountStr forState:UIControlStateNormal];
    }
    
}

-(void) setSubViewFrame{
    self.ivAppIcon.frame = self.openServerSearchFrame.imageFrame;
    self.lblName.frame = self.openServerSearchFrame.nameFrame;
    self.lblMiddle.frame = self.openServerSearchFrame.middleFrame;
    self.lblDescribe.frame = self.openServerSearchFrame.describeFrame;
    self.btnDiscount.frame = self.openServerSearchFrame.discountFrame;
    self.btnDownload.frame = self.openServerSearchFrame.downloadFrame;
    self.btnDownloadText.frame = self.openServerSearchFrame.downloadTextFrame;
    self.lineview.frame = self.openServerSearchFrame.lineFrame;
}

-(void) addOpenServerList:(NSInteger)index{{
    if(_openServerSearchFrame.openServerFrameArray){
        
        NSInteger openserNum = _openServerSearchFrame.openServerFrameArray.count > 2 ? 2 : _openServerSearchFrame.openServerFrameArray.count;
        
        for (int i = 0; i < openserNum; i++) {
            OpenServerPostion *pos = _openServerSearchFrame.openServerFrameArray[i];
            UILabel *lblos = [[UILabel alloc] initWithFrame:CGRectMake(pos.posX, pos.posY, pos.posW, 30)];
            lblos.layer.cornerRadius = 10;
            [lblos setBackgroundColor:[UIColor whiteColor]];
            lblos.layer.borderWidth = 1;
            lblos.layer.borderColor = [TopBackColor CGColor];
            lblos.font = OpenServerFont;
            [lblos setText:pos.openTime];
            [lblos setTextColor:TopBackColor];
            [lblos setTextAlignment:NSTextAlignmentCenter];
            
            [self.contentView addSubview:lblos];
        }
        
        if(_openServerSearchFrame.openServerFrameArray.count > 2 && !isdShowAll){
            UIButton *showAll = [[UIButton alloc] initWithFrame:_openServerSearchFrame.showAllServerFrame];
            [showAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            showAll.titleLabel.font = ButtonShowFont;
            [showAll setTitle:NSLocalizedString(@"ShowAllServer", @"") forState:UIControlStateNormal];
            showAll.tag = index;
            [showAll addTarget:self action:@selector(showAllOpenServer:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:showAll];
            self.btnShowAll = showAll;
            
        }
        
        if(isdShowAll){
            CGRect lineF = self.lineview.frame;
            lineF.origin.y = _openServerSearchFrame.openServerFrameArray.count * 40 + 10 + CGRectGetMaxY(self.ivAppIcon.frame);
            lineF.size.width = kScreesWidth - 10;
            self.lineview.frame = lineF;
            [self.btnShowAll removeFromSuperview];
            
            for (int i = 2; i < _openServerSearchFrame.openServerFrameArray.count; i++) {
                OpenServerPostion *pos = _openServerSearchFrame.openServerFrameArray[i];
                UILabel *lblos = [[UILabel alloc] initWithFrame:CGRectMake(pos.posX, pos.posY, pos.posW, 30)];
                lblos.layer.cornerRadius = 10;
                [lblos setBackgroundColor:[UIColor whiteColor]];
                lblos.layer.borderWidth = 1;
                lblos.layer.borderColor = [TopBackColor CGColor];
                lblos.font = OpenServerFont;
                [lblos setText:pos.openTime];
                [lblos setTextColor:TopBackColor];
                [lblos setTextAlignment:NSTextAlignmentCenter];
                
                [self.contentView addSubview:lblos];
            }
            
            self.openServerSearchFrame.cellHeight = CGRectGetMaxY(self.lineview.frame) + 10;
        }
    }
//    else{
//        if(_openServerSearchFrame.openServerFrameArray.count == 1){
//            OpenServerPostion *pos = _openServerSearchFrame.openServerFrameArray[0];
//            UILabel *lblos = [[UILabel alloc] initWithFrame:CGRectMake(pos.posX, pos.posY, pos.posW, 30)];
//            lblos.layer.cornerRadius = 10;
//            [lblos setBackgroundColor:[UIColor whiteColor]];
//            lblos.layer.borderWidth = 1;
//            lblos.layer.borderColor = [TopBackColor CGColor];
//            lblos.font = OpenServerFont;
//            [lblos setText:NSLocalizedString(@"NoOpenServerInfo", @"")];
//            [lblos setTextColor:TopBackColor];
//            [lblos setTextAlignment:NSTextAlignmentCenter];
//            
//            [self.contentView addSubview:lblos];
//        }
//        
    }
}

-(void) downloadApp:(UIButton *)sender{
    //    NSLog(@"%ld", (long)currentSection);
    NSInteger index = sender.tag;
    if (_delegate) {
        [_delegate startDownloadApp:index];
    }
}


-(void) showAllOpenServer:(UIButton *)sender{
    NSLog(@"1111111");
    isdShowAll = YES;
    NSInteger index = sender.tag;
    if(_delegate){
        [_delegate showAllOpenServerInfo:index];
    }
}







@end
