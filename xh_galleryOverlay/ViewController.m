//
//  ViewController.m
//  xh_galleryOverlay
//
//  Created by Xiaohe Hu on 6/10/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
{
    BOOL        arr_statusOfBtns[5];
    BOOL        arr_trackBtns[5];
}
@property (nonatomic, strong)           NSMutableArray          *arr_ctrlBtnArray;
@property (nonatomic, strong)           NSMutableArray          *arr_circleViewArray;
@property (nonatomic, strong)           NSMutableArray          *arr_labelArray;
@property (nonatomic, strong)           NSMutableArray          *arr_colorArray;
@property (nonatomic, strong)           NSArray                 *arr_overLayImage;
@property (nonatomic, strong)           NSArray                 *arr_overLayNames;

@property (nonatomic, strong)           UIView                  *uiv_buttonContainer;
@property (nonatomic, strong)           UIImageView             *uiiv_baseMap;

@property (nonatomic, strong, readonly) UIScrollView            *scrollView;
@property (nonatomic, strong)           UIView                  *uiv_windowComparisonContainer;
@end

@implementation ViewController

-(void)viewWillLayoutSubviews {
NSLog(@"the size is %@",[self.view description]);
    [self initVC];
}
-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"\n\nthe size is %@",[self.view description]);
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Reset array that tracking status of buttons
    for (int i = 0; i < sizeof(arr_trackBtns); i++) {
        arr_trackBtns[i] = 0;
    }
    
    //Init Arrays
    _arr_overLayNames = [[NSArray alloc] initWithObjects:@"RETAIL", @"OFFICE", @"RESID.", @"HOTEL", @"PARK", nil];
    _arr_overLayImage = [[NSArray alloc] initWithObjects:@"ABOUT_SECTION_02_USE_RETAIL.png", @"ABOUT_SECTION_03_USE_OFFICE.png", @"ABOUT_SECTION_04_USE_RESIDENTIAL.png", @"ABOUT_SECTION_05_USE_HOTEL.png", @"ABOUT_SECTION_07_PARK.png", nil];
    _arr_ctrlBtnArray = [[NSMutableArray alloc] init];
    _arr_circleViewArray = [[NSMutableArray alloc] init];
    _arr_labelArray = [[NSMutableArray alloc] init];
    _arr_colorArray = [[NSMutableArray alloc] init];
}

