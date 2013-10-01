//
//  HKZTouchDrawView.h
//  TouchTracker
//
//  Created by zm on 9/30/13.
//  Copyright (c) 2013 Hackazach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKZTouchDrawView : UIView

- (void)clearAll;

@property (nonatomic) NSMutableDictionary *linesInProcess;
@property (nonatomic) NSMutableArray *completeLines;

@end
