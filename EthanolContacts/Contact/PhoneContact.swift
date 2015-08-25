//
//  PhoneContact.swift
//  EthanolContacts
//
//  Created by svs-fueled on 24/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation
import Contacts
import AddressBook



@objc class PhoneContact: NSObject, Contact {
  var identifier: String

  var userName: String?

  var givenName: String
  var middleName: String
  var familyName: String

  var namePrefix: String
  var nameSuffix: String
  var nickname: String

  var phoneticGivenName: String
  var phoneticMiddleName: String
  var phoneticFamilyName: String

  var organizationName: String
  var jobTitle: String
  var departmentName: String

  var note: String

  var emails: Array<String>?
  var birthdayDate: NSDate?

  var addresses: Array<String>?

  var kind: ContactType

  var dateList: Array<NSDate>?

  var phone: Array<String>?

  var instantMessageIdentifiers: Array<String>?

  var urls: Array<String>?
  var socialNetworkProfiles: Array<String>?

  var relatedNames: Array<String>?

  var originalImage: UIImage?
  var originalImageURL: NSURL?

  var thumbnailImage: UIImage?
  var thumbnailImageURL: NSURL?

  override init() {
    self.identifier = ""

    self.givenName = ""
    self.middleName = ""
    self.familyName = ""

    self.namePrefix = ""
    self.nameSuffix = ""

    self.nickname = ""

    self.phoneticFamilyName = ""
    self.phoneticGivenName = ""
    self.phoneticMiddleName = ""

    self.organizationName = ""
    self.jobTitle = ""
    self.departmentName = ""

    self.note = ""

    self.kind = ContactType.Unknown

    super.init()
  }

  convenience init(person:ABRecordRef) {
    self.init()
    
    
    self.givenName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as? String ?? ""
    self.familyName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as? String ?? ""
    self.middleName = ABRecordCopyValue(person, kABPersonMiddleNameProperty).takeRetainedValue() as? String ?? ""
    self.namePrefix = ABRecordCopyValue(person, kABPersonPrefixProperty).takeRetainedValue() as? String ?? ""
    self.nameSuffix = ABRecordCopyValue(person, kABPersonSuffixProperty).takeRetainedValue() as? String ?? ""
    self.nickname = ABRecordCopyValue(person, kABPersonNicknameProperty).takeRetainedValue() as? String ?? ""
    
    self.phoneticFamilyName = ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty).takeRetainedValue() as? String ?? ""
    self.phoneticGivenName = ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty).takeRetainedValue() as? String ?? ""
    self.phoneticMiddleName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as? String ?? ""
    
    self.organizationName = ABRecordCopyValue(person, kABPersonOrganizationProperty).takeRetainedValue() as? String ?? ""
    self.jobTitle = ABRecordCopyValue(person, kABPersonJobTitleProperty).takeRetainedValue() as? String ?? ""
    self.departmentName = ABRecordCopyValue(person, kABPersonDepartmentProperty).takeRetainedValue() as? String ?? ""
    
    self.note = ABRecordCopyValue(person, kABPersonNoteProperty).takeRetainedValue() as? String ?? ""
    
    self.kind = ContactType.Unknown
    

    let GetArrayFromAdressBookMultipleValueProperty = {(property: ABPropertyID) -> [String] in
      
      let values = ABRecordCopyValue(person, property).takeRetainedValue()
      let count = ABMultiValueGetCount(values)
      var array:[String] = []
      for counter in 0...count{
        let copiedVal = ABMultiValueCopyValueAtIndex(values, counter).takeRetainedValue() as? String ?? ""
        array.append(copiedVal)
      }
      
      return array
    }
    
    self.addresses = GetArrayFromAdressBookMultipleValueProperty(kABPersonAddressProperty)
    self.emails = GetArrayFromAdressBookMultipleValueProperty(kABPersonEmailProperty)
    self.birthdayDate = ABRecordCopyValue(person, kABPersonBirthdayProperty).takeRetainedValue() as? NSDate
    
    let dateFormatter = NSDateFormatter()
    self.dateList = GetArrayFromAdressBookMultipleValueProperty(kABPersonDateProperty).map(){
      print($0)
      return  dateFormatter.dateFromString($0) ?? NSDate()
    }
    
    self.phone = GetArrayFromAdressBookMultipleValueProperty(kABPersonPhoneProperty)
    self.instantMessageIdentifiers = GetArrayFromAdressBookMultipleValueProperty(kABPersonInstantMessageProperty)
    self.urls = GetArrayFromAdressBookMultipleValueProperty(kABPersonURLProperty)
    self.socialNetworkProfiles = GetArrayFromAdressBookMultipleValueProperty(kABPersonSocialProfileProperty)
    self.relatedNames = GetArrayFromAdressBookMultipleValueProperty(kABPersonRelatedNamesProperty)
    
    if ABPersonHasImageData(person) {
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize).takeRetainedValue() as? NSData {
        self.originalImage = UIImage(data: data)
      }
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail).takeRetainedValue() as? NSData {
        self.thumbnailImage = UIImage(data: data)
      }

    }
    
  }
}

@available(iOS 9.0, *)
extension Array where Element : CNLabeledValue {
  var stringArray: [String] {
    return self.map() { ($0.value as! String) }
  }
}

@available(iOS 9.0, *)
extension CNContact: Contact {

  public var userName: String? {
    return nil
  }

  public var kind: ContactType {
    switch self.contactType {
    case CNContactType.Person:
      return ContactType.Person
    case CNContactType.Organization:
      return ContactType.Organization
    }
  }

  public var phone: Array<String>? {
    return self.phoneNumbers.stringArray
  }

  public var emails: Array<String>? {
    return self.emailAddresses.stringArray
  }

  public var addresses: Array<String>? {
    return self.postalAddresses.stringArray
  }

  public var urls: Array<String>? {
    return self.urlAddresses.stringArray
  }

  public var relatedNames: Array<String>? {
    return self.contactRelations.stringArray
  }

  public var socialNetworkProfiles: Array<String>? {
    return self.socialProfiles.stringArray
  }

  public var instantMessageIdentifiers: Array<String>? {
    return self.instantMessageAddresses.stringArray
  }

  public var birthdayDate: NSDate? {
    return self.birthday?.date
  }

  public var dateList: Array<NSDate>? {
    return self.dates.map() { ($0.value as! NSDate) }
  }

  public var originalImage: UIImage? {
    if let data = self.imageData {
      return UIImage(data: data)
    } else {
      return nil
    }
  }

  public var thumbnailImage: UIImage? {
    if let data = self.thumbnailImageData {
      return UIImage(data: data)
    } else {
      return nil
    }
  }

  public var originalImageURL: NSURL? {
    return nil
  }

  public var thumbnailImageURL: NSURL? {
    return nil
  }
  
}
