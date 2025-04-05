//
//  AppIDViewModel.swift
//  Entitlement
//
//  Created by s s on 2025/3/15.
//
import SwiftUI
import StosSign

enum Entitlement: String, CaseIterable {
    case networkSlicing = "5G_NETWORK_SLICING"
    case accessWifiInfo = "ACCESS_WIFI_INFO"
    case accessibilityMerchantApi = "ACCESSIBILITY_MERCHANT_API_CONTROL"
    case appAttest = "APP_ATTEST"
    case applicationGroups = "APPLICATION_GROUPS_ENTITLEMENT"
    case autofillCredentialProvider = "AUTOFILL_CREDENTIAL_PROVIDER"
    case classKit = "CLASSKIT"
    case criticalMessaging = "CRITICAL_MESSAGING"
    case networkCustomProtocol = "NETWORK_CUSTOM_PROTOCOL"
    case dataProtection = "DATA_PROTECTION_PERMISSION_LEVEL"
    case driverKit = "DRIVERKIT"
    case fontInstallation = "FONT_INSTALLATION"
    case fsKit = "FSKIT_MODULE"
    case gameCenter = "GAME_CENTER"
    case groupActivities = "GROUP_ACTIVITIES"
    case headPose = "HEAD_POSE"
    case healthKit = "HEALTHKIT"
    case healthKitDeveloper = "HEALTHKIT_DEVELOPER_ACCESS"
    case healthKitBackground = "HEALTHKIT_BACKGROUND_DELIVERY"
    case healthKitRecalibrate = "HEALTHKIT_RECALIBRATE_ESTIMATES"
    case hlsInterstitial = "HLS_INTERSTITIAL_PREVIEW"
    case homeKit = "HOMEKIT"
    case hotSpot = "HOT_SPOT"
    case iCloud = "ICLOUD"
    case increasedMemory = "INCREASED_MEMORY_LIMIT"
    case inAppPayments = "IN_APP_PAYMENTS"
    case maps = "MAPS"
    case mediaDeviceDiscovery = "MEDIA_DEVICE_DISCOVERY_EXTENSION"
    case multipath = "MULTIPATH"
    case nearbyInteraction = "NEARBY_INTERACTION"
    case networkExtensions = "NETWORK_EXTENSIONS"
    case nfcTagReading = "NFC_TAG_READING"
    case personalVpn = "PERSONAL_VPN"
    case pushNotifications = "PUSH_NOTIFICATIONS"
    case rawPhotosAccess = "RAW_PHOTOS_ACCESS"
    case rawSensorsAccess = "RAW_SENSORS_ACCESS"
    case sharedIpadSupervised = "SHARED_IPAD_SUPERVISED_MODE"
    case siri = "SIRI"
    case timeSensitiveNotifications = "TIME_SENSITIVE_NOTIFICATIONS"
    case userActivity = "USER_ACTIVITY"
    case userManagement = "USER_MANAGEMENT"
    case userNotificationsTimeSensitive = "USER_NOTIFICATIONS_TIME_SENSITIVE"
    case vendorDeepLinks = "VENDOR_DEEP_LINKS"
    case wallet = "WALLET"
    case webkitBrowser = "WEBKIT_BROWSER_ENGINE"
    case wifiInfo = "WIFI_INFO"
    case wirelessAccessory = "WIRELESS_ACCESSORY_CONFIGURATION"
    
    var displayName: String {
        switch self {
        case .networkSlicing: return "5G Network Slicing"
        case .accessWifiInfo: return "Access WiFi Info"
        case .accessibilityMerchantApi: return "Accessibility Merchant API"
        case .appAttest: return "App Attest"
        case .applicationGroups: return "Application Groups"
        case .autofillCredentialProvider: return "Autofill Credential Provider"
        case .classKit: return "ClassKit"
        case .criticalMessaging: return "Critical Messaging"
        case .networkCustomProtocol: return "Network Custom Protocol"
        case .dataProtection: return "Data Protection"
        case .driverKit: return "DriverKit"
        case .fontInstallation: return "Font Installation"
        case .fsKit: return "FSKit Module"
        case .gameCenter: return "Game Center"
        case .groupActivities: return "Group Activities"
        case .headPose: return "Head Pose"
        case .healthKit: return "HealthKit"
        case .healthKitDeveloper: return "HealthKit Developer Access"
        case .healthKitBackground: return "HealthKit Background Delivery"
        case .healthKitRecalibrate: return "HealthKit Recalibrate Estimates"
        case .hlsInterstitial: return "HLS Interstitial Preview"
        case .homeKit: return "HomeKit"
        case .hotSpot: return "Hot Spot"
        case .iCloud: return "iCloud"
        case .increasedMemory: return "Increased Memory"
        case .inAppPayments: return "In-App Payments"
        case .maps: return "Maps"
        case .mediaDeviceDiscovery: return "Media Device Discovery"
        case .multipath: return "Multipath"
        case .nearbyInteraction: return "Nearby Interaction"
        case .networkExtensions: return "Network Extensions"
        case .nfcTagReading: return "NFC Tag Reading"
        case .personalVpn: return "Personal VPN"
        case .pushNotifications: return "Push Notifications"
        case .rawPhotosAccess: return "Raw Photos Access"
        case .rawSensorsAccess: return "Raw Sensors Access"
        case .sharedIpadSupervised: return "Shared iPad (Supervised)"
        case .siri: return "Siri"
        case .timeSensitiveNotifications: return "Time Sensitive Notifications"
        case .userActivity: return "User Activity"
        case .userManagement: return "User Management"
        case .userNotificationsTimeSensitive: return "User Notifications (Time Sensitive)"
        case .vendorDeepLinks: return "Vendor Deep Links"
        case .wallet: return "Wallet"
        case .webkitBrowser: return "WebKit Browser Engine"
        case .wifiInfo: return "WiFi Info"
        case .wirelessAccessory: return "Wireless Accessory Configuration"
        }
    }
}

