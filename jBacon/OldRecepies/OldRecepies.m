//
//  OldRecepies.m
//  jBacon
//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "OldRecepies.h"

#import "JIAOldRecepiesInformationManager.h"
#import "JIAConstants.h"
#import "OldRecepieHeaderCell.h"
#import "UIColor+JIABaconColors.h"
#import "OldRecepieFullInfoCell.h"

@interface OldRecepies ()

@property (nonatomic, weak) JIAOldRecepiesInformationManager *informationManager;

@end

@implementation OldRecepies

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.informationManager = [JIAOldRecepiesInformationManager sharedManager];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(50, 20, 100, 40)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.informationManager synchronize];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:[self separatorEdgeInset]];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:[self separatorEdgeInset]];
    }
}

#pragma mark - Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OldRecepieFullInfoCell *cell = (OldRecepieFullInfoCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseIDForOldRecepieFullInfoCell
                                                                                             forIndexPath:indexPath];
    [self configureFullInfoCell:cell
                    atIndexPath:indexPath];
    
    if ((indexPath.row % 2) == 0) {
        cell.contentView.backgroundColor = [UIColor cellsBackgroundColorForEavenCells];
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForOldRecepieHeaderCell];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    OldRecepieHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForOldRecepieHeaderCell];
    
    CGFloat height = headerCell.customTextLabel.intrinsicContentSize.height + (2 * 20);
    
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:[self separatorEdgeInset]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:[self separatorEdgeInset]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    JIAOldRecepie *oldRecepie = [self.informationManager oldRecepies][indexPath.row];
    
    [self.interactionDelegate oldRecepies:self
                      didSelectOldRecepie:oldRecepie];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.informationManager recepiesCount];
}

#pragma mark - Helper Methods

- (UIEdgeInsets)separatorEdgeInset
{
    return UIEdgeInsetsMake(0, 8, 0, 0);
}

- (void)configureFullInfoCell:(OldRecepieFullInfoCell *)cell
                  atIndexPath:(NSIndexPath *)indexPath
{
    JIAOldRecepie *oldRecepie = [self.informationManager oldRecepies][indexPath.row];
    JIABaconInformation *baconInformation = oldRecepie.baconInformation;
    
    cell.valueName.text = baconInformation.name;
    cell.UUIDLabel.text = baconInformation.uuid;
    cell.valueMajor.text = [baconInformation.major stringValue];
    cell.valueMinor.text = [baconInformation.minor stringValue];
}

@end
