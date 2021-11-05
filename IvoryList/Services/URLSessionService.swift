//
//  URLSessionService.swift
//  IvoryList
//
//  Created by Alexander Berezovsky on 05.11.2021.
//

import Foundation

final class URLSessionService {
    
    typealias QueryResult = ([ToDoListItem]?, String) -> Void
    static let shared = URLSessionService()
    let currentSession = URLSession(configuration: .default)
    private init() {}
    
    private var dataTask: URLSessionDataTask?
    
    private var errorMessage = ""
    private var todoListItems: [ToDoListItem] = []
    
    public func getToDoList(completion: @escaping QueryResult) { //} -> QueryResult {
        
        self.dataTask?.cancel()
        
        guard var urlComponents = URLComponents(string: Constants.baseURLString) else {
            return
        }
        urlComponents.query = Constants.getListURLString
        guard let url = urlComponents.url else {
            return
        }

        dataTask = currentSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                self?.parseSearchResults(data)
                DispatchQueue.main.async {
                    completion(self?.todoListItems, self?.errorMessage ?? "")
                }
                
            }
        }
        
        dataTask?.resume()
    }
    
    private func parseSearchResults(_ data: Data) {
        
    }
}
