//
//  FryBacon.m
//  jBacon
//
//  Created by Developer iOS on 02.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "FryBacon.h"

#import "AddButcherInputCell.h"
#import "BaconBrotcaster.h"
#import "FryBaconFooterCell.h"
#import "FryBaconHeaderCell.h"
#import "JIAAlertViewControllerFactory.h"
#import "JIABaconInformation.h"
#import "JIAConstants.h"
#import "JIAFryBaconValidationResult.h"
#import "JIAOldRecepiesInformationManager.h"
#import "NSString+JIAUUIDValidation.h"
#import "OldRecepies.h"

static NSUInteger const kFryBaconLastRowIndex = 4;

static NSInteger const kRowForUUID  = 0;
static NSInteger const kRowForMajor = 1;
static NSInteger const kRowForMinor = 2;
static NSInteger const kRowForName  = 3;

static NSInteger const kMaxMajorMinorValue = 65535;
static NSInteger const kMinMajorMinorValue = 0;

@interface FryBacon () <FryBaconFooterCellInteractionDelegate, OldRecepiesInteractionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) JIABaconInformation *baconConfiguration;

@end

@implementation FryBacon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baconConfiguration = [[JIAOldRecepiesInformationManager sharedManager] newestBacon];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == kFryBaconLastRowIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForFryBaconFooter
                                               forIndexPath:indexPath];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(cell.frame));
        
        
        
        FryBaconFooterCell *footerCell = (FryBaconFooterCell *)cell;
        footerCell.interactionDelegate = self;
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForFrySimpleInformation
                                               forIndexPath:indexPath];
        
        AddButcherInputCell *inputCell = (AddButcherInputCell *)cell;
        inputCell.fieldValue.delegate = self;
        inputCell.fieldValue.tag = indexPath.row;
        inputCell.fieldValue.keyboardType = [self keybordTypeForRow:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != kFryBaconLastRowIndex) {
        [self configureCell:cell atIndexPath:indexPath];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self titleForRow:indexPath.row];
    NSString *value = [self valueForRow:indexPath.row];
    NSString *placeHolderText = [self placeHolderTextForRow:indexPath.row];
    
    AddButcherInputCell *inputCell = (AddButcherInputCell *)cell;
    
    inputCell.fieldTitle.text = title;
    inputCell.fieldValue.text = value;
    inputCell.fieldValue.placeholder = placeHolderText;
}

- (NSString *)valueForRow:(NSInteger)row
{
    switch (row) {
        case kRowForUUID:{
            return self.baconConfiguration.uuid;
        }
            
        case kRowForMajor:{
            return [self.baconConfiguration.major stringValue];
        }
            
        case kRowForMinor:{
            return [self.baconConfiguration.minor stringValue];
        }
            
        case kRowForName:{
            return self.baconConfiguration.name;
        }
            
        default:{
            return @"no value";
        }
    }
}

- (NSString *)titleForRow:(NSInteger)row
{
    NSDictionary *titles = @{
                             @(kRowForUUID) : @"UUID:",
                             @(kRowForMajor): @"MAJOR:",
                             @(kRowForMinor): @"MINOR:",
                             @(kRowForName) : @"NAME:"
                             };
    
    return titles[@(row)];
}

- (NSString *)placeHolderTextForRow:(NSInteger)row
{
    NSDictionary *placeHolderText = @{
                                      @(kRowForUUID) : @"12345678-1234-1234-1234-123456789012",
                                      @(kRowForMajor): @"0 to 65 535",
                                      @(kRowForMinor): @"0 to 65 535",
                                      @(kRowForName) : @"Unique name eg. Sweet bacon in the kitchen."
                                      };
    
    return placeHolderText[@(row)];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FryBaconHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForFryBaconHeader];
    
    headerView.backgroundImage.image = [UIImage imageNamed:@"PaperTileLarge"];
    headerView.decorationImage.image = [UIImage imageNamed:@"FryBaconWidly"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 111;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[AddButcherInputCell class]]) {
        
        AddButcherInputCell *inputCell = (AddButcherInputCell *)cell;
        [inputCell.fieldValue becomeFirstResponder];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions
- (IBAction)didTapedOldRecpiesButton:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueShowOldRecepies
                              sender:self];
}

