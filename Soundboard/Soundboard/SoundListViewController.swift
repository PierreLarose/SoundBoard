//
//  SoundListViewController.swift
//  Soundboard
//
//  Created by Pierre Larose on 9/22/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SoundListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    
    var sounds: [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Roll Tide...
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Roll Tide...
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "Sound")
        self.sounds = (try! context.executeFetchRequest(request)) as! [Sound]
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sound = self.sounds[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel!.text = sound.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sound = self.sounds[indexPath.row]
        
        let baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
        let pathComponents = [baseString, sound.url]
        let audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioNSURL!)
        self.audioPlayer.play()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextViewControler = segue.destinationViewController as! NewSoundViewController
        nextViewControler.previousViewController = self
    }
    
}

