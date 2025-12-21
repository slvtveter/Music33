//
//  PlayerViewModel.swift
//  Music33
//
//  Created by Ilya Sergeev on 30.11.25.
//
import SwiftUI
import Foundation
import AVFoundation
import Combine
import UIKit

@MainActor
class PlayerViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var time: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    @Published var currentImage: UIImage?
    @Published var totalTime: TimeInterval = 0.0
    @Published var tracks = [Track]()
    @Published var isPlaying = false
    @Published var currentSong: Track?
    var timer: Timer?
    var audioPlayer: AVAudioPlayer?
    override init() {
        super.init()
        loadTracks()
    }
    func formatTime(_ time: TimeInterval) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    }
    func changeTime(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                if let player = self.audioPlayer, player.isPlaying {
                    self.currentTime = player.currentTime
                }
            }
        }
    }
    func loadTracks() {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {return}
        self.tracks = urls.map { url in
            let rawNameURL = url.deletingPathExtension().lastPathComponent
            let rawName = rawNameURL.replacingOccurrences(of: "SpotiDownloader.com - ", with: "")
            let parts = rawName.components(separatedBy: " - ")
            var songName = rawName
            var artistName = "Неизвестен"
            if parts.count >= 2 {
                songName = parts[0]
                artistName = parts.last ?? "Неизвестен"
            }
            return Track(
                songName: songName, artist: artistName, fileName: rawNameURL, cover: ""
            )
        }
    }
    func extractCover(from url: URL) async {
        let asset = AVURLAsset(url: url)
        let metadata = try? await asset.load(.commonMetadata)
        if let artworkItem = metadata?.first(where: {$0.commonKey == .commonKeyArtwork }),
           let data = try? await artworkItem.load(.dataValue),
           let image = UIImage(data: data) {
            self.currentImage = image
        } else {
            self.currentImage = nil
        }
    }
    func playSong(track: Track) {
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3")
        else {
            print("Error, there's file finding problem, file: \(track.fileName)")
            return
        }
        do {
            self.currentImage = nil
            Task {
                await extractCover(from: url)
            }
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            setupTimer()
            isPlaying = true
            currentSong = track
            self.totalTime = audioPlayer?.duration ?? 0.0
        } catch {
            print("There is problem with player: \(error.localizedDescription)")
        }
    }
    func togglePlayPause() {
        guard let player = audioPlayer else {return}
        if player.isPlaying {
            player.pause()
            timer?.invalidate()
            isPlaying = false
        } else {
            player.play()
            setupTimer()
            isPlaying = true
        }
    }
    func backSong() {
        guard let currentIndex = tracks.firstIndex(where: {$0.id == currentSong?.id}) else { return }
        let backIndex = currentIndex - 1
        if backIndex < 0 {
            if let lastTrack = tracks.last {
                playSong(track: lastTrack)
            }
        } else if backIndex >= 0 {
            playSong(track: tracks[backIndex])
        }
    }
    func nextSong() {
        guard let currentIndex = tracks.firstIndex(where: {$0.id == currentSong?.id}) else { return }
        let nextIndex = currentIndex + 1
        if nextIndex > tracks.count - 1 {
            if tracks.count > 1 {
                playSong(track: tracks[0])
            } else {
                isPlaying = false
            }
        } else {
            playSong(track: tracks[nextIndex])
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else { return }
        nextSong()
    }
}
