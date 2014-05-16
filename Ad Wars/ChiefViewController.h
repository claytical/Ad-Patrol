//
//  ChiefViewController.h
//  Ad Wars
//
//  Created by Clay Ewing on 2/6/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChiefViewController : UIViewController {
    NSMutableArray *chiefStatements;
    NSMutableArray *imChiefStatements;
    NSMutableArray *imSpecialStatements;
    NSMutableArray *whatsUpChiefStatements;
    NSMutableArray *helpStatements;
    NSMutableArray *firstOptions;
    NSMutableArray *secondOptions;
    BOOL wantsToBeChief;
    BOOL wantsToBeSpecial;
    int conversationCounter;
    int annoyanceCounter;
}
@property (nonatomic) BOOL callingChief;
@property (nonatomic) BOOL noPlayerID;
@property (strong, nonatomic) IBOutlet UIButton *optionTwoButton;
@property (strong, nonatomic) IBOutlet UIButton *optionOneButton;
@property (strong, nonatomic) IBOutlet UILabel *chiefStatementLabel;
@property (strong, nonatomic) IBOutlet UIButton *optionThreeButton;
- (IBAction)choseOptionOne:(id)sender;
- (IBAction)choseOptionTwo:(id)sender;
- (IBAction)choseOptionThree:(id)sender;

@end
