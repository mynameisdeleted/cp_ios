//
//  CPUserActionCell.h
//  candpiosapp
//
//  Created by Andrew Hammond on 7/7/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "CPSoundEffectsManager.h"
#import "User.h"

#define kCancelOpenSlideActionButtonsNotification @"kCancelOpenSlideActionButtonsNotification"

typedef enum {
	CPUserActionCellDirectionRight = 0,
	CPUserActionCellDirectionLeft,
} CPUserActionCellDirection;

typedef enum {
    CPUserActionCellSwipeStyleNone = 0,
    CPUserActionCellSwipeStyleQuickAction,
    CPUserActionCellSwipeStyleReducedAction,
} CPUserActionCellSwipeStyle;

@class CPUserActionCell;

@protocol CPUserActionCellDelegate <NSObject>

@optional
- (void)cell:(CPUserActionCell*)cell didSelectSendLoveToUser:(User*)user;
- (void)cell:(CPUserActionCell*)cell didSelectSendMessageToUser:(User*)user;
- (void)cell:(CPUserActionCell*)cell didSelectExchangeContactsWithUser:(User*)user;
- (void)cell:(CPUserActionCell*)cell didSelectRowWithUser:(User*)user;

@end

@interface CPUserActionCell : UITableViewCell <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIView *hiddenView;
@property (strong, nonatomic) UIButton *sendLoveButton;
@property (strong, nonatomic) UIButton *sendMessageButton;
@property (strong, nonatomic) UIButton *exchangeContactsButton;
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *inactiveColor;
@property (weak, nonatomic) id<CPUserActionCellDelegate> delegate;
@property (nonatomic) BOOL shouldBounce;
@property (nonatomic) CPUserActionCellSwipeStyle leftStyle;
@property (nonatomic) CPUserActionCellSwipeStyle rightStyle;
@property (nonatomic, getter = isRevealing) BOOL revealing;
@property (nonatomic, readonly) CGFloat originalCenter;

+ (void)cancelOpenSlideActionButtonsNotification:(CPUserActionCell *)cell;
- (void)animateSlideButtonsWithNewCenter:(CGFloat)newCenter delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration animated:(BOOL)animated;

@end
