/*!
 @header FrontiaPersonalStorageModel.h
 @abstract 提供对个人云存储PCS(Personal Cloud Storage)的操作的模块。
 @discussion 在正式使用个人云存储之前，需要到百度开发者中心进行特定的权限开通，管理中心－>应用管理－>应用－>API列表，在这个页面开通PCS API列表就可以了。
     在调用这个类之前需要先完成授权工作，设置当前用户，必须时通过百度帐号来进行登陆，而且scope必须包括授权声明：basic和netdisk。
     在开通个人云存储之后就可以直接使用了，下边示例，
 
       FrontiaAuthorization *auth = [Frontia getAuthorization];
     
       NSMutableArray *scope = [[NSMutableArray alloc] init];
       [scope addObject:@"basic"];
       [scope addObject:@"netdisk"];
 
       [auth authorizeWithController:yourUIController
                          platform:FRONTIA_SOCIAL_PLATFORM_BAIDU
                             scope:scope
                    cancelListener:onCancel
                   failureListener:onFailure
                    resultListener:onResult];
      
        //in onResult, get the user
        [Frontia setCurrentAccount:user];
 
  	    FrontiaPersonalStorage *personalStorage = [Frontia getPersonalStorage];
  	    [personalStorage quota:listener];
 
  	  如果需要访问图片流，视频流等，需要scope包含如下额外授权声明：
  	    图片流：pcs_album
  	    视频流：pcs_video
  	    音乐流：pcs_music
  	    文档流：pcs_doc
 @version 1.00 2013/06/19 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IModule.h"
#import "FrontiaPersonalStorageDelegate.h"

/*!
 @class FrontiaPersonalStorage
 @abstract 提供对个人云存储的操作的模块。
 */
@interface FrontiaPersonalStorage : NSObject <IModule>

/*!
 @method uploadFileWithData
 @abstract 将指定文件上传到个人云存储的指定路径，可监控上传的进度。
 @param data
     指定文件
 @param target
     个人云存储上的指定路径。
 @param statusListener
     监听上传进度的监听器。
 @param resultListener
     上传成功后的回调函数。
 @param failureListener
     上传失败后的回调函数。
 @result 无
 */
-(void)uploadFileWithData:(NSData*)data
                   target:(NSString*)target
           statusListener:(FrontiaPersonalProgressCallback)statusListener
           resultListener:(FrontiaPersonalUploadResultCallback)resultListener
          failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method uploadFileWithData
 @abstract 将指定文件上传到个人云存储的指定路径，没有上传进度监听。
 @param data
     指定文件
 @param target
     个人云存储上的指定路径。
 @param resultListener
     上传成功后的回调函数。
 @param failureListener
     上传失败后的回调函数。
 @result 无
 */
-(void)uploadFileWithData:(NSData*)data
                   target:(NSString*)target
           resultListener:(FrontiaPersonalUploadResultCallback)resultListener
          failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method downloadFileWithSource
 @abstract 将个人云存储上指定路径的文件下载到本地，没有下载进度监听。
 @param source
     个人云存储上指定路径的文件。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 @result 无
 */
-(void)downloadFileWithSource:(NSString*)source
                    resultListener:(FrontiaPersonalDownloadCallback)resultListener
                   failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method downloadFileWithSource
 @abstract 将个人云存储上指定路径的文件下载到本地，可监控下载的进度。
 @param accessToken
     access token
 @param source
     个人云存储上指定路径的文件。
 @param statusListener
     监听下载进度的监听器。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 @result 无
 */
-(void)downloadFileWithSource:(NSString*)source
               statusListener:(FrontiaPersonalProgressCallback)statusListener
               resultListener:(FrontiaPersonalDownloadCallback)resultListener
              failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method downloadFileFromStreamWithSource
 @abstract 将个人云存储上指定路径的fstream文件下载到本地，可监控下载的进度。
 @param source
     个人云存储上指定路径的文件。
 @param statusListener 
     监听下载进度的监听器。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 */
-(void)downloadFileFromStreamWithSource:(NSString*)source
                         statusListener:(FrontiaPersonalProgressCallback)statusListener
                         resultListener:(FrontiaPersonalDownloadCallback)resultListener
                        failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method downloadFileFromStreamWithSource
 @abstract 将个人云存储上指定路径的fstream文件下载到本地。
 @param source
     个人云存储上指定路径的文件。
 @param resultListener
     下载成功后的回调函数。
 @param failureListener
     下载失败后的回调函数。
 */
