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
	func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
		if isAuthorized {
			do {
				let defaultContainer = store.defaultContainerIdentifier()
				let predicate = CNContact.predicateForContactsInContainerWithIdentifier(defaultContainer)
				let keysToFetch = CNContactKeysFromContactProperties(properties)
				let contacts = try self.store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
				dispatch_async(dispatch_get_main_queue(), {
					success(contacts: contacts)
				})

			} catch {
				// handle error
				print("error occured")
				dispatch_async(dispatch_get_main_queue(), {
					failure(error: nil)
				})
			}

		} else {
			self.authorizeWithCompletion(success: {
				self.fetchContactsForProperties(properties, success: success, failure: failure)
				}, failure: failure)
		}
	}

	func authorizeWithCompletion(success successBlock: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {
		CNContactStore().requestAccessForEntityType(CNEntityType.Contacts) { (success: Bool, error: NSError?) in
			self.isAuthorized = success
			if success {
				dispatch_async(dispatch_get_main_queue(), {
					successBlock()
				})
			} else {
				dispatch_async(dispatch_get_main_queue(), {
					failure(error: error)
				})
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