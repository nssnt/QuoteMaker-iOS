//
//  SettingsViewController.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/1/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"

@interface SettingsViewController ()
@property (nonatomic, strong) NSMutableArray *listValues;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    self.listValues = [NSMutableArray arrayWithObjects: @"SouthbankLT", @"Smoothie_Shoppe", @"Saros-Regular", @"Cornerstone", @"BlendaScript", @"BacktoBlack-Regular", @"Alcubierre", @"BadheadTypeface", @"GrandHotel-Regular", @"Langdon", nil];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.title = @"Settings";
    [super viewDidLoad];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

//MARK: Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listValues.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *nameOfTheFont = self.listValues[indexPath.row];
    UIFont *font = [UIFont fontWithName:nameOfTheFont size:30];
    cell.textLabel.text = self.listValues[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = font;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *selectedValue = self.listValues[indexPath.row];
    [ud setValue:selectedValue forKey:MAIN_FONT];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

/*
 
 *****FONT NAMES*****
 (If you add any new fonts, please add them here in order, for easy reference)
 
 1. SouthbankLT
 2. Smoothie_Shoppe
 3. Saros-Regular
 4. Cornerstone
 5. BlendaScript
 6. BacktoBlack-Regular
 7. Alcubierre
 8. BadheadTypeface
 9. GrandHotel-Regular
 10. Langdon
 
 */
