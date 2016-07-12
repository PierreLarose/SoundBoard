//
//  NewSoundViewController.swift
//  Soundboard
//
//  Created by Pierre Larose on 9/23/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NewSoundViewController : UIViewController {

    required init?(coder aDecoder: NSCoder) {
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = try? AVAudioRecorder(URL: audioNSURL!, settings: recordSettings)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        // Super init is below
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var soundTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    var previousViewController = SoundListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Roll Tide...
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        
        // Create a sound Object
        let sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as! Sound
        sound.name = self.soundTextField.text!
        sound.url = self.audioURL
        
        do {
            // Save Sound to CoreData
            try context.save()
        } catch _ {
        }
        
        // Dismiss ViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordTapped(sender: AnyObject) {
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
        } else {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(true)
            } catch _ {
            }
            self.audioRecorder.record()
            self.recordButton.setTitle("Finish Recording", forState: UIControlState.Normal)
        }
    }
}
