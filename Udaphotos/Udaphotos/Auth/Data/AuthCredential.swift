//
//  AuthCredential.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 20/07/2024.
//

import Foundation

let USER_DEFAULTS_KEY_AUTH_CREDENTIAL = "USER_DEFAULT_KEY_AUTH_CREDENTIAL"

class AuthCredential: NSObject, NSCoding, NSSecureCoding {

    private var _accessToken : String
    private var _tokenType : String
    private var _scope : String
    private var _createdAt : Double

    static var supportsSecureCoding: Bool{ get{ return true } }

    init(
        accessToken: String,
        tokenType: String,
        scope: String,
        createdAt: Double
    ){
        self._accessToken = accessToken
        self._tokenType = tokenType
        self._scope = scope
        self._createdAt = createdAt
    }

    public var accessToken : String{
        get{ return _accessToken }
    }

    public var tokenType : String{
        get { return _tokenType }
    }

    public var scope : String{
        get { return _scope }
    }

    public var createdAt : Date{
        get { return Date(timeIntervalSince1970: _createdAt) }
    }

    required init(coder: NSCoder) {
        self._accessToken = coder.decodeObject(forKey: "accessToken") as? String ?? ""
        self._tokenType = coder.decodeObject(forKey: "tokenType") as? String ?? ""
        self._scope = coder.decodeObject(forKey: "scope") as? String ?? ""
        self._createdAt = coder.decodeObject(forKey: "createdAt") as? Double ?? 0
    }

    func encode(with coder: NSCoder) {
        coder.encode(self._accessToken, forKey: "accessToken")
        coder.encode(self._tokenType, forKey: "tokenType")
        coder.encode(self._scope, forKey: "scope")
        coder.encode(self._createdAt, forKey: "createdAt")
    }
}

extension AuthCredential{
    public static func localCredential() -> AuthCredential? {
        guard let credential = UserDefaults.standard.data(forKey: USER_DEFAULTS_KEY_AUTH_CREDENTIAL) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: AuthCredential.self, from: credential)
        }
        catch{
            print("Unarchive AuthCredential failed.")
        }

        return nil
    }

    public static func storeCredential(for credential: AuthCredential?) {
        guard let credential = credential else{
            UserDefaults.standard.setValue(nil, forKey: USER_DEFAULTS_KEY_AUTH_CREDENTIAL)
            return
        }

        do{
            let authCredentialData = try NSKeyedArchiver.archivedData(withRootObject: credential, requiringSecureCoding: true)
            UserDefaults.standard.setValue(authCredentialData, forKey: USER_DEFAULTS_KEY_AUTH_CREDENTIAL)
        }
        catch{
            print("Archive AuthCredential failed.")
        }
    }
}
