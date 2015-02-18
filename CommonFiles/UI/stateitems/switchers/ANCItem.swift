//
//  ANCItem.swift
//  ParrotZik
//
//  Created by Внештатный командир земли on 18/02/15.
//  Copyright (c) 2015 Внештатный командир земли. All rights reserved.
//

import Foundation

class ANCItem: SwitcherItem {
    override var apiSet:String { get { return "/api/audio/noise_cancellation/enabled" }}
    override var path: String  { get { return "/answer/audio/noise_cancellation/@enabled" }}
    override var label: String  { get { return "ANC" }}
}