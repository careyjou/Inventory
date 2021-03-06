//
//  ImagePicker.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/17/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import UIKit
public struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    public func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(
            image: $image,
            isPresented: $isPresented
        )
    }
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No op
    }
}
public extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: UIImage?
        public init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
            self._image = image
            self._isPresented = isPresented
        }
    }
}
extension ImagePicker.Coordinator: UIImagePickerControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        isPresented = false
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isPresented = false
    }
}
