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
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

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
    
    // setup double-taps
    UITapGestureRecognizer *userNameDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameDoubleTapped:)];
    userNameDoubleTap.numberOfTapsRequired = 2;
    [self.userNameButton addGestureRecognizer:userNameDoubleTap];
    
    UITapGestureRecognizer *passwordDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordDoubleTapped:)];
    passwordDoubleTap.numberOfTapsRequired = 2;
    [self.passwordButton addGestureRecognizer:passwordDoubleTap];
    
    UITapGestureRecognizer *urlDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlDoubleTapped:)];
    urlDoubleTap.numberOfTapsRequired = 2;
    [self.urlButton addGestureRecognizer:urlDoubleTap];
    
}

- (IBAction) userNameKeyPressed:(id)sender {
    // Obtain an initial message from the wormhole
    id messageObject = [self.wormhole messageWithIdentifier:@"username"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        [self.textDocumentProxy insertText:value];
        // if user enters username most likely the next will be the password, so copy it to clipboard due to security limitation
        [self passwordDoubleTapped:nil];
    }
}

-(void) userNameDoubleTapped: (UIButton*) sender {
    
    id messageObject = [self.wormhole messageWithIdentifier:@"username"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
    }
}

- (IBAction)passwordKeyPressed:(UIButton*)sender {
    id messageObject = [self.wormhole messageWithIdentifier:@"password"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        [self.textDocumentProxy insertText:value];
        
    }
}

-(void) passwordDoubleTapped: (UIButton*) sender {
    
    id messageObject = [self.wormhole messageWithIdentifier:@"password"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
        
        // MiniKeePassAppDelegat listens to clipboard messages
        // if clearClipboard is enabled in settings the background-thread clearing
        // clipboard after specfied amount of time runs
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

-(void) urlDoubleTapped: (UIButton*) sender {
    
    id messageObject = [self.wormhole messageWithIdentifier:@"url"];
    NSString *value = [messageObject valueForKey:@"value"];
    
    if(value != nil)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
    }
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
