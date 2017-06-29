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


private func unwrapobject( object:Any) -> Any{
    switch object {
    case let json as JSON:
        return unwrapobject(object: json.object)
    case let array as [Any]:
        return array.map(unwrapobject)
    case let 
    default:

        <#code#>
    }
}


public struct EMJSON{
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String : Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber :NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    fileprivate var rawBool: Bool = false

    public fileprivate(set) var type:JsonType = .null
    public fileprivate(set) var error:LearnJsonError
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
            switch unwa  {
            case <#pattern#>:
                <#code#>
            default:
                <#code#>
            }


        }
    }







    public init(data: Data, options opt: JSONSerialization.ReadingOptions = []) throws{
        let object:Any = try JSONSerialization.jsonObject(with: Data, options: opt)
//        self.ini
    }

    fileprivate init(jsonObject:Any){
        self.
    }


}

class LearnJson: NSObject {

}
