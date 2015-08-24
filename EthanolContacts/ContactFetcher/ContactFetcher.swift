//
//  ContactFetcher.swift
//  EthanolContacts
//
//  Created by hhs-fueled on 20/08/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit

public typealias ETHContactFetcherAuthorizeSuccessBlock = () -> ()
public typealias ETHContactFetcherSuccessBlock = (contacts: Array<Contact>) -> Void
public typealias ETHContactFetcherFailureBlock = (error: NSError?) -> Void

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

  var isAuthorized:Bool { get }

  /**
  *  Allow to fetch contacts. This method is designed to be implemented in subclasses.
  *  The fetched contacts will have all of their properties set.
  *
  *  @param success Block called when the contacts have been successfuly fetched.
  *  @param failure Block called when the contacts haven't been successfuly fetched.
  */

  func fetchContactsWithCompletion(success success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock);

  /**
  *  Allow to fetch contacts. This method is designed to be implemented in subclasses.
  *  The fetched contacts will only have the properties set
  *
  *  @discussion This method will call authorizeWithSuccess internally if the user is not yet authorized.
  *  @param propertiesFlag The properties that should be retrieved from each contacts.
  *  @param success        Block called when the contacts have been successfuly fetched.
  *  @param failure        Block called when the contacts haven't been successfuly fetched.
  */

  func fetchContactsForProperties(properties: ContactProperty, success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock);

  /**
  *  Pre-authorize a user.
  *
  *  @discussion If the success block is called, fetchContactsWithSuccess: methods will not re-authorized the user and isAuthorized shall return true.
  *  If isAuthorized returns YES, this method will directly call the success block.
  *  @param success Block called when the user has been successfuly authorized.
  *  @param failure Block called when the user hasn't been successfuly authorized.
  */

  func authorizeWithCompletion(success success: ETHContactFetcherAuthorizeSuccessBlock, failure: ETHContactFetcherFailureBlock);
}


extension ContactFetcher {
 public func fetchContactsWithCompletion(success success: ETHContactFetcherSuccessBlock, failure: ETHContactFetcherFailureBlock) {
    self.fetchContactsForProperties(ContactProperty.AllProperties, success: success, failure: failure)
  }
}
