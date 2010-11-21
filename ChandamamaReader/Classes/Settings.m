//
//  Settings.m
//  ChandamamaReader
//
//  Created by Prashant Cholachagudda on 18/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "ChandamamaConstants.h"

@implementation Settings

@synthesize languages;
@synthesize doneButton;
@synthesize languagesTable;

#pragma mark -
#pragma mark View lifecycle

-(id) initWithModalViewDelegate:(id <ModalViewDelegate>)delegate {
	if ((self = [super init])) {
		modalViewDelegate = delegate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Chandamama";
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ComicLanguages" ofType:@"plist"];
	
	NSMutableArray *tempLanguages = [[NSMutableArray alloc]  initWithContentsOfFile:path];
	self.languages =  tempLanguages;
	[tempLanguages release];
	
	NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
	NSDictionary *savedSettings = [userSettings objectForKey:@"selectedLanguage"];
	selectedLanguage = [savedSettings objectForKey:LANGUAGE];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.languages count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString *currentItemString = [[self.languages objectAtIndex:indexPath.row] objectForKey:LANGUAGE];
    
	cell.textLabel.text = currentItemString;
	
	if ([currentItemString isEqualToString:selectedLanguage]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *selected = [self.languages objectAtIndex:indexPath.row];
	NSString *currentLanguage = [selected objectForKey:LANGUAGE];
	
	if (currentLanguage != selectedLanguage) {
		selectedLanguage = [selected objectForKey:LANGUAGE];
				
		NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
		[userSettings setObject:selected forKey:@"selectedLanguage"];
	}
	
	[tableView reloadData];
}

- (void) awakeFromNib {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
	backButton.title = @"Languages";
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(IBAction) doneButtonPressed:(id) sender{
	[self dismissModalViewControllerAnimated:YES];
	[modalViewDelegate viewDissmissed];
}


- (void)dealloc {
	[selectedLanguage release];
	[languages release];
	[doneButton release];
    [super dealloc];
}

@end
