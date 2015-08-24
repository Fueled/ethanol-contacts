//
//  PhoneContact.swift
//  EthanolContacts
//
//  Created by svs-fueled on 24/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation
import Contacts

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