class AppIDModel : ObservableObject, Hashable {
    static func == (lhs: AppIDModel, rhs: AppIDModel) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var appID: AppID  // Remove @Published
    @Published var bundleID: String
    @Published var result: String = ""
    
    init(appID: AppID) {
        self.appID = appID
        self.bundleID = appID.bundleIdentifier
    }
    
    func addEntitlement(_ entitlement: Entitlement) async throws {
        guard let team = DataManager.shared.model.team, let session = DataManager.shared.model.session else {
            throw "Please Login First"
        }

        let dateFormatter = ISO8601DateFormatter()
        let httpHeaders = [
            "Content-Type": "application/vnd.api+json",
            "User-Agent": "Xcode",
            "Accept": "application/vnd.api+json",
            "Accept-Language": "en-us",
            "X-Apple-App-Info": "com.apple.gs.xcode.auth",
            "X-Xcode-Version": "11.2 (11B41)",
            "X-Apple-I-Identity-Id": session.dsid,
            "X-Apple-GS-Token": session.authToken,
            "X-Apple-I-MD-M": session.anisetteData.machineID,
            "X-Apple-I-MD": session.anisetteData.oneTimePassword,
            "X-Apple-I-MD-LU": session.anisetteData.localUserID,
            "X-Apple-I-MD-RINFO": session.anisetteData.routingInfo.description,
            "X-Mme-Device-Id": session.anisetteData.deviceUniqueIdentifier,
            "X-MMe-Client-Info": session.anisetteData.deviceDescription,
            "X-Apple-I-Client-Time": dateFormatter.string(from:session.anisetteData.date),
            "X-Apple-Locale": session.anisetteData.locale.identifier,
            "X-Apple-I-TimeZone": session.anisetteData.timeZone.abbreviation()!
        ] as [String : String];
        
        var request = URLRequest(url: URL(string: "https://developerservices2.apple.com/services/v1/bundleIds/\(appID.identifier)")!)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = "{\"data\":{\"relationships\":{\"bundleIdCapabilities\":{\"data\":[{\"relationships\":{\"capability\":{\"data\":{\"id\":\"\(entitlement.rawValue)\",\"type\":\"capabilities\"}}},\"type\":\"bundleIdCapabilities\",\"attributes\":{\"settings\":[],\"enabled\":true}}]}},\"id\":\"\(appID.identifier)\",\"attributes\":{\"hasExclusiveManagedCapabilities\":false,\"teamId\":\"\(team.identifier)\",\"bundleType\":\"bundle\",\"identifier\":\"\(appID.bundleIdentifier)\",\"seedId\":\"\(team.identifier)\",\"name\":\"\(appID.name)\"},\"type\":\"bundleIds\"}}".data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        await MainActor.run {
            result = String(data: data, encoding: .utf8) ?? "Unable to decode response."
        }
        
    }
    
}

class AppIDViewModel : ObservableObject {
    @Published var appIDs : [AppIDModel] = []
    
    func fetchAppIDs() async throws {
        guard let team = DataManager.shared.model.team, let session = DataManager.shared.model.session else {
            throw "Please Login First"
        }
        
        let ids = try await withUnsafeThrowingContinuation { (c: UnsafeContinuation<[AppID], Error>) in
            AppleAPI().fetchAppIDsForTeam(team: team, session: session) { (appIDs, error) in
                if let error = appIDs as? Error {
                    c.resume(throwing: error)
                }
                guard let appIDs else {
                    c.resume(throwing: "AppIDs is nil. Please try again or reopen the app.")
                    return
                }
                c.resume(returning: appIDs)
            }
        }
        await MainActor.run {
            for id in ids {
                appIDs.append(AppIDModel(appID: id))
            }
        }
    }
}
