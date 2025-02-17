//
//  CameraManager.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/3/24.
//

import Foundation
import AVFoundation
import CoreImage

class CameraManager : NSObject, ObservableObject{
    @Published var frame : CGImage?
    @Published var taken = false
    private var allowed = false
    private let cameraSession = AVCaptureSession()
    private let queue = DispatchQueue(label: "queue")
    private let context = CIContext()
    private var wait = false
    
    override init(){
        super.init()
        checkAuthorization()
        while(wait){}
        queue.async {
            self.setup()
            self.start()
        }
    }
    
    func start(){
        if(!allowed){return}
        queue.async {
            self.cameraSession.startRunning()
        }
    }
    
    func takePicture(){
        taken = true
        end()
    }
    
    func end(){
        queue.async {
            self.cameraSession.stopRunning()
        }
    }
    
    func checkAuthorization(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            allowed = true
        case .notDetermined:
            wait = true
            requestAccess()
        default:
            break
        }
    }
    
    func requestAccess(){
        AVCaptureDevice.requestAccess(for: .video){ accepted in
            self.queue.async {
                if(accepted){
                    self.allowed = true
                }
                self.wait = false
            }
        }
    }
    
    func setup(){
        cameraSession.beginConfiguration()
        let output = AVCaptureVideoDataOutput()
        if(!allowed){return}
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        if(!cameraSession.canAddInput(input)){
            return
        }
        cameraSession.addInput(input)
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample"))
        cameraSession.addOutput(output)
        cameraSession.sessionPreset = .high
        output.connection(with: .video)?.videoRotationAngle = 90.0
        cameraSession.commitConfiguration()
    }
    
}

extension CameraManager : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput buffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let image = imageFromBuffer(buffer: buffer) else {return}
        DispatchQueue.main.async {
            self.frame = image
        }
    }
    
    func imageFromBuffer(buffer : CMSampleBuffer) -> CGImage? {
        guard let buffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        
        let image = CIImage(cvPixelBuffer: buffer)
        guard let image = context.createCGImage(image, from: image.extent) else{
            return nil
        }
        return image
    }
}
