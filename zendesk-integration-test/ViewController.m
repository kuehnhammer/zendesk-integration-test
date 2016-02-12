//
//  ViewController.m
//  zendesk-integration-test
//
//  Created by Klaus Kuehnhammer on 12/02/16.
//  Copyright © 2016 Bitstem GmbH. All rights reserved.
//

#import "ViewController.h"
#import "StuffTableViewController.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <ZendeskProviderSDK/ZendeskProviderSDK.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (strong, nonatomic) UINavigationController * targetNavigationController;
@property (nonatomic,strong) StuffTableViewController* stuffController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard * board = [UIStoryboard storyboardWithName: @"Main" bundle: [NSBundle mainBundle]];
    self.stuffController = (StuffTableViewController*)[board instantiateViewControllerWithIdentifier: @"StuffTableViewController"];

    self.targetNavigationController = [[UINavigationController alloc] initWithRootViewController: self.stuffController];
    self.targetNavigationController.view.frame = self.targetView.bounds;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self doShowStuff:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doShowStuff:(id)sender {

    [self.targetView addSubview: self.targetNavigationController.view];
    self.targetNavigationController.view.frame = self.targetView.bounds;
    [self.targetNavigationController setViewControllers:@[self.stuffController] animated:NO];

}

- (IBAction)doOpenZendesk:(id)sender {
    [self.targetNavigationController setViewControllers:@[] animated:NO];
    [self.targetView addSubview: self.targetNavigationController.view];
    self.targetNavigationController.view.frame = self.targetView.bounds;

    [ZDKLogger enable:YES];
    [ZDKLogger setLogLevel:ZDKLogLevelVerbose];
    [ZDKConfig instance].userLocale = @"de";

    [[ZDKConfig instance] initializeWithAppId:@"c556a6154e95f42aad7063354874fe1efe4075278c474cb4"
                                   zendeskUrl:@"https://scan2lead.zendesk.com"
                                     ClientId:@"mobile_sdk_client_1be78330c031b64f3aa0"
                                    onSuccess:^() {
                                        
                                        NSLog(@"ZenDesk init OK");
                                        
        
                                        
                                        ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
                                        identity.name = @"Some Name";
                                        identity.externalId = @"DT_12345";
                                        [ZDKConfig instance].userIdentity = identity;
                                        
                                        [ZDKHelpCenter showHelpCenterWithNavController:self.targetNavigationController];
                                        
                                    }
                                      onError:^(NSError *error) {
                                          NSLog(@"ZenDesk init failed with %@", error.localizedDescription);
                                          
                                      }];
}

@end
