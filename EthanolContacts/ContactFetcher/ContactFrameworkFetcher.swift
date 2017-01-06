//
//  ContactFrameworkFetcher.swift
//  EthanolContacts
//
//  Created by svs-fueled on 02/09/15.
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

@available(iOS 9.0, *)
final class ContactFrameworkFetcher: NSObject, ContactFetcher {

	static let internalContactFetcher = ContactFrameworkFetcher()

	static var contactFetcher: ContactFetcher {
		return internalContactFetcher
	}

	let store = CNContactStore()

	var isAuthorized:Bool = false
	func fetchContacts(for properties: ContactProperty, success: @escaping ETHContactFetcherSuccessBlock, failure: @escaping ETHContactFetcherFailureBlock) {
		if isAuthorized {
			do {
				let defaultContainer = store.defaultContainerIdentifier()
				let predicate = CNContact.predicateForContactsInContainer(withIdentifier: defaultContainer)
				let keysToFetch = CNContactKeysFromContactProperties(properties)
				let contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
				DispatchQueue.main.async(execute: {
					success(contacts)
				})

			} catch {
				// handle error
				print("error occured")
				DispatchQueue.main.async(execute: {
					failure(nil)
				})
			}

		} else {
			self.authorize(success: {
				self.fetchContacts(for: properties, success: success, failure: failure)
			}, failure: failure)
		}
	}

	func authorize(success successBlock: @escaping ETHContactFetcherAuthorizeSuccessBlock, failure: @escaping ETHContactFetcherFailureBlock) {
		CNContactStore().requestAccess(for: CNEntityType.contacts) { (success: Bool, error: Error?) in
			self.isAuthorized = success
			if success {
				DispatchQueue.main.async(execute: {
					successBlock()
				})
			} else {
				DispatchQueue.main.async(execute: {
					failure(error)
				})
			}
		}
	}

	let CNContactKeysFromContactProperties = { (properties: ContactProperty) -> [CNKeyDescriptor] in
		var keys:[CNKeyDescriptor] = [CNContactIdentifierKey as CNKeyDescriptor, CNContactNonGregorianBirthdayKey as CNKeyDescriptor, CNContactPreviousFamilyNameKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor]

		if properties.contains(ContactProperty.GivenName) {
			keys.append(CNContactGivenNameKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.FamilyName) {
			keys.append(CNContactFamilyNameKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.MiddleName) {
			keys.append(CNContactMiddleNameKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.NamePrefix) {
			keys.append(CNContactNamePrefixKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.NameSuffix) {
			keys.append(CNContactNameSuffixKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.Nickname) {
			keys.append(CNContactNicknameKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.PhoneticGivenName) {
			keys.append(CNContactPhoneticGivenNameKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.PhoneticFamilyName) {
			keys.append(CNContactPhoneticFamilyNameKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.PhoneticMiddleName) {
			keys.append(CNContactPhoneticMiddleNameKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.OrganizationName) {
			keys.append(CNContactOrganizationNameKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.JobTitle) {
			keys.append(CNContactJobTitleKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.DepartmentName) {
			keys.append(CNContactDepartmentNameKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.BirthdayDate) {
			keys.append(CNContactBirthdayKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.Emails) {
			keys.append(CNContactEmailAddressesKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.Addresses) {
			keys.append(CNContactPostalAddressesKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.Phone) {
			keys.append(CNContactPhoneNumbersKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.Note) {
			keys.append(CNContactNoteKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.Kind) {
			keys.append(CNContactTypeKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.DateList) {
			keys.append(CNContactDatesKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.InstantMessageIdentifiers) {
			keys.append(CNContactInstantMessageAddressesKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.URLs) {
			keys.append(CNContactUrlAddressesKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.SocialNetworkProfiles) {
			keys.append(CNContactSocialProfilesKey as CNKeyDescriptor)
		}
		if properties.contains(ContactProperty.RelatedNames) {
			keys.append(CNContactRelationsKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.OriginalImage) || properties.contains(ContactProperty.OriginalImageURL) {
			keys.append(CNContactImageDataKey as CNKeyDescriptor)
		}

		if properties.contains(ContactProperty.ThumbnailImage) || properties.contains(ContactProperty.ThumbnailImageURL) {
			keys.append(CNContactThumbnailImageDataKey as CNKeyDescriptor)
		}

		return keys
	}
}
