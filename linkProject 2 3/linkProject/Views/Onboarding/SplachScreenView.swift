
//  ContentView.swift
//  linkProject
//
//  Created by Hibah Abdullah Alatawi on 17/02/1445 AH.
import SwiftUI
import AVKit

struct SplachScreenView: View {
    @State var isEnded: Bool = false
    @State var video: AVPlayer = .init()
    @StateObject var authService = AuthServiceViewModel()

    var body: some View {
        if isEnded {
            OnBoardingView()
        } else {
            GeometryReader { geometry in
                VideoPlayer(player: video)
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .onAppear {
                        DispatchQueue.main.async {
                            video.play()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                video.pause()
                                isEnded = true
                            }
                        }
                    }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if let bundleURL = Bundle.main.url(forResource: "splash", withExtension: "mp4") {
                    video = AVPlayer(url: bundleURL)
                    print("Found URL", bundleURL)
                } else {
                    print("Did not find URL")
                }
            }
        }
    }
}

struct SplachScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplachScreenView()
            .preferredColorScheme(.light)
    }
}

//
//
//struct SplachScreenView: View {
//
//    @State var isEnded : Bool = false
//    @State var video: AVPlayer = .init()
//    @StateObject  var authService = AuthServiceViewModel()
//    @State private var size = 0.8
//    @State private var opacity = 0.5
//
//    var body: some View {
//        if isEnded{
//            OnBoardingView()
//        } else{
//            ZStack {
//                Image("appBackground")
//                    .resizable()
//                    .ignoresSafeArea()
//
//                Image("splash")
//                    .resizable()
//                    .ignoresSafeArea()
//                    .onAppear {
//                        withAnimation(.easeIn(duration: 2)){ self.size = 1.5
//                            self.opacity = 1.0
//                        }
//                    }
//
//            } .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.isEnded = true}
//            }
//
//
//
//            }
//        }
//    }
//
//
