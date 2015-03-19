//
//  KeyboardViewController.m
//  com.baumhoto.MiniKeepassKeyboard
//
//  Created by Tobias Baumhöver on 16.03.15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "KeyboardViewController.h"
#import "MMWormhole.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *letterButtonsArray;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) MMWormhole *wormhole;


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
    
    // Initialize the wormhole
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.baumhoto.MiniKeePass"
                                                         optionalDirectory:nil];
}

- (IBAction) userNameKeyPressed:(id)sender {
    // Obtain an initial message from the wormhole
    id messageObject = [self.wormhole messageWithIdentifier:@"username"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
        [self.textDocumentProxy insertText:value];
    // if user enters username most likely the next will be the password, so copy it to clipboard due to security limitation
    [self passwordKeyPressed:nil];
}

- (IBAction)passwordKeyPressed:(UIButton*)sender {
    id messageObject = [self.wormhole messageWithIdentifier:@"password"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        // don't insert text when it was not called by button
        if(sender != nil)
            [self.textDocumentProxy insertText:value];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
        [self.wormhole passMessageObject:@{@"value" : @1}
                              identifier:@"clipboard"];
    }
}

- (IBAction)urlKeyPressed:(UIButton*)sender {
    // Get the application delegate
    id messageObject = [self.wormhole messageWithIdentifier:@"url"];
    NSString *value = [messageObject valueForKey:@"value"];
    if(value != nil)
        [self.textDocumentProxy insertText:value];
}

- (IBAction) globeKeyPressed:(id)sender {
    //required functionality, switches to user's next keyboard
    [self advanceToNextInputMode];
}

-(IBAction) returnKeyPressed: (UIButton*) sender {
    
    [self.textDocumentProxy insertText:@"\n"];
}

-(IBAction) backspaceKeyPressed: (UIButton*) sender {
    
    [self.textDocumentProxy deleteBackward];
}

-(IBAction) clearClipboardPressed: (UIButton*) sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
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
