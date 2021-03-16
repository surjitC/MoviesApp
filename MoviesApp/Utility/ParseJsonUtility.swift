//
//  ParseJsonUtility.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import Foundation

public enum FileType: String {
    case json
}

public enum MockFile: String {
    case Movie = "movies"
}

//APPError enum which shows all possible errors
public enum AppError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonReadingError(Error)
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case invalidURL
}

//Result enum to show success or failure
public enum CustomResult<T> {
    case success(T)
    case failure(AppError)
}

struct JsonParserUtility {
    
    func parseJson<T: Decodable>(fileName: MockFile, fileType: FileType = .json, resultType: T.Type, completionHandler: @escaping ((CustomResult<T>) -> Void)) {
        guard let path = Bundle.main.path(forResource: fileName.rawValue, ofType: fileType.rawValue) else {
            completionHandler(CustomResult.failure(.dataNotFound))
            return
        }
            var data = Data()
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch let error {
                // handle error
                completionHandler(CustomResult.failure(.jsonReadingError(error)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let movieModelList = try decoder.decode(resultType.self, from: data)
                completionHandler(CustomResult.success(movieModelList))
            } catch let error {
                // handle error
                completionHandler(CustomResult.failure(.jsonParsingError(error)))
            }
        
    }
}
