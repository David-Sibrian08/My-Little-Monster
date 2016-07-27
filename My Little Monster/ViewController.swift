//
//  ViewController.swift
//  My Little Monster
//
//  Created by Sibrian on 7/15/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var monsterImage: MonsterImage!
    
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var timer: NSTimer!
    
    //: SOUND VARIABLES
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //: CREATE THE INITIAL GAME STATE WITH SOUNDS AND A TIMER
    func initializeGame() {
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        
        //this class is the observer. It will listen for the notification
        // selector syntax --> selector: #selector(class.functionToBeCalled) if function has parameters use (class.functionToBeCalled(_:))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        initializeSounds()
        
        startTimer()
        
    }
    
    //: INITIALIZE SOUNDS OF THE GAME. CALLED WHEN GAME GETS INITIALIZED
    func initializeSounds() {
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        
        sfxSkull.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxBite.prepareToPlay()
        sfxDeath.prepareToPlay()

    }
    
    //: DETECT WHEN FOOD/HEART IS DROPPED ON THE MONSTER. PLAY APPROPRIATE SOUND AND DIM THE ITEMS AGAIN
    func itemDroppedOnCharacter(notification: AnyObject) {
        monsterHappy = true     //make the monster happy
        
        startTimer()            //restart the timer
        
        //dim the food and heart and disable the interaction
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
        
    }
    
    //: START A TIMER THAT FIRES EVERY 2 SECONDS AND CHECKS THE GAMESTATE TO SEE IF THE MONSTER IS HAPPY OR NOT
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    //: CHECK THE HAPPINESS OF THE MONSTER. IF NOT HAPPY, ADD A PENALTY AND CHECK TOTAL PENALTIES
    //  IF HAPPY, RANDOMLY DISPLAY FOOD OR HEART
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            checkPenalties()
        }
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        } else {
            randomizeItem()
        }
    }
    
    //: RANDOMLY ASSIGN AN ITEM FOR THE USER TO DRAG
    func randomizeItem() {
        
        let random = arc4random_uniform(2)
        
        if random == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        
        currentItem = random
        monsterHappy = false
    }
    
    //:
    func checkPenalties() {
        
        if penalties == 1 {
            penalty1Image.alpha = OPAQUE
            penalty2Image.alpha = DIM_ALPHA
        } else if penalties == 2 {
            penalty2Image.alpha = OPAQUE
            penalty3Image.alpha = DIM_ALPHA
        } else if (penalties >= 3) {
            penalty3Image.alpha = OPAQUE
        } else {
            penalty1Image.alpha = DIM_ALPHA
            penalty2Image.alpha = DIM_ALPHA
            penalty3Image.alpha = DIM_ALPHA
        }
    }
    
    //: KILL THE MONSTER, PLAY HIS DEATH SOUND, DIM ALL THE ITEMS, SHOW THE RESTART BUTTON, STOP THE TIMER
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        
        sfxDeath.play()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        restartButton.hidden = false
    }
    
    //: EVERYTHING GOES BACK TO ITS INITIAL STATE UPON PRESSING RESTART
    @IBAction func restartButtonPressed(sender: UIButton) {
        
        //reset the music
        musicPlayer.currentTime = 0
        musicPlayer.play()
        restartButton.hidden = true
        
        //reset the penalties
        penalties = 0

        //revive the monster
        monsterImage.playIdleAnimation()
        
        //restart the game
        initializeGame()
        
        //begin randomizing items again
        randomizeItem()
    }
    
}

