//
//  CameraPoseFinder_Wrapper.m
//  Inventory
//
//  Created by Vincent Spitale on 1/10/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

#import "CameraPoseFinder_Wrapper.h"
#import "jly_main.hpp"

@implementation CameraPoseFinder_Wrapper

-(CAMERAPOSEFINDERRESULT) getCameraPose:(POINT3D[]) queryCloud queryCloudSize: (int) queryCloudSize referenceCloud: (POINT3D[]) referenceCloud referenceCloudSize: (int) referenceCloudSize {
    CameraPoseFinder finder;
    GoICP goicp = finder.cameraPose(queryCloud, queryCloudSize, referenceCloud, referenceCloudSize);
    
    Matrix optR = goicp.optR;
    Matrix optT = goicp.optT;
    
    
    CAMERAPOSEFINDERRESULT result = CAMERAPOSEFINDERRESULT();
    
    result.matrix = SCNMatrix4();
    result.error = goicp.optError;
    
    
    return result;
}

@end
