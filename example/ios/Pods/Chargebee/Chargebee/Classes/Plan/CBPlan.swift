//
// Created by Mac Book on 6/7/20.
//

import Foundation

public typealias PlanHandler = (CBResult<CBPlan>) -> Void
public typealias AllPlanHandler = (CBResult<CBPlansWrapper>) -> Void

public struct CBPlanWrapper: Decodable {
    public let plan: CBPlan
}
public struct CBPlansWrapper: Decodable {
    public let list: [CBPlanWrapper]
    public  let nextOffset: String?
    
    enum CodingKeys: String, CodingKey {
        case list
        case nextOffset = "next_offset"
    }
}


public class CBPlan: Decodable {
    public let addonApplicability: String
    public let chargeModel: String
    public let currencyCode: String
    public let enabledInHostedPages: Bool
    public let enabledInPortal: Bool
    public let freeQuantity: Int
    public let giftable: Bool
    public let id: String
    public let invoiceName: String?
    public let isShippable: Bool
    public let name: String
    public let object: String
    public let period: Int
    public let periodUnit: String
    public let price: Int?
    public let pricingModel: String
    public let resourceVersion: UInt64
    public let status: String
    public let taxable: Bool
    public let updatedAt: UInt64

    enum CodingKeys: String, CodingKey {
        case addonApplicability = "addon_applicability"
        case chargeModel = "charge_model"
        case currencyCode = "currency_code"
        case enabledInHostedPages = "enabled_in_hosted_pages"
        case enabledInPortal = "enabled_in_portal"
        case freeQuantity = "free_quantity"
        case giftable = "giftable"
        case id = "id"
        case invoiceName = "invoice_name"
        case isShippable = "is_shippable"
        case name = "name"
        case object = "object"
        case period = "period"
        case periodUnit = "period_unit"
        case price = "price"
        case pricingModel = "pricing_model"
        case resourceVersion = "resource_version"
        case status = "status"
        case taxable = "taxable"
        case updatedAt = "updated_at"
    }
    
    public static func retrieve(_ planId: String, completion handler: @escaping PlanHandler) {
        let logger = CBLogger(name: "plan", action: "retrieve_plan")
        logger.info()
        let (onSuccess, onError) = CBResult.buildResultHandlers(handler, logger)
        if planId.isEmpty {
            return onError(CBError.defaultSytemError(statusCode: 400, message: "Plan id is empty"))
        }
        let request = CBAPIRequest(resource: CBPlanResource(planId))
        request.load(withCompletion: { planWrapper in
            onSuccess(planWrapper.plan)
        }, onError: onError)
    }

    public static func retrieveAllPlans(queryParams : [String:String]? = nil, completion handler: @escaping AllPlanHandler) {
        let logger = CBLogger(name: "plan", action: "getAllPlans")
        logger.info()
        let (onSuccess, onError) = CBResult.buildResultHandlers(handler, logger)
        let request = CBAPIRequest(resource: CBPlansResource(queryParams :queryParams ))
        request.load(withCompletion: { planListWrapper in
            onSuccess(planListWrapper)
        }, onError: onError)
    }

}
