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
  
  let store = CNContactStore()

  public var isAuthorized:Bool = false

  public func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    if isAuthorized {
      do {
        
        let predicate = NSPredicate(value: true)
        let keysToFetch = self.CNContactKeysFromContactProperties(properties)
        let contacts = try self.store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
        
        var contactsArray: Array<Contact> = Array()

        for contact in contacts {
          let myContact = Contact()
          myContact.firstName = contact.givenName
          contactsArray.append(myContact)
        }
        
        success(contacts: contactsArray)
        
      } catch {
          // handle error
          print("error occured")
          failure(error: nil)
      }
      
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
  
  private func CNContactKeysFromContactProperties(properties: ContactProperty) -> [CNKeyDescriptor] {
    
    var keys:[CNKeyDescriptor] = []

    if properties.contains(ContactProperty.Addresses) {
        keys.append(CNContactPostalAddressesKey)
    }
    
    return keys
  }

}