#pragma mark - FryBaconFooterCellInteractionDelegate

- (void)userDidTapCallToActionButton
{
    JIAFryBaconValidationResult *validationResult = [self validateAllCells];
    
    if ([validationResult isValid]) {
        [self gatherBaconInformation];
        [self performSegueWithIdentifier:kSegueShowBrotcaster
                                  sender:self];
    }
    else {
        NSString *title = @"Bacon recipe is incorrect :(";
        NSMutableString *message = [NSMutableString stringWithString:@"Incorrect values in fields for:\n"];
        
        if (validationResult.hasValidUUID == NO) {
            [message appendFormat:@"%@\n", @"- UUID"];
        }
        
        if (validationResult.hasValidMajor == NO) {
            [message appendFormat:@"%@\n", @"- Major"];
        }
        
        if (validationResult.hasValidMinor == NO) {
            [message appendFormat:@"%@\n", @"- Minor"];
        }
        
        if (validationResult.hasValidName == NO) {
            [message appendFormat:@"%@\n", @"- Name"];
        }
        
        [self showAllertWithTitle:title
                          message:[NSString stringWithString:message]
                     forTextField:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.view endEditing:YES];
    
    if ([segue.identifier isEqualToString:kSegueShowOldRecepies]) {
        OldRecepies *destinationVC = (OldRecepies *)segue.destinationViewController;
        destinationVC.interactionDelegate = self;
    }
    else if ([segue.identifier isEqualToString:kSegueShowBrotcaster]) {
        BaconBrotcaster *destinationVC = (BaconBrotcaster *)segue.destinationViewController;
        destinationVC.baconConfiguration = self.baconConfiguration;
    }
}

#pragma mark - OldRecepiesInteractionDelegate

- (void)oldRecepies:(OldRecepies *)oldRecepies didSelectOldRecepie:(JIAOldRecepie *)oldRecepie
{
    self.baconConfiguration = oldRecepie.baconInformation;
}

#pragma mark - Helper Methods

- (void)gatherBaconInformation
{
    NSNumberFormatter *formater = [NSNumberFormatter new];
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.baconConfiguration = [[JIABaconInformation alloc] initWithUUID:[self valueForCellInRow:kRowForUUID]
                                                                   name:[self valueForCellInRow:kRowForName]
                                                                  major:[formater numberFromString:[self valueForCellInRow:kRowForMajor]]
                                                                  minor:[formater numberFromString:[self valueForCellInRow:kRowForMinor]]];
    
}

- (NSString *)valueForCellInRow:(NSInteger)row
{
    AddButcherInputCell *cell = [self butcherInputCellForRow:row];
    
    // get the value
    NSString *value = cell.fieldValue.text;
    
    if (value == nil) {
        value = @"";
    }
    
    return value;
}

- (UIKeyboardType)keybordTypeForRow:(NSUInteger)row
{
    switch (row) {
            
        case kRowForUUID:{
            return UIKeyboardTypeNumbersAndPunctuation;
        }
            
        case kRowForMajor:{
            return UIKeyboardTypeNumberPad;
        }
            
        case kRowForMinor: {
            return UIKeyboardTypeNumberPad;
        }
            
        case kRowForName: {
            return UIKeyboardTypeASCIICapable;
        }
            
        default:{
            return UIKeyboardTypeDefault;
        }
    }
}

- (void)showAllertWithTitle:(NSString *)title
                    message:(NSString *)message
               forTextField:(UITextField *)textField
{
    UIAlertController *alertController = [JIAAlertViewControllerFactory alertControllerWithDefayultOkActionWithTitle:title
                                                                                                             message:message];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger currentRow = textField.tag;
    
    switch (currentRow) {
        case kRowForUUID:{
            [self validateUUIDTextField:textField showErrorAllert:YES];
            break;
        }
            
        case kRowForMajor:{
            [self validateMajorTextField:textField showErrorAllert:YES];
            break;
        }
            
        case kRowForMinor: {
            [self validateMinorTextField:textField showErrorAllert:YES];
            break;
        }
            
        case kRowForName: {
            [self validateNameTextField:textField showErrorAllert:YES];
            break;
        }
            
        default:{
            return;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (AddButcherInputCell *)butcherInputCellForRow:(NSInteger)row
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row
                                                                                     inSection:0]];
    if ([cell isKindOfClass:[AddButcherInputCell class]]) {
        return (AddButcherInputCell *)cell;
    }
    
    return nil;
}

#pragma mark - Validacja Wpisanych Wartosci

- (JIAFryBaconValidationResult *)validateAllCells
{
    // get the cells
    AddButcherInputCell *cellUUID  = [self butcherInputCellForRow:kRowForUUID];
    AddButcherInputCell *cellMajor = [self butcherInputCellForRow:kRowForMajor];
    AddButcherInputCell *cellMinor = [self butcherInputCellForRow:kRowForMinor];
    AddButcherInputCell *cellName  = [self butcherInputCellForRow:kRowForName];
    
    // validate textfields
    JIAFryBaconValidationResult *result = [JIAFryBaconValidationResult new];
    
    result.hasValidUUID  = [self validateUUIDTextField:cellUUID.fieldValue
                                       showErrorAllert:NO];
    
    result.hasValidMajor = [self validateMajorTextField:cellMajor.fieldValue
                                        showErrorAllert:NO];
    
    result.hasValidMinor = [self validateMinorTextField:cellMinor.fieldValue
                                        showErrorAllert:NO];
    
    result.hasValidName  = [self validateNameTextField:cellName.fieldValue
                                       showErrorAllert:NO];
    
    return result;
}

- (BOOL)validateUUIDTextField:(UITextField *)textField
              showErrorAllert:(BOOL)showErrorAlert
{
    BOOL isValidUUID = [textField.text isValidUUIDString];
    
    if (isValidUUID == NO && showErrorAlert) {
        [self.view endEditing:YES];
        
        [self showAllertWithTitle:@"UUID string is incorrect :("
                          message:@"Please provide string in format: 12345678-1234-1234-1234-123456789012"
                     forTextField:textField];
    }
    
    return isValidUUID;
}

- (BOOL)validateMajorTextField:(UITextField *)textField
               showErrorAllert:(BOOL)showErrorAlert
{
    BOOL isValid = [self validateMajorMinorForTextField:textField];
    
    if (isValid == NO && showErrorAlert) {
        [self.view endEditing:YES];
        
        [self showAllertWithTitle:@"Major is out of bounds :("
                          message:@"Please provide value from 0 to 65535"
                     forTextField:textField];
    }
    
    return isValid;
}

- (BOOL)validateMinorTextField:(UITextField *)textField
               showErrorAllert:(BOOL)showErrorAlert
{
    BOOL isValid = [self validateMajorMinorForTextField:textField];
    
    if (isValid == NO && showErrorAlert) {
        [self.view endEditing:YES];
        
        [self showAllertWithTitle:@"Minor is out of bounds :("
                          message:@"Please provide value from 0 to 65535"
                     forTextField:textField];
    }
    
    return isValid;
}

- (BOOL)validateNameTextField:(UITextField *)textField
              showErrorAllert:(BOOL)showErrorAlert
{
    BOOL validName = [self valideteIfStringExgistInTextField:textField];
    
    if (validName == NO && showErrorAlert) {
        [self.view endEditing:YES];
        
        [self showAllertWithTitle:@"Name is missing"
                          message:@"Please provide a name"
                     forTextField:textField];
    }
    
    return validName;
}

- (BOOL)valideteIfStringExgistInTextField:(UITextField *)textField
{
    NSString *stringToValidate = textField.text;
    
    if (stringToValidate == nil || [stringToValidate isEqualToString:@""]) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validateMajorMinorForTextField:(UITextField *)textField
{
    BOOL stringEgxists = [self valideteIfStringExgistInTextField:textField];
    
    if (stringEgxists == NO) {
        return NO;
    }
    
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    
    [formater setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [formater numberFromString:textField.text];
    
    if ([myNumber integerValue] < kMinMajorMinorValue || [myNumber integerValue] > kMaxMajorMinorValue) {
        return NO;
    }
    
    return YES;
}

@end
