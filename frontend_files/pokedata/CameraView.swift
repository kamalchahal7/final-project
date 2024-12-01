//
//  CameraView.swift
//  pokedata
//
//  Created by Kamal on 2024-10-11.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .fullScreen
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = .rear
        picker.showsCameraControls = true // Hide default controls
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Preview fallback view
    static func previewFallbackView() -> some View {
        VStack {
            Text("Camera is not available in preview.")
                .font(.headline)
                .padding()
            Rectangle()
                .fill(Color.gray)
                .frame(width: 200, height: 300)
                .overlay(Text("Camera Placeholder"))
        }
    }
}

struct CameraOverlayView: View {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraView(image: $image)
                .aspectRatio(contentMode: .fill)
        }
    }
}



//    var body: some View {
//        VStack{
//            HStack {
//                Spacer()
//                Button (action: {
//                    showCamera = false
//                }) {
//                    Text("Cancel")
//                }
//            }
//            .padding()
//            Spacer()
//        }
//    }


#Preview {
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
        CameraView.previewFallbackView()
    } else {
        CameraView(image: .constant(nil))
    }
}
