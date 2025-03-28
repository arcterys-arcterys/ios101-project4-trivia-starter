//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//
//portions of this code generated by chatGPT

import Foundation

struct TriviaAPIResponse: Decodable{
    let results: [TriviaQuestion]
    
    private enum CodingKeys: String, CodingKey{
        case results = "results"
    }
}

struct TriviaQuestion: Decodable{
    let type: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    private enum CodingKeys: String, CodingKey{
        case type = "type"
        case category = "category"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        category = try container.decode(String.self, forKey: .category)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        
        // Decode HTML directly within the initializer
        let rawQuestion = try container.decode(String.self, forKey: .question)
        if let data = rawQuestion.data(using: .utf8),
           let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            question = attributedString.string
        } else {
            question = rawQuestion // Fallback to original text if decoding fails
        }
    }
}
