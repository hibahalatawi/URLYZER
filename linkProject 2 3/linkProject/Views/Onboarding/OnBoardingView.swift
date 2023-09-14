//
//  OnBoardingView.swift
//  linkProject
//
//  Created by Hibah Abdullah Alatawi on 19/02/1445 AH.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(\.locale) var locale
    @AppStorage("didOnboard123") var didOnboard: Bool = false
    @State private var currentStep = 0
    @StateObject var authServiceViewModel = AuthServiceViewModel()
    
    var body: some View {
        if didOnboard {
            MainView()
        } else{
            let onBordingsteps = [
                OnBordingStep(image: "onb1",
                              title: locale.languageCode == "en" ?
                              NSLocalizedString("1", comment: "this title one in english") :
                                NSLocalizedString("1", comment: "this title one in arabic") ,
                              description: locale.languageCode == "en" ?
                              NSLocalizedString("4", comment: "this dis two in english") :
                                NSLocalizedString("4", comment: "this dis tow in arabic") ),
                
                OnBordingStep(image: "onb2",
                              title: locale.languageCode == "en" ?
                              NSLocalizedString("2", comment: "this title one in english") :
                                NSLocalizedString("2", comment: "this title one in arabic"),
                              description: locale.languageCode == "en" ?
                              NSLocalizedString("5", comment: "this dis two in english") :
                                NSLocalizedString("5", comment: "this dis tow in arabic")),
                
                OnBordingStep(image: "onb3",
                              title: locale.languageCode == "en" ?
                              NSLocalizedString("3", comment: "this title one in english") :
                                NSLocalizedString("3", comment: "this title one in arabic"),
                              description: locale.languageCode == "en" ?
                              NSLocalizedString("6", comment: "this dis two in english") :
                                NSLocalizedString("6", comment: "this dis tow in arabic"))
            ]
            
            VStack {
                TabView(selection: $currentStep) {
                    ForEach(0..<3) { it in
                        ZStack {
                            Image(onBordingsteps[it].image)
                                .resizable()
                                .edgesIgnoringSafeArea(.all)
                            VStack{
                                Spacer()
                                Text(onBordingsteps[it].title)
                                    .font(.title)
                                    .foregroundColor(Color.black)
                                    .bold()
                                    .padding(.bottom)
                                Text(onBordingsteps[it].description)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                                    .padding(.bottom,50)
                                
                                
                                
                            }
                        }
                    }
                } .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.vertical)
                HStack{
                    ForEach(0..<3) { it in
                        if it == currentStep {
                            Rectangle()
                                .frame(width: 20,height: 10)
                                .cornerRadius(10)
                                .foregroundColor(Color("Color2"))
                                .animation(.spring(), value: currentStep)
                        } else {
                            Circle()
                                .frame(width: 10 , height: 10)
                                .foregroundColor(Color("Color1"))
                                .animation(.spring(), value: currentStep)
                            
                        }
                    }
                }
                
                Button(action:{
                    if self.currentStep < onBordingsteps.count - 1 {
                        withAnimation {
                            self.currentStep += 1
                        }
                    } else {
                        
                        authServiceViewModel.registerAnonymously()
                        self.didOnboard.toggle()
                    }
                }
                )
                {
                    Text(currentStep < onBordingsteps.count - 1 ? "7" : "8")
                        .padding(16)
                        .frame(width: 280 , height: 44)
                        .background(
                            Rectangle()
                                .foregroundColor(Color("Color1")))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .padding(.bottom,50)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct OnBoardingView_PreView: PreviewProvider{
    static var previews: some View{
        OnBoardingView()
    }
}
