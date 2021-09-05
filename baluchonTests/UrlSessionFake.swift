//
//  UrlSessionFake.swift
//  baluchonTests
//
//  Created by laurent aubourg on 31/08/2021.
//

import Foundation

class UrlSessionFake:URLSession{
    var completionHandler: ((Data?,URLResponse?,Error?)->Void)?
    var data:Data?
    var response:URLResponse?
    var error: Error?
    init(data:Data?,response:URLResponse?,error:Error?){
        self.data = data
        self.response = response
        self.error = error
    }
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = UrlSessionDataTaskFake()
        task.data = data
        task.urlResponse = response
        task.errorResponse = error
        task.completionHandler = completionHandler
        return task
    }
    override func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)  -> URLSessionDataTask{
        let task = UrlSessionDataTaskFake()
        task.data = data
        task.urlResponse = response
        task.errorResponse = error
        task.completionHandler = completionHandler
        return task
    }
}
class UrlSessionDataTaskFake:URLSessionDataTask{
    var completionHandler: ((Data?,URLResponse?,Error?)->Void)?
    var data:Data?
    var urlResponse:URLResponse?
    var errorResponse:Error?
    override func resume() {
        completionHandler?(data,urlResponse,errorResponse)
    }
    override func cancel() {}
}
