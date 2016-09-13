//
//  DTTakePhoto.h
//  DTUtils
//
//  Created by zhaojh on 17/7/14.
//  Copyright (c) 2014年 zjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TakePhotoType)
{
    TakePhotoFromCamera,        //调用摄像头
    TakePhotoFromPhotoLibrary,  //调用图片库
    TakePhotoSavedPhotosAlbum   //调用iOS设备中的胶卷相机的图片.
};

//完成照相后获取到图片回调
typedef void (^CompleteTakePhotoBlock) (UIImage *image, NSString *videoPath);

@interface DTTakePhoto : NSObject 

@property (nonatomic) TakePhotoType type;   // 选择获取照片的方式，默认为TakePhotoFromCamera
@property (nonatomic) BOOL isEdit;          //是否可以编辑， 默认为NO
@property (nonatomic) BOOL isSaveToAlbum;   //是否保存到相册，默认为NO
@property (nonatomic, copy) CompleteTakePhotoBlock blockComplete;

- (instancetype)initWithTakePhotoType:(TakePhotoType)type;

- (void)startTakePhotoFromViewControl:(UIViewController *)viewControl
                             complete:(CompleteTakePhotoBlock)complete;

@end
