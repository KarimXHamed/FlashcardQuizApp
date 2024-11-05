//
//  FetchViewModel.swift
//  flashCardApp
//
//  Created by karim hamed ashour on 10/10/24.
//

import UIKit

class FetchViewModel: NSObject {
    
    var myQuiz=[Quiz]()
    
        func fetchQuiz(link: String, completion: @escaping ([Quiz]) -> Void) {
              // Define the URL for the GitHub API
              let token = "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"
              let url = URL(string: link)!
              
              // Define the headers for the request
              var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
              request.httpMethod = "GET"
              request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
              
              // Make the request
              let task = URLSession.shared.dataTask(with: request) { data, response, error in
                  if let error = error {
                      print("Error making request: \(error)")
                      return
                  }
                  
                  guard let data = data else {
                      print("No data returned")
                      return
                  }
                  
                  // Parse the JSON data
                  do {
                      let quiz = try JSONDecoder().decode([Quiz].self, from: data)
                      completion(quiz)
                  } catch {
                      print("Error parsing JSON: \(error)")
                  }
              }
              
              // Handle the response
              task.resume()
            

          }
      }

