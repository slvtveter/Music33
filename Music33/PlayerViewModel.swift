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
    
    @Published var currentImage: UIImage?
    @Published var tracks = [Track]()
    
    @Published var isPlaying = false
    @Published var currentSong: Track?
    
    var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
        loadTracks()
    }
    
    func loadTracks(){
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
           let image = UIImage(data: data){
            self.currentImage = image
        }
        else {
            self.currentImage = nil
        }
        
    }
    
    func playSong(track: Track){
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3")
        else{
            print("Error, there's file finding problem, file: \(track.fileName)")
            return
        }
        do {
            self.currentImage = nil
            Task{
                await extractCover(from: url)
            }
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            isPlaying = true
            currentSong = track
            
        } catch {
            print("There is problem with player: \(error.localizedDescription)")
        }
    }
    func togglePlayPause(){
        guard let player = audioPlayer else {return}
        if player.isPlaying{
            player.pause()
            isPlaying = false
        }
        else {
            player.play()
            isPlaying = true
        }
    }
    func backSong(){
        guard let currentIndex = tracks.firstIndex(where: {$0.id == currentSong?.id}) else { return }
        
        let backIndex = currentIndex - 1
        
        if backIndex < 0 {
            if let lastTrack = tracks.last{
                playSong(track: lastTrack)
            }
        }
        else if backIndex >= 0 {
            playSong(track: tracks[backIndex])
        }
    }
    
    
    func nextSong(){
        guard let currentIndex = tracks.firstIndex(where: {$0.id == currentSong?.id}) else
        { return }
        
        let nextIndex = currentIndex + 1
        if nextIndex > tracks.count - 1{
            if tracks.count > 1{
                playSong(track: tracks[0])
            }
            else {
                isPlaying = false
            }
        }
        else {
            playSong(track: tracks[nextIndex])
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else { return }
        nextSong()
    }
}
