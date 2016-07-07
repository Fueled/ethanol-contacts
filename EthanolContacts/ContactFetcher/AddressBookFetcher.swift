//
//  AddressBookFetcher.swift
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

