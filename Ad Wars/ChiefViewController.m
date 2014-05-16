//
//  ChiefViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 2/6/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "ChiefViewController.h"
#import "AppDelegate.h"

@interface ChiefViewController ()

@end

@implementation ChiefViewController
@synthesize optionOneButton, optionTwoButton, chiefStatementLabel, callingChief, optionThreeButton, noPlayerID;

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
    wantsToBeChief = NO;
    annoyanceCounter = 0;
    wantsToBeSpecial = NO;
	// Do any additional setup after loading the view.
    chiefStatements = [[NSMutableArray alloc] initWithObjects:@"Around here, we take photos of ads in our city.", @"Many ads are illegal and it's hard to keep track of it all.", @"Strength in numbers! For the glory! And you're special.", nil];
    imChiefStatements = [[NSMutableArray alloc] initWithObjects:@"No, I'm the chief.", @"There can only be one chief.", @"Sorry, you don't have enough experience.", @"That's my name.",@"That's great, me too.", nil];
    whatsUpChiefStatements = [[NSMutableArray alloc] initWithObjects:@"I'm busy, leave me alone.", @"It's a great day to report an ad.", @"We're behind on our quota, get to work!", @"I have many burdens, one of them is you.", @"Huh?", @"If I give you an achievement will you leave me alone?",@"My wife left me, you're all that I have, and that's not much.", @"Terrible, thanks for asking.", @"Don't you have something better to do?", nil];
    
    imSpecialStatements = [[NSMutableArray alloc] initWithObjects:@"You're as special as everyone else, now get to work.", @"You're a shining diamond, just like the rest of us.", @"You're the MOST average person, ever.", @"You're 1 in 7.4 billion...", @"You're EXTRA ordinary.", @"I'm saying stuff that inspires you! Move along!",@"You're not inspired yet?", nil];
    
    helpStatements = [[NSMutableArray alloc] initWithObjects:@"Did you read through the help book?", @"Use that report stamp to report ads around your city.", @"Use the map to find other reported ads nearby.", @"Your badge will take you to the top patrollers list.",@"An ad can be verified after 24 hours.", @"In the ocean? Make sure you allowed access to your location.", nil];
    
    firstOptions = [[NSMutableArray alloc] initWithObjects:@"Why?", @"Why me?", @"I'm special?", nil];
    secondOptions = [[NSMutableArray alloc] initWithObjects:@"That's great, I'm ready to report!", @"Awesome, let's do this!", @"OK",  nil];
    conversationCounter = -1;
    if (callingChief) {
        [optionThreeButton setHidden:NO];
        [optionTwoButton setTitle:@"Help!" forState:UIControlStateNormal];
        [optionOneButton setTitle:@"How are you?" forState:UIControlStateNormal];
        [optionThreeButton setTitle:@"Nevermind." forState:UIControlStateNormal];
        [chiefStatementLabel setText:@"What's up?"];

    }
    if (noPlayerID) {
        [optionThreeButton setHidden:NO];
        [optionTwoButton setTitle:@"Help!" forState:UIControlStateNormal];
        [optionOneButton setTitle:@"Take me to Game Center!" forState:UIControlStateNormal];
        [optionThreeButton setTitle:@"Nevermind." forState:UIControlStateNormal];
        [chiefStatementLabel setText:@"Is Game Center disabled? Check your settings."];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choseOptionOne:(id)sender {
    if (noPlayerID) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
    if (!callingChief) {
        if (conversationCounter == 1) {
            wantsToBeSpecial = YES;
            NSInteger randomNum = arc4random() % [imSpecialStatements count];
            [optionTwoButton setTitle:@"OK." forState:UIControlStateNormal];
            [optionOneButton setTitle:@"Inspire me more." forState:UIControlStateNormal];
            [chiefStatementLabel setText:[imSpecialStatements objectAtIndex:randomNum]];

        }
        else {
            if (wantsToBeChief) {
                NSInteger randomNum = arc4random() % [imChiefStatements count];
                [optionTwoButton setTitle:@"OK, fine, you're the Chief." forState:UIControlStateNormal];
                [optionOneButton setTitle:@"But... I'm the Chief." forState:UIControlStateNormal];
                [chiefStatementLabel setText:[imChiefStatements objectAtIndex:randomNum]];

            }
            else {
                conversationCounter++;
                [optionOneButton setTitle:[firstOptions objectAtIndex:conversationCounter] forState:UIControlStateNormal];
                [optionTwoButton setTitle:[secondOptions objectAtIndex:conversationCounter] forState:UIControlStateNormal];
                [chiefStatementLabel setText:[chiefStatements objectAtIndex:conversationCounter]];
            }
        }
    }
    else {
        NSInteger randomNum = arc4random() % [whatsUpChiefStatements count];
        [optionOneButton setTitle:@"Tell me more." forState:UIControlStateNormal];

        [chiefStatementLabel setText:[whatsUpChiefStatements objectAtIndex:randomNum]];
        annoyanceCounter++;
        if (annoyanceCounter == 10) {
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate annoying];
            [chiefStatementLabel setText:@"I give up, you've achieved something."];
            
        }
    }
}

- (IBAction)choseOptionTwo:(id)sender {
    if (!callingChief) {
        if (conversationCounter != -1) {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            if (conversationCounter == -1 && !wantsToBeChief) {
                wantsToBeChief = YES;
                NSInteger randomNum = arc4random() % [imChiefStatements count];
                [optionTwoButton setTitle:@"OK, fine, you're the Chief." forState:UIControlStateNormal];
                [optionOneButton setTitle:@"But... I'm the Chief." forState:UIControlStateNormal];
                [chiefStatementLabel setText:[imChiefStatements objectAtIndex:randomNum]];

            }
            else {
                wantsToBeChief = NO;
                conversationCounter++;
                [optionOneButton setTitle:[firstOptions objectAtIndex:conversationCounter] forState:UIControlStateNormal];
                [optionTwoButton setTitle:[secondOptions objectAtIndex:conversationCounter] forState:UIControlStateNormal];
                [chiefStatementLabel setText:[chiefStatements objectAtIndex:conversationCounter]];
            }
        }
    }
    else {
        NSInteger randomNum = arc4random() % [helpStatements count];
        [chiefStatementLabel setText:[helpStatements objectAtIndex:randomNum]];

    }
}

- (IBAction)choseOptionThree:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
