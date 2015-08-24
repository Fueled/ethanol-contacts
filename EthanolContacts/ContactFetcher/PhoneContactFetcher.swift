//
//  PhoneContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

public class PhoneAddressBookFetcher:NSObject, ContactFetcher {

  static let internalAddressBookFetcher = PhoneAddressBookFetcher()
  public static var contactFetcher: ContactFetcher {
    return internalAddressBookFetcher
  }

  var addressBook:ABAddressBookRef?

  public var isAuthorized:Bool {
    return ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.Authorized
  }
  public func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    if isAuthorized {
      do {
        let contacts = try self.contactsFromAddressBookWithGivenProperties(properties)
        success(contacts: contacts)
      } catch {
        failure(error: self.errorWithInfo("something happened", "contacts werent fetched"))
      }
    } else {
      authorizeWithCompletion(success: { () -> () in
        self.fetchContactsForProperties(properties, success: success, failure: failure)
        }, failure: { (error) -> Void in
          failure(error: error)
      })
    }
  }

  public func authorizeWithCompletion(success successBlock: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {

    guard let thisAddressBook = ABAddressBookCreate() as? ABAddressBook else {
      failure(error: self.errorWithInfo("EthanolContactAuthorizationFailed", "EthanolContactAddressBookFailedToCreate"))
      return
    }

    self.addressBook = thisAddressBook

    if(isAuthorized) {
      successBlock()
    } else {
      let completionHandler:ABAddressBookRequestAccessCompletionHandler = { (granted:Bool, error:CFError!) -> Void in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          if let error = error {
            failure(error: (error as NSError))
          } else if(!granted) {
            failure(error: self.errorWithInfo("EthanolContactFetchFailed", "EthanolContactPhoneNotAllowed"))
          } else {
            successBlock()
          }
        })
      }
      ABAddressBookRequestAccessWithCompletion(thisAddressBook, completionHandler)
    }
  }

  func errorWithInfo(description:String, _ reason:String) -> NSError {
    let userInfo = [NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason]
    return NSError(domain: "com.fueled.Ethanol", code: 1214, userInfo: userInfo)
  }

  func contactsFromAddressBookWithGivenProperties(propertiesFlag:ContactProperty) throws -> [Contact] {
    guard let thisAddressBook = self.addressBook else {
      throw self.errorWithInfo("EthanolContactFetchFailed", "SomethingWentWrong")
    }

    var contacts:[Contact] = []
    let people = ABAddressBookCopyArrayOfAllPeople(thisAddressBook) as! CFArray
    let count = CFArrayGetCount(people)
    for index in 0...count {
      if let thisPerson = CFArrayGetValueAtIndex(people, index) as? ABRecordRef {
        print("look: \(thisPerson)")
        let aContact = PhoneContact(person: thisPerson)
        contacts.append(aContact)
      }
    }

    if contacts.count > 0 {
      return contacts
    }

//    NSMutableArray * contacts = [NSMutableArray array];
//    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    CFIndex peopleCount = CFArrayGetCount(people);
//    for(CFIndex i = 0;i < peopleCount;i++) {
//      ETHContact * contact = [[ETHFramework injector] instanceForClass:[ETHContact class]];
//      ABRecordRef person = CFArrayGetValueAtIndex(people, i);
//
//      if(!!(propertiesFlag & ETHContactIdentifier)) {
//        contact.id = [NSString stringWithFormat:@"%lu", (unsigned long)ABRecordGetRecordID(person)];
//      }
//
//      CONDITIONAL_ASSIGN(FirstName, NSString);
//      CONDITIONAL_ASSIGN(LastName, NSString);
//      CONDITIONAL_ASSIGN(MiddleName, NSString);
//      CONDITIONAL_ASSIGN(Prefix, NSString);
//      CONDITIONAL_ASSIGN(Suffix, NSString);
//      CONDITIONAL_ASSIGN(Nickname, NSString);
//      CONDITIONAL_ASSIGN(FirstNamePhonetic, NSString);
//      CONDITIONAL_ASSIGN(LastNamePhonetic, NSString);
//      CONDITIONAL_ASSIGN(MiddleNamePhonetic, NSString);
//      CONDITIONAL_ASSIGN(Organization, NSString);
//      CONDITIONAL_ASSIGN(JobTitle, NSString);
//      CONDITIONAL_ASSIGN(Department, NSString);
//      CONDITIONAL_ASSIGN(Birthday, NSDate);
//      CONDITIONAL_ASSIGN(Note, NSString);
//      CONDITIONAL_ASSIGN(CreationDate, NSString);
//      CONDITIONAL_ASSIGN(ModificationDate, NSString);
//
//      contact.kind = ETHContactKindUnknown;
//      if(!!(propertiesFlag & ETHContactKind)) {
//        CFNumberRef numberType = ABRecordCopyValue(person, kABPersonKindProperty);
//        if(numberType == kABPersonKindPerson) {
//          contact.kind = ETHContactKindPerson;
//        } else if(numberType == kABPersonKindOrganization) {
//          contact.kind = ETHContactKindOrganization;
//        }
//        CFRelease(numberType);
//      }
//
//      CONDITIONAL_MULTI_ASSIGN(Emails, Email, NSString);
//      CONDITIONAL_MULTI_ASSIGN(Dates, Date, NSDate);
//      CONDITIONAL_MULTI_ASSIGN(Phones, Phone, NSString);
//      CONDITIONAL_MULTI_ASSIGN(SocialProfiles, InstantMessage, NSDictionary);
//      CONDITIONAL_MULTI_ASSIGN(InstantMessageIdentifiers, SocialProfile, NSDictionary);
//      CONDITIONAL_MULTI_ASSIGN_PROP(URLs, URL, NSString, @"urls");
//      CONDITIONAL_MULTI_ASSIGN(RelatedNames, RelatedNames, NSString);
//
//      if(!!(propertiesFlag & ETHContactOriginalImage)) {
//        contact.originalImage = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize)];
//      }
//
//      if(!!(propertiesFlag & ETHContactThumbnailImage)) {
//        contact.thumbnailImage = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
//      }
//      
//      [contacts addObject:contact];
//    }
//    CFRelease(people);
//    
//    return contacts;


    throw self.errorWithInfo("EthanolContactFetchFailed", "SomethingWentWrong")
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