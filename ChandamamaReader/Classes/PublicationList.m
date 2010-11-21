//
//  PublicationList.m
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 18/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PublicationList.h"
#import "ChandamamaConstants.h"
#import "ComicViewController.h"
#import "Settings.h"



@implementation PublicationList

@synthesize issuesListFilePath;
@synthesize issues;
@synthesize months;
@synthesize language;
@synthesize comicLanguage;
@synthesize navigationTitle;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadInitialData];
		
	UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Languages" style:UIBarButtonItemStyleBordered
																target:self action:@selector(settingsPressed:)];
	
	self.navigationItem.leftBarButtonItem = settings;
	[settings release];
	
	/*UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil];
	self.navigationItem.rightBarButtonItem = delete;
	[delete release];*/
											  
}

- (void) loadInitialData {
	
	NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
	NSDictionary *savedSettings = [userSettings objectForKey:@"selectedLanguage"];
	
	if (savedSettings == nil) {
		NSArray *objects = [[NSArray alloc] initWithObjects:@"English", @"EnglishList", @"english", nil];
		NSArray *keys = [[NSArray alloc] initWithObjects:LANGUAGE, LIST_FILE, COMIC_LANGUAGE, nil];
		savedSettings = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
		[objects release];
		[keys release];
		
		[userSettings setObject:savedSettings forKey:@"selectedLanguage"];
	}
	
	
	self.navigationTitle = [savedSettings objectForKey:LANGUAGE];
	self.issuesListFilePath = [savedSettings objectForKey:LIST_FILE];
	self.comicLanguage = [savedSettings objectForKey:COMIC_LANGUAGE];
	
	self.title = self.navigationTitle;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:self.issuesListFilePath ofType:@"plist"];
	
	NSMutableArray *tempLanguages = [[NSMutableArray alloc]  initWithContentsOfFile:path];
	self.issues =  tempLanguages;
	[tempLanguages release];
	
	
	NSArray *tempMonths = [[NSArray alloc] initWithObjects:@"January",
						   @"February",
						   @"March",
						   @"April",
						   @"May",
						   @"June",
						   @"July",
						   @"August",
						   @"September",
						   @"October",
						   @"November",
						   @"December", nil];
	
	self.months = tempMonths;
	[tempMonths release];
	
}


-(void) settingsPressed:(id)sender {
	Settings *settingsontroller = [[Settings alloc] initWithModalViewDelegate:self];
	[self.navigationController presentModalViewController:settingsontroller animated:YES];
	[settingsontroller release];
}


-(void) viewDissmissed{
	[self loadInitialData];
	UITableView *tempTableView = (UITableView*)self.view;
	[tempTableView reloadData];
	[tempTableView scrollRectToVisible:CGRectMake(0, 0, 10,10) animated:NO];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.issues count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dictionary = [self.issues objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:MONTH];
	return [array count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {
	return [[self.issues objectAtIndex:section] objectForKey:YEAR];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	NSDictionary *dictionary = [self.issues objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:MONTH];
	cell.textLabel.text = [self.months objectAtIndex:[[array objectAtIndex:indexPath.row] intValue]-1];	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ComicViewController *comicViewController = [[ComicViewController alloc] init];
	comicViewController.comicLanguage = comicLanguage;
	comicViewController.issuedYear = [[self.issues objectAtIndex:indexPath.section] objectForKey:YEAR];
	
	NSDictionary *dictionary = [self.issues objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:MONTH];
	comicViewController.issuedMonth = [self.months objectAtIndex:[[array objectAtIndex:indexPath.row] intValue]-1];
     
	 [self.navigationController pushViewController:comicViewController animated:YES];
	 [comicViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[language release];
	[months release];
	[issuesListFilePath release];
	[issues release];
	[comicLanguage release];
	[navigationTitle release];
    [super dealloc];
}


@end

