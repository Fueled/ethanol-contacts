//
//  PhoneContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit
import Contacts

public class PhoneContactFetcher: NSObject, ContactFetcher {
  
  static let internalContactFetcher = PhoneContactFetcher()

  public static var contactFetcher: ContactFetcher {
    return internalContactFetcher
  }
  
  let store: CNContactStore = CNContactStore()

  public var isAuthorized:Bool = false
  
  public func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    if isAuthorized {
      
      let contacts = try store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsMatchingName("Appleseed"), keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
      

    } else {
      self.authorizeWithCompletion(success: {
        self.fetchContactsForProperties(properties, success: success, failure: failure)
        }, failure: failure)
    }
  }

  public func authorizeWithCompletion(success successBlock: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    CNContactStore().requestAccessForEntityType(CNEntityType.Contacts) { (success: Bool, error: NSError?) -> Void in
     self.isAuthorized = success
      if success {
        successBlock()
      } else {
        failure(error: error)
      }
    }
  }

}
