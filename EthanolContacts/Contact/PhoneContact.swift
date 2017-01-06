//
//  PhoneContact.swift
//  EthanolContacts
//
//  Created by svs-fueled on 24/08/15.
//  Copyright (c) 2015 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Contacts
import AddressBook


@available(iOS 8.0, *)
@objc final class PhoneContact: NSObject, Contact {
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
  var birthdayDate: Date?

  var addresses: Array<String>?

  var kind: ContactType

  var dateList: Array<Date>?

  var phone: Array<String>?

  var instantMessageIdentifiers: Array<String>?

  var urls: Array<String>?
  var socialNetworkProfiles: Array<String>?

  var relatedNames: Array<String>?

  var originalImage: UIImage?
  var originalImageURL: URL?

  var thumbnailImage: UIImage?
  var thumbnailImageURL: URL?

  override init() {
    identifier = ""

    givenName = ""
    middleName = ""
    familyName = ""

    namePrefix = ""
    nameSuffix = ""

    nickname = ""

    phoneticFamilyName = ""
    phoneticGivenName = ""
    phoneticMiddleName = ""

    organizationName = ""
    jobTitle = ""
    departmentName = ""
    
    note = ""

    kind = .unknown

    super.init()
  }

  convenience init(person:ABRecord, withProperties properties:ContactProperty) {
    self.init()

    identifier = properties.contains(ContactProperty.Identifier) ? "\(ABRecordGetRecordID(person))" : ""
    
    givenName = properties.contains(ContactProperty.GivenName) ? ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    familyName = properties.contains(ContactProperty.FamilyName) ? ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    middleName = properties.contains(ContactProperty.MiddleName) ? ABRecordCopyValue(person, kABPersonMiddleNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    namePrefix = properties.contains(ContactProperty.NamePrefix) ? ABRecordCopyValue(person, kABPersonPrefixProperty)?.takeRetainedValue() as? String ?? "" : ""
    nameSuffix = properties.contains(ContactProperty.NameSuffix) ? ABRecordCopyValue(person, kABPersonSuffixProperty)?.takeRetainedValue() as? String ?? "" : ""
    nickname = properties.contains(ContactProperty.Nickname) ? ABRecordCopyValue(person, kABPersonNicknameProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    phoneticFamilyName = properties.contains(ContactProperty.PhoneticFamilyName) ? ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty)?.takeRetainedValue() as? String ?? "" : ""
    phoneticGivenName = properties.contains(ContactProperty.PhoneticGivenName) ? ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty)?.takeRetainedValue() as? String ?? "" : ""
    phoneticMiddleName = properties.contains(ContactProperty.PhoneticMiddleName) ? ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    organizationName = properties.contains(ContactProperty.OrganizationName) ? ABRecordCopyValue(person, kABPersonOrganizationProperty)?.takeRetainedValue() as? String ?? "" : ""
    jobTitle = properties.contains(ContactProperty.JobTitle) ? ABRecordCopyValue(person, kABPersonJobTitleProperty)?.takeRetainedValue() as? String ?? "" : ""
    departmentName = properties.contains(ContactProperty.DepartmentName) ? ABRecordCopyValue(person, kABPersonDepartmentProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    note = properties.contains(ContactProperty.Note) ? ABRecordCopyValue(person, kABPersonNoteProperty)?.takeRetainedValue() as? String ?? "" : ""
    
    kind = .unknown
    if properties.contains(ContactProperty.Kind) {
      let kindVal = ABRecordCopyValue(person, kABPersonKindProperty)?.takeRetainedValue() as? NSNumber
      if kindVal?.intValue == (kABPersonKindPerson as NSNumber).intValue {
        kind = .person
      } else if kindVal?.intValue == (kABPersonKindOrganization as NSNumber).intValue {
        kind = .organization
      }
    }
    
    
    let GetArrayFromAdressBookMultipleValueProperty = {(property: ABPropertyID, contactProperty:ContactProperty) -> [String] in
      if properties.contains(contactProperty) {
        let values = ABRecordCopyValue(person, property)?.takeRetainedValue()
        let count = ABMultiValueGetCount(values)
        var array = [String]()
        for counter in 0..<count{
          let copiedVal = ABMultiValueCopyValueAtIndex(values, counter)?.takeRetainedValue() as? String ?? ""
          array.append(copiedVal)
        }
        return array
      }
      return []
    }
    
    addresses = GetArrayFromAdressBookMultipleValueProperty(kABPersonAddressProperty, ContactProperty.Addresses)
    emails = GetArrayFromAdressBookMultipleValueProperty(kABPersonEmailProperty, ContactProperty.Emails)
    birthdayDate = properties.contains(ContactProperty.BirthdayDate) ?  ABRecordCopyValue(person, kABPersonBirthdayProperty)?.takeRetainedValue() as? Date : nil
    
    let dateFormatter = DateFormatter()
    dateList = GetArrayFromAdressBookMultipleValueProperty(kABPersonDateProperty, ContactProperty.DateList).map(){
      return  dateFormatter.date(from: $0) ?? Date()
    }
    
    phone = GetArrayFromAdressBookMultipleValueProperty(kABPersonPhoneProperty, ContactProperty.Phone)
    instantMessageIdentifiers = GetArrayFromAdressBookMultipleValueProperty(kABPersonInstantMessageProperty, ContactProperty.InstantMessageIdentifiers)
    urls = GetArrayFromAdressBookMultipleValueProperty(kABPersonURLProperty, ContactProperty.URLs)
    socialNetworkProfiles = GetArrayFromAdressBookMultipleValueProperty(kABPersonSocialProfileProperty, ContactProperty.SocialNetworkProfiles)
    relatedNames = GetArrayFromAdressBookMultipleValueProperty(kABPersonRelatedNamesProperty, ContactProperty.RelatedNames)
    
    if ABPersonHasImageData(person) {
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize)?.takeRetainedValue() as? Data , properties.contains(ContactProperty.OriginalImage.union(ContactProperty.OriginalImageURL)) {
          originalImage = UIImage(data: data)
      }
      if let data = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)?.takeRetainedValue() as? Data , properties.contains(ContactProperty.ThumbnailImage.union(ContactProperty.ThumbnailImageURL)){
          thumbnailImage = UIImage(data: data)
      }
      
    }
  }
  convenience init(person:ABRecord) {
    self.init(person: person, withProperties: ContactProperty.AllProperties)
  }
}

