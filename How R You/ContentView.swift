//
//  ContentView.swift
//  How R You
//
//  Created by XIAOYU YOU on 05/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        VStack {
            TabView{
                Tab("Calendar",systemImage: "face.dashed.fill"){
                    CalendarView()
                }
                
               
                Tab("Profile",systemImage: "person.fill")
                    {ProfileView()
                }
                    
                
            }
        }
    
           }
       }

