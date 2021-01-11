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

-(CAMERAPOSEFINDERRESULT) getCameraPose:(SCNVector3[]) queryCloud secondCloud: (SCNVector3[]) referenceCloud {
    CameraPoseFinder finder;
    POINT3D *query = {};
    POINT3D *reference = {};
    finder.cameraPose(query, 0, reference, 0);
    return CAMERAPOSEFINDERRESULT();
}

@end
