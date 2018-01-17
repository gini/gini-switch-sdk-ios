//
//  ExtractionCollection.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 22.05.17.
//
//

import UIKit

public class ExtractionCollection: Codable {
    
    public var companyName:Extraction<StringValue>?
    public var customerAddress:Extraction<ContractAddressValue>?
    public var energyMeterNumber:Extraction<StringValue>?
    public var consumption:Extraction<AmountValue>?
    public var consumptionDuration:Extraction<AmountValue>?
    public var billingAmount:Extraction<AmountValue>?
    public var paidAmount:Extraction<AmountValue>?
    public var amountToPay:Extraction<AmountValue>?
    public var documentDate:Extraction<StringValue>?
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
    
    public required init(from decoder: Decoder) throws {
        companyName = ExtractionCollection.parse(type: StringValue.self, decoder: decoder, key: .companyName, name: companyNameKey)
        customerAddress = ExtractionCollection.parse(type: ContractAddressValue.self, decoder: decoder, key: .customerAddress, name: customerAddressKey)
        energyMeterNumber = ExtractionCollection.parse(type: StringValue.self, decoder: decoder, key: .energyMeterNumber, name: energyMeterNumberKey)
        consumption = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .consumption, name: consumptionKey)
        consumptionDuration = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .consumptionDuration, name: consumptionDurationKey)
        billingAmount = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .billingAmount, name: billingAmountKey)
        paidAmount = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .paidAmount, name: paidAmountKey)
        amountToPay = ExtractionCollection.parse(type: AmountValue.self, decoder: decoder, key: .amountToPay, name: amountToPayKey)
        documentDate = ExtractionCollection.parse(type: StringValue.self, decoder: decoder, key: .documentDate, name: documentDateKey)
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        links = try values?.decode(ResponseLinks.self, forKey: .links)
    }
    
    private static func parse<T: ExtractionValue>(type: T.Type, decoder: Decoder, key: CodingKeys, name: String) -> Extraction<T>? {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        let value = try? values?.decode(T.self, forKey: key)
        if let value = value {
            let extraction = Extraction<T>()
            extraction.name = name
            extraction.value = value
            return extraction
        }
        return nil
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
