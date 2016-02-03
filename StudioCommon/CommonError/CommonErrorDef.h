//
//  CommonErrorDef.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef  kUSERINFO_INPUT_INFO_KEY
#define kUSERINFO_INPUT_INFO_KEY @"UserInfoInputDictKey"

#undef  ERROR_INPUT_INFO
#define ERROR_INPUT_INFO( __error) \
    (__error . userInfo [kUSERINFO_INPUT_INFO_KEY])




