//
//  EffectsViewController.m
//  PhotoTwist
//
//  Created by Shriniket Sarkar on 2/18/12.
//  Copyright (c) 2012 CTS. All rights reserved.
//

#import "EffectsViewController.h"

@implementation EffectsViewController
@synthesize btnGrayImage;
@synthesize btnNegative;
@synthesize imageViewEffectsVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setImageViewEffectsVC:nil];
    [self setBtnGrayImage:nil];
    [self setBtnNegative:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnNegateImage:(id)sender {
}

- (IBAction)btnGrayImage:(id)sender 
{
    
    UIImage *sourceImage = imageViewEffectsVC.image;
    
    int width = sourceImage.size.width;
	int height = sourceImage.size.height;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

	CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    
	CGColorSpaceRelease(colorSpace);
    
	if (context)
    {
        CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
        UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
        imageViewEffectsVC.image = grayImage;
	}
}
@end
