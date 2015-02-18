//
//  PhoneANCItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

class PhoneANCItem: SwitcherItem {
    override var apiSet:String { get { return "/api/system/anc_phone_mode/enabled" }}
    override var path: String  { get { return "/answer/system/anc_phone_mode/@enabled" }}
    override var label: String  { get { return "Phone ANC" }}
}
