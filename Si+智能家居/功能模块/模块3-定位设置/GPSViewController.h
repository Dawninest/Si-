//
//  GPSViewController.h
//  Si+智能家居
//
//  Created by 蒋一博 on 16/5/3.
//  Copyright © 2016年 JiangYibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^homeEventBlock)(BOOL homeEvent);

@interface GPSViewController : UIViewController

@property (strong ,nonatomic) homeEventBlock homeEventHandle;

- (void)backWithHomeEvent:(homeEventBlock)backEvent;

@end
