//
//  ViewController.m
//  MyBeacon
//
//  Created by Amol Chaudhari on 12/19/13.
//  Copyright (c) 2013 Amol Chaudhari. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
{
    CLBeaconRegion *beaconRegion;
    NSUUID *beaconUUID;

}
@property(nonatomic,retain)    CLLocationManager *appLocationManager;
@end


@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appLocationManager=[[CLLocationManager alloc]init];
    _appLocationManager.delegate=self;
    
    NSString *beaconIdent;
    
    
    
    // beaconUUID = [[NSUUID alloc] initWithUUIDString:@"9277830A-B2EB-490F-A1DD-7FE38C492EDE"];
    beaconUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    ;
    beaconIdent = @"Vulture.Zone.1";
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:0 minor:0 identifier:beaconIdent];
    //beaconRegion.notifyOnEntry=true;
  //  beaconRegion.notifyOnExit=true;
    beaconRegion.notifyEntryStateOnDisplay = true;
    //  _appLocationManager.distanceFilter=kCLDistanceFilterNone;
    [_appLocationManager startMonitoringForRegion:beaconRegion];
    [_appLocationManager startRangingBeaconsInRegion:beaconRegion];

}

-(void)sendRequestToOpenDoor{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.6:1234/runMotor"]];
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody         = @"You have entered ibeacon region";
    notif.fireDate          = [NSDate date];
    notif.repeatInterval    = 0;
    notif.timeZone          = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Request sent successfully");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)scanIbeacons:(id)sender{
    
    [_appLocationManager requestStateForRegion:beaconRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region {
    _enteredDistance.text=[NSString stringWithFormat:@"latitude=%f, longitude=%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude];
    NSLog(@"entered coordinates  = %@",_enteredDistance.text);
    
    [manager startRangingBeaconsInRegion:beaconRegion];
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region{
    [manager stopRangingBeaconsInRegion:beaconRegion];
    _enteredDistance.text=@"NOT IN RANGE";
    NSLog(@"Not in range");
    
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody         = @"You have exited ibeacon region";
    notif.fireDate          = [NSDate date];
    notif.repeatInterval    = 0;
    notif.timeZone          = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];


}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    _enteredDistance.text=[NSString stringWithFormat:@"state=%ld, radius=%f",state,region.radius];
    
    NSLog(@"%@",_enteredDistance.text);

    
}



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    for (CLBeacon *eachBeacon in beacons) {
        if ([eachBeacon.proximityUUID.UUIDString isEqualToString:[beaconUUID UUIDString]]) {
            if (eachBeacon.proximity == CLProximityUnknown) {
                [self.view setBackgroundColor:[UIColor blackColor]];
            } else if (eachBeacon.proximity == CLProximityImmediate) {
                [self.view setBackgroundColor:[UIColor redColor]];
            } else if (eachBeacon.proximity == CLProximityNear) {
                [self.view setBackgroundColor:[UIColor orangeColor]];
                [self sendRequestToOpenDoor];
                
            } else if (eachBeacon.proximity == CLProximityFar) {
                [self.view setBackgroundColor:[UIColor blueColor]];
            }
        }
       

    }
   }

@end
