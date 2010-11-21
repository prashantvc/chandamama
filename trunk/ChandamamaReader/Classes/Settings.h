//
//  Settings.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudda on 18/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"


@interface Settings : UIViewController {
	NSMutableArray *languages;
	IBOutlet UIBarButtonItem *doneButton;
	IBOutlet UITableView *languagesTable;
	NSString *selectedLanguage;
	
	id<ModalViewDelegate> modalViewDelegate;
}

@property (nonatomic, retain) NSMutableArray *languages;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UITableView *languagesTable;

- (IBAction) doneButtonPressed:(id) sender;
- (id) initWithModalViewDelegate:(id<ModalViewDelegate>) delegate;
@end