-(void)initVC {
    //Init ScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 46.0, self.view.bounds.size.width, 554)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview: _scrollView];
    
    //Init ImageView
    _uiiv_baseMap = [[UIImageView alloc] init];
    _uiiv_baseMap.frame = CGRectMake(0.0, 46, self.view.bounds.size.width, 554);
    _uiiv_baseMap.image = [UIImage imageNamed:@"ABOUT_SECTION_00_BASE.png"];
    _uiiv_baseMap.contentMode = UIViewContentModeScaleAspectFit;
    _uiiv_baseMap.userInteractionEnabled = YES;
    
    _uiv_windowComparisonContainer = [[UIView alloc] initWithFrame:_uiiv_baseMap.bounds];
    [_uiv_windowComparisonContainer addSubview:_uiiv_baseMap];
    
    _scrollView.contentSize = _uiv_windowComparisonContainer.frame.size;
    [_scrollView addSubview:_uiv_windowComparisonContainer];
    [self zoomableScrollview:self withImage:_uiiv_baseMap];
    
    //Init button container
    if (!_uiv_buttonContainer) {
        _uiv_buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(30.0, self.view.bounds.size.height - 30 - 55, 390.0, 55.0)];
        _uiv_buttonContainer.backgroundColor = [UIColor clearColor];
        [self.view addSubview: _uiv_buttonContainer];
        
        //Init Views in container
        CGFloat detailView_W = 70;
        CGFloat padding = 8;
        
        for (int i = 0; i < 5; i++) {
            UIView *uiv_detail = [[UIView alloc] initWithFrame:CGRectMake((detailView_W + padding)*i, 0.0, detailView_W, _uiv_buttonContainer.frame.size.height)];
            
            //Set circle inside of detail view
            UIView *uiv_colorCircle = [[UIView alloc] initWithFrame:CGRectMake(20.0, 0.0, 30.0, 30.0)];
            uiv_colorCircle.backgroundColor = [UIColor lightGrayColor];
            CGPoint savedCenter = uiv_colorCircle.center;
            uiv_colorCircle.layer.cornerRadius = uiv_colorCircle.frame.size.height/2;
            uiv_colorCircle.center = savedCenter;
            uiv_colorCircle.layer.borderWidth = 1.0;
            uiv_colorCircle.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [uiv_detail addSubview: uiv_colorCircle];
            [_arr_circleViewArray addObject: uiv_colorCircle];
            
            //Set lable inside of detail view
            UILabel *uil_buttonName = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 35.0, detailView_W, 20)];
            uil_buttonName.backgroundColor = [UIColor clearColor];
            [uil_buttonName setText:[_arr_overLayNames objectAtIndex:i]];
            uil_buttonName.textAlignment = NSTextAlignmentCenter;
            uil_buttonName.font = [UIFont fontWithName:@"Futura-Medium"size:14];
            uil_buttonName.textColor = [UIColor grayColor];
            [uiv_detail addSubview: uil_buttonName];
            [_arr_labelArray addObject: uil_buttonName];
            
            [_uiv_buttonContainer addSubview: uiv_detail];
            
            //Set buttons ON top of detail view
            UIButton *uib_ctrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            uib_ctrlBtn.backgroundColor = [UIColor clearColor];
            uib_ctrlBtn.frame = uiv_detail.frame;
            uib_ctrlBtn.tag = i;
            [uib_ctrlBtn addTarget:self action:@selector(ctrlBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [_uiv_buttonContainer addSubview:uib_ctrlBtn];
            [_arr_ctrlBtnArray addObject: uib_ctrlBtn];
        }
    }
    
    [self initBtnColors];
    [self unlockZoom];
//    [self lockZoom];
}

-(void)initBtnColors {
    for (int i = 0; i < 5; i++) {
        UIColor *btnColor;
        switch (i) {
            case 0: { //RETAIL
                btnColor = [UIColor colorWithRed:249.0/255.0 green:233.0/255.0 blue:90.0/255.0 alpha:1.0];
                [_arr_colorArray addObject:btnColor];
                break;
            }
            case 1: { //OFFICE
                btnColor = [UIColor colorWithRed:162.0/255.0 green:181.0/255.0 blue:237.0/255.0 alpha:1.0];
                [_arr_colorArray addObject:btnColor];
                break;
            }
            case 2: { //RESID.
                btnColor = [UIColor colorWithRed:245.0/255.0 green:152.0/255.0 blue:64.0/255.0 alpha:1.0];
                [_arr_colorArray addObject:btnColor];
                break;
            }
            case 3: { //HOTEL
                btnColor = [UIColor colorWithRed:175.0/255.0 green:191.0/255.0 blue:65.0/255.0 alpha:1.0];
                [_arr_colorArray addObject:btnColor];
                break;
            }
            case 4: { //PARK
                btnColor = [UIColor colorWithRed:175.0/255.0 green:221.0/255.0 blue:113.0/255.0 alpha:1.0];
                [_arr_colorArray addObject:btnColor];
                break;
            }
            default:
                break;
        }
    }
}

