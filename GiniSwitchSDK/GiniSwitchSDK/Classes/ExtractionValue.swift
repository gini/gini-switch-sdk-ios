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
    public let postalCode:String
    public let country:String
    public let street:AddressValue
    
    public var valueString: String {
        return "\(name), \(street.valueString), \(city), \(postalCode), \(country)"
    }
    
    public static func ==(lhs: ContractAddressValue, rhs: ContractAddressValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct AddressValue : ExtractionValue {
    
    public let streetName:String
    public let streetNumber:String
    
    public var valueString: String {
        return "\(streetName) \(streetNumber)"
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

extension String:ExtractionValue {
    
    public var valueString:String {
        return self
    }
    
}

public protocol ExtractionValue : Equatable, Codable {
    
    var valueString:String { get }
    
}


