//
//  IAAPushNoteView.m
//  TLV Airport
//
//  Created by Aviel Gross on 1/29/14.
//  Copyright (c) 2014 NGSoft. All rights reserved.
//

#import "AGPushNoteView.h"

#define APP [UIApplication sharedApplication].delegate
#define isIOS7 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define PUSH_VIEW [AGPushNoteView sharedPushView]

#define CLOSE_PUSH_SEC 3
#define SHOW_ANIM_DUR 0.5
#define HIDE_ANIM_DUR 0.35

@interface AGPushNoteView()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSTimer *closeTimer;
@property (strong, nonatomic) NSString *currentMessage;
@property (strong, nonatomic) NSMutableArray *pendingPushArr;

@property (strong, nonatomic) void (^messageTapActionBlock)(NSString *message);
@end


@implementation AGPushNoteView

//Singleton instance
static AGPushNoteView *_sharedPushView;

+ (instancetype)sharedPushView
{
	@synchronized([self class])
	{
		if (!_sharedPushView){
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed: @"AGPushNoteView" owner:self options:nil];
            for (id currentObject in nibArr)
            {
                if ([currentObject isKindOfClass:[AGPushNoteView class]])
                {
                    _sharedPushView = (AGPushNoteView *)currentObject;
                    break;
                }
            }
            [_sharedPushView setUpUI];
		}
		return _sharedPushView;
	}
	// to avoid compiler warning
	return nil;
}

+ (void)setDelegateForPushNote:(id<AGPushNoteViewDelegate>)delegate {
    [PUSH_VIEW setPushNoteDelegate:delegate];
}

#pragma mark - Lifecycle (of sort)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect f = self.frame;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.frame = CGRectMake(f.origin.x, f.origin.y, width, f.size.height);
        NSLog(@"X axis %f",f.origin.x);
        
    }
    return self;
}

- (void)setUpUI {
    CGRect f = self.frame;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = isIOS7? 98: f.size.height;
    self.frame = CGRectMake(f.origin.x, -height, width, height);
    
    CGRect cvF = self.containerView.frame;
    self.containerView.frame = CGRectMake(cvF.origin.x, cvF.origin.y, self.frame.size.width, cvF.size.height);
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = true;
    //OS Specific:
    if (isIOS7) {
        self.barTintColor = nil;
        self.translucent = YES;
        self.barStyle = UIBarStyleDefault;
        
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor greenColor]);
        self.layer.borderWidth = 2;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.containerView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.containerView addSubview:blurEffectView];
        
       
        
        
    } else {
        [self setTintColor:[UIColor colorWithRed:5 green:31 blue:75 alpha:1]];
        [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
        self.messageLabel.shadowColor = [UIColor blackColor];
    }
    
    self.layer.zPosition = MAXFLOAT;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = NO;
    self.exclusiveTouch = YES;
    
    UITapGestureRecognizer *msgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTapAction)];
    self.messageLabel.userInteractionEnabled = YES;
    [self.messageLabel addGestureRecognizer:msgTap];
    self.descriptionLabel.userInteractionEnabled = YES;
    [self.descriptionLabel addGestureRecognizer:msgTap];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:msgTap];
   
    
    //:::[For debugging]:::
    //            self.containerView.backgroundColor = [UIColor yellowColor];
    //            self.closeButton.backgroundColor = [UIColor redColor];
    //            self.messageLabel.backgroundColor = [UIColor greenColor];
    
    [APP.window addSubview:PUSH_VIEW];
}

+ (void)awake {
    if (PUSH_VIEW.frame.origin.y == 0) {
        [APP.window addSubview:PUSH_VIEW];
    }
}

+ (void)showWithNotificationMessage:(NSString *)message description:(NSString *)description{
    [AGPushNoteView showWithNotificationMessage:message description:description completion:^{
        //Nothing.
    }];
}

+ (void)showWithNotificationMessage:(NSString *)message description:(NSString *)description completion:(void (^)(void))completion {
    
    PUSH_VIEW.currentMessage = message;

    if (message) {
        [PUSH_VIEW.pendingPushArr addObject:message];
        
        PUSH_VIEW.messageLabel.text = message;
        PUSH_VIEW.descriptionLabel.text = description;
        APP.window.windowLevel = UIWindowLevelStatusBar;
        
        CGRect f = PUSH_VIEW.frame;
        PUSH_VIEW.frame = CGRectMake(f.origin.x, -f.size.height, f.size.width, f.size.height);
        [APP.window addSubview:PUSH_VIEW];
        NSLog(@"X axis3 %f",f.origin.x);
        
        
        //Show
        [UIView animateWithDuration:SHOW_ANIM_DUR delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect f = PUSH_VIEW.frame;
            PUSH_VIEW.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
            NSLog(@"X axis4 %f",f.origin.x);
        } completion:^(BOOL finished) {
            completion();
            if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteDidAppear)]) {
                [PUSH_VIEW.pushNoteDelegate pushNoteDidAppear];
            }
        }];
        
        //Start timer (Currently not used to make sure user see & read the push...)
        PUSH_VIEW.closeTimer = [NSTimer scheduledTimerWithTimeInterval:CLOSE_PUSH_SEC target:[AGPushNoteView class] selector:@selector(close) userInfo:nil repeats:NO];
    }
}
+ (void)closeWitCompletion:(void (^)(void))completion {
    if ([PUSH_VIEW.pushNoteDelegate respondsToSelector:@selector(pushNoteWillDisappear)]) {
        [PUSH_VIEW.pushNoteDelegate pushNoteWillDisappear];
    }
    
    [PUSH_VIEW.closeTimer invalidate];
    
    [UIView animateWithDuration:HIDE_ANIM_DUR delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect f = PUSH_VIEW.frame;
        PUSH_VIEW.frame = CGRectMake(f.origin.x, -f.size.height, f.size.width, f.size.height);
        NSLog(@"X axis5 %f",f.origin.x);
    } completion:^(BOOL finished) {
        [PUSH_VIEW handlePendingPushJumpWitCompletion:completion];
    }];
}

+ (void)close {
    [AGPushNoteView closeWitCompletion:^{
        //Nothing.
    }];
}

#pragma mark - Pending push managment
- (void)handlePendingPushJumpWitCompletion:(void (^)(void))completion {
    id lastObj = [self.pendingPushArr lastObject]; //Get myself
    if (lastObj) {
        [self.pendingPushArr removeObject:lastObj]; //Remove me from arr
        NSString *messagePendingPush = [self.pendingPushArr lastObject]; //Maybe get pending push
        if (messagePendingPush) { //If got something - remove from arr, - than show it.
            [self.pendingPushArr removeObject:messagePendingPush];
            [AGPushNoteView showWithNotificationMessage:messagePendingPush description:@"Tap To See Notification" completion:completion];
        } else {
            APP.window.windowLevel = UIWindowLevelNormal;
        }
    }
}

- (NSMutableArray *)pendingPushArr {
    if (!_pendingPushArr) {
        _pendingPushArr = [[NSMutableArray alloc] init];
    }
    return _pendingPushArr;
}

#pragma mark - Actions
+ (void)setMessageAction:(void (^)(NSString *message))action {
    PUSH_VIEW.messageTapActionBlock = action;
}

- (void)messageTapAction {
    if (self.messageTapActionBlock) {
        self.messageTapActionBlock(self.currentMessage);
        [AGPushNoteView close];
    }
}

- (IBAction)closeActionItem:(UIBarButtonItem *)sender {
    [AGPushNoteView close];
}


@end
