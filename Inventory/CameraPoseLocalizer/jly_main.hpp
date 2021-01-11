//
//  jly_main.hpp
//  Inventory
//
//  Created by Vincent Spitale on 1/10/21.
//  Copyright © 2021 Vincent Spitale. All rights reserved.
//

#include "jly_goicp.h"

class CameraPoseFinder {
public:
    float * cameraPose(POINT3D queryPointCloud[], int sizeQueryCloud, POINT3D referencePointCloud[], int sizeReferenceCloud);
};
