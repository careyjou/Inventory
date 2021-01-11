//
//  CameraPoseFinder_Wrapper.h
//  Inventory
//
//  Created by Vincent Spitale on 1/10/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKitTypes.h>

typedef struct CAMERAPOSEFINDERRESULT_ {
    SCNMatrix4 matrix;
    float confidence;
}CAMERAPOSEFINDERRESULT;


@interface CameraPoseFinder_Wrapper : NSObject
-(CAMERAPOSEFINDERRESULT) getCameraPose:(SCNVector3[]) queryCloud secondCloud: (SCNVector3[]) referenceCloud;
@end

