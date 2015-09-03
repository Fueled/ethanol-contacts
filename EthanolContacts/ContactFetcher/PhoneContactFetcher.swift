//
//  PhoneContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit

public final class PhoneContactFetcher : NSObject, ContactFetcher {
  public static var contactFetcher: ContactFetcher {
    if #available(iOS 9.0, *) {
      return ContactFrameworkFetcher.contactFetcher
    } else {
      return AddressBookFetcher.contactFetcher
    }
  }

  public var isAuthorized:Bool {
    return PhoneContactFetcher.contactFetcher.isAuthorized
  }
  
  public func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
      PhoneContactFetcher.contactFetcher.fetchContactsForProperties(properties, success: success, failure: failure)
  }

  public func authorizeWithCompletion(success success: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    PhoneContactFetcher.contactFetcher.authorizeWithCompletion(success: success, failure: failure)
  }
}
