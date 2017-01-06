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
final class AddressBookFetcher: NSObject, ContactFetcher {

	static let internalAddressBookFetcher = AddressBookFetcher()
	static var contactFetcher: ContactFetcher {
		return internalAddressBookFetcher
	}

	var addressBook: ABAddressBook?

	var isAuthorized: Bool {
		return ABAddressBookGetAuthorizationStatus() == .authorized && (addressBook != nil)
	}

	public func fetchContacts(for properties: ContactProperty, success: @escaping (Array<Contact>) -> Void, failure: @escaping (Error?) -> Void) {
		if isAuthorized {
			do {
				let contacts = try self.contactsFromAddressBookWithGivenProperties(properties)

				DispatchQueue.main.async(execute: {
					success(contacts)
				})
			} catch {
				DispatchQueue.main.async(execute: {
					failure(self.errorWithInfo("something happened", "contacts werent fetched"))
				})
			}
		} else {
			authorize(success: { () -> () in
				self.fetchContacts(for: properties, success: success, failure: failure)
				}, failure: { (error) in
					DispatchQueue.main.async(execute: {
						failure(error)
					})
			})
		}
	}

	public func authorize(success: @escaping () -> (), failure: @escaping (Error?) -> Void) {

		guard let thisAddressBook = ABAddressBookCreate().takeRetainedValue() as ABAddressBook? else {
			DispatchQueue.main.async(execute: {
				failure(self.errorWithInfo("EthanolContactAuthorizationFailed", "EthanolContactAddressBookFailedToCreate"))
			})
			return
		}

		addressBook = thisAddressBook

		if(isAuthorized) {
			DispatchQueue.main.async(execute: {
				success()
			})
		} else {
			let completionHandler:ABAddressBookRequestAccessCompletionHandler = { (granted: Bool, error: CFError!) in
				DispatchQueue.main.async(execute: {
					if let error = error {
						failure(self.errorWithInfo(error.localizedDescription, "EthanolContactRequestAccessError"))
					} else if(!granted) {
						failure(self.errorWithInfo("EthanolContactFetchFailed", "EthanolContactPhoneNotAllowed"))
					} else {
						success()
					}
				})
			} as! ABAddressBookRequestAccessCompletionHandler
			ABAddressBookRequestAccessWithCompletion(thisAddressBook, completionHandler)
		}
	}

	func errorWithInfo(_ description:String, _ reason:String) -> NSError {
		let userInfo = [NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason]
		return NSError(domain: "com.fueled.Ethanol", code: 1214, userInfo: userInfo)
	}

	func contactsFromAddressBookWithGivenProperties(_ propertiesFlag:ContactProperty) throws -> [Contact] {

		guard let addressBook = addressBook else {
			throw self.errorWithInfo("EthanolContactFetchFailed", "SomethingWentWrong")
		}

		var contacts = [Contact]()
		if let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray? {
			for person in people {
				if let person = person as ABRecord? {
					let contact = PhoneContact(person: person, withProperties:propertiesFlag)
					contacts.append(contact)
				}
			}
		}
		return contacts
	}
}
