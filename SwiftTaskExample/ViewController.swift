//
//  ViewController.swift
//  HealthSwiftMeetup
//
//  Created by akio0911 on 2016/04/26.
//  Copyright © 2016年 akio0911. All rights reserved.
//

import UIKit
import SwiftTask

class ViewController: UIViewController {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressAnime1(sender: AnyObject) {
        
        redView.transform = CGAffineTransformIdentity
        UIView.animateWithDuration(2){
            self.redView.transform
                = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
        }
        
    }
    
    @IBAction func pressAnime2(sender: AnyObject) {
        
        
        redView.transform = CGAffineTransformIdentity
        UIView.animateWithDuration(
            2,
            animations: {
                self.redView.transform
                    = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
            },
            completion: { finish in
                print("finish!")
            })
        
        
    }
    
    @IBAction func pressAnime3(sender: AnyObject) {
        
        redView  .transform = CGAffineTransformIdentity
        greenView.transform = CGAffineTransformIdentity
        blueView .transform = CGAffineTransformIdentity
        
        UIView.animateWithDuration(
            2,
            animations: {
                self.redView.transform
                    = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
            },
            completion: { finish in

                UIView.animateWithDuration(
                    2,
                    animations: {
                        self.greenView.transform
                            = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
                    },
                    completion: { finish in
                        
                        UIView.animateWithDuration(
                            2,
                            animations: {
                                self.blueView.transform
                                    = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
                            },
                            completion: { _ in
                                print("finish!")
                            })
                    })
            })

    }
}

extension Task {
    func resumeTask() -> Task {
        resume()
        return self
    }
}

typealias AnimationTask = Task<(),(),()>
    
extension ViewController {
    @IBAction func pressAnime4(sender: AnyObject) {
        
        let animationTask = AnimationTask(paused: true) {
            (_, fulfill, _, _) in
            
            UIView.animateWithDuration(
                2,
                animations: {
                    self.redView.transform
                        = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
                },
                completion: { _ in fulfill() })
        }
        
        redView.transform = CGAffineTransformIdentity
        animationTask.resumeTask().success {
            print("finish!")
        }
        
    }
}

extension UIView {
    class func animationTask
        (duration duration: NSTimeInterval, animations: () -> Void)
        -> AnimationTask {
        
        return AnimationTask(paused: true) {
            (_, fulfill, _, _) in
            
            UIView.animateWithDuration(
                duration,
                animations: animations,
                completion: { _ in fulfill() } )
        }
    }
}

extension ViewController {
    func rotateAnimation(target: UIView) -> AnimationTask {
        return UIView.animationTask(duration: 2) {
            target.transform
                = CGAffineTransformMakeRotation(CGFloat(M_PI) / 2.0)
        }
    }
    
    @IBAction func pressAnime5(sender: AnyObject) {
        
        let anime1 = rotateAnimation(redView)
        let anime2 = rotateAnimation(greenView)
        let anime3 = rotateAnimation(blueView)
        
        [redView, greenView, blueView]
            .forEach{ $0.transform = CGAffineTransformIdentity }
        
        anime1.resumeTask().success {
            return anime2.resumeTask()
        }.success {
            return anime3.resumeTask()
        }
        
    }
}

infix operator >>> { associativity left }

func >>> (left: AnimationTask, right: AnimationTask) -> AnimationTask {
    let task = left.resumeTask().then { _ -> AnimationTask in
        return right.resumeTask()
    }
    return task
}

extension ViewController {
    @IBAction func pressAnime6(sender: AnyObject) {
        
        let anime1 = rotateAnimation(redView)
        let anime2 = rotateAnimation(greenView)
        let anime3 = rotateAnimation(blueView)
        
        [redView, greenView, blueView]
            .forEach{ $0.transform = CGAffineTransformIdentity }
        
        anime1 >>> anime2 >>> anime3
        
    }
}



