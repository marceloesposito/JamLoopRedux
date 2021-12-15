//
//  ContentView.swift
//  JamLoopRedux
//
//  Created by Marcelo Esposito on 14/12/21.
//

import SwiftUI
import AudioKit

struct ContentView: View {
    
    let player = AudioPlayer()
    let engine = AudioEngine()
    
    func preparePlayer(){
    var fileURL = [URL]()
    let files = ["hi_tom_D2.wav", "snare_D1.wav"]

        for filename in files {
            guard let url = Bundle.main.resourceURL?.appendingPathComponent(
                    "Samples/\(filename)") else {
                Log("failed to load sample", filename)
                return
            }
            fileURL.append(url)
        }
        try? player.load(url: fileURL[0])
        
        
        
    }
    
    
    
    @State var backgroundColor: Color = Color("mainViewBG")
    
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                
                Button{}label: {
                    Image(systemName: "gear").font(.title2).foregroundColor(.white)
                }
                
                Spacer()
                RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white).padding(.horizontal, 15)
                RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
                RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
                RoundedRectangle(cornerRadius: 40).frame(width: 100, height: 20).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 15)
                Spacer()
                
                Button{}label: {
                    Image(systemName: "metronome.fill").font(.title2).foregroundColor(.white)
                }
                
                Spacer()
                
                
            }.padding(.top,30)
            
            
            Spacer()
            
            
            GeometryReader {geometry in
                HStack{
                    Image("double.chevron.left")
                    Image(systemName: "play.fill").font(.system(size: 56)).foregroundColor(.white)
                    Text("Swipe left to play").font(.callout).foregroundColor(.white.opacity(0.5))
                    Spacer()
                    Text("Swipe right to record").font(.callout).foregroundColor(.white.opacity(0.5))
                    Image("custom.record.button")
                    Image("double.chevron.right")
                    
                }.position(x: geometry.size.width/2, y: (geometry.size.height/2)-geometry.safeAreaInsets.bottom)     .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local).onChanged({ swipe in
                    
                    
                    if swipe.translation.width < 0 {
                        
                        
                        backgroundColor = Color("playbackViewBG")
                    }
                    if swipe.translation.width > 0 {
                        backgroundColor = Color("recordViewBG")
                    }
                }))
                    .frame(minWidth: 100, idealWidth: 100, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: .infinity, alignment: .center)
            }
        
        
   
        }.background(backgroundColor)

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}


