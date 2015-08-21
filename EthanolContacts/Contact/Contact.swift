//
//  Contact.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit
import Contacts

public struct  ContactProperty : OptionSetType {
  
  public let rawValue: UInt
  
  public init(rawValue newRawValue:UInt) {
    rawValue = newRawValue
  }
  static let None = ContactProperty(rawValue: 0)

  static let GivenName = ContactProperty(rawValue: 1 << 1)
  static let FamilyName = ContactProperty(rawValue: 1 << 2)
  static let MiddleName = ContactProperty(rawValue: 1 << 3)

  static let NamePrefix = ContactProperty(rawValue: 1 << 4)
  static let NameSuffix = ContactProperty(rawValue: 1 << 5)
  static let Nickname = ContactProperty(rawValue: 1 << 6)

  static let PhoneticGivenName = ContactProperty(rawValue: 1 << 7)
  static let PhoneticLastName = ContactProperty(rawValue: 1 << 8)
  static let PhoneticMiddleName = ContactProperty(rawValue: 1 << 9)

  static let OrganizationName = ContactProperty(rawValue: 1 << 10)
  static let JobTitle = ContactProperty(rawValue: 1 << 11)
  static let DepartmentName = ContactProperty(rawValue: 1 << 12)

  static let BirthdayDate = ContactProperty(rawValue: 1 << 13)

  static let Emails = ContactProperty(rawValue: 1 << 14)
  static let Addresses = ContactProperty(rawValue: 1 << 15)
  static let Phone = ContactProperty(rawValue: 1 << 16)

  static let Note = ContactProperty(rawValue: 1 << 17)
  static let Kind = ContactProperty(rawValue: 1 << 18)
  static let DateList = ContactProperty(rawValue: 1 << 19)

  static let InstantMessageIdentifiers = ContactProperty(rawValue: 1 << 20)
  static let URLs = ContactProperty(rawValue: 1 << 21)
  static let SocialNetworkProfiles = ContactProperty(rawValue: 1 << 22)
  static let RelatedNames = ContactProperty(rawValue: 1 << 23)

  static let OriginalImage = ContactProperty(rawValue: 1 << 24)
  static let OriginalImageURL = ContactProperty(rawValue: 1 << 25)

  static let ThumbnailImage = ContactProperty(rawValue: 1 << 26)
  static let ThumbnailImageURL = ContactProperty(rawValue: 1 << 27)

  static let UserName = ContactProperty(rawValue: 1 << 28)
  static let Identifier = ContactProperty(rawValue: 1 << 29)

  static let AllProperties:ContactProperty = [.GivenName, .FamilyName, .MiddleName, .NamePrefix, .NameSuffix, .Nickname, .PhoneticGivenName, .PhoneticLastName, .PhoneticMiddleName, .OrganizationName, .JobTitle, .DepartmentName, .BirthdayDate, .Emails, .Addresses, .Phone, .Note, .Kind, .DateList, .InstantMessageIdentifiers, .URLs, .SocialNetworkProfiles, .RelatedNames, .OriginalImage, .OriginalImageURL, .ThumbnailImage, .ThumbnailImageURL, .UserName, .Identifier]
}

/**
*  Define the type of a contact
*/
@objc public enum ContactType: Int {
  case Unknown
  case Person
  case Organization
}

/**
*  A Protocol representing a contact.
*/

@objc public protocol Contact: NSObjectProtocol {
  var identifier: String { get }

  var userName: String? { get }

  var givenName: String { get }
  var middleName: String { get }
  var familyName: String { get }

  var namePrefix: String { get }
  var nameSuffix: String { get }
  var nickname: String { get }

  var phoneticGivenName: String { get }
  var phoneticMiddleName: String { get }
  var phoneticFamilyName: String { get }

  var organizationName: String { get }
  var jobTitle: String { get }
  var departmentName: String { get }

  var note: String { get }

  var emails: Array<String>? { get }
  var birthdayDate: NSDate? { get }

  var addresses: Array<String>? { get }

  var kind: ContactType { get }

  var dateList: Array<NSDate>? { get }

  var phone: Array<String>? { get }

  var instantMessageIdentifiers: Array<String>? { get }

  var urls: Array<String>? { get }
  var socialNetworkProfiles: Array<String>? { get }

  var relatedNames: Array<String>? { get }

  var originalImage: UIImage? { get }
  var originalImageURL: NSURL? { get }

  var thumbnailImage: UIImage? { get }
  var thumbnailImageURL: NSURL? { get }
}

extension Array where Element : CNLabeledValue {
  var stringArray: [String] {
    return self.map() { ($0.value as! String) }
  }
}

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
