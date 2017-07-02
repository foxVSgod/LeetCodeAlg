//
//  LearnJson.swift
//  SwiftyJSON
//
//  Created by yourongrong on 2017/6/28.
//
//

import UIKit

public enum LearnJsonError: Int, Swift.Error{
    case unsupportedType = 999
    case indexOutOfBounds = 900
    case elementTooDeep = 902
    case wrongType = 901
    case notExist = 500
    case invalidJson = 490
}

//public protocol CustomNSError : Error {
//
//    /// The domain of the error.
//    public static var errorDomain: String { get }
//
//    /// The error code within the given domain.
//    public var errorCode: Int { get }
//
//    /// The user-info dictionary.
//    public var errorUserInfo: [String : Any] { get }
//}

extension LearnJsonError: CustomNSError{
    public static var errorDomain: String { return "com.swiftyjson.SwiftyJSON"}
    public var errorCdoe:Int { return self.rawValue}
    public var errorUserInfo: [String : Any]{
        switch self {
        case .unsupportedType:
            return [NSLocalizedDescriptionKey: "It is an unsupported type."]
        case .indexOutOfBounds:
            return [NSLocalizedDescriptionKey: "Array Index is out of bounds."]
        case .elementTooDeep:
            return [NSLocalizedDescriptionKey: "Element too deep. Increase maxObjectDepth and make sure there is no reference loop."]
        case .wrongType:
            return [NSLocalizedDescriptionKey: "Couldn't merge, because the JSONs differ in type on top level."]
        case .invalidJson:
            return [NSLocalizedDescriptionKey: "JSON is invalid."]
        case .notExist:
            return [NSLocalizedDescriptionKey: "Dictionary key does not exist."]
        }
    }
}

public enum JsonType: Int{
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

public struct EMJSON{
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String : Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber :NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    fileprivate var rawBool: Bool = false

    public fileprivate(set) var type:JsonType = .null
    public fileprivate(set) var error: LearnJsonError?
    public var object:Any{
        get {
            switch self.type {
            case .array:
                return self.rawArray
            case .dictionary:
                return self.rawDictionary
            case .string:
                return self.rawString
            case .number:
                return self.rawNumber
            case .bool:
                return self.rawBool
            default:
                return self.rawNull
            }
        }
        set {
            error = nil
            switch unwrapobject(object: newValue) {
            case let number as NSNumber:
                if number.isBool{
                   self.rawBool = number.boolValue
                   type = .bool
                }else{
                   type = .number
                    self.rawNumber = number
                }
            case let array as [Any]:
                type = .array
                self.rawArray = array
            case let dictionary as [String: Any]:
                type = .dictionary
                self.rawDictionary = dictionary
            default:
                type = .unknown
                error = LearnJsonError.unsupportedType
            }
        }
    }
    @available(*, unavailable ,renamed:"null")
    public static var nullJSON:JSON { return null }
    public static var null: JSON { return JSON(NSNull()) }

    public init(data: Data, options opt: JSONSerialization.ReadingOptions = []) throws{
        let object:Any = try JSONSerialization.jsonObject(with: Data, options: opt)
    }

    fileprivate init(jsonObject:Any){
        self.object = jsonObject
    }

    fileprivate mutating func merge(with other: JSON, typecheck:Bool) throws{
        if  self.type == other.type {
            switch self.type {
            case .dictionary:
                for(key , _) in other{
                    try self[key].merge(with: other[key])
                }
            case .array
                self = JSON(self.rawArray + other.array)
            default:
                self = other
            }
        }else{
            if typecheck {
                throw SwiftyJSONError.wrongType
            }else{
                self =  other
            }
        }
    }

    public mutating func merged(with other:JSON) throws -> JSON{
        var merged = self
        try merged.merge(with: other, typecheck: true)
        return merged
    }

    public mutating func merged(with other:JSON) throws{
        try self.merge(with: other, typecheck: true)
    }

    public init(parseJSON jsonString:String){
        if  let data = jsonString.data(using: .utf8) {
            self.init(data: data)
        }else{
            self.init(NSNull()
        }
    }
}

private func unwrapobject( object:Any) -> Any{
    switch object {
    case let json as EMJSON:
        return unwrapobject(object: json.object)
    case let array as [Any]:
        return array.map(unwrapobject)
    case let dictionary as [String: Any]:
        var unwarppedDic = dictionary
        for (k,v) in dictionary{
            unwarppedDic[k] = unwrapobject(object: v)
        }
        return unwarppedDic
    default:
        return object
    }
}

public enum EMIndex<T:Any> :Comparable{
    case array(Int)
    case dictionaray(DictionaryIndex<String,T>)
    case null

    static public func == (lhs:EMIndex, rhs:EMIndex) ->Bool{
        switch (lhs, rhs) {
        case (.array(let left),.array(let right)):
            return left < right
        case (.dictionary(let left),.dictionary(let right)):
            return left < right
        default:
            return false
        }
    }

    static public func < (lhs: Index, rhs:Index) -> Bool{
        switch (lhs, rhs) {
        case (.array(let left), .array(let right)):
            return left < right
        case (.dictionary(let left), .dictionary(let right)):
            return left < right
        default:
            return false
        }
    }
}
//
//public typealias JSONIndex = Index<JSON>
//public typealias JSONRawIndex = Index<Any>
//
//



class LearnJson: NSObject {

}
