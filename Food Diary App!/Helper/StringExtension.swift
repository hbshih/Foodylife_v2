//
//  StringExtension.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
