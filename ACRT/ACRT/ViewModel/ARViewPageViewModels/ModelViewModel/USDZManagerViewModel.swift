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
    var exploreModelList = USDZModelList(usdzModelList:[
        ModelContrib( "qs_AppleLogo_left.reality", .special, isVertcalToGround: true),
        ModelContrib( "qs_AppleLogo_Right.reality", .special, isVertcalToGround: true),
        ModelContrib( "qs_AppleMusic.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_AppStore.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Calendar.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Camera.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Facetime.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Health.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Hello.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Home.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_iBook.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_iMessage.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Phone.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Safari.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Setting.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Swift.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_SwiftChangeTheWorld.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Weather.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_BugerKing.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_Cocacola.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_Coffee.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_FrenchFires.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_KFC.usdz", .special, isVertcalToGround: true),
        ModelContrib( "yt_McDonald's.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_findMy.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_Title.reality", .special, isVertcalToGround: true),
        ModelContrib( "qs_contact.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_AppleLogo_center.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_contacts.usdz", .special, isVertcalToGround: true),
        ModelContrib( "qs_zjuLogo.usdz", .special, isVertcalToGround: true)])
    
    var createModelList = USDZModelList(usdzModelList:[
        ModelContrib( "user_like_blue.reality", .foundmental, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_like_red.reality", .foundmental, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_love_white.reality", .foundmental, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_love_red.reality", .foundmental, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_A.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_B.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_C.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_D.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_E.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_F.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_H.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_L.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_O.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_letter_P.usdz", .letter, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_message_OMG!.usdz", .message, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_message_YES!.usdz", .message, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_message_BANG!.usdz", .message, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_message_BOOM!.usdz", .message, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_message_COOL.usdz", .message, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_emoji_smileWithSweat.usdz", .emoji, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_emoji_smile.usdz", .emoji, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_special_pumpkin.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_special_witchHat.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_special_skull.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_special_candy.usdz", .special, isVertcalToGround: false, readThumbnail: true),
        ModelContrib( "user_special_bat.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_special_deadHand.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_special_ghost.usdz", .special, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_victory_crown.reality", .victory, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_victory_fanfare.reality", .victory, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_victory_like.reality", .victory, isVertcalToGround: true, readThumbnail: true),
        ModelContrib( "user_text_MessageBoard.reality", .text, isVertcalToGround: true, readThumbnail: true)])
    
    init() {
        exploreModelList.loadModelEntities()
        
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
