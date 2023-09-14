//
//  MainView.swift
//  linkProject
//
//  Created by Hibah Abdullah Alatawi on 17/02/1445 AH.


import SwiftUI
import FirebaseAuth

struct MainView : View {
    @State  var isURLValid = true
    @State  var showAlert = false
    @State  var message = ""
    @StateObject  var authService = AuthServiceViewModel()
    @State  var urlText = ""
    @State  var isUrlFake : Bool?
    @State  var networking = false
    @Environment(\.locale) var locale
    @State  var currentImageIndex = 0
    @State var checkFireStrore : Bool = true
    @State private var showErrorPass = false

    var body: some View {
        @State var image = [
            ImageModel(Image: locale.languageCode == "en" ? "enCard1" : "arCard1"),
            ImageModel(Image: locale.languageCode == "en" ? "enCard2" : "arCard2"),
            ImageModel(Image: locale.languageCode == "en" ? "enCard3" : "arCard3")
        ]
        VStack {
            //Awareness images
            Spacer()
            Image(image[currentImageIndex].Image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 250)
                .cornerRadius(20)
                .shadow(radius: 5)
            HStack{
                TextField("19", text: $urlText)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .keyboardType(.URL)
                    .onChange(of: urlText) { url in
                        isURLValid = authService.isValidURL(URL: url)
                        if url == "" {
                            self.isUrlFake = nil
                        }
                    }
                    .disabled(networking)
            }

            HStack{
                Button(action: {
                    verifyFunction()
                }){
                    Text("13")
                }
               
                .frame(width: 150)
                .padding()
                .background(Color("Color2"))
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(networking)
                .disabled(!isURLValid)
                .onTapGesture {
                    if !isURLValid {
                        showAlert = true
                    }else {
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("17"), message: Text("16"), dismissButton: .default(Text("18")))
                }
            }
            if networking {
                ProgressView()
            }
            if (isUrlFake == false && authService.savedFireStore == false && urlText.isEmpty == false){
                Text("15")
                    .foregroundColor(Color.green)
                
            } else if (isUrlFake == true &&  urlText.isEmpty == false) {
                HStack{
                    Button("14"){
                        authService.openReportingURL()
                    }
                  
                    .frame(width: 250)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
            }
            Spacer()
        }
        //bac
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("appBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
                    if allowed {
                        // register for remote push notification
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        print("Push notification allowed by user")
                    } else {
                        print("Error while requesting push notification permission. Error \(String(describing: error))")
                    }
                }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                self.currentImageIndex = (self.currentImageIndex + 1) %  image.count
            }
        }
    }
    
    func verifyFunction() {
        networking = true
        authService.verifyURL(urlText) { result in
            switch result {
            case .success(let success):
                isUrlFake = success
            case .failure:
                isUrlFake = true
                print("fail")
            }
            
            authService.getURLsFromDB(urlText)
            authService.saveURL(urlText, suspicious: isUrlFake ?? false)
            networking = false
        }
    }


}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
