//
//  APIManager.swift
//  HantongWatch WatchKit Extension
//
//  Created by SONGKIWON on 2020/08/02.
//  Copyright © 2020 intosharp. All rights reserved.
//

import Foundation
//import Alamofire

struct APIManager {
    
    struct API_HOST {
        static let host = "https://firestore.googleapis.com"
    }
    
    struct urls {
        
        // 패스워드
        static let password = APIManager.getUrl("/v1/projects/hantongcalcrawl/databases/(default)/documents/Password/S79sAnKS1wkVGIwqntos")
        
        // 판매현황
        static let sales_status = APIManager.getUrl("/v1/projects/hantongcalcrawl/databases/(default)/documents/SalesStatus/GIfe230j8lFmLatxU2F0")
                
    }
    
    static func getUrl(_ apiUrl: String) -> String {
        return API_HOST.host + apiUrl
    }
}

class API {
    
    static let sharedInstance: API = API()
    
    let dataStore = DataStore()
    
    func request(_ urlString: String, success: @escaping ([String : Any?]) -> Void, failure: @escaping (Error?) -> Void) {
        
        // HTTP
        guard let session_url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "urlString is null"])
            failure(error)
            return
        }
        
        var session_request = URLRequest(url: session_url)
        session_request.httpMethod = "get"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: session_request) { (data, response, responseError) in
            //debugPrint("response: \(String(describing: response))")
            if let error = responseError {
                failure(error)
                return
            }
            
                        
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "data is null"])
                failure(error)
                return
            }
            
            //guard let response_str = String(data: data, encoding: .utf8) else {
            //    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "response_str is null"])
            //    failure(error)
            //    return
            //}
            //debugPrint("response_str -> \(response_str)")
  
            do {
                let result = try JSONSerialization.jsonObject(with: data) as! [String:Any?]
                success(result)
            } catch {
                failure(error)
            }
        }
        task.resume()
        
    }
    
