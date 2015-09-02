//
//  AddressBookFetcher.swift
//  EthanolContacts
//
//  Created by svs-fueled on 02/09/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation
import AddressBook

@available(iOS 8.0, *)
final class AddressBookFetcher:NSObject, ContactFetcher {

	static let internalAddressBookFetcher = AddressBookFetcher()
	static var contactFetcher: ContactFetcher {
		return internalAddressBookFetcher
	}

	var addressBook:ABAddressBookRef?

	var isAuthorized:Bool {
		return ABAddressBookGetAuthorizationStatus() == .Authorized && (addressBook != nil)
	}

	func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
		if isAuthorized {
			do {
				let contacts = try self.contactsFromAddressBookWithGivenProperties(properties)

				dispatch_async(dispatch_get_main_queue(), {
					success(contacts: contacts)
				})
			} catch {
				dispatch_async(dispatch_get_main_queue(), {
					failure(error: self.errorWithInfo("something happened", "contacts werent fetched"))
				})
			}
		} else {
			authorizeWithCompletion(success: { () -> () in
				self.fetchContactsForProperties(properties, success: success, failure: failure)
				}, failure: { (error) in
					dispatch_async(dispatch_get_main_queue(), {
						failure(error: error)
					})
			})
		}
	}

	func authorizeWithCompletion(success successBlock: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock) {

		guard let thisAddressBook = ABAddressBookCreate().takeRetainedValue() as ABAddressBook? else {
			dispatch_async(dispatch_get_main_queue(), {
				failure(error: self.errorWithInfo("EthanolContactAuthorizationFailed", "EthanolContactAddressBookFailedToCreate"))
			})
			return
		}

		addressBook = thisAddressBook

		if(isAuthorized) {
			dispatch_async(dispatch_get_main_queue(), {
				successBlock()
			})
		} else {
			let completionHandler:ABAddressBookRequestAccessCompletionHandler = { (granted:Bool, error:CFError!) in
				dispatch_async(dispatch_get_main_queue(), {
					if let error = error {
						failure(error: (error as NSError))
					} else if(!granted) {
						failure(error: self.errorWithInfo("EthanolContactFetchFailed", "EthanolContactPhoneNotAllowed"))
					} else {
						successBlock()
					}
				})
			}
			ABAddressBookRequestAccessWithCompletion(thisAddressBook, completionHandler)
		}
	}

	func errorWithInfo(description:String, _ reason:String) -> NSError {
		let userInfo = [NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason]
		return NSError(domain: "com.fueled.Ethanol", code: 1214, userInfo: userInfo)
	}

	func contactsFromAddressBookWithGivenProperties(propertiesFlag:ContactProperty) throws -> [Contact] {

		guard let addressBook = addressBook else {
			throw self.errorWithInfo("EthanolContactFetchFailed", "SomethingWentWrong")
		}

		var contacts = [Contact]()
		if let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray? {
			for person in people {
				if let person = person as ABRecordRef? {
					let contact = PhoneContact(person: person, withProperties:propertiesFlag)
					contacts.append(contact)
				}
			}
		}
		return contacts
	}
}

