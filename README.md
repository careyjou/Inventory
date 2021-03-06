![Inventory](./images/banner.jpeg)
#  inventory

An augmented reality iOS app that allows users to document where their belongings are in physical space. Full functionality of the app is only available on Apple devices with a LiDAR scanner since the core-functionality works by capturing high-fidelity point clouds. 

![Inventory App](./images/inventory.png)
![Inventory AR System](./images/augmented-reality.gif)
![Inventory 3D Viewer](./images/3d-viewer.gif)

## Technologies
The point cloud capture system builds upon [the ARKit 4 Point Cloud Demo App](https://developer.apple.com/documentation/arkit/environmental_analysis/visualizing_a_point_cloud_using_scene_depth). A lot of work was put in to make the point cloud data accessible to the the cpu by extracting the data from the gpu buffers.

Currently the system is integrated with the [Go-ICP algorithm](https://github.com/kuwt/GOICP) to register captured point clouds. The functionality is abstracted so the registration algorithm can be easily replaced in the future. A key feature is the app discretely captures a point cloud in the background in the augmented reality view to localize the device. Point clouds are cached for quick access and will automatically be deleted if the device needs to free memory.
