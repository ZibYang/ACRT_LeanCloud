//
//  USDZModelManagerViewModel.swift
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

import Foundation


class USDZManagerViewModel: ObservableObject {
    var exploreModelList = USDZModelList(usdzModelNameList:  ["qs_AppleLogo_left", //1
                                                              "qs_AppleLogo_right", //2
                                                              "qs_AppleMusic", //3
                                                              "qs_AppStore", //4
                                                              "qs_Calendar", //5
                                                              "qs_Camera", //5
                                                              "qs_Facetime", //6
                                                              "qs_Health", //7
                                                              "qs_Hello", //8
                                                              "qs_Home", //9
                                                              "qs_iBook", //10
                                                              "qs_iMessage", //11
                                                              "qs_Phone", //12
                                                              "qs_Safari", //13
                                                              "qs_Setting", //14
                                                              "qs_Swift", //15
                                                              "qs_SwiftChangeTheWorld", //16
                                                              "qs_Weather", //17
                                                              "yt_BugerKing", //18
                                                              "yt_Burger", //19
                                                              "yt_Cocacola", //20
                                                              "yt_Coffee", // 21
                                                              "yt_FrenchFires", //22
                                                              "yt_KFC", //23
                                                              "yt_McDonald's"], //24
                                                         categoryList: [.other, //1
                                                                        .other, //2
                                                                        .other, //3
                                                                        .other, //4
                                                                        .other, //5
                                                                        .other, //5
                                                                        .other, //6
                                                                        .other, //7
                                                                        .other, //8
                                                                        .other, //9
                                                                        .other, //10
                                                                        .other, //11
                                                                        .other, //12
                                                                        .other, //13
                                                                        .other, //14
                                                                        .other, //15
                                                                        .other, //16
                                                                        .other, //17
                                                                        .other, //18
                                                                        .other, //19
                                                                        .other, //20
                                                                        .other, // 21
                                                                        .other, //22
                                                                        .other, //23
                                                                        .other])  //24
    
    var createModelList = USDZModelList(usdzModelNameList:["user_like_blue", //1
                                                           "user_like_green", //2
                                                           "user_like_purple", //3
                                                           "user_like_red", //4
                                                           "user_like_yellow", //5
                                                           "user_love_red", //6
                                                           "user_love_white", //7
                                                           "user_letter_A", //1
                                                           "user_letter_B", //2
                                                           "user_letter_C", //3
                                                           "user_letter_D" //4
                                                          ],
                                        categoryList:[.foundmental, //1
                                                      .foundmental, //2
                                                      .foundmental, //3
                                                      .foundmental, //4
                                                      .foundmental, //5
                                                      .foundmental, //6
                                                      .foundmental, //7
                                                      .letter, //1
                                                      .letter, //2
                                                      .letter, //3
                                                      .letter //4
                                                     ])
    
//    func AreModelLibrariesLoaded() -> Bool {
//        return exploreModelList.AreModelsLoaded() && createModelList.AreModelsLoaded()
//    }
    
}
