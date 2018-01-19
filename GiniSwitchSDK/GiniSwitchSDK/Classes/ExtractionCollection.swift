//
//  ExtractionCollection.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit

public class ExtractionCollection: Codable {
    
    public var companyName:Extraction<String>?
    public var customerAddress:Extraction<ContractAddressValue>?
    public var energyMeterNumber:Extraction<String>?
    public var consumption:Extraction<AmountValue>?
    public var consumptionDuration:Extraction<AmountValue>?
    public var billingAmount:Extraction<AmountValue>?
    public var paidAmount:Extraction<AmountValue>?
    public var amountToPay:Extraction<AmountValue>?
    public var documentDate:Extraction<String>?
    public let links:ResponseLinks?
    
    private enum CodingKeys : String, CodingKey {
        case companyName = "companyName"
        case customerAddress = "customerAddress"
        case energyMeterNumber = "energyMeterNumber"
        case consumption = "consumption"
        case consumptionDuration = "consumptionDuration"
        case billingAmount = "billingAmount"
        case paidAmount = "paidAmount"
        case amountToPay = "amountToPay"
        case documentDate = "documentDate"
        case links = "_links"
    }
    
    private enum ValueKeys : String, CodingKey {
        case value = "value"
        case alternatives = "alternatives"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(ResponseLinks.self, forKey: .links)
        companyName = ExtractionCollection.parse(type: String.self, decoder: decoder, key: .companyName, name: companyNameKey, container: container)
        customerAddress = ExtractionCollection.parse(type: ContractAddressValue.self, decoder: decoder, key: .customerAddress, name: customerAddressKey, container: container)
        energyMeterNumber = ExtractionCollection.parse(type: String.self, decoder: decoder, key: .energyMeterNumber, name: energyMeterNumberKey, container: container)
        consumption = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .consumption, name: consumptionKey, container: container)
        consumptionDuration = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .consumptionDuration, name: consumptionDurationKey, container: container)
        billingAmount = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .billingAmount, name: billingAmountKey, container: container)
        paidAmount = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .paidAmount, name: paidAmountKey, container: container)
        amountToPay = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .amountToPay, name: amountToPayKey, container: container)
        documentDate = ExtractionCollection.parse(type: String.self, decoder: decoder, key: .documentDate, name: documentDateKey, container: container)
        
    }
    
    private static func parse<T: ExtractionValue>(type: T.Type, decoder: Decoder, key: CodingKeys, name: String, container: KeyedDecodingContainer<CodingKeys>) -> Extraction<T>? {
        do {
            let values = try container.nestedContainer(keyedBy: ValueKeys.self, forKey: key)
            let value = try values.decode(T.self, forKey: .value)
            let extraction = Extraction<T>()
            extraction.value = value
            return extraction
        } catch {
            return nil
        }
    }
    
    var companyNameKey = "companyName"
    var customerAddressKey = "customerAddress"
    var energyMeterNumberKey = "energyMeterNumber"
    var consumptionKey = "consumption"
    var consumptionDurationKey = "consumptionDuration"
    var billingAmountKey = "billingAmount"
    var paidAmountKey = "paidAmount"
    var amountToPayKey = "amountToPay"
    var documentDateKey = "documentDate"
    
    func isEmpty() -> Bool {
        let emptyJson = "{}".data(using: .utf8)!
        let emptyCollection = try? JSONDecoder().decode(ExtractionCollection.self, from: emptyJson)
        return self == emptyCollection
    }
    
}

extension ExtractionCollection:Equatable {
    
    public static func ==(lhs: ExtractionCollection, rhs: ExtractionCollection) -> Bool {
        return (lhs.companyName == rhs.companyName &&
            lhs.customerAddress == rhs.customerAddress &&
            lhs.energyMeterNumber == rhs.energyMeterNumber &&
            lhs.consumption == rhs.consumption &&
            lhs.consumptionDuration == rhs.consumptionDuration &&
            lhs.billingAmount == rhs.billingAmount &&
            lhs.paidAmount == rhs.paidAmount &&
            lhs.amountToPay == rhs.amountToPay &&
            lhs.documentDate == rhs.documentDate);
    }
    
}
