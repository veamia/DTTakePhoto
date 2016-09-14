//
//  DTTakePhoto.m
//  DTUtils
//
//  Created by zhaojh on 17/7/14.
//  Copyright (c) 2014年 zjh. All rights reserved.
//

#import "DTTakePhoto.h"

@interface DTTakePhoto ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation DTTakePhoto

- (instancetype)init
{
    return [self initWithTakePhotoType:TakePhotoFromCamera];
}

- (instancetype)initWithTakePhotoType:(TakePhotoType)type
{
    if (self = [super init]) {
        self.type = type;
        self.isEdit = NO;
        self.isSaveToAlbum = NO;
    }
    return self;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (void)addIndicatorViewToPickerView:(UIView *)pickerView
{
    self.indicatorView.center = pickerView.center;
    [pickerView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (void)removeIndicatorViewFromPikerView:(UIView *)pickerView
{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
}

- (void)startTakePhotoFromViewControl:(UIViewController *)viewControl
                             complete:(CompleteTakePhotoBlock)complete
{
    self.blockComplete = complete;
    UIImagePickerControllerSourceType sourceType;
    switch (self.type) {
        case TakePhotoFromCamera:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case TakePhotoFromPhotoLibrary:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case TakePhotoSavedPhotosAlbum:
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        default:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = self.isEdit;
        picker.editing = YES;
        picker.sourceType = sourceType;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        [viewControl presentViewController:picker animated:YES completion:NULL];
    } else {
//        if (complete) {
//            complete(nil, nil);
//        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)dismissPickerViewController:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.blockComplete = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {

    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self addIndicatorViewToPickerView:picker.view];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        UIImage *image = nil;
        NSString *videoPath = nil;
        if ([mediaType isEqualToString:@"public.image"]) {
            UIImage *originImage;
            if (self.isEdit) {
                originImage = [info objectForKey:UIImagePickerControllerEditedImage];
            } else {
                originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            
            if (self.isSaveToAlbum) {
                UIImageWriteToSavedPhotosAlbum(originImage, NULL, NULL, NULL);
            }
            
            UIImage *scaleImage = originImage;
            //[UIImage scaleImage:originImage toScale:0.3];
            
            NSData  *data;
            if (UIImagePNGRepresentation(scaleImage) == nil) {
                data = UIImageJPEGRepresentation(scaleImage, 0.9);
            } else {
                data = UIImagePNGRepresentation(scaleImage);
            }
            image = [UIImage imageWithData:data];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeIndicatorViewFromPikerView:picker.view];
            if (self.blockComplete) {
                self.blockComplete(image, videoPath);
            }
            [self dismissPickerViewController:picker];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPickerViewController:picker];
}

@end
