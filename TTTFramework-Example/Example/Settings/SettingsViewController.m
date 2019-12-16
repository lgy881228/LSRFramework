//
//  SettingsViewController.m
//  TTTFramework-Testing
//
//  Created by jia on 2017/10/2.
//  Copyright © 2017年 jia. All rights reserved.
//

#import "SettingsViewController.h"
#import "CommonTableViewCell.h"
#import "CommonTableViewHeaderFooter.h"
#import "BlurEffectViewController.h"
#import "TabBarController+Theme.h"
#import <TTTFramework/TTTFramework.h>
#import <Masonry/Masonry.h>

@interface SettingsViewController ()

@end

#define kTableViewSectionAmount  6

@implementation SettingsViewController

- (BOOL)customizedEnabled
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarTitle = @"我的";
    [self addNavigationBarRightButtonItemWithTitle:@"Loading" action:@selector(testloading)];
    
    self.tableView.backgroundColor = RGBCOLOR(247, 247, 247);
    
    // 是否根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的inset（从透明的bar后面调整出来：缩进）
    // self.automaticallyAdjustsScrollViewInsets = NO;
    
    // self.preferredNavigationBarLargeTitleColor = [UIColor redColor];
    
    if (@available(iOS 11.0, *))
    {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self hideLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Member Methods
- (void)testloading
{
    [self showLoading];
    
    [NSThread delaySeconds:2.0 perform:^{
        [self.tableView reloadData];
        [self hideLoading];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kTableViewSectionAmount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger settingSection = 0;
    if (settingSection++ == section)
    {
        return 2;
    }
    else if (settingSection++ == section)
    {
        return 3;
    }
    else if (settingSection++ == section)
    {
        return 1;
    }
    else if (settingSection++ == section)
    {
        return 1;
    }
    else if (settingSection++ == section)
    {
        return 1;
    }
    else
    {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight;
    if (0 == section)
    {
        headerHeight = [CommonTableViewHeaderFooter defaultHeight] + [CommonTableViewHeaderFooter textingHeight];
    }
    else if (4 == section) // 清除缓存
    {
        headerHeight = [CommonTableViewHeaderFooter defaultHeight];
    }
    else
    {
        headerHeight = [CommonTableViewHeaderFooter textingHeight];
    }
    
    // NSLog(@"Header %ld Height: %f", (long)section, headerHeight);
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight;
    if (kTableViewSectionAmount - 1 == section)
    {
        footerHeight = [CommonTableViewHeaderFooter defaultHeight] + [CommonTableViewHeaderFooter defaultHeight];
    }
    else
    {
        footerHeight = [CommonTableViewHeaderFooter defaultHeight];
    }
    
    // NSLog(@"Footer %ld Height: %f", (long)section, footerHeight);
    return footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommonTableViewCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentifier = @"SettingTableViewHeaderIdentifier";
    
    CommonTableViewHeaderFooter *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header)
    {
        header = [[CommonTableViewHeaderFooter alloc] initWithReuseIdentifier:headerIdentifier];
        // [header setFont:[UIFont boldSystemFontOfSize:13]];
    }
    
    switch (section)
    {
        case 0:
        {
            [header setTitle:NSLocalizedString(@"选择功能", nil)];
            break;
        }
        case 1:
        {
            [header setTitle:NSLocalizedString(@"分组2", nil)];
            break;
        }
        case 2:
        {
            [header setTitle:NSLocalizedString(@"分组3", nil)];
            break;
        }
        case 3:
        {
            [header setTitle:NSLocalizedString(@"分组4", nil)];
            break;
        }
        case 4:
        {
            [header setTitle:@""];
            
            break;
        }
        default:
        {
            [header setTitle:NSLocalizedString(@"分组6", nil)];
            break;
        }
    }
    
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *footerIdentifier = @"SettingTableViewFooterIdentifier";
    
    CommonTableViewHeaderFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    if (!footer) footer = [[CommonTableViewHeaderFooter alloc] initWithReuseIdentifier:footerIdentifier];
    
    switch (section)
    {
        default:
        {
            [footer setTitle:NSLocalizedString(@"", nil)];
            break;
        }
    }
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idtf = @"SettingTableViewCell";
    
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idtf];
    
    if (!cell)
    {
        cell = [[CommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idtf];
    }
    
    // 恢复
    cell.accessoryStyle = TableViewCellAccessoryNone;
    cell.selectionEnable = YES;
    
    NSString *str = @"";
    NSUInteger settingSection = 0;
    if (settingSection++ == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                str = NSLocalizedString(@"模糊测试", nil);
                
                cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
                [cell.rightTextLabel setText:@"请点击"];
                
                break;
            }
            case 1:
            {
                str = NSLocalizedString(@"TabBar刷新", nil);
                
                cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
                [cell.rightTextLabel setText:@"请点击"];
                
                break;
            }
            default:
                break;
        }
    }
    else if (settingSection++ == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                str = NSLocalizedString(@"TabBar显示和隐藏", nil);
                
                cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
                [cell.rightTextLabel setText:@"请点击"];
                
                break;
            }
            case 1:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessorySwitch;
                
                cell.switchView.on = YES;
                [cell setSwitchChangedHandler:^(BOOL isOn)
                 {
                     //
                 }];
                
                break;
            }
            case 2:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessorySwitch;
                
                cell.switchView.on = NO;
                [cell setSwitchChangedHandler:^(BOOL isOn)
                 {
                     //
                 }];
                
                break;
            }
            default:
                break;
        }
    }
    else if (settingSection++ == indexPath.section)
    {
        str = NSLocalizedString(@"Todo", nil);
        
        cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
        [cell.rightTextLabel setText:@"text"];
    }
    else if (settingSection++ == indexPath.section)
    {
        str = NSLocalizedString(@"Todo", nil);
        
        cell.accessoryStyle = TableViewCellAccessoryTextIndicator;
        [cell.rightTextLabel setText:@"text"];
    }
    else if (settingSection++ == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessoryText;
                [cell.rightTextLabel setText:@"text"];
                
                break;
            }
            default:
                break;
        }
    }
    else if (settingSection++ == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessoryIndicator;
                
                break;
            }
            case 1:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessoryNone;
                
                break;
            }
            case 2:
            {
                str = NSLocalizedString(@"Todo", nil);
                cell.accessoryStyle = TableViewCellAccessoryNone;
                
                break;
            }
            default:
                break;
        }
    }
    else
    {
        
    }
    
    [cell.textLabel setText:str];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    CommonTableViewCell *cell = (CommonTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSUInteger settingSection = 0;
    NSUInteger settingRow = 0;
    if (settingSection++ == indexPath.section)
    {
        if (settingRow++ == indexPath.row)
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"IMG_3962" ofType:@"JPG"];
            UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
            
            BlurEffectViewController *blurEffect = [BlurEffectViewController new];
            blurEffect.navigationBarTitle = cell.textLabel.text;
            blurEffect.blurBackgroundImage = bgImage;
            blurEffect.blurEffectStyle = UIBlurEffectStyleDark;
            
            // blurEffect.prefersNavigationBarHidden = YES;
            // blurEffect.prefersStatusBarHidden = YES;
            
            [self pushViewController:blurEffect];
        }
        else if (settingRow++ == indexPath.row)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarChanging" object:nil];
        }
        else
        {
            // do nothing
        }
    }
    else if (settingSection++ == indexPath.section)
    {
        if (settingRow++ == indexPath.row)
        {
            TabBarController *tabBarController = (TabBarController *)self.tabBarController;
            if (tabBarController.isTabBarShowing)
            {
                [tabBarController hideTabBar];
            }
            else
            {
                [tabBarController showTabBar];
            }
        }
    }
    else
    {
        // do nothing
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
