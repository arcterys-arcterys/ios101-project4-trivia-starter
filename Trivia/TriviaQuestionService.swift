//chatGPT was used to generate portions of this code
import Foundation

class TriviaQuestionService {
    static func fetchTrivia(
        completion: (([TriviaQuestion]) -> Void)? = nil) {
            let url = URL(string: "https://opentdb.com/api.php?amount=5")!
            // create a data task and pass in the URL
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // this closure is fired when the response is received
                guard error == nil else {
                    assertionFailure("Error: \(error!.localizedDescription)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    assertionFailure("Invalid response")
                    return
                }
                guard let data = data, httpResponse.statusCode == 200 else {
                    assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    // Decode as TriviaAPIResponse containing an array of results
                    let triviaResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
                    
                    // Pass the array of questions to the completion closure
                    DispatchQueue.main.async {
                        completion?(triviaResponse.results)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
        }
}
