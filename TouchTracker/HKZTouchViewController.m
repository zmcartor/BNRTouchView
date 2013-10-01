//
//  HKZTouchViewController.m
//  TouchTracker
//
//  Created by zm on 9/30/13.
//  Copyright (c) 2013 Hackazach. All rights reserved.
//

#import "HKZTouchViewController.h"
#import "HKZTouchDrawView.h"

@implementation HKZTouchViewController

// set the view to our special drawing subclass
-(void)loadView {
    [self setView:[[HKZTouchDrawView alloc] initWithFrame:CGRectZero]];
    
    
}

@end
