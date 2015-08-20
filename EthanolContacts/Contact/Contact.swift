//
//  Contact.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit

public struct  ContactProperty : OptionSetType {
  
  public let rawValue: UInt
  
  public init(rawValue newRawValue:UInt) {
    rawValue = newRawValue
  }
  static let FirstName = ContactProperty(rawValue: 1 << 0)
  static let MiddleName = ContactProperty(rawValue: 1 << 2)
  static let LastName = ContactProperty(rawValue: 1 << 1)
  static let Prefix = ContactProperty(rawValue: 1 << 3)
  static let Suffix = ContactProperty(rawValue: 1 <<  4)
  static let Nickname = ContactProperty(rawValue: 1 <<  5)
  static let FirstNamePhonetic = ContactProperty(rawValue: 1 <<  6)
  static let MiddleNamePhonetic = ContactProperty(rawValue: 1 <<  8)
  static let LastNamePhonetic = ContactProperty(rawValue: 1 <<  7)
  static let Organization = ContactProperty(rawValue: 1 <<  9)
  static let JobTitle = ContactProperty(rawValue: 1 <<  10)
  static let Department = ContactProperty(rawValue: 1 <<  11)
  static let Emails = ContactProperty(rawValue: 1 <<  12)
  static let Birthday = ContactProperty(rawValue: 1 <<  13)
  static let Note = ContactProperty(rawValue: 1 <<  14)
  static let CreationDate = ContactProperty(rawValue: 1 <<  15)
  static let ModificationDate = ContactProperty(rawValue: 1 <<  16)
  static let Addresses = ContactProperty(rawValue: 1 <<  17)
  static let Kind = ContactProperty(rawValue: 1 <<  18)
  static let Dates = ContactProperty(rawValue: 1 <<  19)
  static let Phones = ContactProperty(rawValue: 1 <<  20)
  static let InstantMessageIdentifiers = ContactProperty(rawValue: 1 <<  21)
  static let URLs = ContactProperty(rawValue: 1 <<  22)
  static let SocialProfiles = ContactProperty(rawValue: 1 <<  23)
  static let RelatedNames = ContactProperty(rawValue: 1 <<  24)
  static let OriginalImage = ContactProperty(rawValue: 1 <<  25)
  static let ThumbnailImage = ContactProperty(rawValue: 1 <<  26)
  static let UserName = ContactProperty(rawValue: 1 <<  27)
  static let Identifier = ContactProperty(rawValue: 1 <<  28)
  static let OriginalImageURL = ContactProperty(rawValue: 1 <<  29)
  static let ThumbnailImageURL = ContactProperty(rawValue: 1 <<  30)
  
  static let AllProperties:ContactProperty = [.FirstName, .MiddleName, .LastName, .Prefix, .Suffix, .Nickname, .FirstNamePhonetic, .MiddleNamePhonetic, .LastNamePhonetic, .Organization, .JobTitle, .Department, .Emails, .Birthday, .Note, .CreationDate, .ModificationDate, .Addresses, .Kind, .Dates, .Phones, .InstantMessageIdentifiers, .URLs, .SocialProfiles, .RelatedNames, .OriginalImage, .OriginalImageURL, .ThumbnailImage, .ThumbnailImageURL, .UserName, .Identifier]
}

/**
*  Define the type of a contact
*/
@objc enum ContactType: NSInteger {
  case Unknown, Person, Organization
}

/**
*  A class representing a contact.
*/

public class Contact: NSObject {
  var id: String?
  var userName: String?
  var firstName: String?
  var middleName: String?
  var lastName: String?
  var prefix: String?
  var suffix: String?
  var nickname: String?
  var firstNamePhonetic: String?
  var middleNamePhonetic: String?
  var lastNamePhonetic: String?
  var organization: String?
  var jobTitle: String?
  var department: String?
  var emails: Array<String>?
  var birthday: NSDate?
  var note: String?
  var creationDate: NSDate?
  var modificationDate: NSDate?
  var addresses: Array<String>?
  var kind: ContactType?
  var dates: Array<NSDate>?
  var phones: Array<String>?
  var instantMessageIdentifiers: Array<String>?
  var urls: Array<String>?
  var socialProfiles: Array<String>?
  var relatedNames: Array<String>?
  var originalImage: UIImage?
  var originalImageURL: NSURL?
  var thumbnailImage: UIImage?
  var thumbnailImageURL: NSURL?

}
