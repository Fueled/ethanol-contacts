//
//  ContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
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

import UIKit

public typealias ETHContactFetcherAuthorizeSuccessBlock = () -> ()
public typealias ETHContactFetcherSuccessBlock = (_ contacts: Array<Contact>) -> Void
public typealias ETHContactFetcherFailureBlock = (_ error: Error?) -> Void

/**
*  A protocol designed to be followed, for fetching contacts.
*/

public protocol ContactFetcher {

  /**
  *  Should Create a new instance of the implementing class following ContactFetcher or one of its subclass.
  *
  *  @return An instance following ContactFetcher
  */
  static var contactFetcher: ContactFetcher { get }
  
  /**
  *  Check whether the user is authorized or not to fetch the contact.
  *
  *  @return A BOOL indicating whether the user is authorized or not.
  */

  var isAuthorized: Bool { get }

  /**
  *  Allow to fetch contacts.
  *  The fetched contacts will only have the properties set
  *
  *  @discussion This method will call authorizeWithSuccess internally if the user is not yet authorized.
  *  @param properties		 The properties that should be retrieved from each contacts.
  *  @param success        Block called when the contacts have been successfuly fetched.
  *  @param failure        Block called when the contacts haven't been successfuly fetched.
  */

	func fetchContacts(for properties: ContactProperty, success: @escaping (Array<Contact>) -> Void, failure: @escaping (Error?) -> Void);

  /**
  *  Pre-authorize a user.
  *
  *  @discussion If the success block is called, fetchContactsWithSuccess: methods will not re-authorized the user and isAuthorized shall return true.
  *  If isAuthorized returns YES, this method will directly call the success block.
  *  @param success Block called when the user has been successfuly authorized.
  *  @param failure Block called when the user hasn't been successfuly authorized.
  */

	func authorize(success: @escaping () -> (), failure: @escaping (Error?) -> Void);
}

/** Default implementation of fetchContactsWithCompletion to return contacts with all properties */
extension ContactFetcher {

	/**
	*  Allow to fetch contacts.
	*  The fetched contacts will have all of their properties set.
	*
	*  @param success Block called when the contacts have been successfuly fetched.
	*  @param failure Block called when the contacts haven't been successfuly fetched.
	*/

 public func fetchContactsWithCompletion(success: @escaping ETHContactFetcherSuccessBlock, failure: @escaping ETHContactFetcherFailureBlock) {
		self.fetchContacts(for: ContactProperty.AllProperties, success: success, failure: failure)
  }
}
