//
//  ViewController.m
//  CachingTableViewCells
//
//  Created by Eric Parker on 12/10/14.
//  Copyright (c) 2014 testing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *cells;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cells = [[NSMutableDictionary alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Don't create a new cell if your cell is already in memory. Return it from your dictionary of cells
    if ([self.cells objectForKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]]) {
        return [self.cells objectForKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    }
    
    //Register a new identifier for each cell to avoid dequeueReusableCellWithIdentifier: reusing an old one
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    //Do any additional cell setup here
    
    [self.cells setObject:cell forKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    
    return cell;
}


@end
