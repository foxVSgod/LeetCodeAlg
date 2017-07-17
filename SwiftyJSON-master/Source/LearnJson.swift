//
//  LearnJson.swift
//  SwiftyJSON
//
//  Created by yourongrong on 2017/6/28.
//
//

import Foundation
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
        let object:Any = try JSONSerialization.jsonObject(with: data, options: opt)
        self.init(jsonObject: object)
    }

    fileprivate init(jsonObject:Any){
        self.object = jsonObject
    }

    fileprivate mutating func merge(with other: EMJSON, typecheck:Bool) throws{
//        if  self.type == other.type {
//            switch self.type {
//            case .dictionary:
//                for(key , _) in other{
//                    try self[key].merge(with: other[key])
//                }
//            case .array :
//                self = EMJSON(self.rawArray + other.rawArray)
//            default:
//                self = other
//            }
//        }else{
//            if typecheck {
//                throw SwiftyJSONError.wrongType
//            }else{
//                self =  other
//            }
//        }
    }

    public mutating func merged(with other:EMJSON) throws -> EMJSON{
        var merged = self
        try merged.merge(with: other, typecheck: true)
        return merged
    }

    public mutating func merged(with other:EMJSON) throws{
        try self.merge(with: other, typecheck: true)
    }

    public init(_ object: Any){
        switch object {
        case let object as Data:
            do{
                try self.init(data: object)
            }catch{
                self.init(jsonObject: NSNull())
            }
        default:
            self.init(jsonObject: object)
        }
    }

    public init(parseJSON jsonString:String){
        if let data = jsonString.data(using: .utf8) {
            self.init(data)
        }else{
            self.init(NSNull())
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

//public enum EMIndex<T:Any> :Comparable{
//    case array(Int)
//    case dictionaray(DictionaryIndex<String,T>)
//    case null
//
//    static public func == (lhs:EMIndex, rhs:EMIndex) ->Bool{
//        switch (lhs, rhs) {
//        case (.array(let left),.array(let right)):
//            return left < right
//        case (.dictionary(let left),.dictionary(let right)):
//            return left < right
//        default:
//            return false
//        }
//    }
//
//    static public func < (lhs: EMJsonIndex, rhs:EMJsonIndex) -> Bool{
//        switch (lhs, rhs) {
//        case (.array(let left), .array(let right)):
//            return left < right
//        case (.dictionary(let left), .dictionary(let right)):
//            return left < right
//        default:
//            return false
//        }
//    }
//}

extension EMJSON{
    // optional [EMJson]
    public var array: [EMJSON]? {
        if  self.type == .array {
            return self.rawArray.map {
                EMJSON($0)
            }
        }else{
            return nil
        }
    }
    // Non-optional [EMJson]
    public var arrayValue: [EMJSON] {
        return self.array ?? []
    }

    public var arrayObject: [Any]? {
        get {
            switch self.type {
            case .array:
                return self.arrayValue
            default:
                return nil
            }
        }
        set {
            if  let array = newValue {
                self.object = array as Any
            }else {
                self.object = NSNull()
            }
        }
    }
}

extension EMJSON{
    public var dictionary: [String: EMJSON]? {
        if self.type == .dictionary {
            var d = [String : EMJSON].init(minimumCapacity: rawDictionary.count)
            for (key , value ) in rawDictionary{
                d[key] = EMJSON(value)
            }
            return d
        }else {
            return nil
        }
    }

    public var dictionaryValue:[String : EMJSON] {
        return self.dictionary ?? [:]
    }

    public var dictionargValue:[String : Any]? {
        get {
            switch self.type {
            case .dictionary:
                return self.rawDictionary
            default:
                return nil
            }
        }
        set {
            if let v = newValue {
                self.object = v as Any
            }else{
                self.object = NSNull()
            }
        }
    }
}

extension EMJSON{
    public var bool : Bool? {
        get {
            switch self.type {
            case .bool:
                return self.rawBool
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.object = newValue as Bool
            }else{
                self.object = NSNull()
            }
        }
    }

    public var boolValue: Bool {
        get {
            switch  self.type {
            case .bool:
                return self.rawBool
            case .number:
                return self.rawNumber.boolValue
            case .string:
                return ["true", "y", "t"].contains { (truthyString) in
                    return self.rawString.caseInsensitiveCompare(truthyString) == .orderedSame
                }
            default:
                return false
            }
        }
        set {
            self.object = newValue
        }
    }
}

extension EMJSON{
    public var string: String? {
        get {
            switch self.type {
            case .string:
                return self.object as? String
            default:
                return nil
            }
        }
        set {
            if  let newValue = newValue {
                self.object = NSString(string:newValue)
            }else{
                self.object = NSNull()
            }
        }
    }


    public var stringValue: String {
        get  {
            switch self.type {
            case .string:
                return self.object as? String ?? ""
            case .number:
                return self.rawNumber.stringValue
            case .bool:
                return (self.object as? Bool).map{ String($0) } ?? ""
            default:
                return self.rawNumber.stringValue
            }
        }
        set  {
            self.object = NSString(string:newValue)
        }
    }
}

extension EMJSON{
    public var number:NSNumber? {
        get {
            switch self.type {
            case .number:
                return self.rawNumber
            case .bool:
                return NSNumber.init(value: self.rawBool ? 1:0)
            default:
                return nil
            }
        }
        set {
            self.object = newValue ?? NSNull()
        }
    }

    public var numberValue:NSNumber {
        get {
            switch self.type {
            case .string:
                let decimal = NSDecimalNumber.init(string: self.object as? String)
                if  decimal == NSDecimalNumber.notANumber {
                    return NSDecimalNumber.zero
                }
                return decimal
            case .number:
                return self.object as? NSNumber ?? NSNumber.init(value: 0)
            default:
                return NSNumber.init(value: 0.0)
            }
        }
        set {
            self.object = numberValue
        }
    }
}

extension EMJSON{
    public var null: NSNull? {
        get {
            switch self.type {
            case .null:
                return self.rawNull
            default:
                return nil
            }
        }
        set {
            self.object = NSNull()
        }
    }

    public func exists() ->Bool {
        if let errorValue = error, (400...1000).contains(errorValue.errorCdoe){
            return false
        }
      return true
    }
}

extension EMJSON{
    public var url:URL? {
        get {
            switch self.type {
            case .string:
                if self.rawString.range(of: "%[0-9A-Fa-f]{2}",options: .regularExpression,range: nil, locale:  nil) != nil{
                    return Foundation.URL.init(string: self.rawString)
                } else if let encodedstring = self.rawString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed){
                    return Foundation.URL.init(string: encodedstring)
                }
                return Foundation.URL.init(string: self.rawString)
            default:
                return nil
            }
        }
        set {
            self.object = newValue?.absoluteString ?? NSNull()
        }
    }
}

extension EMJSON{
    public var double: Double? {
        set {
            if let newValue = newValue {
                self.object = NSNumber(value:newValue)
            }else{
                self.object = NSNull()
            }
        }
        get {
            return self.number?.doubleValue
        }
    }

    public var doubleValue:Double{
        set {
            self.object = NSNumber.init(value: newValue)
        }
        get {
            return self.numberValue.doubleValue
        }
    }

    public var float: Float? {
        get {
            return self.number?.floatValue
        }
        set {
            if  let newValue = newValue {
                self.object = NSNumber.init(value: newValue)
            }else{
                self.object = NSNull()
            }
        }
    }

    public var floatValue :Float {
        get {
            return self.numberValue.floatValue
        }
        set {
            self.object = NSNumber.init(value: newValue)

        }
    }

    public var int: Int? {
        set {
            if let value = newValue {
                self.object = NSNumber.init(value: value)
            }else{
                self.object = NSNull()
            }
        }
        get {
            return self.number?.intValue
        }
    }

    public var intvalue:Int {
        get {
            return self.numberValue.intValue
        }
        set {
            self.object = NSNumber.init(value: newValue)
        }
    }

    public var uInt: UInt? {
        get {
            return self.number?.uintValue
        }
        set {
            if let newvalue = newValue {
                self.object = NSNumber.init(value: newValue)
            }
        }
    }
    public var uIntValue: UInt{
        get {
            return self.numberValue.uintValue
        }
        set {
            self.object = NSNumber.init(value: newValue)
        }
    }

    public var int8: Int8? {
        get {
            return self.number?.int8Value
        }
        set {
            if  let newValue = newValue {
                self.object = NSNumber.init(value: newValue)
            }else{
                self.object = NSNull()
            }
        }
    }

    public var int8Value: Int8 {
        get {
            return self.numberValue.int8Value
        }
        set {
            self.object = NSNumber.init(value: Int(newValue))
        }
    }

    public var uInt8: UInt8?{
        get {
            return self.number?.uint8Value
        }
        set {
            if let newValue = newValue  {

            }
        }
    }

    public var uInt8Value:UInt8{
        get {
            return self.number?.uint8Value
        }
        set {
            self.object = NSNumber.init(value: newValue)
        }
    }

    public var int16: Int16? {
        get {
            return self.number?.int16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int16Value: Int16 {
        get {
            return self.numberValue.int16Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var uInt16: UInt16? {
        get {
            return self.number?.uint16Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt16Value: UInt16 {
        get {
            return self.numberValue.uint16Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var int32: Int32? {
        get {
            return self.number?.int32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int32Value: Int32 {
        get {
            return self.numberValue.int32Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var uInt32: UInt32? {
        get {
            return self.number?.uint32Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt32Value: UInt32 {
        get {
            return self.numberValue.uint32Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var int64: Int64? {
        get {
            return self.number?.int64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var int64Value: Int64 {
        get {
            return self.numberValue.int64Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }

    public var uInt64: UInt64? {
        get {
            return self.number?.uint64Value
        }
        set {
            if let newValue = newValue {
                self.object = NSNumber(value: newValue)
            } else {
                self.object =  NSNull()
            }
        }
    }

    public var uInt64Value: UInt64 {
        get {
            return self.numberValue.uint64Value
        }
        set {
            self.object = NSNumber(value: newValue)
        }
    }
}


public enum Index<T: Any>: Comparable{
    case array(Int)
    case dictionary(DictionaryIndex<String,T>)
    case null
    static public func == (lhs: Index, rhs: Index) ->Bool{
        switch (lhs, rhs) {
        case (.array(let left), .array(let right)):
            return left == right
        case (.dictionary(let left), .dictionary(let right)):
            return left == right
        case (.null, .null):
            return true
        default:
            return false
        }

    }

}

public typealias EMJsonIndex = Index<EMJSON>
public typealias EMJsonRawIndex = Index<Any>

extension EMJSON: Swift.Collection{
    public typealias Index = EMJsonRawIndex
    public var startIndex: Index{
        switch type {
        case .array:
            return .array(rawArray.startIndex)
        case .dictionary:
            return .dictionary(rawDictionary.startIndex)
        default:
            return .null
        }

        
    }
}




