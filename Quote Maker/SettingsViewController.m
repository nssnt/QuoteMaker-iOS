//
//  SettingsViewController.m
//  Quote Maker
//
//  Created by Badhan Ganesh on 4/1/17.
//  Copyright © 2017 BJ. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController () {
    
}

@property (nonatomic, strong) NSMutableArray *listValues;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    _listValues = [NSMutableArray arrayWithObjects: @"whiteTheme", @"", @"", nil];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
