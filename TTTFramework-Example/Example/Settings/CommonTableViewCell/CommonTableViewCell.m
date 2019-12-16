//
//  CommonTableViewCell.m
//  FileBox
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 OrangeTeam. All rights reserved.
//

#import "CommonTableViewCell.h"

#define kSystemGreenSwitchColor RGBCOLOR(75, 216, 99)

#define kSegmentColor           kThemeColor
#define kSwitchColor            kSettingSwitchColor
#define kArrowTextColor         kCellArrowTextColor

// 5s 6 is 15, 6plus is 20
#define kControlLeftSpace      CGRectGetMinX(self.textLabel.frame)
#define kArrowWidth            8
#define kArrowTextToArrow      (kControlLeftSpace - 2)

#define kFontSize 15

@interface CommonTableViewCell ()
{
    //
}
@property (nonatomic, strong) UIColor *segmentedViewColor;
@end

@implementation CommonTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.textLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        
        CGRect selectViewRect = CGRectZero;
        UIView *selectionView = [[UIView alloc] initWithFrame:selectViewRect];
        self.selectedBackgroundView = selectionView;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setSegmentViewDataSource:(NSArray *)segmentViewDataSource
{
    _segmentViewDataSource = segmentViewDataSource;
    
    if (self.segmentedControl)
    {
        [self.segmentedControl removeFromSuperview];
    }
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Push", @"Modal", nil]];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_segmentedControl];
}

- (void)segmentChanged
{
    
}

- (void)setupSubviews
{
    _rightTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_rightTextLabel setTextAlignment:NSTextAlignmentRight];
    [_rightTextLabel setFont:[UIFont systemFontOfSize:kFontSize]];
    [_rightTextLabel setTextColor:[UIColor darkGrayColor]];
    // [_arrowTextLabel setBackgroundColor:[UIColor redColor]];
    
    [self.contentView addSubview:_rightTextLabel];
    
    _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchView setOnTintColor:[UIColor greenColor]];
    [_switchView setOn:NO animated:NO];
    [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_switchView];
    
    self.segmentedViewColor = [UIColor blueColor];
    self.segmentViewDataSource = @[@{@"text": NSLocalizedString(@"Name1", nil), @"icon": @""}, @{@"text": NSLocalizedString(@"Name2", nil), @"icon": @""}];
}

- (CGFloat)cellWidth
{
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return [[UIScreen mainScreen] bounds].size.width;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        else
        {
            return [[UIScreen mainScreen] bounds].size.width;
        }
    }
}

+ (float)cellHeight
{
    return 44.0f;
}

- (CGRect)cellFrame
{
    CGRect cellFrame = self.frame;
    cellFrame.size.height = [[self class] cellHeight];
    
    return cellFrame;
}

- (void)setAccessoryStyle:(TableViewCellAccessoryStyle)style
{
    _accessoryStyle = style;
    
    switch (style)
    {
        case TableViewCellAccessoryIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryDetailIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryCheckmark:
        {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryDetailButton:
        {
            self.accessoryType = UITableViewCellAccessoryDetailButton;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryTextIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self showView:self.rightTextLabel];
            break;
        }
        case TableViewCellAccessoryText:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            [self showView:self.rightTextLabel];
            break;
        }
        case TableViewCellAccessorySwitch:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionEnable = NO;
            [self showView:self.switchView];
            break;
        }
        case TableViewCellAccessorySegment:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionEnable = NO;
            
            [self showView:self.segmentedControl];
            break;
        }
        default:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            [self showView:nil];
            break;
        }
    }
}

- (void)setSelectionEnable:(BOOL)selectionEnable
{
    _selectionEnable = selectionEnable;
    self.selectionStyle = selectionEnable ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
}

- (void)setSegmentViewColor:(UIColor *)segmentSelectedColor
{
    _segmentedViewColor = segmentSelectedColor;
    
    if (self.segmentedControl)
    {
        self.segmentedControl.tintColor = _segmentedViewColor;
    }
}

- (void)setSwitchViewColor:(UIColor *)switchColor
{
    [self.switchView setOnTintColor:switchColor];
}

- (void)setIndicatorTextColor:(UIColor *)indicatorTextColor
{
    [self.rightTextLabel setTextColor:indicatorTextColor];
}

// hide one
- (void)hideView:(UIView *)view
{
    if (view)
    {
        view.hidden = YES;
    }
}

// show one, hide others
- (void)showView:(UIView *)view
{
    if (self.switchView)
    {
        self.switchView.hidden = YES;
    }
    
    if (self.segmentedControl)
    {
        self.segmentedControl.hidden = YES;
    }
    
    if (self.rightTextLabel)
    {
        self.rightTextLabel.hidden = YES;
    }
    
    if (view)
    {
        view.hidden = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectedBackgroundView.frame = self.bounds;
    
    if (self.switchView)
    {
        CGRect controlRect = self.switchView.frame;
        controlRect.origin.x = CGRectGetWidth(self.bounds) - controlRect.size.width - kControlLeftSpace;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.switchView.frame = controlRect;
    }
    
    if (self.segmentedControl)
    {
        CGRect controlRect = self.segmentedControl.frame;
        controlRect.origin.x = CGRectGetWidth(self.bounds) - controlRect.size.width - kControlLeftSpace;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.segmentedControl.frame = controlRect;
    }
    
    if (self.rightTextLabel)
    {
        CGRect controlRect;
        controlRect.size.width = 120;
        controlRect.size.height = 31;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        controlRect.origin.x = (UITableViewCellAccessoryDisclosureIndicator == self.accessoryType) ?
                               (CGRectGetWidth(self.bounds) - (controlRect.size.width + kArrowTextToArrow + kArrowWidth + kControlLeftSpace)) :
                               (CGRectGetWidth(self.bounds) - (controlRect.size.width + kControlLeftSpace));
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.rightTextLabel.frame = controlRect;
    }
}

#pragma mark - Switch
- (void)switchChanged:(UISwitch *)swith
{
    if (self.switchChangedHandler)
    {
        self.switchChangedHandler(swith.on);
    }
}

@end
