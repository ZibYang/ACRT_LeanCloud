//
//  ModelPickerView.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct ModelPickerView: View {
    @Environment(\.dismiss) var dismissSheet
    @EnvironmentObject var usdzManagerViewModel : USDZManagerViewModel
    @EnvironmentObject var placementSetting: PlacementSetting
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                VStack{
                    ForEach(ModelCategory.allCases, id: \.self){ category in
                        if let modelsByCategory = usdzManagerViewModel.createModelList.get(category: category){
                            HorizontalGrid(title: category.label, items: modelsByCategory)
                                .environmentObject(placementSetting)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Models"), displayMode: .large)
            .navigationBarItems(trailing:
                  Button(action: {
                    dismissSheet()
                }, label: {
                    Text("Cancel")
                }))
        }
    }
}

struct HorizontalGrid: View{
    let title: String
    let items: [USDZModel]
    @Environment(\.dismiss) var dismissSheet
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    @EnvironmentObject var placementSetting: PlacementSetting
    
    var body: some View{
        VStack(alignment: .leading){
            Divider()
            Text(LocalizedStringKey(title))
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false){
                LazyHGrid(rows: gridItemLayout){
                    ForEach(0..<items.count){ index in
                        let model = items[index]
                        Button(action:{
                            placementSetting.selectedModel = model.modelName
                            print("DEBUG(BCH): select \(placementSetting.selectedModel)")
                            dismissSheet()
                        }, label:{
                            if let unwrapedUIImage = model.modelPreviewImage {
                                Image(uiImage: unwrapedUIImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    //.aspectRatio(1/1, contentMode: .fit)
                                    //.background(Color(UIColor.secondarySystemFill))
                                    //.cornerRadius(8.0)
                                    .shadow(radius: 2)
                            }else{
                                Image(uiImage: UIImage(systemName: "photo")!)
                                    .resizable()
                                    .frame(height: 150)
                                    .aspectRatio(1.1, contentMode: .fit)
                                    .background(Color(UIColor.secondarySystemFill))
                                    .cornerRadius(8.0)
                            }
                        })
                            .padding()
                    }
                }
            }
        }
        .padding(.leading)
    }
}

struct ModelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ModelPickerView()
            .environmentObject(PlacementSetting())
            .environmentObject(USDZManagerViewModel())
    }
}
