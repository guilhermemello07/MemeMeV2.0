//
//  MemeTableViewController.swift
//  MemeMe -V2.0
//
//  Created by Guilherme Mello on 25/09/23.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var memes: [Meme]! {
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.tableCellNibName, bundle: nil), forCellReuseIdentifier: K.tableCellID)
        tableView.reloadData()
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if memes.count > 0 {
            tableView.allowsSelection = true
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableCellID, for: indexPath) as! TableCell
        
        cell.cellImageView.image = memes[indexPath.row].memedImage
        cell.backgroundColor = UIColor.clear
        cell.cellLabel.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: K.memeDetailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.memeDetailSegue {
            let destinationVC = segue.destination as! MemeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedIndex = indexPath.row
            }
        }
    }
}
