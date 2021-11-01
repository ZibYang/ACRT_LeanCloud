//
//  WelcomePageDetail.swift
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

// [center] reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-adjust-text-alignment-using-multilinetextalignment

import SwiftUI

struct WelcomePageDetail: View {
    var imageName: String
    var title: String
    var detail: String
    var theColor: Color
    
    var body: some View {
        VStack {
            // MARK: Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack(spacing: 0) {
                // MARK: Title
                Text(title)
            }
            .font(.largeTitle)
            .foregroundColor(theColor)
            .offset(y: -50)
            
            // MARK: title with localized String
            Text(LocalizedStringKey(title))
                .foregroundColor(.secondary)
                .font(.title2)
                .offset(y: -40)
            
            // MARK: Detail
            Text(LocalizedStringKey(detail))
                .multilineTextAlignment(.center)  // [center]
                .foregroundColor(.secondary)
                .offset(y: -20)
                .padding(.horizontal)
        }
        .padding()
    }
}

// reference: https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(0).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct WelcomePageDetail_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageDetail(imageName: "Welcome_A",
                          title: "Augmented",
                          detail:"A stands for Augmented Reality which enhanced the version of the real physical world, achieved through our iPhone and  iPad.",
                          theColor: Color(red: 0.15, green: 0.39, blue: 0.94))
    }
}
