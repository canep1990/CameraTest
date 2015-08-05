//
//  ViewController.m
//  CameraTest
//
//  Created by Юрий Воскресенский on 05.08.15.
//  Copyright (c) 2015 Юрий Воскресенский. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

/** Constant for size offset */
CGFloat const kSizeOffset = 60;

/** Constant for start view title */
NSString * const kVideoStartTitle = @"Start";

/** Constant for stop view title */
NSString * const kVideoStopTitle = @"Stop";

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

/** Button to display video */
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

/** Current device */
@property (weak, nonatomic) AVCaptureDevice *currentDevice;

/** The capture session takes the input from the camera and capture it */
@property (nonatomic, strong) AVCaptureSession *captureSession;

/** Layer for displaying video */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (IBAction)startVideo:(id)sender
{
    if (self.captureSession.running)
    {
        [self.captureSession stopRunning];
        [self.videoButton setTitle:kVideoStartTitle forState:UIControlStateNormal];
    }
    else
    {
        [self.videoButton setTitle:kVideoStopTitle forState:UIControlStateNormal];
        [self startVideo];
    }
}

- (void)startVideo
{
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    NSArray *devicesArray = [AVCaptureDevice devices];
    if (devicesArray && devicesArray.count > 0)
    {
        for (AVCaptureDevice *device in devicesArray)
        {
            if ([device hasMediaType:AVMediaTypeVideo])
            {
                if(device.position == AVCaptureDevicePositionBack)
                {
                    self.currentDevice = device;
                    [self showVideo];
                }
            }
        }
    }
}

- (void)showVideo
{
    NSError *error = nil;
    [self.captureSession addInput:[[AVCaptureDeviceInput alloc] initWithDevice:self.currentDevice error:&error]];
    if (!error)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.view.layer addSublayer:self.previewLayer];
        CGRect frame = self.view.layer.frame;
        frame.origin.y = kSizeOffset;
        frame.size.height = frame.size.height - kSizeOffset;
        self.previewLayer.frame = frame;
        [self.captureSession startRunning];
    }
    else
    {
        NSLog(@"error: %@", error.localizedDescription);
    }
}

@end
