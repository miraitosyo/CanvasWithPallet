//
//  FbViewController.m
//  CanvasWithPallet
//
//  Created by 古川 涼太 on 12/11/08.
//  Copyright (c) 2012年 古川 涼太. All rights reserved.
//

#import "FbViewController.h"

@interface FbViewController ()

@end

@implementation FbViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *FbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [FbBtn setTitle:@"☆" forState:UIControlStateNormal];
    FbBtn.frame = CGRectMake(self.view.frame.size.width-20, self.view.frame.size.height-20, 20, 20);
    [FbBtn addTarget:self action:@selector(FbBtnAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:FbBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)FbBtnAction:(UIButton*)sender
{
    
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    // 初期テキスト
    [facebookPostVC setInitialText:@"FB投稿テスト"];
    // 添付画像
    [facebookPostVC addImage:[UIImage imageNamed:@"EUI.jpg"]];
        
    // セット
    [self presentViewController:facebookPostVC animated:YES completion:nil];
    
    NSLog(@"tu-ka");
}

@end
