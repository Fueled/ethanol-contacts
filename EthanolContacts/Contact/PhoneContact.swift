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
    //TODO: add Mapping
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
