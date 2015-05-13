//
//  ViewController.swift
//  SpeechDemo
//
//  Created by Gabriel Theodoropoulos on 2/10/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var tvEditor: UITextView!
    
    @IBOutlet weak var btnSpeak: UIButton!
    
    @IBOutlet weak var btnPause: UIButton!
    
    @IBOutlet weak var btnStop: UIButton!
    
    @IBOutlet weak var pvSpeechProgress: UIProgressView!
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    var preferredVoiceLanguageCode: String!
    
    var previousSelectedRange: NSRange!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make the corners of the textview rounded and the buttons look like circles.
        tvEditor.layer.cornerRadius = 15.0
        btnSpeak.layer.cornerRadius = 40.0
        btnPause.layer.cornerRadius = 40.0
        btnStop.layer.cornerRadius = 40.0
        
        // Set the initial alpha value of the following buttons to zero (make them invisible).
        btnPause.alpha = 0.0
        btnStop.alpha = 0.0
        
        // Make the progress view invisible and set is initial progress to zero.
        pvSpeechProgress.alpha = 0.0
        pvSpeechProgress.progress = 0.0
        
        // Create a swipe down gesture for hiding the keyboard.
        var swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeDownGesture:")
        swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        speechSynthesizer.delegate = self
        
        setInitialFontAttribute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueSettings" {
            let settingsViewController = segue.destinationViewController as SettingsViewController
            settingsViewController.delegate = self
        }    
    }
    
    
    // MARK: Custom method implementation
    
    func handleSwipeDownGesture(gestureRecognizer: UISwipeGestureRecognizer) {
        tvEditor.resignFirstResponder()
    }
    
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<NSObject, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as Float
            volume = userDefaults.valueForKey("volume") as Float
            
            return true
        }
        
        return false
    }
    
    
    func animateActionButtonAppearance(shouldHideSpeakButton: Bool) {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.btnSpeak.alpha = speakButtonAlphaValue
            
            self.btnPause.alpha = pauseStopButtonsAlphaValue
            
            self.btnStop.alpha = pauseStopButtonsAlphaValue
            
            self.pvSpeechProgress.alpha = pauseStopButtonsAlphaValue
        })
    }
    
    
    func setInitialFontAttribute() {
        let rangeOfWholeText = NSMakeRange(0, tvEditor.text.utf16Count)
        let attributedText = NSMutableAttributedString(string: tvEditor.text)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 18.0)!, range: rangeOfWholeText)
        tvEditor.textStorage.beginEditing()
        tvEditor.textStorage.replaceCharactersInRange(rangeOfWholeText, withAttributedString: attributedText)
        tvEditor.textStorage.endEditing()
    }
    
    
    func unselectLastWord() {
        if let selectedRange = previousSelectedRange {
            // Get the attributes of the last selected attributed word.
            let currentAttributes = tvEditor.attributedText.attributesAtIndex(selectedRange.location, effectiveRange: nil)
            // Keep the font attribute.
            let fontAttribute: AnyObject? = currentAttributes[NSFontAttributeName]
            
            // Create a new mutable attributed string using the last selected word.
            let attributedWord = NSMutableAttributedString(string: tvEditor.attributedText.attributedSubstringFromRange(selectedRange).string)
            
            // Set the previous font attribute, and make the foreground color black.
            attributedWord.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, attributedWord.length))
            attributedWord.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, attributedWord.length))
            
            // Update the text storage property and replace the last selected word with the new attributed string.
            tvEditor.textStorage.beginEditing()
            tvEditor.textStorage.replaceCharactersInRange(selectedRange, withAttributedString: attributedWord)
            tvEditor.textStorage.endEditing()
        }
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func speak(sender: AnyObject) {
        if !speechSynthesizer.speaking {
            /**
            let speechUtterance = AVSpeechUtterance(string: tvEditor.text)
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            speechSynthesizer.speakUtterance(speechUtterance)
            */

            let textParagraphs = tvEditor.text.componentsSeparatedByString("\n")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
            for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.005
                
                if let voiceLanguageCode = preferredVoiceLanguageCode {
                    let voice = AVSpeechSynthesisVoice(language: voiceLanguageCode)
                    speechUtterance.voice = voice
                }
                
                totalTextLength = totalTextLength + pieceOfText.utf16Count
                
                speechSynthesizer.speakUtterance(speechUtterance)
            }
            
            
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(true)
    }
    
    
    @IBAction func pauseSpeech(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
        animateActionButtonAppearance(false)
    }
    
    
    @IBAction func stopSpeech(sender: AnyObject) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        animateActionButtonAppearance(false)
    }
    
    
 
    // MARK: AVSpeechSynthesizerDelegate method implementation
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        spokenTextLengths = spokenTextLengths + utterance.speechString.utf16Count + 1
        
        let progress: Float = Float(spokenTextLengths * 100 / totalTextLength)
        pvSpeechProgress.progress = progress / 100
        
        if currentUtterance == totalUtterances {
            animateActionButtonAppearance(false)
            
            unselectLastWord()
            previousSelectedRange = nil
        }
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        currentUtterance = currentUtterance + 1
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let progress: Float = Float(spokenTextLengths + characterRange.location) * 100 / Float(totalTextLength)
        pvSpeechProgress.progress = progress / 100
    
        
        // Determine the current range in the whole text (all utterances), not just the current one.
        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)
        
        // Select the specified range in the textfield.
        tvEditor.selectedRange = rangeInTotalText
        
        // Store temporarily the current font attribute of the selected text.
        let currentAttributes = tvEditor.attributedText.attributesAtIndex(rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes[NSFontAttributeName]
        
        // Assign the selected text to a mutable attributed string.
        let attributedString = NSMutableAttributedString(string: tvEditor.attributedText.attributedSubstringFromRange(rangeInTotalText).string)
        
        // Make the text of the selected area orange by specifying a new attribute.
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSMakeRange(0, attributedString.length))
        
        // Make sure that the text will keep the original font by setting it as an attribute.
        attributedString.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.utf16Count))
        
        // In case the selected word is not visible scroll a bit to fix this.
        tvEditor.scrollRangeToVisible(rangeInTotalText)
        
        // Begin editing the text storage.
        tvEditor.textStorage.beginEditing()
        
        // Replace the selected text with the new one having the orange color attribute.
        tvEditor.textStorage.replaceCharactersInRange(rangeInTotalText, withAttributedString: attributedString)
        
        // If there was another highlighted word previously (orange text color), then do exactly the same things as above and change the foreground color to black.
        if let previousRange = previousSelectedRange {
            let previousAttributedText = NSMutableAttributedString(string: tvEditor.attributedText.attributedSubstringFromRange(previousRange).string)
            previousAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, previousAttributedText.length))
            previousAttributedText.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, previousAttributedText.length))
            
            tvEditor.textStorage.replaceCharactersInRange(previousRange, withAttributedString: previousAttributedText)
        }
        
        // End editing the text storage.
        tvEditor.textStorage.endEditing()
        
        // Keep the currently selected range so as to remove the orange text color next.
        previousSelectedRange = rangeInTotalText
    }
    
    
    // MARK: SettingsViewControllerDelegate method implementation
    
    func didSaveSettings() {
        let settings = NSUserDefaults.standardUserDefaults() as NSUserDefaults!
        
        rate = settings.valueForKey("rate") as Float
        pitch = settings.valueForKey("pitch") as Float
        volume = settings.valueForKey("volume") as Float
        
        preferredVoiceLanguageCode = settings.objectForKey("languageCode") as String
    }
    
}

