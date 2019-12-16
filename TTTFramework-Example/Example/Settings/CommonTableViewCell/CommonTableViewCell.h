//
//  CommonTableViewCell.h
//  FileBox
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewCellAccessoryStyle)
{
    TableViewCellAccessoryNone = 0,
    TableViewCellAccessoryIndicator,
    TableViewCellAccessoryDetailIndicator,
    TableViewCellAccessoryCheckmark,
    TableViewCellAccessoryDetailButton,
    TableViewCellAccessoryTextIndicator,
    TableViewCellAccessoryText,
    TableViewCellAccessorySwitch,
    TableViewCellAccessorySegment,
};

typedef void (^SwitchChangedHandler)(BOOL isOn);

@interface CommonTableViewCell : UITableViewCell

@property (nonatomic, assign) TableViewCellAccessoryStyle accessoryStyle;
@property (nonatomic, assign, getter=isSelectionEnable) BOOL selectionEnable;

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, copy)   SwitchChangedHandler switchChangedHandler;

@property (nonatomic, strong) NSArray *segmentViewDataSource;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UILabel *rightTextLabel;

+ (float)cellHeight;

- (void)setSegmentViewColor:(UIColor *)segmentSelectedColor;
- (void)setSwitchViewColor:(UIColor *)switchColor;
- (void)setIndicatorTextColor:(UIColor *)indicatorTextColor;

@end
