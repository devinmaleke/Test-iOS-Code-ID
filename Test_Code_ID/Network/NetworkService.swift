//
//  NetworkService.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import Alamofire
import RxSwift

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

class NetworkService {

    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://pokeapi.co/api/v2/"

    func requestObservable<T: Decodable>(
        url: String,
        method: HTTPMethodType,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        responseType: T.Type
    ) -> Observable<T> {
        return Observable.create { observer in
            let afMethod = HTTPMethod(rawValue: method.rawValue)
            let fullURL = self.baseURL + url

            print("[Request] \(method.rawValue) \(fullURL)")
            if let params = parameters {
                print("[Request Params] \(params)")
            }

            let request = AF.request(fullURL, method: afMethod, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseData { response in

                    print("[Response] \(response.response?.statusCode ?? -1) \(fullURL)")

                    switch response.result {
                    case .success(let data):
                        let responseBody = String(data: data, encoding: .utf8) ?? "<binary data>"
                        print("[Response Body] \(responseBody)")

                        do {
                            let decoded = try JSONDecoder().decode(responseType, from: data)
                            observer.onNext(decoded)
                            observer.onCompleted()
                        } catch {
                            print("[Decoding Error] \(error)")
                            observer.onError(NetworkError.decodingError(error))
                        }

                    case .failure(let afError):
                        print("[AFError] \(afError)")
                        
                        let statusCode = response.response?.statusCode ?? -1
                        
                        if let data = response.data,
                           let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            print("[API Error] \(apiError.message)")
                            observer.onError(NetworkError.apiError(apiError.message))
                        } else {
                            let underlyingError = afError.underlyingError as? URLError
                            if let urlError = underlyingError {
                                observer.onError(NetworkError.urlError(urlError))
                            } else {
                                observer.onError(NetworkError.unknown(statusCode: statusCode, error: afError))
                            }
                        }
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
