
#import "Keboard.h"

@implementation Keboard
@synthesize hideButton=_hideButton;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (id)Share
{
	static Keboard *_instance=nil;
	if (_instance==nil) {
		_instance=[[Keboard alloc] init];
	}
    
	return _instance;
}

+ (id)retain
{
	return [self Share];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidChangeFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
	}
    
    return self;
}
#pragma keyboard
- (void)keyboardDidShow:(NSNotification *)notification{
        CGRect keyboardBounds;
        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        if (!_hideButton) {
            _hideButton=[[UIButton alloc] initWithFrame:CGRectMake(keyboardBounds.size.width-50,keyboardBounds.origin.y-22,48, 23)];
            [_hideButton setImage:[UIImage imageNamed:@"hidebutton.png"] forState:UIControlStateNormal];
            [_hideButton addTarget:self action:@selector(resignAllTextField) forControlEvents:UIControlEventTouchUpInside];
        }
        [_hideButton setFrame:CGRectMake(keyboardBounds.size.width-50,keyboardBounds.origin.y-22,48, 23)];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:_hideButton];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_hideButton removeFromSuperview];
}

- (void)removeHideButton
{
    [_hideButton removeFromSuperview];
}

- (void)resignAllTextField
{
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            [window endEditing:YES];
    }];
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[curTextView resignFirstResponder];
}

@end
