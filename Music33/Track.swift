//
//  Track.swift
//  Music33
//
//  Created by Ilya Sergeev on 30.11.25.
//

import Foundation

struct Track: Identifiable {
    let id = UUID()
    let songName: String
    let artist: String
    let fileName: String
    let cover: String
}
