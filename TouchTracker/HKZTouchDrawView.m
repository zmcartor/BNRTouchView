//
//  HKZTouchDrawView.m
//  TouchTracker
//
//  Created by zm on 9/30/13.
//  Copyright (c) 2013 Hackazach. All rights reserved.
//

#import "HKZTouchDrawView.h"
#import "HKZLine.h"


@implementation HKZTouchDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self){
        self.linesInProcess = [[NSMutableDictionary alloc] init];
        self.completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor orangeColor]];
        
        // IMPORTANT means view will keep listening after first touch is detected.
        [self setMultipleTouchEnabled:YES];
    }
    
    return self;
}

// drawRect override to actually draw the lines with CoreGraphics
// Takes data from various collections and renders on screen.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // draw complete lines in black
    
    [[UIColor blackColor] set];
    
    for(HKZLine *line in self.completeLines){
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    // lines in progress are RED
    [[UIColor blueColor] set];
    // iterate through dictionary
    for(NSValue *v in self.linesInProcess){
        HKZLine *line = [self.linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
}

#pragma mark - Touch methods

// multiple fingers could be touching at once. Run through each 'touch' and create a new line
// for each touch detected in touches set
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *t in touches){
        // is this double tap?
        if ([t tapCount] > 1){
            [self clearAll];
            return;
        }
        // use the touch object as the key
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        //create a line for the value
        CGPoint loc = [t locationInView:self];
        HKZLine *newLine = [[HKZLine alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        [self.linesInProcess setObject:newLine forKey:key];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // update lines in process with moved touches
    for (UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        //lookup the line for this touch
        HKZLine *line = [self.linesInProcess objectForKey:key];
        
        //update the line
        CGPoint movedPoint = [t locationInView:self];
        [line setEnd:movedPoint];
    }
    [self setNeedsDisplay];
}


// we'll use this method handle cases when touches have ended or have cancelled
- (void)endTouches:(NSSet *)touches{
    for(UITouch *t in touches){
        // remove touch from dict, this one is finished
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HKZLine *line = [self.linesInProcess objectForKey:key];
        
        if(line){
            [self.completeLines addObject:line];
            [self.linesInProcess removeObjectForKey:key];
        }
    }
    [self setNeedsDisplay];
}

// When touches end, add the finalized touches to the 'finalized'
// arry and redraw the view
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}


- (void)clearAll {
    [self.linesInProcess removeAllObjects];
    [self.completeLines removeAllObjects];
    
    //redraw the lines. inform view it needs to be re-drawn at next drawing loop.
    [self setNeedsDisplay];
}

@end
