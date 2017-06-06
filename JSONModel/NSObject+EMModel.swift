//
//  NSObject+EMModel.swift
//  LeetCodeSwift
//
//  Created by yourongrong on 2017/6/6.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

import Foundation

enum EMEncodingType {
    case EMEncodingTypeNSUnknown
    case EMEncodingTypeNSString
    case EMEncodingTypeNSNumber
    case EMEncodingTypeDecimalNumber
    case EMEncodingTypeNSData
    case EMEncodingTypeNSdate
    case EMEncodingTypeNSURL
    case EMEncodingTypeArray
    case EMEncodingTypeDictionary
    case EMEncodingTypeNSet
}

func EMClassGetNSType(cls:Any?) -> EMEncodingType{
    if cls == nil {
        return EMEncodingType.EMEncodingTypeNSUnknown
    }else if((cls is NSString) == true){

    }
}

extension NSObject{
    class func modelWithJSON( json:AnyObject!) -> NSObject!{
        return NSObject.init()
    }

    class func modelWithDictionary(dictionary: NSDictionary) -> NSObject! {
        return NSObject.init()
    }

    func modelSetwithJSON(json:AnyObject!) -> Bool {
        return true
    }

    func modelSetWithDictionary(dict: NSDictionary) -> Bool {
        return false
    }

    func modelToJSONObject() -> NSObject! {
        return NSObject.init()
    }

    func modeltoJSONData() -> NSData! {
        return NSData.init()
    }

    func modeltoJSONString() -> NSString! {
        return NSString.init()
    }

    func modelCopy() -> NSObject! {
        return NSObject.init()
        var a:NSString
    }

    func modelEncodeWithCoder(acoder: NSCoder) {
        return
    }

    func modelHash()-> UInt {
        return 0
    }

    func modelDescription() -> NSString? {
        return ""
    }
}

extension NSArray{
    class func modelDictionaryWithClass(cls :AnyClass, json:(AnyObject!)){
    }
}

@objc protocol EMModle {
    func modelPropertyMapper() -> Dictionary<NSString,AnyObject>
    func modelContainerPropertyGenericClass() -> Dictionary<NSString,AnyObject>
    func modelPropertyBlacklist() -> Array<NSString>
    func modelClassForDictionary(dictionary:NSDictionary) -> AnyClass!
    func modelPropertyBlacklist() -> Array<NSString>!
    func modelPropertyWhitelist() -> Array<NSString>!
    func modelWillTransformFromDictionary(dict:NSDictionary) ->NSDictionary
    func modelTransformFromDictionary(dic:NSDictionary) -> Bool
    func modelTransformToDictionary() -> NSDictionary
}

//