/*
    func alamofireRequest(_ urlString: String,
                          _ method: Alamofire.HTTPMethod,
                          _ parameters: Parameters? = nil,
                          _ headers: HTTPHeaders? = nil,
                          success: @escaping ([String : Any?]) -> Void,
                          failure: @escaping (Error?) -> Void) {
        
        AF.request(urlString, method: method, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseJSON { (response) in
            switch (response.result) {
            case .success(let value):
                debugPrint ("success : \(value)")
                guard let data = response.data else {
                    let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey : "Response data is null"])
                    failure(error)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data) as! [String:Any?]
                    success(result)
                } catch {
                    failure(error)
                }
                
            case .failure(let error):
                debugPrint("failure : \(error.localizedDescription)")
                var resultError: String = "Unknown error";
                switch error {
                case .invalidURL(let url):
                    resultError = "Invalid URL: \(url) - \(error.localizedDescription)"
                case .parameterEncodingFailed(let reason):
                    resultError = "Parameter encoding failed: \(error.localizedDescription) Failure Reason: \(reason)"
                case .multipartEncodingFailed(let reason):
                    resultError = "Multipart encoding failed: \(error.localizedDescription) Failure Reason: \(reason)"
                case .responseValidationFailed(let reason):
                    let message = "Response validation failed: \(error.localizedDescription) Failure Reason: \(reason)"
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        resultError =  message + "Downloaded file could not be read"
                    case .missingContentType(let acceptableContentTypes):
                        resultError =  message + "Content Type Missing: \(acceptableContentTypes)"
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        resultError =  message + "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                    case .unacceptableStatusCode(let code):
                        resultError =  message + "Response status code was unacceptable: \(code) statusCode:\(String(describing: response.response?.statusCode))"
                    case .customValidationFailed(error: let cvError):
                        resultError =  message + "Response customValidationFailed: \(cvError) statusCode:\(String(describing: response.response?.statusCode))"
                    }
                case .responseSerializationFailed(let reason):
                    resultError = "Response serialization failed: \(error.localizedDescription) Failure Reason: \(reason)"
                default:
                    resultError = "URLError occurred: \(error)"
                }
                let failureError = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey : resultError])
                failure(failureError)
            }
        }
    }
*/
    
    func getIntegerValue(value: String?) -> Int {
        guard let value = value else { return 0 }
        return Int(value) ?? 0
    }
    
    // 판매현황 가져오기
    func sales_status(result: @escaping (Error?) -> Void) {
        //self.alamofireRequest(APIManager.urls.sales_status, .get, nil, success: { (data) in
        self.request(APIManager.urls.sales_status, success: { (data) in
            guard let fields = data["fields"] as? NSDictionary else {
                result(nil)
                return
            }
            
            // 금일
            if let todaySum = fields["today_sum"] as? NSDictionary {
                self.dataStore.todaySum = self.getIntegerValue(value: (todaySum["integerValue"] as? String))
            }
            
            // 전일
            if let yesterdaySum = fields["yesterday_sum"] as? NSDictionary {
                self.dataStore.yesterdaySum = self.getIntegerValue(value: (yesterdaySum["integerValue"] as? String))
            }
            
            // 당월
            if let thisMonthSum = fields["this_month_sum"] as? NSDictionary {
                self.dataStore.thisMonthSum = self.getIntegerValue(value: (thisMonthSum["integerValue"] as? String))
                
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "M"
                let month: Int = Int(monthFormatter.string(from: Date())) ?? 0
                
                // 퍼센트
                let goal = self.dataStore.goals[month];
                let percent = (round((Double(self.dataStore.thisMonthSum ?? 0) / goal) * 100)) as NSNumber
                self.dataStore.percent = percent.stringValue
                
                // 당월 목표금액
                self.dataStore.goal = Int(self.dataStore.goals[month]).decimalType();
                
            }
            
            // 전월
            if let lastMonthSum = fields["last_month_sum"] as? NSDictionary {
                self.dataStore.lastMonthSum = self.getIntegerValue(value: (lastMonthSum["integerValue"] as? String))
            }
            
            // 서버에 저장된 시간
            if let timestampDict = fields["timestamp"] as? NSDictionary {
                if let timestampValue = timestampDict["timestampValue"] as? String {
                    let formatter = DateFormatter()
                    formatter.locale = .current
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let date = formatter.date(from: timestampValue) {
                        self.dataStore.serverUpdateDate = date
                    }
                }
            }
                
            result(nil)
            
        }) { (error) in
            result(error)
        }
    }
    
    // 금일, 당월 판매현황 가져오기
    func todayAndTishMonthSum(result: @escaping () -> Void) {
        debugPrint("todayAndTishMonthSum")
        
        if dataStore.checkUnlockDate() {
            debugPrint("todayAndTishMonthSum checkUnlockDate true")
            result()
            return
        }
        
        //self.alamofireRequest(APIManager.urls.sales_status, .get, nil, success: { (data) in
        self.request(APIManager.urls.sales_status, success: { (data) in
            guard let fields = data["fields"] as? NSDictionary else {
                debugPrint("fields is null")
                result()
                return
            }
            
            // 금일
            if let todaySum = fields["today_sum"] as? NSDictionary {
                self.dataStore.todaySum = self.getIntegerValue(value: (todaySum["integerValue"] as? String))
            }
            
            // 당월
            if let thisMonthSum = fields["this_month_sum"] as? NSDictionary {
                self.dataStore.thisMonthSum = self.getIntegerValue(value: (thisMonthSum["integerValue"] as? String))
            }
            
            self.dataStore.lastUpdateDate = Date()
            debugPrint("todayAndTishMonthSum is success : \(String(describing: self.dataStore.lastUpdateDate))")
            result()
            
        }) { (error) in
            debugPrint(error?.localizedDescription ?? "")
            result()
        }
    }
    
    // 패스워드 가져오기
    func serverPassword(result: @escaping () -> Void) {
        debugPrint("serverPassword")
        self.request(APIManager.urls.password, success: { (data) in
            guard let fields = data["fields"] as? NSDictionary else {
                debugPrint("fields is null")
                result()
                return
            }
            
            // 패스워드
            if let pw = fields["pw"] as? NSDictionary {
                self.dataStore.serverPassword = pw["stringValue"] as? String
            }
            result()
            
        }) { (error) in
            debugPrint(error?.localizedDescription ?? "")
            result()
        }
    }
}
