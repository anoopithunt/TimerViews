//
//  TimerView.swift
//  Demo
//
//  Created by Sandeep Kesarwani on 22/02/23.
//

import SwiftUI

struct TimerView: View {
    
     @State  var endDateText: String
     @State  var remainingTime = ""
     @State  var timer: Timer?
    init(endDateText: String) {
        self.endDateText = endDateText
    }
        var body: some View {
            VStack{
                
                if remainingTime == "Donate Now" {
                    Text("Donate Now").foregroundColor(.red).font(.system(size: 20, weight: .semibold))
                }
                else{
                    Text(remainingTime).foregroundColor(.gray)
                        .font(.system(size: 14, weight: .regular))
//                        .padding(6)
                }
            }
            .onAppear{
                startTimer()
            }
//            .onDisappear(perform: stopTimer)
        }
        
    func startTimer() {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            if let endDate = formatter.date(from: endDateText) {
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    let currentDate = Date()
                    
                    let calendar = Calendar.current
                    let difference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: endDate)
                    
                    if difference.day! > 0 {
                        remainingTime = "\(difference.day!)d  \(difference.hour!)h \(difference.minute!)m \(difference.second!)s"
                    } else if difference.hour! > 0 {
                        remainingTime = "\(difference.hour!)h  \(difference.minute!) m \(difference.second!)s"
                    } else if difference.minute! > 0 {
                        remainingTime = "\(difference.minute!)m \(difference.second!)s"
                    } else {
                        remainingTime = "\(difference.second!)s"
                    }
                    
                    if currentDate >= endDate {
                        stopTimer()
                    }
                }
                
                self.timer = timer
            } else {
                remainingTime = "Invalid date format"
            }
        }
        
        func stopTimer() {
            remainingTime = "Donate Now"
            timer?.invalidate()
            timer = nil
        }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(endDateText: "21-12-2027")

    }
}





struct ContentTimerView: View{
    @State  var timer: Timer?
    @State  var remainingTime = ""
    @StateObject var list = GuestSubscribeViewModel()
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View{
        VStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10){
                    ForEach(list.datas, id: \.id){
                        item in
                        VStack{
                            
                            
                            AsyncImage(url: URL(string: item.book_media.url ?? "")){
                                img in
                                img.resizable().frame(height: 235)
                            }placeholder: {
                                Image("logo_gray").resizable().frame(height: 235)
                            }
                            TimerView(endDateText: item.rc_enddate).background(Color.blue.opacity(0.4))
                        }.onAppear{
                            self.startTimer(endDate:item.rc_enddate)
                            
                        }
                    }
                }
            }
        }.onAppear{
            list.getSubscribeData()
           
        }
        
        
    }
    
func startTimer(endDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        if let endDate = formatter.date(from: endDate) {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                let currentDate = Date()
                
                let calendar = Calendar.current
                let difference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: endDate)
                
                if difference.day! > 0 {
                    remainingTime = "\(difference.day!)d  \(difference.hour!)h \(difference.minute!)m \(difference.second!)s"
                } else if difference.hour! > 0 {
                    remainingTime = "\(difference.hour!)h  \(difference.minute!) m \(difference.second!)s"
                } else if difference.minute! > 0 {
                    remainingTime = "\(difference.minute!)m \(difference.second!)s"
                } else {
                    remainingTime = "\(difference.second!)s"
                }
                
                if currentDate >= endDate {
                    stopTimer()
                }
            }
            
            self.timer = timer
        } else {
            remainingTime = "Invalid date format"
        }
    }
    
    func stopTimer() {
        remainingTime = "Donate Now"
        timer?.invalidate()
        timer = nil
    }
    
}
