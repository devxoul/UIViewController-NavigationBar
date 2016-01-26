// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

void UIViewControllerNavigationBarSwizzle(Class cls, SEL originalSelector) {
    NSString *originalName = NSStringFromSelector(originalSelector);
    NSString *alternativeName = [NSString stringWithFormat:@"UIViewControllerNavigationBar_%@", originalName];

    SEL alternativeSelector = NSSelectorFromString(alternativeName);

    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(cls, alternativeSelector);

    class_addMethod(cls,
                    originalSelector,
                    class_getMethodImplementation(cls, originalSelector),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(cls,
                    alternativeSelector,
                    class_getMethodImplementation(cls, alternativeSelector),
                    method_getTypeEncoding(alternativeMethod));

    method_exchangeImplementations(class_getInstanceMethod(cls, originalSelector),
                                   class_getInstanceMethod(cls, alternativeSelector));
}


@implementation UIViewController (NavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIViewControllerNavigationBarSwizzle(self, @selector(viewWillAppear:));
        UIViewControllerNavigationBarSwizzle(self, @selector(viewDidLayoutSubviews));
        UIViewControllerNavigationBarSwizzle(self, @selector(observeValueForKeyPath:ofObject:change:context:));
        UIViewControllerNavigationBarSwizzle(self, NSSelectorFromString(@"dealloc"));
    });
}


#pragma mark - Observing keys

+ (NSArray *)observingKeys {
    return @[@"navigationItem.title",
             @"navigationItem.titleView",
             @"navigationItem.prompt",
             @"navigationItem.backBarButtonItem",
             @"navigationItem.hidesBackButton",
             @"navigationItem.rightBarButtonItem",
             @"navigationItem.rightBarButtonItems",
             @"navigationItem.leftBarButtonItem",
             @"navigationItem.leftBarButtonItems",
             @"navigationItem.leftItemsSupplementBackButton"];
}


#pragma mark - Properties

- (BOOL)hasNavigationBar {
    return [objc_getAssociatedObject(self, @selector(hasNavigationBar)) boolValue];
}

- (void)setHasNavigationBar:(BOOL)has {
    objc_setAssociatedObject(self, @selector(hasNavigationBar), @(has), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)navigationBar {
    UINavigationBar *navigationBar = objc_getAssociatedObject(self, @selector(navigationBar));
    if (!navigationBar) {
        navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        navigationBar.delegate = self;
        objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self updateNavigationItem:navigationBar];
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return navigationBar;
}

- (void)updateNavigationItem:(UINavigationBar *)navigationBar {
    navigationBar.items = [self deepCopy:self.navigationController.navigationBar.items];
    [navigationBar pushNavigationItem:[self deepCopy:self.navigationItem] animated:NO];
}


#pragma mark - View life cycle

- (void)UIViewControllerNavigationBar_viewWillAppear:(BOOL)animated {
    [self UIViewControllerNavigationBar_viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.hasNavigationBar animated:animated];
}


- (void)UIViewControllerNavigationBar_viewDidLayoutSubviews {
    [self UIViewControllerNavigationBar_viewDidLayoutSubviews];
    if (self.hasNavigationBar) {
        [self.view addSubview:self.navigationBar];
    }
}

- (void)UIViewControllerNavigationBar_observeValueForKeyPath:(NSString *)keyPath
                                            ofObject:(id)object
                                              change:(NSDictionary<NSString *,id> *)change
                                             context:(void *)context {
    if ([self.class.observingKeys containsObject:keyPath]) {
        [self updateNavigationItem:self.navigationBar];
    } else {
        [self UIViewControllerNavigationBar_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)UIViewControllerNavigationBar_dealloc {
    if (self.hasNavigationBar) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self UIViewControllerNavigationBar_dealloc];
}


#pragma mark - Utils

- (id)deepCopy:(id)object {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:object]];
}


#pragma mark - UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    return [self.navigationController popViewControllerAnimated:YES];
}

@end
