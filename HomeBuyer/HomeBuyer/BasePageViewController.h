//
//  BasePageViewController.h
//  PageControllerTemplate
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePageViewController : UIViewController <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray* mPageNibNames;
@property (nonatomic, strong) UIPageViewController* pageController;
@property (nonatomic, strong) NSMutableArray* mPageViewControllers;
@end
