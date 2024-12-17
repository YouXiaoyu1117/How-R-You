//
//  DiaryEditView.swift
//  How R You
//
//  Created by XIAOYU YOU on 09/12/24.
//

import SwiftUI
import AVFoundation

struct DiaryEditView: View {
    let selectedMood: String
    let date: Date

    @State private var diaryText: String = ""
    @State private var textColor: Color = .black
    @State private var textAlignment: TextAlignment = .leading
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    
    var body: some View {
        VStack(spacing: 16) {
            // 日期和表情显示
            HStack {
                Text(dateFormatter.string(from: date))
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Image(selectedMood)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .padding()

            // 日记编辑框
            TextEditor(text: $diaryText)
                .frame(height: 200)
                .padding()
                .foregroundColor(textColor)
                .multilineTextAlignment(textAlignment)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .shadow(radius: 1)
                )

            // 文字样式选项
            HStack(spacing: 20) {
                // 颜色选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach([Color.black, Color.red, Color.blue, Color.green, Color.orange, Color.purple], id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    textColor = color
                                }
                        }
                    }
                }

                Spacer()

                // 对齐选项
                HStack {
                    Button(action: { textAlignment = .leading }) {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(textAlignment == .leading ? .blue : .gray)
                    }
                    Button(action: { textAlignment = .center }) {
                        Image(systemName: "text.aligncenter")
                            .foregroundColor(textAlignment == .center ? .blue : .gray)
                    }
                    Button(action: { textAlignment = .trailing }) {
                        Image(systemName: "text.alignright")
                            .foregroundColor(textAlignment == .trailing ? .blue : .gray)
                    }
                }
            }
            .padding(.horizontal)

            // 录音功能
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                HStack {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .foregroundColor(isRecording ? .red : .blue)
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .foregroundColor(isRecording ? .red : .blue)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .onDisappear {
            if isRecording {
                stopRecording()
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }

    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentPath.appendingPathComponent("diary_recording.m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
}


