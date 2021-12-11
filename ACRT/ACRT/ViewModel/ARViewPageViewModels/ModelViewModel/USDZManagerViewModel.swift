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
import UIKit


class USDZManagerViewModel: ObservableObject {
    var exploreModelList = USDZModelList(usdzModelNameList:  ["qs_AppleLogo_left.reality":.special, //1
                                                              "qs_AppleLogo_Right.reality":.special, //2
                                                              "qs_AppleMusic.usdz":.special, //3
                                                              "qs_AppStore.usdz":.special, //4
                                                              "qs_Calendar.usdz":.special, //5
                                                              "qs_Camera.usdz":.special, //5
                                                              "qs_Facetime.usdz":.special, //6
                                                              "qs_Health.usdz":.special, //7
                                                              "qs_Hello.usdz":.special, //8
                                                              "qs_Home.usdz":.special, //9
                                                              "qs_iBook.usdz":.special, //10
                                                              "qs_iMessage.usdz":.special, //11
                                                              "qs_Phone.usdz":.special, //12
                                                              "qs_Safari.usdz":.special, //13
                                                              "qs_Setting.usdz":.special, //14
                                                              "qs_Swift.usdz":.special, //15
                                                              "qs_SwiftChangeTheWorld.usdz":.special, //16
                                                              "qs_Weather.usdz":.special, //17
                                                              "yt_BugerKing.usdz":.special, //19
                                                              "yt_Cocacola.usdz":.special, //20
                                                              "yt_Coffee.usdz":.special, // 21
                                                              "yt_FrenchFires.usdz":.special, //22
                                                              "yt_KFC.usdz":.special, //23
                                                              "yt_McDonald's.usdz":.special,//24
                                                              "qs_findMy.usdz":.special, //25
                                                              "qs_Title.usdz":.special, //26
                                                              "qs_contact.usdz":.special, //27
                                                              "qs_AppleLogo_center.usdz":.special,
                                                              "qs_contacts.usdz":.special,
                                                              "qs_zjuLogo.usdz":.special

                                                             ])
    
    var createModelList = USDZModelList(usdzModelNameList:["user_like_blue.reality":.foundmental, //1
                                                           "user_like_red.reality":.foundmental, //2
                                                           "user_love_red.reality":.foundmental, //3
                                                           "user_love_white.reality":.foundmental, //4
                                                           
                                                            "user_letter_A.usdz":.letter, //1
                                                            "user_letter_B.usdz":.letter, //2
                                                            "user_letter_C.usdz":.letter, //3
                                                            "user_letter_D.usdz":.letter, //4
                                                            "user_letter_E.usdz":.letter, //5
                                                            "user_letter_F.usdz":.letter, //6
                                                            "user_letter_H.usdz":.letter, //7
                                                            "user_letter_L.usdz":.letter, //8
                                                            "user_letter_O.usdz":.letter, //9
                                                            "user_letter_P.usdz":.letter, //10
                                                                                
//                                                           "user_message_HELLO!.usdz":.message, //1
//                                                           "user_message_LOL.usdz":.message, //2
//                                                           "user_message_OHNO!.usdz":.message, //3
                                                           "user_message_OMG!.usdz":.message, //4
//                                                           "user_message_OOPS!.usdz":.message, //5
//                                                           "user_message_OUCH!.usdz":.message, //6
//                                                           "user_message_ZZZ...usdz":.message, //7
//                                                           "user_message_POP!.usdz":.message, //8
//                                                           "user_message_POW!.usdz":.message, //9
//                                                           "user_message_SHH!.usdz":.message, //10
//                                                           "user_message_WTF.usdz":.message, //11
//                                                           "user_message_YEAH!.usdz":.message, //12
                                                           "user_message_YES!.usdz":.message, //13
//                                                           "user_message_YES!2.usdz":.message, //14
//                                                           "user_message_DAMN!.usdz":.message, //15
//                                                           "user_message_ZAP!.usdz":.message, //16
                                                           "user_message_BANG!.usdz":.message, //17
                                                           "user_message_BOOM!.usdz":.message, //18
                                                           "user_message_COOL.usdz":.message, //19
//                                                           "user_message_CRASH!":.message //20
                                                           
                                                           "user_emoji_smileWithSweat.usdz":.emoji, //1
                                                           "user_emoji_smile.usdz":.emoji, //2
                                                           
                                                           "user_special_pumpkin.usdz":.special, //1
                                                           "user_special_witchHat.usdz":.special, //2
                                                           "user_special_skull.usdz":.special, //3
                                                           "user_special_candy.usdz":.special, //4
                                                           "user_special_bat.usdz":.special, //5
                                                           "user_special_deadHand.usdz":.special, //6
                                                           "user_special_ghost.usdz":.special, //7
                                                           
                                                           "user_victory_crown.reality":.victory, //1
                                                           "user_victory_fanfare.reality":.victory, //2
                                                           "user_victory_like.reality":.victory,  //3
                                                           
                                                           "user_text_MessageBoard.reality":.text  //3
                                                           
                                                          ], readThumbnails: true)
    
    init() {
        for model in self.exploreModelList.usdzModelList {
            model.asyncLoadEntity(){ completed, error in
                if completed {
                    print("DEBUG(BCH): explore load \(model.modelName) sucessfully")
                }
            }
        }
        
    }
 
    
    func getModel(modelName: String) -> USDZModel? {
        if let usdzModel = getCreateModel(modelName: modelName) {
            return usdzModel
        } else if let usdzModel = getExploreModel(modelName: modelName) {
            return usdzModel
        }
        return nil
    }
    
    func getCreateModel(modelName: String) -> USDZModel? {
        return createModelList.getUSDZModel(modelName: modelName)
    }
    
    func getExploreModel(modelName: String) -> USDZModel? {
        return exploreModelList.getUSDZModel(modelName: modelName)
    }
    
    func AreExploreModelLibrariesLoaded() -> Bool {
        return exploreModelList.AreModelsLoaded()
    }
    
}
