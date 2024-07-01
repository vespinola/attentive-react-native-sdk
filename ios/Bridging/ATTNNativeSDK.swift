//
//  ATTNNativeSDK.swift
//  AttentiveReactNativeSdk
//
//  Created by Vladimir - Work on 2024-06-28.
//  Copyright © 2024 Facebook. All rights reserved.
//

import Foundation
import attentive_ios_sdk

@objc public class ATTNNativeSDK: NSObject {
  private let sdk: ATTNSDK

  @objc(initWithDomain:mode:)
  public init(domain: String, mode: String) {
    self.sdk = ATTNSDK(domain: domain, mode: ATTNSDKMode(rawValue: mode) ?? .production)
    ATTNEventTracker.setup(with: sdk)
  }

  @objc(trigger:)
  public func trigger(_ view: UIView) {
    sdk.trigger(view)
  }

  @objc(identify:)
  public func identify(_ identifiers: [String: Any]) {
    sdk.identify(identifiers)
  }

  @objc
  public func clearUser() {
    sdk.clearUser()
  }
}

public extension ATTNNativeSDK {
  @objc
  func recordAddToCartEvent(_ attributes: [String: Any]) {
    let items = parseItems(attributes["items"] as? [[String : Any]] ?? [])
    let event = ATTNAddToCartEvent(items: items)
    ATTNEventTracker.sharedInstance()?.record(event: event)
  }

  @objc
  func recordProductViewEvent(_ attributes: [String: Any]) {
    let items = parseItems(attributes["items"] as? [[String : Any]] ?? [])
    let event = ATTNProductViewEvent(items: items)
    ATTNEventTracker.sharedInstance()?.record(event: event)
  }

  @objc
  func recordPurchaseEvent(_ attributes: [String: Any]) {
    let attrOrder = attributes["order"] as? [String: String] ?? [:]
    guard let orderId = attrOrder["id"] else { return }
    let order = ATTNOrder(orderId: orderId)
    let items = parseItems(attributes["items"] as? [[String : Any]] ?? [])
    let event = ATTNPurchaseEvent(items: items, order: order)
    ATTNEventTracker.sharedInstance()?.record(event: event)
  }

  @objc
  func recordCustomEvent(_ attributes: [String: Any]) {
    let type = attributes["type"] as? String ?? ""
    let properties = attributes["properties"] as? [String: String] ?? [:]
    guard let customEvent = ATTNCustomEvent(type: type, properties: properties) else { return }
    ATTNEventTracker.sharedInstance()?.record(event: customEvent)
  }
}

private extension ATTNNativeSDK {
  func parseItems(_ rawItems: [[String: Any]]) -> [ATTNItem] {
    var itemsToReturn: [ATTNItem] = []

    for rawItem in rawItems {
      if let rawPrice = rawItem["price"] as? [String: Any],
         let priceString = rawPrice["price"] as? String,
         let currency = rawPrice["currency"] as? String {

        let price = NSDecimalNumber(string: priceString)

        let attnPrice = ATTNPrice(price: price, currency: currency)

        if let productId = rawItem["productId"] as? String,
           let productVariantId = rawItem["productVariantId"] as? String {

          let item = ATTNItem(productId: productId, productVariantId: productVariantId, price: attnPrice)
          itemsToReturn.append(item)
        }
      }
    }

    return itemsToReturn
  }
}
