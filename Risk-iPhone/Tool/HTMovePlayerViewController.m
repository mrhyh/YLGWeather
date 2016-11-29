//
//  HTMovePlayerViewController.m
//  Haitangshequ
//
//  Created by Jack on 12/22/14.
//  Copyright (c) 2014 zxy. All rights reserved.
//

#import "HTMovePlayerViewController.h"

@interface HTMovePlayerViewController ()

@end

@implementation HTMovePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskAll;
    
}


- (BOOL)shouldAutorotate

{

    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
