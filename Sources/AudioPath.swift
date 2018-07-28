//
//  Path.swift
//  VoiceKit
//
//  Created by Tatsuya Tanaka on 20180402.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation

public enum AudioURL {
    case document(filePath: String)
    case temporary(filePath: String)
    case web(url: String)
    case fullPath(URL)

    public var url: URL {
        switch self {
        case .document(let filePath):
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return url.appendingPathComponent(filePath)
        case .temporary(let filePath):
            let url = FileManager.default.temporaryDirectory
            return url.appendingPathComponent(filePath)
        case .web(let url):
            return URL(string: url) ?? .init(fileURLWithPath: "")
        case .fullPath(let path):
            return path
        }
    }

    public static var defaultURL: AudioURL {
        return AudioURL.temporary(filePath: "voiceKit/recording.m4a")
    }
}

func createDirectoryIfNeeded(url: AudioURL) throws{
    if case .web = url { return }
    var dirUrl = url.url
    dirUrl.deleteLastPathComponent()
    try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
}
