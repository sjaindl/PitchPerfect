//
//  RecordSoundsViewController
//  PitchPerfect
//
//  Created by Stefan Jaindl on 19.03.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(enableRecording: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(enableRecording: true)
        
        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(enableRecording: true)
    }
    
    func configureUI(enableRecording: Bool) {
        recordingLabel.text = enableRecording ? "Tap to Record" : "Recording in Progress"
        recordButton.isEnabled = enableRecording
        stopRecordingButton.isEnabled = !enableRecording
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording wasn't successful!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let destination = segue.destination as! PlaySoundsViewController
            let url = sender as! URL
            destination.recordedAudioURL = url.absoluteURL
        }
    }
}

