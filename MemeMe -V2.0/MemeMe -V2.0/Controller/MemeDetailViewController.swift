//
//  MemeDetailViewController.swift
//  MemeMe -V2.0
//
//  Created by Guilherme Mello on 26/09/23.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedIndex: Int?
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var memes: [Meme]! {
        return appDelegate.memes
    }

    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedIndex != nil {
            detailImageView.image = memes[selectedIndex!].memedImage
        }
        
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let memedImage = memes[selectedIndex!].memedImage
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityVC, animated: true)
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                return
            }
            if let sharedError = error {
                print("Error while sharing: \(sharedError.localizedDescription)")
            }
        }

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
