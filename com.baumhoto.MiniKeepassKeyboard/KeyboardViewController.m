//
//  KeyboardViewController.m
//  com.baumhoto.MiniKeepassKeyboard
//
//  Created by Tobias Baumhöver on 16.03.15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
    
    UIButton *userNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [userNameButton setTitle:@"UserName" forState:UIControlStateNormal];
    [userNameButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [userNameButton setBackgroundColor: [[UIColor alloc] initWithWhite:1.0f alpha: 1.0f]];
    [userNameButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    [userNameButton addTarget:self action:@selector(userNameKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [userNameButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    UIButton *passwordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [passwordButton setTitle:@"Password" forState:UIControlStateNormal];
    [passwordButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [passwordButton setBackgroundColor: [[UIColor alloc] initWithWhite:1.0f alpha: 1.0f]];
    [passwordButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    [passwordButton addTarget:self action:@selector(passwordKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [passwordButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    UIButton *urlButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [urlButton setTitle:@"Url" forState:UIControlStateNormal];
    [urlButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [urlButton setBackgroundColor: [[UIColor alloc] initWithWhite:1.0f alpha: 1.0f]];
    [urlButton setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    [urlButton addTarget:self action:@selector(urlKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [urlButton setTranslatesAutoresizingMaskIntoConstraints: NO];

    UIView *row = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    [row addSubview: userNameButton];
    [row addSubview: passwordButton];
    [row addSubview: urlButton];
    
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:passwordButton attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:userNameButton attribute:NSLayoutAttributeRightMargin multiplier:1.0f constant:20];
    
    NSLayoutConstraint *myConstraint2 =[NSLayoutConstraint
                                       constraintWithItem:urlButton attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:passwordButton attribute:NSLayoutAttributeRightMargin multiplier:1.0f constant:20];
    
    [row addConstraint:myConstraint];
    [row addConstraint:myConstraint2];
    [self.view addSubview: row];
}

- (void)userNameKeyPressed:(UIButton*)sender {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"username"];
    if(value != nil)
        [self.textDocumentProxy insertText:value];
    // if user enters username most likely the next will be the password, so copy it to clipboard due to security limitation
    [self passwordKeyPressed:sender];
}

- (void)passwordKeyPressed:(UIButton*)sender {
    // password fields will be most likely be secure fields, so apple keyboard will be used. copy password to clipboard instead
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"password"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(value != nil)
         pasteboard.string = value;
}

- (void)urlKeyPressed:(UIButton*)sender {
    // Get the application delegate
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"url"];
    if(value != nil)
        [self.textDocumentProxy insertText:value];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
