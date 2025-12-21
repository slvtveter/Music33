//
//  FullPlayerView.swift
//  Music33
//
//  Created by Ilya Sergeev on 03.12.25.
//

import SwiftUI

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
                Spacer()
            }
        }.preferredColorScheme(.dark)
    }
}

#Preview{
    let prevVM = PlayerViewModel()
    if let first = prevVM.tracks.first {
        prevVM.playSong(track: first)
    }
    return FullPlayerView(viewModel: prevVM)
}
