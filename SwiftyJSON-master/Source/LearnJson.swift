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
        default:
        }
    }
}

public enum Type: Int{
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

public struct EMJSON{


    public var object:Any{
        get{



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
