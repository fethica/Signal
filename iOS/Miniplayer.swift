//
//  Miniplayer.swift
//  AppleMusic
//
//  Created by Balaji on 16/11/20.
//

import SwiftUI

struct Miniplayer: View {
    
    @EnvironmentObject var radioPlayer: RadioPlayer
    @Binding var expand : Bool
    
    var animation: Namespace.ID
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var volume : CGFloat = 0
    @State var offset : CGFloat = 0
    
    var body: some View {
        
        VStack{
            
            Capsule()
                .fill(Color.gray)
                .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
                .opacity(expand ? 1 : 0)
                .padding(.top,expand ? safeArea?.top : 0)
                .padding(.vertical,expand ? 30 : 0)
            
            HStack(spacing: 15){
                
                if expand{Spacer(minLength: 0)}
                
                Image(uiImage: radioPlayer.radio.track.image ?? #imageLiteral(resourceName: "albumArt")).renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                    .resizable()
                    .frame(width: expand ? height : 55, height: expand ? height : 55)
                    .scaledToFill()
                    .clipShape(Circle())
                    .shadow(radius: 3)
                
                if !expand{
                    Text(radioPlayer.radio.track.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                if !expand{
                    
                    Button(action: {
                        radioPlayer.player.togglePlaying()
                    }, label: {
                        
                        Image(systemName: radioPlayer.radio.playbackState == .playing ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {
                        print("Forward")
                        radioPlayer.currentIndex += 1
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 15){
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if expand{
                        VStack{
                            Text("\(radioPlayer.radio.track.name ?? "")" )
                                .font(.title3)
                                .bold()
                                .lineLimit(1)
                                .allowsTightening(true)
                                .matchedGeometryEffect(id: "Label", in: animation)
                                                        
                            Text(" \(radioPlayer.radio.track.artist ?? "")" )
                                .font(.footnote)
                                .lineLimit(1)
                                .allowsTightening(true)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .padding(.top,20) //todo
                
                HStack{
                    
                    Capsule()
                        .fill(
                            
                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.7),Color.primary.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                    
                    Text("LIVE")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Capsule()
                        .fill(
                            
                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.1),Color.primary.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                }
                .padding()
                
                // Stop Button...
                
                Button(action: {
                    radioPlayer.player.togglePlaying()
                }) {
                    
                    Image(systemName: radioPlayer.radio.playbackState == .playing ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                .padding()
                
                Spacer(minLength: 0)
                
                HStack(spacing: 15){
                    
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $volume)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
                HStack(spacing: 22){
                    
                    AirPlayView()
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                    
                }
                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            }
            // this will give strech effect...
            .frame(height: expand ? nil : 0)
            .opacity(expand ? 1 : 0)
        }
        // expanding to full screen when clicked...
        .frame(maxHeight: expand ? .infinity : 80)
        // moving the miniplayer above the tabbar...
        // approz tab bar height is 49
        
        // Divider Line For Separting Miniplayer And Tab Bar....
        .background(
            
            VStack(spacing: 0){
                
                BlurView(style: .systemMaterial)
                
                Divider()
            }
            .onTapGesture(perform: {
                
                withAnimation(.spring()){expand = true}
            })
        )
        .cornerRadius(expand ? 20 : 0)
        .offset(y: expand ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
    }
    
    
    func onchanged(value: DragGesture.Value){
        
        // only allowing when its expanded...
        
        if value.translation.height > 0 && expand {
            
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value){
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)){
            
            // if value is > than height / 3 then closing view...
            
            if value.translation.height > height{
                
                expand = false
            }
            
            offset = 0
        }
    }
}