-(void)downloadFileFromStreamWithSource:(NSString*)source
                         resultListener:(FrontiaPersonalDownloadCallback)resultListener
                        failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method stopDownloadingWithSource
 @abstract 停止所有下载个人云存储上同一路径下的文件的任务。
 @param source
 被下载的云端文件的路径。
 */
-(void)stopDownloadingWithSource:(NSString*)source;

/*!
 @method stopUploadingWithTarget
 @abstract 停止所有上传到个人云存储上同一路径的任务。
 @param target
 文件被上传到的云端路径。
 */
-(void)stopUploadingWithTarget:(NSString*)target;

/*!
 @method deleteFileWithPath
 @abstract 将个人云存储上指定路径的文件删除。
 @param filePath 
     个人云存储上指定路径的文件。
 @param resultListener 
     删除成功后的回调函数。
 @param failureListener
     删除失败后的回调函数。
 */
-(void)deleteFileWithPath:(NSString*)filePath
           resultListener:(FrontiaPersonalFileOperationCallBack)resultListener
          failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method listWithPath
 @abstract 列举个人云存储上存储在给定路径下的所有文件。
 @param path
     个人云存储上的给定路径。
 @param resultListener
     列举成功后的回调函数。
 @param failureListener
     列举失败后的回调函数。
 */
-(void)listWithPath:(NSString*)path
     resultListener:(FrontiaPersonalListCallback)resultListener
    failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method listWithPath
 @abstract 列举个人云存储上存储在给定路径下的所有文件，列举结果根据给定角色进行排序。
 @param path
     个人云存储上的给定路径。
 @param by 
     给定角色，可以是多个角色。
 @param order
     排序方法。
 @param resultListener
     列举成功后的回调函数。
 @param failureListener
     列举失败后的回调函数。
 */
-(void)listWithPath:(NSString*)path
                 by:(NSString*)by
              order:(NSString*)order
    resultListener:(FrontiaPersonalListCallback)resultListener
           failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method imageStream
 @abstract 从个人云存储上获得图片文件。
 @param resultListener
     获取成功后的回调函数。
 @param failureListener
     获取失败后的回调函数。
 */
-(void)imageStream:(FrontiaPersonalListCallback)resultListener
   failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method videoStream
 @abstract 从个人云存储上获得视频文件。
 @param resultListener
     获取成功后的回调函数。
 @param failureListener
     获取失败后的回调函数。
 */
-(void)videoStream:(FrontiaPersonalListCallback)resultListener
   failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method audioStream
 @abstract 从个人云存储上获得音频文件。
 @param resultListener
     获取成功后的回调函数。
 @param failureListener
     获取失败后的回调函数。
 */
-(void)audioStream:(FrontiaPersonalListCallback)resultListener
   failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method docStream
 @abstract 从个人云存储上获得文本文件。
 @param resultListener
     获取成功后的回调函数。
 @param failureListener
     获取失败后的回调函数。
 */
-(void)docStream:(FrontiaPersonalListCallback)resultListener
 failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method makeDirWithPath
 @abstract 在个人云存储的指定路径创建新文件夹。
 @param path
     个人云存储的指定路径。
 @param resultListener
     获取成功后的回调函数。
 @param failureListener
     获取失败后的回调函数。
 */
-(void)makeDirWithPath:(NSString*)path
        resultListener:(FrontiaPersonalFileOperationCallBack)resultListener
       failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method thumbnailWithPath
 @abstract 为个人云存储上指定路径的图片生成本地缩略图。
 @param path
     个人云存储上指定路径的图片。
 @param quality
     缩略图的质量，范围是开区间：(0,100]。
 @param width
     缩略图的宽，最大值是850。
 @param height
     缩略图的高，最大值是580。
 @param resultListener
     本地缩略图生成成功后的回调函数。
 @param failureListener
     本地缩略图生成失败后的回调函数。
 */
-(void)thumbnailWithPath:(NSString*)path
                 quality:(int)quality
                   width:(int)width
                  height:(int)height
          resultListener:(FrontiaPersonalDownloadCallback)resultListener
         failureListener:(FrontiaPersonalFailureCallback)failureListener;

/*!
 @method quotaInfo
 @abstract 获取个人云存储配额信息。
 @param resultListener
     获取配额信息成功后的回调函数。
 @param failureListener
     获取配额信息失败后的回调函数。
 */
-(void)quotaInfo:(FrontiaPersonalQuotaCallback)resultListener
 failureListener:(FrontiaPersonalFailureCallback)failureListener;

@end