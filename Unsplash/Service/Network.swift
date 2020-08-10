//
//  Network.swift
//  Unsplash
//
//  Created by mmxsound on 2020/08/10.
//  Copyright © 2020 mmxsound. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

enum OrderBy: String {
    case latest
    case oldest
    case popular
}

class HTTPBinDefaultAPI {
    let url = "https://api.unsplash.com/photos/?client_id=ubG1ZwktRT1RVFseWFJEkE3Hp9KJQMenLHz0RphrX6c"
    static let sharedAPI = HTTPBinDefaultAPI()

    func get(page: Int, perPage: Int, orderby: OrderBy) -> Observable<[Unsplash]> {
        let requestURL = URL(string: url + "&page=\(page)" + "&perpage=\(perPage)" + "orderby=\(orderby)")!
        print(requestURL.absoluteURL)
        return Observable.create { observer -> Disposable in
            let session = URLSession.shared.dataTask(with: requestURL) {
                (data, response, error) in
                if let error = error {
                    observer.onError(error)
                }
                do {
                    if let data = data {
                        let decoded = try JSONDecoder().decode([Unsplash].self, from: data)
                        observer.onNext(decoded)
                    }
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            session.resume()
            return Disposables.create {}
        }
    }
}

