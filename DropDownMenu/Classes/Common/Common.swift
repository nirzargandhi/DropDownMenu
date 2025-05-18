//
//  Common.swift
//  DropDownMenu
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import Foundation
import UIKit


// MARK: - UI / Device Related Functions
func getStoryBoard(identifier: String, storyBoardName: String) -> UIViewController {
    return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
}


// MARK: - Text Width
func getTextWidth(text: String, font: UIFont) -> CGSize {
    let size = text.size(withAttributes: [NSAttributedString.Key.font : font])
    return size
}