@available(iOS 9.0, *)
extension Array {
	var stringArray: [String] {
		var stringArray: [String] = []

		self.forEach {
			if let phone = $0 as? CNLabeledValue<CNPhoneNumber> {
				stringArray.append(phone.value.stringValue)
			} else if let postalAddress = $0 as? CNLabeledValue<CNPostalAddress> {
				stringArray.append(postalAddress.value.stringValue())
			} else if let complementaryStringValue = $0 as? CNLabeledValue<NSString> {
				stringArray.append(String(complementaryStringValue.value))
			}
		}
		return stringArray
	}
}

@available(iOS 9.0, *)
extension CNPostalAddress {
  public func stringValue() -> String {
    return self.street + self.city + self.state + self.postalCode + country + self.isoCountryCode
  }
}

@available(iOS 9.0, *)
extension CNContact: Contact {

  public var userName: String? {
    return nil
  }

  public var kind: ContactType {
    switch contactType {
    case CNContactType.person:
      return .person
    case CNContactType.organization:
      return .organization
    }
  }

  public var phone: Array<String>? {
    return phoneNumbers.stringArray
  }

  public var emails: Array<String>? {
    return emailAddresses.stringArray
  }

  public var addresses: Array<String>? {
    return postalAddresses.stringArray
  }

  public var urls: Array<String>? {
    return urlAddresses.stringArray
  }

  public var relatedNames: Array<String>? {
    return contactRelations.stringArray
  }

  public var socialNetworkProfiles: Array<String>? {
    return socialProfiles.stringArray
  }

  public var instantMessageIdentifiers: Array<String>? {
    return instantMessageAddresses.stringArray
  }

  public var birthdayDate: Date? {
    return (birthday as NSDateComponents?)?.date
  }

  public var dateList: Array<Date>? {
    return dates.map() { $0.value.date! }
  }

  public var originalImage: UIImage? {
    if let imageData = imageData {
      return UIImage(data: imageData)
    } else {
      return nil
    }
  }

  public var thumbnailImage: UIImage? {
    if let thumbnailImageData = thumbnailImageData {
      return UIImage(data: thumbnailImageData)
    } else {
      return nil
    }
  }

  public var originalImageURL: URL? {
    return nil
  }

  public var thumbnailImageURL: URL? {
    return nil
  }
  
}
