//
//  FullPlayerView.swift
//  Music33
//
//  Created by Ilya Sergeev on 03.12.25.
//

import SwiftUI
internal import AVFAudio

struct FullPlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    Text("Now is playing")
                }
            }
            if let image = viewModel.currentImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 360, height: 360)
                    .scaledToFill()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.currentSong?.songName ?? "")
                        .font(.title)
                    Text(viewModel.currentSong?.artist ?? "")
                        .font(.headline)
                }
                .padding(.leading)
                Spacer()
            }
            Slider(value: Binding(get: { viewModel.currentTime
            }, set: { time in
                viewModel.changeTime(to: time)
            }), in: 0...viewModel.totalTime)
            .accentColor(.white)
            .padding(.horizontal)
            HStack {
                Text(viewModel.formatTime(viewModel.currentTime))
                Spacer()
                Text(viewModel.formatTime(viewModel.totalTime))
            }
            .padding(.horizontal)
            HStack {
                Button {
                    withAnimation(.none) {
                        viewModel.backSong()
                    }
                } label: {
                    Image(systemName: "backward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                        .foregroundStyle(.indigo)
                }
                Button {
                    withAnimation(.none) {
                        viewModel.togglePlayPause()
                    }
                }label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64)
                        .foregroundStyle(.purple.opacity(0.8))
                        .contentTransition(.symbolEffect(.replace))
                }
                Button {
                    withAnimation(.none) {
                        viewModel.nextSong()
                    }
                }label: {
                    Image(systemName: "forward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                        .foregroundStyle(.indigo)
                }
            }
        }.preferredColorScheme(.dark)
    }
}

#Preview{
    let prevVM = PlayerViewModel()
    if let first = prevVM.tracks.first {
        prevVM.playSong(track: first)
        prevVM.audioPlayer?.pause()
        prevVM.isPlaying = false
    }
    return FullPlayerView(viewModel: prevVM)
}
