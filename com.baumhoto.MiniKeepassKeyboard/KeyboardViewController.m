//
//  KeyboardViewController.m
//  com.baumhoto.MiniKeepassKeyboard
//
//  Created by Tobias Baumhöver on 16.03.15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *letterButtonsArray;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"Keyboard"
                                                      owner:self
                                                    options:nil];
    
    UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
    
    [self setView: mainView];
    
}

- (IBAction) userNameKeyPressed:(id)sender {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"username"];
    if(value != nil)
        [self.textDocumentProxy insertText:value];
    // if user enters username most likely the next will be the password, so copy it to clipboard due to security limitation
    [self passwordKeyPressed:sender];
}

- (IBAction)passwordKeyPressed:(UIButton*)sender {
    // password fields will be most likely be secure fields, so apple keyboard will be used. copy password to clipboard instead
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"password"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(value != nil)
         pasteboard.string = value;
}

- (IBAction)urlKeyPressed:(UIButton*)sender {
    // Get the application delegate
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.baumhoto.MiniKeePass"];
    NSString *value = [sharedDefaults stringForKey:@"url"];
    if(value != nil)
        [self.textDocumentProxy insertText:value];
}

- (IBAction) globeKeyPressed:(id)sender {
    //required functionality, switches to user's next keyboard
    [self advanceToNextInputMode];
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
}

@end
