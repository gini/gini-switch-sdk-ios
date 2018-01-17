//
//  ExtractionValue.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.06.17.
//
//

public struct ContractAddressValue : ExtractionValue {
    public let name:String
    public let city:String
    public let postCode:String
    public let country:String
    public let address:AddressValue
    
    public var valueString: String {
        return "\(name), \(address.valueString), \(city), \(postCode), \(country)"
    }
    
    public static func ==(lhs: ContractAddressValue, rhs: ContractAddressValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct AddressValue : ExtractionValue {
    
    public let address:String
    public let houseNumber:String
    
    public var valueString: String {
        return "\(address) \(houseNumber)"
    }
    
    public static func ==(lhs: AddressValue, rhs: AddressValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct AmountValue : ExtractionValue {
    public let value:Double
    public let unit:String
    
    public var valueString: String {
        return "\(value) \(unit)"
    }
    
    public static func ==(lhs: AmountValue, rhs: AmountValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct StringValue : ExtractionValue {
    public let value:String?
    
    private enum CodingKeys : String, CodingKey {
        case value = "value"
    }
    
    public var valueString: String {
        return value!
    }
    
    public static func ==(lhs: StringValue, rhs: StringValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public protocol ExtractionValue : Equatable, Codable {
    
    var valueString:String { get }
    
}


