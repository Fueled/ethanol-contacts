//
//  Contact.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit

public struct  ContactProperty : OptionSetType {
  
  public let rawValue: Int
  
  public init(rawValue newRawValue:Int) {
    rawValue = newRawValue
  }
  public static let None = ContactProperty(rawValue: 0)

  public static let GivenName = ContactProperty(rawValue: 1 << 1)
  public static let FamilyName = ContactProperty(rawValue: 1 << 2)
  public static let MiddleName = ContactProperty(rawValue: 1 << 3)

  public static let NamePrefix = ContactProperty(rawValue: 1 << 4)
  public static let NameSuffix = ContactProperty(rawValue: 1 << 5)
  public static let Nickname = ContactProperty(rawValue: 1 << 6)

  public static let PhoneticGivenName = ContactProperty(rawValue: 1 << 7)
  public static let PhoneticFamilyName = ContactProperty(rawValue: 1 << 8)
  public static let PhoneticMiddleName = ContactProperty(rawValue: 1 << 9)

  public static let OrganizationName = ContactProperty(rawValue: 1 << 10)
  public static let JobTitle = ContactProperty(rawValue: 1 << 11)
  public static let DepartmentName = ContactProperty(rawValue: 1 << 12)

  public static let BirthdayDate = ContactProperty(rawValue: 1 << 13)

  public static let Emails = ContactProperty(rawValue: 1 << 14)
  public static let Addresses = ContactProperty(rawValue: 1 << 15)
  public static let Phone = ContactProperty(rawValue: 1 << 16)

  public static let Note = ContactProperty(rawValue: 1 << 17)
  public static let Kind = ContactProperty(rawValue: 1 << 18)
  public static let DateList = ContactProperty(rawValue: 1 << 19)

  public static let InstantMessageIdentifiers = ContactProperty(rawValue: 1 << 20)
  public static let URLs = ContactProperty(rawValue: 1 << 21)
  public static let SocialNetworkProfiles = ContactProperty(rawValue: 1 << 22)
  public static let RelatedNames = ContactProperty(rawValue: 1 << 23)

  public static let OriginalImage = ContactProperty(rawValue: 1 << 24)
  public static let OriginalImageURL = ContactProperty(rawValue: 1 << 25)

  public static let ThumbnailImage = ContactProperty(rawValue: 1 << 26)
  public static let ThumbnailImageURL = ContactProperty(rawValue: 1 << 27)

  public static let UserName = ContactProperty(rawValue: 1 << 28)
  public static let Identifier = ContactProperty(rawValue: 1 << 29)

  public static let AllProperties:ContactProperty = [.GivenName, .FamilyName, .MiddleName, .NamePrefix, .NameSuffix, .Nickname, .PhoneticGivenName, .PhoneticFamilyName, .PhoneticMiddleName, .OrganizationName, .JobTitle, .DepartmentName, .BirthdayDate, .Emails, .Addresses, .Phone, .Note, .Kind, .DateList, .InstantMessageIdentifiers, .URLs, .SocialNetworkProfiles, .RelatedNames, .OriginalImage, .OriginalImageURL, .ThumbnailImage, .ThumbnailImageURL, .UserName, .Identifier]

  public static let BasicProperties:ContactProperty = [.GivenName, .FamilyName, .MiddleName, .BirthdayDate, .Emails, .Addresses, .Phone, .OriginalImage, .ThumbnailImage, .UserName, .Identifier]
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

