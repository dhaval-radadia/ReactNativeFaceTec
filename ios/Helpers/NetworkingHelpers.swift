// Demonstrates calling the FaceTec Managed Testing API and/or FaceTec Server

import UIKit
import Foundation
// import FaceTecAuthentication

// Possible directives after parsing the result from FaceTec Server
enum UXNextStep {
    case Succeed
    case Retry
    case Cancel
}

class NetworkingHelpers {
    /*// Get the Session Token from the server
    class func getSessionToken(sessionTokenCallback: @escaping (String?) -> ()) {
        let endpoint = FaceTecGlobalState.FaceTecServerBaseURL! + "/session-token"
        let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL)

        request.httpMethod = "GET"
        // Required parameters to interact with the FaceTec Managed Testing API.
        request.addValue(FaceTecGlobalState.DeviceLicenseKeyIdentifier!, forHTTPHeaderField: "X-Device-License-Key")

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // Ensure the data object is not nil otherwise callback with empty dictionary.
            if let data = data {
                if let responseJSONObj = try? (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]) {
                    if((responseJSONObj["data"] as? [String : Any]) != nil
                        && (responseJSONObj["data"] as? [String : Any])?["sessionToken"] as? String != nil)
                    {
                        sessionTokenCallback((responseJSONObj["data"] as? [String : Any])?["sessionToken"] as? String)
                        return
                    }
                }
            }

            sessionTokenCallback(nil)
        }

        task.resume()
    }

    // Set up common parameters needed to communicate to the API.
    class func getEnrollmentParameters(faceTecSessionResult: FaceTecSessionResult) -> [String : Any] {
        let faceTecFaceMapBase64 = faceTecSessionResult.faceMetrics?.faceMapBase64;

        var parameters: [String : Any] = [:]
        parameters["faceMap"] = faceTecFaceMapBase64
        parameters["sessionId"] = faceTecSessionResult.sessionId

        if let auditTrail = faceTecSessionResult.faceMetrics?.auditTrailCompressedBase64 {
            parameters["auditTrailImage"] = auditTrail[0]
        }

        // pass the low quality audit trail image
        if let lowQualityAuditTrail = faceTecSessionResult.faceMetrics?.lowQualityAuditTrailCompressedBase64 {
            parameters["lowQualityAuditTrailImage"] = lowQualityAuditTrail[0]
        }

        return parameters
    }

    // Makes the actual call to the API.
    // Note that for initial integration this sends to the FaceTec Managed Testing API.
    // After deployment of your own instance of FaceTec Server, this will be your own configurable endpoint.
    class func callToGoodServerForResult(
        endpoint: String,
        method: String,
        parameters: [String: Any],
        jwtAccessToken: String,
        urlSessionDelegate: URLSessionDelegate,
        resultCallback: @escaping ([String : AnyObject]) -> ()
        )
    {
        let endpointUrl = "\(FaceTecGlobalState.GoodServerURL!)/\(endpoint)"
        let request = NSMutableURLRequest(url: NSURL(string: endpointUrl)! as URL)

        request.httpMethod = method
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Required parameters to interact with the GoodServer
        request.addValue("Bearer: \(jwtAccessToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: urlSessionDelegate, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // Ensure the data object is not nil otherwise callback with empty dictionary.
            if let data = data {
                if let responseJSONObj = try? (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]) {
                    resultCallback(responseJSONObj)
                    return
                }
            }

            resultCallback([:])
        }

        task.resume()
    }

    // Create and send the request.  Parse the results and send the caller what the next step should be (Succeed, Retry, or Cancel).
    public class func getEnrollmentResponseFromGoodServer(
        enrollmentIdentifier: String,
        faceTecSessionResult: FaceTecSessionResult,
        jwtAccessToken: String,
        urlSessionDelegate: URLSessionDelegate,
        resultCallback: @escaping (UXNextStep, String?, [String: Any]?) -> ()
        )
    {
        let parameters = getEnrollmentParameters(faceTecSessionResult: faceTecSessionResult)
        let encodedEnrollmentId = enrollmentIdentifier.addingPercentEncoding(withAllowedCharacters:  NSMutableCharacterSet.urlQueryAllowed)!

        callToGoodServerForResult(
            endpoint: "/verify/face/\(encodedEnrollmentId)",
            method: "PUT",
            parameters: parameters,
            jwtAccessToken: jwtAccessToken,
            urlSessionDelegate: urlSessionDelegate
        ) { responseJSONObj in
            let nextStep = ServerResultHelpers.getEnrollmentNextStep(responseJSONObj: responseJSONObj)
            let lastMessage = ServerResultHelpers.getEnrollmentResultMessage(responseJSONObj: responseJSONObj)
            let lastResult = ServerResultHelpers.getEnrollmentResult(responseJSONObj: responseJSONObj)

            resultCallback(nextStep, lastMessage, lastResult)
        }
    }*/
}

// Helpers for parsing API response to determine if result was a success vs. user needs retry vs. unexpected (cancel out)
class ServerResultHelpers {
    /*public class func getEnrollmentResult(_ responseJSONObj: [String: AnyObject]) -> [String: Any]? {
        return responseJSONObj["enrollmentResult"] as? [String : Any]
    }

    // If isEnrolled and Liveness was Determined, succeed.  Otherwise retry.  Unexpected responses cancel.
    public class func getEnrollmentNextStep(responseJSONObj: [String: AnyObject]) -> UXNextStep {
        let isSuccess = responseJSONObj["success"] as? Bool

        if isSuccess != false {
            return .Succeed
        }

        let enrollmentResult = ServerResultHelpers.getEnrollmentResult(responseJSONObj)
        let isEnrolled = enrollmentResult?["isEnrolled"] as? Bool
        let isLive = enrollmentResult?["isLive"] as? Bool
        let code = enrollmentResult?["code"] as? Int

        // if code is 200 then we have some client-side issues
        // (e.g. low images quality, glasses weared, too dark etc)
        // in this case we're asking to retry capturing
        if (200 == code && (isLive == false || isEnrolled == false)) {
            return .Retry
        }

        // otherwise we're cancelling session
        return .Cancel
    }

    public class func getEnrollmentResultMessage(responseJSONObj: [String: AnyObject]) -> String? {
        let isSuccess = responseJSONObj["success"] as? Bool

        if isSuccess != false {
            return "The FaceMap was successfully enrolled."
        }

        return responseJSONObj["error"] as? String
    }*/
}
