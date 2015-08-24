//
//  PhoneContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit
import Contacts

public class PhoneAddressBookFetcher:NSObject, ContactFetcher {

  static let internalAddressBookFetcher = PhoneAddressBookFetcher()

  public var isAuthorized:Bool = false

  public static var contactFetcher: ContactFetcher {
    return internalAddressBookFetcher
  }

  public func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {

  }

  public func authorizeWithCompletion(success successBlock: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {

  }
}

@available(iOS 9.0, *)
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
        let defaultContainer = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainerWithIdentifier(defaultContainer)
        let keysToFetch = CNContactKeysFromContactProperties(properties)
        let contacts = try self.store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          success(contacts: contacts)
        })
        
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

  let CNContactKeysFromContactProperties = { (properties: ContactProperty) -> [CNKeyDescriptor] in
    var keys:[CNKeyDescriptor] = [CNContactIdentifierKey, CNContactNonGregorianBirthdayKey, CNContactPreviousFamilyNameKey, CNContactImageDataAvailableKey]

    if properties.contains(ContactProperty.GivenName) {
      keys.append(CNContactGivenNameKey)
    }
    if properties.contains(ContactProperty.FamilyName) {
      keys.append(CNContactFamilyNameKey)
    }
    if properties.contains(ContactProperty.MiddleName) {
      keys.append(CNContactMiddleNameKey)
    }

    if properties.contains(ContactProperty.NamePrefix) {
      keys.append(CNContactNamePrefixKey)
    }
    if properties.contains(ContactProperty.NameSuffix) {
      keys.append(CNContactNameSuffixKey)
    }
    if properties.contains(ContactProperty.Nickname) {
      keys.append(CNContactNicknameKey)
    }

    if properties.contains(ContactProperty.PhoneticGivenName) {
      keys.append(CNContactPhoneticGivenNameKey)
    }
    if properties.contains(ContactProperty.PhoneticFamilyName) {
      keys.append(CNContactPhoneticFamilyNameKey)
    }
    if properties.contains(ContactProperty.PhoneticMiddleName) {
      keys.append(CNContactPhoneticMiddleNameKey)
    }

    if properties.contains(ContactProperty.OrganizationName) {
      keys.append(CNContactOrganizationNameKey)
    }
    if properties.contains(ContactProperty.JobTitle) {
      keys.append(CNContactJobTitleKey)
    }
    if properties.contains(ContactProperty.DepartmentName) {
      keys.append(CNContactDepartmentNameKey)
    }

    if properties.contains(ContactProperty.BirthdayDate) {
      keys.append(CNContactBirthdayKey)
    }

    if properties.contains(ContactProperty.Emails) {
      keys.append(CNContactEmailAddressesKey)
    }
    if properties.contains(ContactProperty.Addresses) {
      keys.append(CNContactPostalAddressesKey)
    }
    if properties.contains(ContactProperty.Phone) {
      keys.append(CNContactPhoneNumbersKey)
    }

    if properties.contains(ContactProperty.Note) {
      keys.append(CNContactNoteKey)
    }
    if properties.contains(ContactProperty.Kind) {
      keys.append(CNContactTypeKey)
    }
    if properties.contains(ContactProperty.DateList) {
      keys.append(CNContactDatesKey)
    }

    if properties.contains(ContactProperty.InstantMessageIdentifiers) {
      keys.append(CNContactInstantMessageAddressesKey)
    }
    if properties.contains(ContactProperty.URLs) {
      keys.append(CNContactUrlAddressesKey)
    }
    if properties.contains(ContactProperty.SocialNetworkProfiles) {
      keys.append(CNContactSocialProfilesKey)
    }
    if properties.contains(ContactProperty.RelatedNames) {
      keys.append(CNContactRelationsKey)
    }

    if properties.contains(ContactProperty.OriginalImage) || properties.contains(ContactProperty.OriginalImageURL) {
      keys.append(CNContactImageDataKey)
    }

    if properties.contains(ContactProperty.ThumbnailImage) || properties.contains(ContactProperty.ThumbnailImageURL) {
      keys.append(CNContactThumbnailImageDataKey)
    }

    return keys
  }
}