-(void)ctrlBtnTapped:(id)sender{
    for (int i = 0; i < sizeof(arr_trackBtns); i++) {
        arr_trackBtns[i] = 0;
    }
    for (UIView *tmp in _arr_circleViewArray) {
        tmp.backgroundColor = [UIColor lightGrayColor];
    }
    for (UILabel *tmp in _arr_labelArray) {
        tmp.font = [UIFont fontWithName:@"Futura-Medium"size:14];
    }
    for (UIView *tmp in [_uiiv_baseMap subviews]) {
        [tmp removeFromSuperview];
    }
    
    UIButton *tmpBtn = sender;
    int index = (int)tmpBtn.tag;
    
    arr_trackBtns[index] =  !arr_trackBtns[index];
    for (int i = 0; i < 5; i++) {
        arr_statusOfBtns[i] = arr_statusOfBtns[i] ^ arr_trackBtns[i];
        
        if (arr_statusOfBtns[i]) {
            UILabel *tmpLabel = [_arr_labelArray objectAtIndex:i];
            tmpLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:15];
            
            UIView *tmpView = [_arr_circleViewArray objectAtIndex:i];
            tmpView.backgroundColor = [_arr_colorArray objectAtIndex:i];
            
            UIImageView *uiiv_overLay = [[UIImageView alloc] init];
            uiiv_overLay.frame = _uiiv_baseMap.bounds;
            uiiv_overLay.image = [UIImage imageNamed:[_arr_overLayImage objectAtIndex:i]];
            uiiv_overLay.tag = 100;
            uiiv_overLay.contentMode = UIViewContentModeScaleAspectFit;
            [_uiiv_baseMap addSubview: uiiv_overLay];
        }
    }
    
}
#pragma mark - Set Zooming Scroll View
-(void)unlockZoom {
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = 1.0;
}

-(void)lockZoom {
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
}

-(void)resetScroll {
    _scrollView.zoomScale = 1.0;
}

-(void)zoomableScrollview:(id)sender withImage:(UIImageView*)thisImage {
    
	self.scrollView.tag = 11000;
	//Pinch Zoom Stuff
	_scrollView.maximumZoomScale = 4.0;
	_scrollView.minimumZoomScale = 1.0;
	_scrollView.clipsToBounds = YES;
	_scrollView.scrollEnabled = YES;
    
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMyPlan:)];
    
	[doubleTap setDelaysTouchesBegan : YES];
    [doubleTap setNumberOfTapsRequired:2];
	[doubleTap setDelegate:self];
	[_scrollView addGestureRecognizer:doubleTap];
}

-(void)zoomMyPlan:(UITapGestureRecognizer *)sender {
	
	// 1 determine which to zoom
	UIScrollView *tmp;
	
	tmp = _scrollView;
	
	CGPoint pointInView = [sender locationInView:tmp];
	
	// 2
	CGFloat newZoomScale = tmp.zoomScale * 2.0f;
	newZoomScale = MIN(newZoomScale, tmp.maximumZoomScale);
	
	// 3
	CGSize scrollViewSize = tmp.bounds.size;
	
	CGFloat w = scrollViewSize.width / newZoomScale;
	CGFloat h = scrollViewSize.height / newZoomScale;
	CGFloat x = pointInView.x - (w / 2.0f);
	CGFloat y = pointInView.y - (h / 2.0f);
	CGRect rectToZoomTo = CGRectMake(x, y, w, h);
	// 4
	
    if (tmp.zoomScale > 1.9) {
        [tmp setZoomScale: 1.0 animated:YES];
		
    } else if (tmp.zoomScale < 2) {
		[tmp zoomToRect:rectToZoomTo animated:YES];
		
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	//return uiiv_contentBG;
	return _uiv_windowComparisonContainer;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
	
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
	
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
	
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UIView *dropPinView in _uiiv_baseMap.subviews) {
        if (dropPinView.tag != 100) {
            CGRect oldFrame = dropPinView.frame;
            // 0.5 means the anchor is centered on the x axis. 1 means the anchor is at the bottom of the view. If you comment out this line, the pin's center will stay where it is regardless of how much you zoom. I have it so that the bottom of the pin stays fixed. This should help user RomeoF.
            //[dropPinView.layer setAnchorPoint:CGPointMake(0.5, 1)];
            [dropPinView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            dropPinView.frame = oldFrame;
            // When you zoom in on scrollView, it gets a larger zoom scale value.
            // You transform the pin by scaling it by the inverse of this value.
            dropPinView.transform = CGAffineTransformMakeScale(1.0/_scrollView.zoomScale, 1.0/_scrollView.zoomScale);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
