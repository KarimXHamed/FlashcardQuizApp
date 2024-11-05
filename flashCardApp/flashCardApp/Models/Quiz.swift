//
//  Quiz.swift
//  flashCardApp
//
//  Created by karim hamed ashour on 10/7/24.
//

import UIKit
struct Question:Codable{
    var text:String
}
struct Quiz:Codable {
    var correctAnswer:String
    var question:Question
    var category:String

}

