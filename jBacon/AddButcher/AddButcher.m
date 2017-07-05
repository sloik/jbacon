//
//  AddBacon.m
//  jBacon
//
//  Created by Developer iOS on 09.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "AddButcher.h"

#import "AddButcherInputCell.h"
#import "ButchersPersistance.h"
#import "JIAAlertViewControllerFactory.h"
#import "JIAConstants.h"
#import "NSString+JIAUUIDValidation.h"
#import "AddButcherRow.h"

@interface AddButcher ()

@property (nonatomic, strong) NSArray *rows;

@end

@implementation AddButcher

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self setupRows];
}

#pragma mark - Setup

- (void)setupRows
{
    self.rows = @[
                  ({
                      AddButcherRow *row = [AddButcherRow new];
                      row.rowTitle = @"UUID:";
                      row.keyboardType = JIAKeybordTypeNumbers;
                      row.valuePlaceholder = @"12345678-1234-1234-1234-123456789012";
                      row;
                  }),
                  ({
                      AddButcherRow *row = [AddButcherRow new];
                      row.rowTitle = @"What's the name for that butcher?";
                      row.keyboardType = JIAKeybordTypeText;
                      row.valuePlaceholder = @"Granny's good bacon";
                      row;
                  })
                  
                  ];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddButcherInputCell *cell = (AddButcherInputCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [cell.fieldValue becomeFirstResponder];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddButcherInputCell *cell = (AddButcherInputCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseIDForAddBaconCell];
    
    [self configureAddBaconCell:cell
                    atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rows.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForAddBaconHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 172;
}

#pragma mark - Actions

- (IBAction)userDidPressSaveButton:(id)sender
{
    BOOL uuidIsCorrect = [self checkForCorrectUUIDString];
    
    if (uuidIsCorrect == NO) {
        [self handleUUIDErrorNotCorrectString];
        return;
    }
    
    BOOL hasCorrectName = [self checkForCorrectName];
    if (hasCorrectName == NO) {
        [self handleNameErrorNotCorrectNameString];
        return;
    }
    
    [self handleCorrectUUID];
}

#pragma mark - Save Step Methods

- (void)handleUUIDErrorNotCorrectString
{
    UIAlertController *alertController = [JIAAlertViewControllerFactory alertControllerWithDefayultOkActionWithTitle:@"UUID string is incorrect :("
                                                                                                             message:@"Please provide string in format: 12345678-1234-1234-1234-123456789012"];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)handleNameErrorNotCorrectNameString
{
    UIAlertController *alertController = [JIAAlertViewControllerFactory alertControllerWithDefayultOkActionWithTitle:@"Name is invalid :("
                                                                                                             message:@"Please provide a name for the butcher."];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)handleCorrectUUID
{
    [self gatherBaconInformationAndAddBaconRegion];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper methods

- (BOOL)checkForCorrectName
{
    NSString *nameString = [self gatherNameFromTableView];
    
    if (nameString == nil) {
        return NO;
    }
    
    if ([nameString length] < 1 || [nameString isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)checkForCorrectUUIDString
{
    NSString *testedString = [self gatherUUIDFromTableView];
    
    return [testedString isValidUUIDString];
}

- (void)gatherBaconInformationAndAddBaconRegion
{
    NSString *uuidString = [self gatherUUIDFromTableView];
    NSString *nameString = [self gatherNameFromTableView];
    
    JIAButcher *butcherToSave = [[JIAButcher alloc] initWithUUID:uuidString
                                                            name:nameString];
    
    [[ButchersPersistance sharedButchers] saveButcher:butcherToSave];
    [[ButchersPersistance sharedButchers] synchronize];
}

- (NSString *)gatherUUIDFromTableView
{
    NSIndexPath *firstCell = [NSIndexPath indexPathForRow:0
                                                inSection:0];
    
    AddButcherInputCell *cell = (AddButcherInputCell*)[self.tableView cellForRowAtIndexPath:firstCell];
    return [cell.fieldValue text];
}

- (NSString *)gatherNameFromTableView
{
    NSIndexPath *firstCell = [NSIndexPath indexPathForRow:1
                                                inSection:0];
    
    AddButcherInputCell *cell = (AddButcherInputCell*)[self.tableView cellForRowAtIndexPath:firstCell];
    return [cell.fieldValue text];
}

- (void)configureAddBaconCell:(AddButcherInputCell *)cell
                  atIndexPath:(NSIndexPath *)indexPath
{
    AddButcherRow *baconRow = [self baconRowForIndexPath:indexPath];
    
    cell.fieldTitle.text = baconRow.rowTitle;
    cell.fieldValue.keyboardType = [self keyboardTypeFromBaconRow:baconRow];
    cell.fieldValue.placeholder = baconRow.valuePlaceholder;
}

- (UIKeyboardType)keyboardTypeFromBaconRow:(AddButcherRow *)baconRow
{
    switch (baconRow.keyboardType) {
            
        case JIAKeybordTypeText:{
            return UIKeyboardTypeASCIICapable;
        }
            
        case JIAKeybordTypeNumbers:{
            return UIKeyboardTypeNumbersAndPunctuation;
        }
            
        default:{
            return UIKeyboardTypeDefault;
        }
    }
}

- (AddButcherRow *)baconRowForIndexPath:(NSIndexPath *)indexPath
{
    return self.rows[indexPath.row];
}

@end
