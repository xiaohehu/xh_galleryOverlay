//
//  ViewController.m
//  xh_galleryOverlay
//
//  Created by Xiaohe Hu on 6/10/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL        arr_statusOfBtns[5];
    BOOL        arr_trackBtns[5];
}
@property (nonatomic, strong)       NSMutableArray          *arr_ctrlBtnArray;
@property (nonatomic, strong)       NSMutableArray          *arr_circleViewArray;
@property (nonatomic, strong)       NSMutableArray          *arr_labelArray;
@property (nonatomic, strong)       NSMutableArray          *arr_colorArray;
@property (nonatomic, strong)       NSArray                 *arr_overLayImage;
@property (nonatomic, strong)       NSArray                 *arr_overLayNames;

@property (nonatomic, strong)       UIView                  *uiv_buttonContainer;
@property (nonatomic, strong)       UIImageView             *uiiv_baseMap;
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
    //Init ImageView
    _uiiv_baseMap = [[UIImageView alloc] init];
    _uiiv_baseMap.frame = CGRectMake(0.0, 46, self.view.bounds.size.width, 554);
    _uiiv_baseMap.image = [UIImage imageNamed:@"ABOUT_SECTION_00_BASE.png"];
    _uiiv_baseMap.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview: _uiiv_baseMap];
    
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
            uiiv_overLay.contentMode = UIViewContentModeScaleAspectFit;
            [_uiiv_baseMap addSubview: uiiv_overLay];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
