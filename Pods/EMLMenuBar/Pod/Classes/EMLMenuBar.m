//
//  EMLMenuBar.m
//  EMLMenuBar
//
//  Created by Enric Macias Lopez on 6/30/14.
//

#import "EMLMenuBar.h"

@interface EMLMenuBar()

@property (nonatomic, assign) NSInteger itemsInMenuBar;

- (void)initScrollView;
- (void)initAndAddBarButtons;

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
               animated:(BOOL)animated
         notifyDelegate:(BOOL)notifyDelegate;
- (void)handleAutoScrolling:(BOOL)animated;

@end

@implementation EMLMenuBar{
    NSMutableArray *_barButtonsArray;
}

@synthesize selectedItemIndex = _selectedItemIndex;

#pragma mark -
#pragma mark UIView
#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        NSLog(@"initWithCoder:");
        
        self.barButtonsArray = [NSMutableArray array];
        self.menuBarStyle = EMLMenuBarStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = _scrollView.frame;
    frame.size.width = self.frame.size.width;
    _scrollView.frame = frame;
    
    _scrollView.contentSize = CGSizeMake([self barLenght],
                                         self.frame.size.height);
    _scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark -
#pragma mark Init
#pragma mark -

- (void)setup
{
    [self initScrollView];
    [self initAndAddBarButtons];
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = self.frame.size;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scrollView];
}

- (void)initAndAddBarButtons
{
    self.itemsInMenuBar = [self.dataSource itemCountInMenuBar:self];
    
    for (int i = 0; i < self.itemsInMenuBar; i++)
    {
        // Init
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EMLMenuBarButton" owner:self options:nil];
        EMLMenuBarButton *barButton = (EMLMenuBarButton *) [topLevelObjects objectAtIndex:0];
        barButton.delegate = self;
        [barButton setupWithPosition:i inMenuBar:self];
        
        [_barButtonsArray addObject:barButton];
        [self.scrollView addSubview:barButton];
    }
}

#pragma mark -
#pragma mark Update
#pragma mark -

- (void)reloadMenu
{
    self.itemsInMenuBar = [self.dataSource itemCountInMenuBar:self];
    
    for (EMLMenuBarButton *barButton in self.barButtonsArray){
        [barButton removeFromSuperview];
    }
    [_barButtonsArray removeAllObjects];
    
    [self initAndAddBarButtons];
    [self layoutSubviews];
}

#pragma mark -
#pragma mark SelectedItemIndex
#pragma mark -

- (NSUInteger)selectedItemIndex
{
    return _selectedItemIndex;
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
    [self setSelectedItemIndex:selectedItemIndex
                      animated:YES
                notifyDelegate:YES];
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated notifyDelegate:(BOOL)notifyDelegate
{
    _selectedItemIndex = selectedItemIndex;
    
    // Buttons
    for (EMLMenuBarButton *barButton in self.barButtonsArray)
    {
        [barButton setSelected:barButton.index == selectedItemIndex];
    }
    
    [self handleAutoScrolling:animated];
    
    if (self.delegate && notifyDelegate){
        [self.delegate itemSelectedAtIndex:selectedItemIndex inMenuBar:self];
    }
}

- (void)handleAutoScrolling:(BOOL)animated
{
    EMLMenuBarButton *selectedButton = self.barButtonsArray[_selectedItemIndex];
    CGFloat desiredX = selectedButton.center.x - (_scrollView.bounds.size.width / 2);
    
    if (desiredX < 0)
        desiredX = 0;
    
    if (desiredX > [self barLenght] - _scrollView.bounds.size.width)
        desiredX = [self barLenght] - _scrollView.bounds.size.width;
    
    if (!(_scrollView.bounds.size.width > [self barLenght])) {
        [_scrollView setContentOffset:CGPointMake(desiredX, 0) animated:animated];
    }
}

#pragma mark -
#pragma mark Customization
#pragma mark -

- (void)setMenuBarStyle:(EMLMenuBarStyle)menuBarStyle
{
    _menuBarStyle = menuBarStyle;
    
    if (self.barButtonsArray.count > 0){
        // If the bar is already setted up
        [self reloadMenu];
        self.selectedItemIndex = _selectedItemIndex;
    }
}

#pragma mark -
#pragma mark Bounces
#pragma mark -

- (BOOL)bounces
{
    return self.scrollView.bounces;
}

- (void)setBounces:(BOOL)bounces
{
    self.scrollView.bounces = bounces;
}

#pragma mark -
#pragma mark Bar Length
#pragma mark -

- (CGFloat)barLenght
{
    CGFloat length = 0.0f;
    
    for (EMLMenuBarButton *button in self.barButtonsArray){
        length += button.frame.size.width;
    }
    
    return length;
}

#pragma mark -
#pragma mark ANIMenuBarButtonDelegate
#pragma mark -

- (void)didPressBarButton:(EMLMenuBarButton *)barButton
{
    NSLog(@"Pressed: %@",barButton);
    [self setSelectedItemIndex:barButton.index];
}

- (void)appearanceForNormalStateMenuBarButton:(EMLMenuBarButton *)barButton
{
    if ([self.dataSource respondsToSelector:@selector(appearanceForNormalStateMenuBarButton:)]) {
        [self.dataSource appearanceForNormalStateMenuBarButton:barButton];
    }
    else{
        /*CGRect frame = barButton.frame;
        frame.size.height = self.frame.size.height - 4.0f;
        
        barButton.frame = frame;*/
    }
}

- (void)appearanceForSelectedStateMenuBarButton:(EMLMenuBarButton *)barButton
{
    if ([self.dataSource respondsToSelector:@selector(appearanceForSelectedStateMenuBarButton:)]) {
        [self.dataSource appearanceForSelectedStateMenuBarButton:barButton];
    }
    else{
        /*CGRect frame = barButton.frame;
        frame.size.height = self.frame.size.height;
        
        barButton.frame = frame;*/
    }
}

@end
