//
//  ExtractionValue.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 15.06.17.
//
//

public struct ContractAddressValue : ExtractionValue {
    public var name:String?
    public var city:String?
    public var postalCode:String?
    public var country:String?
    public var street:AddressValue?
    
    public var valueString: String {
        let components = [name, street?.valueString, city, postalCode, country].flatMap({
            if let component = $0,
                !component.isEmpty {
                return component
            }
            return nil
        })
        return components.joined(separator: ", ")
    }
    
    public static func == (lhs: ContractAddressValue, rhs: ContractAddressValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct AddressValue : ExtractionValue {
    
    public var streetName:String?
    public var streetNumber:String?
    
    public var valueString: String {
        let components:[String] = [streetName, streetNumber].flatMap({
            if let component = $0 {
                return component
            }
            return nil
        })
        return components.joined(separator: " ")
    }
    
    public static func == (lhs: AddressValue, rhs: AddressValue) -> Bool {
        return lhs.valueString == rhs.valueString
    }
}

public struct AmountValue : ExtractionValue {
    public var value:Double
    public var unit:String
    
    public var valueString: String {
        return "\(value) \(unit)"
    }
    
    public static func == (lhs: AmountValue, rhs: AmountValue) -> Bool {
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
