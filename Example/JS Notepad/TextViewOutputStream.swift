//
//  TextViewOutputStream.swift
//  iOS
//
//  Created by Connor Grady on 1/17/18.
//  Copyright © 2018 Connor Grady. All rights reserved.
//

import UIKit

struct TextViewOutputStream: TextOutputStream {
    weak var textView: UITextView?
    var dateFormatter: DateFormatter? = nil//DateFormatter()
    mutating func write(_ string: String) {
        let formattedString = (
            dateFormatter != nil
            ? "[\(dateFormatter!.string(from: Date()))] \(string)"
            : string
        )
        DispatchQueue.main.async { [textView] in
            //textView?.text.append(string)
            textView?.text.append(formattedString)
        }
    }
}
