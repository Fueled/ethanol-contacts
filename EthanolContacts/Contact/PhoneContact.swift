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


@available(iOS 8.0, *)
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

  convenience init(person:ABRecordRef, withProperties properties:ContactProperty) {
    self.init()

    self.identifier = properties.contains(ContactProperty.Identifier) ? "\(ABRecordGetRecordID(person))" : ""
    
    self.givenName = properties.contains(ContactProperty.GivenName) ? ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.familyName = properties.contains(ContactProperty.FamilyName) ? ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.middleName = properties.contains(ContactProperty.MiddleName) ? ABRecordCopyValue(person, kABPersonMiddleNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.namePrefix = properties.contains(ContactProperty.NamePrefix) ? ABRecordCopyValue(person, kABPersonPrefixProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.nameSuffix = properties.contains(ContactProperty.NameSuffix) ? ABRecordCopyValue(person, kABPersonSuffixProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.nickname = properties.contains(ContactProperty.Nickname) ? ABRecordCopyValue(person, kABPersonNicknameProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    self.phoneticFamilyName = properties.contains(ContactProperty.PhoneticFamilyName) ? ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.phoneticGivenName = properties.contains(ContactProperty.PhoneticGivenName) ? ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.phoneticMiddleName = properties.contains(ContactProperty.PhoneticMiddleName) ? ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    self.organizationName = properties.contains(ContactProperty.OrganizationName) ? ABRecordCopyValue(person, kABPersonOrganizationProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.jobTitle = properties.contains(ContactProperty.JobTitle) ? ABRecordCopyValue(person, kABPersonJobTitleProperty)?.takeRetainedValue() as? String ?? "" : ""
    self.departmentName = properties.contains(ContactProperty.DepartmentName) ? ABRecordCopyValue(person, kABPersonDepartmentProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    self.note = properties.contains(ContactProperty.Note) ? ABRecordCopyValue(person, kABPersonNoteProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    
    self.kind = ContactType.Unknown
    if properties.contains(ContactProperty.Kind) {
      let kindVal = ABRecordCopyValue(person, kABPersonKindProperty)?.takeRetainedValue() as? NSNumber
      if kindVal?.integerValue == (kABPersonKindPerson as! NSNumber).integerValue {
        self.kind = ContactType.Person
      } else if kindVal?.integerValue == (kABPersonKindOrganization as! NSNumber).integerValue {
        self.kind = ContactType.Organization
      }
    }
    
    
    let GetArrayFromAdressBookMultipleValueProperty = {(property: ABPropertyID, contactProperty:ContactProperty) -> [String] in
      if properties.contains(contactProperty) {
        let values = ABRecordCopyValue(person, property)?.takeRetainedValue()
        let count = ABMultiValueGetCount(values)
        var array:[String] = []
        for counter in 0..<count{
          let copiedVal = ABMultiValueCopyValueAtIndex(values, counter)?.takeRetainedValue() as? String ?? ""
          array.append(copiedVal)
        }
        return array
      }
      return []
    }
    
    self.addresses = GetArrayFromAdressBookMultipleValueProperty(kABPersonAddressProperty, ContactProperty.Addresses)
    self.emails = GetArrayFromAdressBookMultipleValueProperty(kABPersonEmailProperty, ContactProperty.Emails)
    self.birthdayDate = properties.contains(ContactProperty.BirthdayDate) ?  ABRecordCopyValue(person, kABPersonBirthdayProperty)?.takeRetainedValue() as? NSDate : nil
    
    let dateFormatter = NSDateFormatter()
    self.dateList = GetArrayFromAdressBookMultipleValueProperty(kABPersonDateProperty, ContactProperty.DateList).map(){
      return  dateFormatter.dateFromString($0) ?? NSDate()
    }
    
    self.phone = GetArrayFromAdressBookMultipleValueProperty(kABPersonPhoneProperty, ContactProperty.Phone)
    self.instantMessageIdentifiers = GetArrayFromAdressBookMultipleValueProperty(kABPersonInstantMessageProperty, ContactProperty.InstantMessageIdentifiers)
    self.urls = GetArrayFromAdressBookMultipleValueProperty(kABPersonURLProperty, ContactProperty.URLs)
    self.socialNetworkProfiles = GetArrayFromAdressBookMultipleValueProperty(kABPersonSocialProfileProperty, ContactProperty.SocialNetworkProfiles)
    self.relatedNames = GetArrayFromAdressBookMultipleValueProperty(kABPersonRelatedNamesProperty, ContactProperty.RelatedNames)
    
    if ABPersonHasImageData(person) {
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize)?.takeRetainedValue() as? NSData where properties.contains(ContactProperty.OriginalImage.union(ContactProperty.OriginalImageURL)) {
        self.originalImage = UIImage(data: data)
      }
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeRetainedValue() as? NSData where properties.contains(ContactProperty.ThumbnailImage.union(ContactProperty.ThumbnailImageURL)){
        self.thumbnailImage = UIImage(data: data)
      }
      
    }
  }
  convenience init(person:ABRecordRef) {
    self.init(person: person, withProperties: ContactProperty.AllProperties)
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
