//
//  ViewController.h
//  MyBeacon
//
//  Created by Amol Chaudhari on 12/19/13.
//  Copyright (c) 2013 Amol Chaudhari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
}
@property(nonatomic) UILabel IBOutlet *enteredDistance;

-(IBAction)scanIbeacons:(id)sender;
@end
