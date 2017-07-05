//
//  ButchersListTVCTableViewController.m
//  jBacon
//
//  Created by Developer iOS on 01.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "ButchersListTVC.h"

#import "JIAConstants.h"
#import "ButchersPersistance.h"

@interface ButchersListTVC ()

@property (nonatomic, strong) ButchersPersistance *butcherPersistance;

@end

@implementation ButchersListTVC

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 90.0;
	
	self.butcherPersistance = [ButchersPersistance sharedButchers];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.butcherPersistance knownButchers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForButcherListInfoCell];
	
	JIAButcher *butcher = [self butcherForIndexPatch:indexPath];
	
	cell.textLabel.text = butcher.name;
	cell.detailTextLabel.text = butcher.uuid;
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		JIAButcher *butcherToRemove = [self butcherForIndexPatch:indexPath];
		
		// update the model
		[self.butcherPersistance removeButcher:butcherToRemove];
		[self.butcherPersistance synchronize];
		
		[self updateTableView:tableView withDeleteRowsAtIndexPaths:@[indexPath]];
	}
}

- (void)updateTableView:(UITableView *)tableView
withDeleteRowsAtIndexPaths:(NSArray *)deletedRows
{
	[tableView beginUpdates];
	[tableView deleteRowsAtIndexPaths:deletedRows
					 withRowAnimation:UITableViewRowAnimationAutomatic];
	[tableView endUpdates];
}

#pragma mark - Actions

- (IBAction)didPushRightButton:(id)sender
{
	[self performSegueWithIdentifier:kSegueShowAddButcher
							  sender:self];
}

#pragma mark - Helper Methods
- (JIAButcher *)butcherForIndexPatch:(NSIndexPath *)indexPath
{
	NSArray *allButchers = [self.butcherPersistance knownButchers];
	JIAButcher *butcher = allButchers[indexPath.row];
	
	return butcher;
}

@end
