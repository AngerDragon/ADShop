/*!
 @header FrontiaPersonalStorageDalegate.h
 @abstract 对个人云存储PCS(Personal Cloud Storage)的操作涉及的数据结构。
 @version 1.00 2013/06/19 Creation
 @copyright (c) 2013 baidu. All rights reserved.
 */

/*!
 @class FrontiaPersonalFileInfo
 @abstract 记录PCS上的文件的文件信息的数据结构。
 */
@interface FrontiaPersonalFileInfo : NSObject

/*!
 @property path
 @abstract 文件的绝对路径。
 */
@property(strong, nonatomic) NSString *path;

/*!
 @property mTime
 @abstract 文件最近一次被修改的时间。
 */
@property(assign, nonatomic) long mTime;

/*!
 @property cTime
 @abstract 文件被创建的时间。
 */
@property(assign, nonatomic) long cTime;

/*!
 @property md5
 @abstract 文件内容的MD5。
 */
@property(strong, nonatomic)NSString *md5;

/*!
 @property size
 @abstract 文件的大小。
 */
@property(assign, nonatomic) int size;

/*!
 @property isDir
 @abstract 判定该文件是否是文件夹。TRUE表示是文件夹。
 */
@property(assign, nonatomic) BOOL isDir;

/*!
 @property hasSubFolder
 @abstract 判定该文件是否包含子文件夹。TRUE表示包含子文件夹。
 */
@property(assign, nonatomic) BOOL hasSubFolder;

@end

/*!
 @abstract 监视向PCS上传文件，或是从PCS下载文件的进度的监听器。
 @param file
 被上传或下载的文件的文件名。
 @param bytes
 当前已上传或下载的字节数。
 @param total
 被上传或下载的文件的大小（总字节数）。
 @result
 无。
 */
typedef void(^FrontiaPersonalProgressCallback)(NSString* file, long bytes, long total);

/*!
 @abstract PCS相关操作失败的回调函数。
 @param errorCode
 错误码。
 @param errorMessage
 错误原因。
 @result
 无。
 */
typedef void(^FrontiaPersonalFailureCallback)(int errorCode, NSString* errorMessage);

/*!
 @abstract 操作pCS文件成功时的回调函数。
 @param fileName
    被操作文件的文件名。
 @result
    无。
 */
typedef void(^FrontiaPersonalFileOperationCallBack)(NSString *fileName);


/*!
 @abstract 上传文件到PCS的回调函数。
 @param target
     文件上传到的PCS路径。
 @param result
     PCS文件的文件信息。
 @result
     无。
 */
typedef void(^FrontiaPersonalUploadResultCallback)(NSString *target, FrontiaPersonalFileInfo *result);

/*!
 @abstract 下载PCS文件的回调函数。
 @param file
     要被下载的PCS文件。
 @param data
     下载到本地的文件内容。
 @result
     无。
 */
typedef void(^FrontiaPersonalDownloadCallback)(NSString* file, NSData *data);

/*!
 @abstract 列举PCS上所有文件的回调函数。
 @param list
     列举出的PCS文件列表。
 @result
     无。
 */
typedef void(^FrontiaPersonalListCallback)(NSArray *list);


/*!
 @abstract 查询PCS配额的回调函数。
 @param used
     已经使用的PCS配额。
 @param total
     可供使用的PCS配额。
 @result
     无。
 */
typedef void(^FrontiaPersonalQuotaCallback)(long long used, long long total);

