//
//  ContentView.swift
//  Music33
//
//  Created by Ilya Sergeev on 30.11.25.
//

import SwiftUI

struct SongRowView: View {
    let track: Track
    @ObservedObject var viewModel: PlayerViewModel
    @State private var coverImage: UIImage?
    var body: some View {
        HStack {
            if let image = coverImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(RoundedRectangle.rect(cornerRadius: 4))
                    .padding(.leading, 4)
                    .padding(.trailing, 8)
            } else {
                ZStack {
                    Image("questionmark.circle")
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.6))
                }
            }
            VStack(alignment: .leading) {
                let isCurrent = viewModel.currentSong?.id == track.id
                Text(track.songName)
                    .font(.headline)
                    .foregroundStyle(isCurrent ? .purple : .primary)
                Text(track.artist)
                    .font(.caption)
            }
            Spacer()
            
        }
        .task {
            if coverImage == nil {
                if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3"){
                    self.coverImage = await viewModel.extractCover(from: url)
                }
            }
        }
    }
}
struct ContentView: View {
    @StateObject var viewModel = PlayerViewModel()
    @State private var fullPlayerViewPresented = false
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                List(viewModel.tracks) { track in
                    SongRowView(track: track, viewModel: viewModel)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.currentSong?.id == track.id {
                            withAnimation(.bouncy) {
                                viewModel.togglePlayPause()
                            }
                        } else {
                            viewModel.playSong(track: track)
                        }
                    }
                }
                .padding(.top)
                .navigationTitle("Music33")
            }
            if viewModel.currentSong != nil {
                miniPlayerView
            }
        }.preferredColorScheme(.dark)
            .fullScreenCover(isPresented: $fullPlayerViewPresented) {
                FullPlayerView(viewModel: viewModel)
            }
    }
        var miniPlayerView: some View {
            HStack {
                HStack {
                    if let image = viewModel.currentImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                }.padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text(viewModel.currentSong?.songName ?? "")
                    Text(viewModel.currentSong?.artist ?? "")
                }
                Spacer()
                Button {
                    viewModel.backSong()
                }label: {
                    Image(systemName: "backward.circle.fill")
                        .font(.title)
                        .foregroundStyle(.indigo)
                }
                Button {
                    withAnimation {
                        viewModel.togglePlayPause()
                    }
                }label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.purple.opacity(0.8))
                        .contentTransition(.symbolEffect(.replace))
                }
                Button {
                    viewModel.nextSong()
                }label: {
                    Image(systemName: "forward.circle.fill")
                        .font(.title)
                        .foregroundStyle(.indigo)
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(.rect)
            .cornerRadius(20)
            .padding(10)
            .onTapGesture {
                fullPlayerViewPresented = true
            }
        }
}

#Preview {
    ContentView()
}
