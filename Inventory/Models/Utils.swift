//
//  Utils.swift
//  Inventory
//
//  Created by Vincent Spitale on 8/4/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation
import SwiftUI

public class Utils {
    
    /// Return the singular or plural string based on the given integer.
    /// - Parameters:
    ///   - int: Number to be described
    ///   - singular: Singular language
    ///   - plural: Plural language
    /// - Returns: The correct language for the given number of objects.
    static func singularPluralLanguage(int: Int, singular: String, plural: String) -> String {
        return (int == 1) ? singular : plural
    }
    
    /// Convert a point cloud to a ply file.
    /// - Parameters:
    ///   - points: Point cloud
    ///   - url: File location
    static func plyFileFromPoints(points: [PointCloudVertex], url: URL) {
        let header: String = ["ply", "format ascii 1.0", "comment Created by Inventory", "element vertex \(points.count)", "property float x", "property float y", "property float z", "property uchar red", "property uchar green", "property uchar blue", "end_header"].joined(separator: "\n")
        
        
        
        var allPoints = ""
        
        for p in points {
            let point = ["\(p.x)", "\(p.y)", "\(p.z)", "\(Utils.getUchar(float: p.r))", "\(Utils.getUchar(float: p.g))", "\(Utils.getUchar(float: p.b))"].joined(separator: " ")
            allPoints += String(point + "\n")
        }
        
        if allPoints.hasSuffix("\n") {
        allPoints.removeLast(2)
        }
        
        let text = [header, allPoints].joined(separator: "\n")
        
        do {
        try text.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            print("Could not create ply")
        }
        
    }
    
    
    /// Encode the given point cloud to a json file.
    /// - Parameters:
    ///   - points: Point cloud
    ///   - url: File location
    static func JSONFromPoints(points: [PointCloudVertex], url: URL) {
        guard let data = try? JSONEncoder().encode(PointCloud(pointCloud: points)) else {
            return
        }
        do {
        try data.write(to: url)
        }
        catch {
            print("Could not create ply")
        }
    }
    
    /// Convert json encoded point cloud to PointCloud.
    /// - Parameter url: File location
    /// - Returns: Decoded point cloud
    static func pointsFromJSON(url: URL) -> PointCloud? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(PointCloud.self, from: data)
    }
    
    /// Convert ply file to PointCloud.
    /// - Parameter url: ply file location
    /// - Returns: Translated point cloud
    static func pointsFromPLY(url: URL) -> PointCloud? {
        
        var n = 0
        var pointCloud = [PointCloudVertex]()
        
        
        if let data = try? String(contentsOf: url) {
            var isData = false
            
            data.enumerateLines {
                line, stop in
                if line.hasPrefix("element vertex ") {
                    n = Int(line.components(separatedBy: " ")[2])!
                }
                else if line.hasPrefix("end_header") {
                    isData = true
                }
                else if isData {
                    guard let x = Float(line.components(separatedBy: " ")[0]) else {
                        return
                    }
                    guard let y = Float(line.components(separatedBy: " ")[1]) else {
                        return
                    }
                    guard let z = Float(line.components(separatedBy: " ")[2]) else {
                        return
                    }
                    guard let r = UInt8(line.components(separatedBy: " ")[3]) else {
                        return
                    }
                    guard let g = UInt8(line.components(separatedBy: " ")[4]) else {
                        return
                    }
                    guard let b = UInt8(line.components(separatedBy: " ")[5]) else {
                        return
                    }
                    
                    pointCloud.append(PointCloudVertex(x: x, y: y, z: z, r: Utils.getFloat(uchar: r), g: Utils.getFloat(uchar: g), b: Utils.getFloat(uchar: b)))
                }
            }
                   
                       
                        
                        
                        

                        print("Point cloud data loaded: \(n) points")
                    
                
        }
        else {
            return nil
        }
        return PointCloud(pointCloud: pointCloud)
    }
    
    
    /// Converts the float color value to srgb compoenent.
    /// - Parameter float: floating point color component
    /// - Returns: srgb component
    static func getUchar(float: Float) -> UInt8 {
        return UInt8(min(floor(abs(float) * 255), 255))
    }
    
    
    /// Convert from srgb to to float color component
    /// - Parameter uchar: srgb component
    /// - Returns: floating point color component
    static func getFloat(uchar: UInt8) -> Float {
        return Float(uchar) / 255.0
    }
    


    
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}


