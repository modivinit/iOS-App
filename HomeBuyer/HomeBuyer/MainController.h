//
//  MainController.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 8/27/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainController : NSObject
@property (nonatomic, strong) UINavigationController* mMainNavController;

-(id) initWithNavController:(UINavigationController*) navController;
-(void) start;
@end
