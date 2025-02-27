//
//  APIConstants.swift
//  BaseNetWork
//
//  Created by Nguyen Son on 27/2/25.
//

import Foundation

struct APIConstants {
    static let baseURL = "https://27b7895e-ecde-4bff-ac69-8600fdae8cdc.mock.pstmn.io"
}

enum APIEndpoint {
    case getUser
    case createUser(name: String)
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)

    var url: String {
        switch self {
        case .getUser:
            return "\(APIConstants.baseURL)/userMain"
        case .createUser, .updateUser, .deleteUser:
            return "\(APIConstants.baseURL)/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case .getUser:
            return nil
        case .createUser(let name), .updateUser(_, let name):
            let params = ["name": name]
            return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        case .deleteUser:
            return nil
        }
    }
}
