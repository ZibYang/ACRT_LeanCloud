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
    
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                VStack{
                    ForEach(ModelCategory.allCases, id: \.self){ category in
                        if let modelsByCategory = usdzManagerViewModel.createModelList.get(category: category){
                            
                            VStack(alignment: .leading){
                                Divider()
                                Text(LocalizedStringKey(category.label))
                                    .font(.headline)
                                    .padding(.leading)
                                ScrollView(.horizontal, showsIndicators: false){
                                    LazyHGrid(rows: gridItemLayout){
                                        ForEach(0..<modelsByCategory.count){ index in
                                            let model = modelsByCategory[index]
                                            Button(action:{
                                                placementSetting.selectedModel = model.modelName
                                                print("DEBUG(BCH): select \(placementSetting.selectedModel)")
                                                dismissSheet()
                                            }, label:{
                                                if let unwrapedUIImage = model.modelPreviewImage {
                                                    Image(uiImage: unwrapedUIImage)
                                                        .resizable()
                                                        .frame(width: 100, height: 100)
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
                        }
                    }
                }
            }
            .navigationBarTitle(Text("My models"), displayMode: .large)
            .navigationBarItems(trailing:
                  Button(action: {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                    dismissSheet()
                }, label: {
                    Text("Cancel")
                }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}


struct ModelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ModelPickerView()
            .environmentObject(PlacementSetting())
            .environmentObject(USDZManagerViewModel())
    }
}
