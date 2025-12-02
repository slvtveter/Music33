//
//  ContentView.swift
//  Music33
//
//  Created by Ilya Sergeev on 30.11.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlayerViewModel()
   
    var body: some View {
        ZStack(alignment: .bottom){
            NavigationStack{
                List(viewModel.tracks){ track in
                    HStack{
                        let isCurrent = viewModel.currentSong?.id == track.id
                        
                        var iconName: String  {
                            if isCurrent {
                                return viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill"
                            } else {
                                return "music.note"
                            }
                        }
                        Image(systemName: iconName)
                            .font(.title2)
                            .foregroundColor(isCurrent ? .purple : .gray)
                            .frame(width: 40,height: 40)
                            .background(isCurrent ? .red.opacity(0.2) : Color.secondary.opacity(0.2) )
                            .clipShape(Circle())
                            .scaleEffect(isCurrent ? 1.1 : 1.0)
                            .contentTransition(.symbolEffect(.replace))
                        
                        VStack(alignment: .leading){
                            Text(track.songName)
                                .font(.headline)
                                .foregroundColor(isCurrent ? .purple.opacity(0.8) : .primary)
                            Text(track.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.currentSong?.id == track.id{
                            withAnimation(.bouncy){
                                viewModel.togglePlayPause()
                            }
                        }
                        else {
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
        }
    
        
        var miniPlayerView: some View {
            
            HStack{
                HStack{
                    if let image = viewModel.currentImage{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .clipShape(.rect(cornerRadius: 8))
                        
                    }
                }.padding(.trailing, 8)
                VStack(alignment: .leading){
                    Text(viewModel.currentSong?.songName ?? "")
                    Text(viewModel.currentSong?.artist ?? "")
                }
                Spacer()
                Button{
                    viewModel.backSong()
                }label: {
                    Image(systemName: "backward.circle.fill")
                        .font(.title)
                        .foregroundStyle(.indigo)
                }
                Button{
                    withAnimation{
                        viewModel.togglePlayPause()
                    }
                }label:{
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.purple.opacity(0.8))
                        .contentTransition(.symbolEffect(.replace))
                }
                Button{
                    viewModel.nextSong()
                }label:{
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
            
        }
}



#Preview {
    ContentView()
}
