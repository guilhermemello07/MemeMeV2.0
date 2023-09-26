//
//  ViewController.swift
//  MemeMe -V2.0
//
//  Created by Guilherme Mello on 25/09/23.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Defining attributes for TextFields
    let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeWidth: -2.0,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40.0)!
    ]
    
    let imagePicker = UIImagePickerController()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        shareButton.isEnabled = false
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        subscribeForKeyboardNotifications()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        #if targetEnvironment(simulator)
        cameraButton.isEnabled = false
        #else
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        unsubscribeForKeyboardNotifications()
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
    
    func pickImage(source: UIImagePickerController.SourceType) {
        imagePicker.sourceType = source
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - IBAction Methods
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityVC, animated: true)
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.saveMeme()
                return
            }
            if let sharedError = error {
                print("Error while sharing: \(sharedError.localizedDescription)")
            }
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        pickImage(source: UIImagePickerController.SourceType.camera)
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIBarButtonItem) {
        pickImage(source: UIImagePickerController.SourceType.photoLibrary)
    }

    //MARK: - Keyboard Interaction methods
    @objc func keyboardWillShow(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: - Meme Image Generator Functions
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil, nil, nil)
        appDelegate.memes.append(meme)
        print("Adding memes.....")
        print(appDelegate.memes)
    }
}

//MARK: - MemeViewController class Extension methods
extension MemeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func setupTextField(_ textField: UITextField) {
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.adjustsFontSizeToFitWidth = true
        textField.autocapitalizationType = .allCharacters
    }
}

