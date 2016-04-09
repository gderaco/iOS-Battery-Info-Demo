//
//  ViewController.m
//  Battery Info
//
//  Created by Giuseppe Deraco on 09/04/16.
//  Copyright © 2016 Giuseppe Deraco. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property UITextView *tvBatteryInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableString *allInfo = [NSMutableString new];
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    if (CFArrayGetCount(sources) == 0)
        return;	// Could not retrieve battery information.  System may not have a battery.
    
    NSDictionary *limitedBatteryInfo = ((NSDictionary*)((NSArray*)CFBridgingRelease(blob))[0]);
    
    [allInfo appendString:@"IOPSCopyPowerSourcesInfo Data\n\n"];
    
    for (NSString* dictKey in [limitedBatteryInfo allKeys]) {
        [allInfo appendString:[NSString stringWithFormat:@"%@ : %@",dictKey,[limitedBatteryInfo valueForKey:dictKey]]];
        [allInfo appendString:@"\n"];
    }
    
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    
    
    
    CFMutableDictionaryRef batteryProperties = NULL;
    
    IORegistryEntryCreateCFProperties(powerSource, &batteryProperties, NULL, 0);
    
    NSDictionary *extensiveBatteryInfo = (__bridge_transfer NSDictionary *)batteryProperties;
    
    //Credit: https://github.com/jBot-42/JSystemInfoKit/blob/3d8a98d7d1b2a1bff4ff09716d9365e2e8948905/SystemInfoKit/JSKSystemMonitor.m#L346
    

    [allInfo appendString:@"\n\n\nIOPMPowerSource Data\n\n"];
    
    for (NSString* dictKey in [extensiveBatteryInfo allKeys]) {
        [allInfo appendString:[NSString stringWithFormat:@"%@ : %@",dictKey,[extensiveBatteryInfo valueForKey:dictKey]]];
        [allInfo appendString:@"\n"];
    }
    
    self.tvBatteryInfo = [[UITextView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.tvBatteryInfo];

    self.tvBatteryInfo.text = allInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
