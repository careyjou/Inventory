//
//  CameraPoseFinder_Wrapper.h
//  Inventory
//
//  Created by Vincent Spitale on 1/10/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKitTypes.h>
#import "point_3d.h"

typedef struct CAMERAPOSEFINDERRESULT_ {
    SCNMatrix4 matrix;
    float error;
}CAMERAPOSEFINDERRESULT;



@interface CameraPoseFinder_Wrapper : NSObject
-(CAMERAPOSEFINDERRESULT) getCameraPose:(POINT3D[]) queryCloud queryCloudSize: (int) queryCloudSize referenceCloud: (POINT3D[]) referenceCloud referenceCloudSize: (int) referenceCloudSize;
@end

