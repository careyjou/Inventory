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
    
    
    SCNMatrix4 matrix = SCNMatrix4();
    // add translation
    matrix.m14 = optT.val[0][0];
    matrix.m24 = optT.val[0][1];
    matrix.m34 = optT.val[0][2];
    
    // add rotation
    matrix.m11 = optR.val[0][0];
    matrix.m21 = optR.val[0][1];
    matrix.m31 = optR.val[0][2];
    
    matrix.m12 = optR.val[1][0];
    matrix.m22 = optR.val[1][1];
    matrix.m32 = optR.val[1][2];
    
    matrix.m13 = optR.val[2][0];
    matrix.m23 = optR.val[2][1];
    matrix.m33 = optR.val[2][2];
    
    // add bottom row
    matrix.m41 = 0;
    matrix.m42 = 0;
    matrix.m43 = 0;
    matrix.m44 = 1;
    
    
    CAMERAPOSEFINDERRESULT result = CAMERAPOSEFINDERRESULT();
    
    result.matrix = matrix;
    result.error = goicp.optError;
    
    return result;
}

@end
