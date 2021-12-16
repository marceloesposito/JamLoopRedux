//
//  ContentView.swift
//  JamLoopRedux
//
//  Created by Marcelo Esposito on 14/12/21.
//

import SwiftUI
import AudioKit
import AudioKitEX
import AVFoundation

//MARK: Recorder conductor class settings


struct RecorderData {
    var isRecording = false
    var isPlaying = false
}

class RecorderConductor: ObservableObject {
    
    
    
    let audioEngine = AudioEngine()
    let audioPlayer = AudioPlayer()
    var mic: AudioEngine.InputNode?
    let mixer = Mixer()
    let inputDevices = Settings.session.availableInputs
    var inputDeviceList = [String]()
    var recorder: NodeRecorder?
    var silencer: Fader?
    
    
    
    @Published var data = RecorderData(){
        
        
        
        didSet{
            if data.isRecording{
                NodeRecorder.removeTempFiles()
                do{
                    try recorder?.record()
                } catch {
                    Log("Could not record")
                }
            } else {
                recorder?.stop()
            }
            
            if data.isPlaying{
                if let file = recorder?.audioFile{
                    audioPlayer.file = file
                    audioPlayer.play()
                } else {
                    audioPlayer.stop()
                }
            }
        }
        
        
        
    }
    
//   MARK: initializer
    
    init() {
//        do{
//            
//        Settings.bufferLength = .long
//            
//            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
//            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP, .duckOthers])
//            try AVAudioSession.sharedInstance().setActive(true)
//            
//            
//        }catch{
//            Log("Could not correctly set session")
//        }
        
        guard let input = audioEngine.input else {fatalError("Could not set engine to input")}
         
        do {
            recorder = try NodeRecorder(node: input)
        } catch {
            fatalError("Could not start nodeRecorder")
        }
        
        
        mic = audioEngine.input
        
        let silencer = Fader(input, gain: 0)
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(audioPlayer)
        audioEngine.output = mixer
    }
    
    
    
    func start() {
        do {
            try audioEngine.start()
        } catch {
            Log("Could not start audioEngine")
        }
    }
    
    
    
    
    func stop(){
        audioEngine.stop()
    }
    
}

//MARK: Main view

struct ContentView: View {
    

    
    @StateObject var conductor = RecorderConductor()
    
    
    
    @State var backgroundColor: Color = Color("mainViewBG")
    
    var body: some View {
        
        VStack{
            HStack{
                
                
                
                Spacer()
                
                
                
                Button{}label: {
                    Image(systemName: "gear").font(.title2).foregroundColor(.white)
                }
                
                
                
                Spacer()
                
                
                
                ProgressBarView()
                
                
                
                Spacer()
                
                
                
                Button{}label: {
                    Image(systemName: "metronome.fill").font(.title2).foregroundColor(.white)
                }
                
                
                
                Spacer()
                
                
                
            }.padding(.top,30)
            
            
            Spacer()
//     MARK: Swipe view
            
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
                        
                        self.conductor.data.isRecording = false
                        self.conductor.data.isPlaying = true
                        
                        
                        backgroundColor = Color("playbackViewBG")
                    }
                    if swipe.translation.width > 0 {
                        
                        self.conductor.data.isPlaying = false
                        self.conductor.data.isRecording = true
                        
                        backgroundColor = Color("recordViewBG")
                    }
                }))
                    .frame(minWidth: 100, idealWidth: 100, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: .infinity, alignment: .center)
            }
        
        
   
        }.onAppear(perform: self.conductor.start)
            .onDisappear(perform: self.conductor.stop)
        .background(backgroundColor)
        

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}


