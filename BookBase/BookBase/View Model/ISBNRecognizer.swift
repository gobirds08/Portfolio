//
//  ISBNRecognizer.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/5/24.
//

import Foundation
import Vision

class ISBNRecognizer : ObservableObject{
    var image : CGImage?
    @Published var recognized : String = ""
    
    func requestRecognition(){
        guard let image = image else {return}
        let handler = VNImageRequestHandler(cgImage: image)
        
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?){
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        for observation in observations {
            var string = observation.topCandidates(1).first!.string.lowercased()
            if(string.contains("isbn")){
                string = string.replacingOccurrences(of: "isbn", with: "")
                string = string.replacingOccurrences(of: " ", with: "")
                string = string.replacingOccurrences(of: "-", with: "")
                self.recognized = string
                break
            }
        }
    }
}
