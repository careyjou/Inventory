//
//  AddSpaceView.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/17/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct AddSpaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var controller: InventoryController
    @ObservedObject var locationManager = LocationManager()
    
    @State private var name = ""
    @State private var note = ""
    
    
    
    var body: some View {
        return NavigationView{
            ScrollView{
                VStack(){
                    HStack{
                        Text("Name")
                            .bold()
                        TextField("Name", text:$name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    
                }
                .padding()
            }
            .navigationBarTitle(Text("Add Space"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: { presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SecondaryCircleButton()),
                                trailing:
                Button(action: { self.addSpace()}) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(SecondaryCircleButton()))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func addSpace() {
        if let pointCloud = controller.pointCloud {
            
            
            let cloud = Cloud(moc: moc)
            
            var location: Location? = nil
            
            if let loc = self.locationManager.lastLocation {
                location = Location(moc: moc, location: loc)
            }
            
            let space = Space(moc: moc, name: self.name, pointCloud: cloud, location: location)
            
            
            if let key = cloud.id{
                let data = (UIApplication.shared.delegate as! AppDelegate).data
                DispatchQueue.global(qos: .userInitiated).async {
                data.addPointCloud(key: key, pointCloud: PointCloud(pointCloud: pointCloud), cloud: cloud)
                
                    DispatchQueue.main.async {
                        try? moc.save()
                    }
                
                }
                
            }
            
        
            self.presentationMode.wrappedValue.dismiss()
        
        }
        
    }
    
    
    
    
}


