//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Go, Ian on 10/4/16.
//  Copyright © 2016 Go, Ian. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var miscScrollView: UIScrollView!
    @IBOutlet weak var readFeedImageView: UIImageView!
    
    @IBOutlet weak var messageScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    
    var rightMessageIcon: UIImageView!
    var leftMessageIcon: UIImageView!
    
    let archiveIconImage = UIImage(named: "archive_icon.png")
    let deleteIconImage = UIImage(named: "delete_icon.png")
    let laterIconImage = UIImage(named: "later_icon.png")
    let listIconImage = UIImage(named: "list_icon.png")
    
    var messageViewInitialCenter: CGPoint!
    var rightMessageIconInitialCenter: CGPoint!
    var leftMessageIconInitialCenter: CGPoint!
    
    var mainViewInitialCenter: CGPoint!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var rescheduleFullImageView: UIImageView!
    @IBOutlet weak var listFullImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageScrollView.delegate = self
        
        messageScrollView.contentSize = feedImageView.frame.size
        messageScrollView.contentSize.height += messageImageView.frame.height
        
        miscScrollView.contentSize = readFeedImageView.frame.size
        
        rightMessageIcon = UIImageView(image: laterIconImage)
        messageBackgroundView.addSubview(rightMessageIcon)
        messageBackgroundView.insertSubview(rightMessageIcon, belowSubview: messageImageView)
        
        rightMessageIcon.center.y = messageBackgroundView.center.y
        rightMessageIcon.center.x = messageBackgroundView.frame.width - rightMessageIcon.frame.width
        
        leftMessageIcon = UIImageView(image: archiveIconImage)
        messageBackgroundView.addSubview(leftMessageIcon)
        messageBackgroundView.insertSubview(leftMessageIcon, belowSubview: messageImageView)
        leftMessageIcon.center.y = messageBackgroundView.center.y
        leftMessageIcon.center.x = leftMessageIcon.frame.width
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didEdgePanLeft(_:)))
        edgeGesture.edges = UIRectEdge.left
        mainView.addGestureRecognizer(edgeGesture)
        
        segmentedControl.selectedSegmentIndex = 1
        miscScrollView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        print(location)
        print(translation)
        
        if sender.state == UIGestureRecognizerState.began{
            messageViewInitialCenter = messageImageView.center
            
            rightMessageIcon.alpha = 0.0
            rightMessageIconInitialCenter = rightMessageIcon.center
            
            leftMessageIcon.alpha = 0.0
            leftMessageIconInitialCenter = leftMessageIcon.center

            print("Gesture has begun")
        } else if sender.state == UIGestureRecognizerState.changed{
            messageImageView.center = CGPoint(x: translation.x + messageViewInitialCenter.x, y: messageViewInitialCenter.y)
            
            //if moving tile to the right
            if velocity.x > 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.leftMessageIcon.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.rightMessageIcon.alpha = 1
                })
            }
            
            if translation.x < -250 {
                rightMessageIcon.image = listIconImage
                self.rightMessageIcon.center = CGPoint(x: translation.x + rightMessageIconInitialCenter.x + 50, y: rightMessageIconInitialCenter.y)
                self.messageBackgroundView.backgroundColor = UIColor.brown
            } else if translation.x < -50 && translation.x >= -250 {
                rightMessageIcon.image = laterIconImage
                self.rightMessageIcon.center = CGPoint(x: translation.x + rightMessageIconInitialCenter.x + 50, y: rightMessageIconInitialCenter.y)
                self.messageBackgroundView.backgroundColor = UIColor(colorLiteralRed: 255.0, green: 220/255.0, blue: 36/255.0, alpha: 1)
            } else if translation.x > 50 && translation.x <= 250 {
                leftMessageIcon.image = archiveIconImage
                self.leftMessageIcon.center = CGPoint(x: translation.x + leftMessageIconInitialCenter.x - 50, y: leftMessageIconInitialCenter.y)
                self.messageBackgroundView.backgroundColor = UIColor.green
            } else if translation.x > 250 {
                print("turn red")
                leftMessageIcon.image = deleteIconImage
                self.leftMessageIcon.center = CGPoint(x: translation.x + leftMessageIconInitialCenter.x - 50, y: leftMessageIconInitialCenter.y)
                self.messageBackgroundView.backgroundColor = UIColor.red
            } else {
                self.messageBackgroundView.backgroundColor = UIColor.lightGray
            }
            print("Gesture has changed")
        } else if sender.state == UIGestureRecognizerState.ended{
            
            if translation.x < -250 {
                //brown list icon
                UIView.animate(withDuration: 0.2, animations: { 
                    self.messageImageView.frame.origin.x = 0 - self.messageImageView.frame.width
                    self.rightMessageIcon.frame.origin.x = 0 - self.messageImageView.frame.width
                    }, completion: { (Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.listFullImageView.alpha = 1
                            }, completion: { (Bool) in
                        })
                })
            } else if translation.x < -50 && translation.x >= -250 {
                //yellow later icon
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.frame.origin.x = 0 - self.messageImageView.frame.width
                    self.rightMessageIcon.frame.origin.x = 0 - self.messageImageView.frame.width
                    }, completion: { (Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.rescheduleFullImageView.alpha = 1
                            }, completion: { (Bool) in
                        })
                })
            } else if translation.x > 50 && translation.x <= 250 {
                //green check icon
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.frame.origin.x = 375
                    self.leftMessageIcon.frame.origin.x = 375
                    }, completion: { (Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.feedImageView.frame.origin.y = 0
                            }, completion: { (Bool) in
                            self.messageBackgroundView.isHidden = true
                        })
                })
            } else if translation.x > 250 {
                //red delete icon
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.frame.origin.x = 375
                    self.leftMessageIcon.frame.origin.x = 375
                    }, completion: { (Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.feedImageView.frame.origin.y = 0
                            }, completion: { (Bool) in
                            self.messageBackgroundView.isHidden = true
                        })
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.messageImageView.center = self.messageViewInitialCenter
                    self.leftMessageIcon.center = self.leftMessageIconInitialCenter
                    self.rightMessageIcon.center = self.rightMessageIconInitialCenter
                    self.leftMessageIcon.image = self.archiveIconImage
                    self.rightMessageIcon.image = self.laterIconImage
                    
                    self.messageBackgroundView.backgroundColor = UIColor.lightGray
                    
                    }, completion: { (Bool) in
                        //
                })
            }
            print("Gesture has ended")
        }
    }

    @IBAction func didEdgePanLeft(_ sender: UIScreenEdgePanGestureRecognizer) {
        let location = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        print(location)
        print(translation)
        
        if sender.state == UIGestureRecognizerState.began{
            mainViewInitialCenter = mainView.center
            print("Gesture began")
        } else if sender.state == UIGestureRecognizerState.changed{
            self.mainView.center = CGPoint(x: translation.x + mainViewInitialCenter.x, y: mainViewInitialCenter.y)
            print("Gesture is changing")
        } else if sender.state == UIGestureRecognizerState.ended{
            if velocity.x > 0 {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.mainView.frame.origin.x = 375
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainView.frame.origin.x = 0
                })
            }
            print("Gesture ended")
        }
    }
    @IBAction func didTapFullScreen(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: { 
            sender.view?.alpha = 0
            }) { (Bool) in
                UIView.animate(withDuration: 0.2, animations: { 
                    self.feedImageView.frame.origin.y = 0
                    }, completion: { (Bool) in
                        self.messageBackgroundView.isHidden = true
                })
        }
    }
    @IBAction func didTapSegmented(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            miscScrollView.delegate = self
            miscScrollView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.messageScrollView.frame.origin.x = 375
                }, completion: { (Bool) in
                    
            })
            print("later")
        } else if sender.selectedSegmentIndex == 1 {
            messageScrollView.delegate = self
            miscScrollView.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.messageScrollView.frame.origin.x = 0
                }, completion: { (Bool) in
                
            })
            print("mail")
        } else if sender.selectedSegmentIndex == 2 {
            miscScrollView.delegate = self
            miscScrollView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.messageScrollView.frame.origin.x = -375
                }, completion: { (Bool) in
                    
            })
            print("check")
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            print("shake me")
            
            //login error
            let alertController = UIAlertController(title: "Undo Message", message: "Are you sure?", preferredStyle: .alert)
            
            // create a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style:.default) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            
            let UndoAction = UIAlertAction(title: "Undo", style:.default) { (action) in
                self.messageBackgroundView.backgroundColor = UIColor.lightGray
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.feedImageView.frame.origin.y = self.messageImageView.frame.height
                    }, completion: { (Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.messageImageView.frame.origin.x = 0
                            self.messageBackgroundView.isHidden = false
                            }, completion: { (Bool) in
                                self.messageImageView.center = self.messageViewInitialCenter
                                self.leftMessageIcon.center = self.leftMessageIconInitialCenter
                                self.rightMessageIcon.center = self.rightMessageIconInitialCenter
                                self.leftMessageIcon.image = self.archiveIconImage
                                self.rightMessageIcon.image = self.laterIconImage
                        })
                })
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            alertController.addAction(UndoAction)
            
            present(alertController, animated: true, completion: nil)

        }
    }
}
