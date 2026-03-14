//
//  SceneDelegate.m
//  Demo
//
//  Created by Nelson on 2026/3/14.
//  Copyright (c) 2026 Nelson. All rights reserved.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  UIWindowScene *windowScene = (UIWindowScene *)scene;
  self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
  self.window.rootViewController = [[ViewController alloc] init];
  [self.window makeKeyAndVisible];
}

@end
