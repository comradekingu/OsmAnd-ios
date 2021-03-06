//
//  OAPurchaseDialogCardButtonEx.h
//  OsmAnd
//
//  Created by Alexey on 17/12/2018.
//  Copyright © 2018 OsmAnd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAPurchaseDialogItemView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    EOAPurchaseDialogCardButtonTypeRegular = 0,
    EOAPurchaseDialogCardButtonTypeExtended,
    EOAPurchaseDialogCardButtonTypeDisabled
} EOAPurchaseDialogCardButtonType;

typedef void (^OAPurchaseDialogCardButtonClickHandler)(void);

@interface OAPurchaseDialogCardButton : OAPurchaseDialogItemView

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbSaveLess;
@property (weak, nonatomic) IBOutlet UILabel *lbSaveMore;
@property (weak, nonatomic) IBOutlet UIButton *btnRegular;
@property (weak, nonatomic) IBOutlet UIButton *btnExtended;
@property (weak, nonatomic) IBOutlet UIButton *btnDisabled;

@property (nonatomic, readonly) BOOL active;
@property (nonatomic) NSString *discountStr;

- (void) setupButtonActive:(BOOL)active title:(NSAttributedString *)title description:(NSAttributedString *)description buttonText:(NSString *)buttonText buttonType:(EOAPurchaseDialogCardButtonType)buttonType discountDescr:(NSString *)discountDescr showDiscount:(BOOL)showDiscount highDiscount:(BOOL)highDiscount showTopDiv:(BOOL)showTopDiv showBottomDiv:(BOOL)showBottomDiv buttonClickHandler:(nullable OAPurchaseDialogCardButtonClickHandler)buttonClickHandler;

- (UIButton *) getActiveButton;

@end

NS_ASSUME_NONNULL_END
