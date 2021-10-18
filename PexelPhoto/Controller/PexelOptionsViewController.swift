//
//  PexelOptionsViewController.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import UIKit
import JonContextMenu

class PexelOptionsViewController: UIViewController, JonContextMenuDelegate {
    
    //MARK: - Variables
    
    static var select = 0
    
    var imageSelect:SelectedImage = .square
    
    //MARK: - Enums
    
    enum SelectedImage: Int {
        case square = 0
        case portrait = 1
        case landscape = 2
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var square: UIImageView!
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var landscape: UIImageView!
    @IBOutlet weak var orientationTitle: UILabel!
    @IBOutlet weak var photographerTitle: UILabel!
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var artistLineSeparator: UILabel!
    @IBOutlet weak var shareBackground: UIView!
    @IBOutlet weak var orientation: UIButton!
    
    //MARK: - Items & Menu Items
    
    let items = [JonItem(id: 1, title: "Save"   , icon: UIImage(systemName: "photo.fill")),
                 JonItem(id: 2, title: "Save All"  , icon: UIImage(systemName: "photo.on.rectangle.fill")),
                 JonItem(id: 3, title: "Share" , icon: UIImage(systemName: "square.and.arrow.up.fill")),
                 JonItem(id: 4, title: "Photo Album"  , icon: UIImage(systemName: "photo.tv"))]
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Square", image: UIImage(systemName: "person.crop.square"), handler: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                    self.imageSelect = .square
                    self.square.alpha = 1.0
                    self.portrait.alpha = 0.0
                    self.landscape.alpha = 0.0
                    self.orientationTitle.text = "Orientation ~ Square"
                }, completion: nil)
            }),
            UIAction(title: "Portrait", image: UIImage(systemName: "person.crop.artframe"), handler: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                    self.imageSelect = .portrait
                    self.square.alpha = 0.0
                    self.portrait.alpha = 1.0
                    self.landscape.alpha = 0.0
                    self.orientationTitle.text = "Orientation ~ Portrait"
                }, completion: nil)
            }),
            UIAction(title: "Landscape", image: UIImage(systemName: "person.crop.rectangle"), handler: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                    self.imageSelect = .landscape
                    self.square.alpha = 0.0
                    self.portrait.alpha = 0.0
                    self.landscape.alpha = 1.0
                    self.orientationTitle.text = "Orientation ~ Landscape"
                }, completion: nil)
            })
        ]
    }
    
    var orientationMenu: UIMenu {
        return UIMenu(title: "Select", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    //MARK: - Setup
    
    @objc func setUp() {
        let contextMenu = JonContextMenu().setDelegate(self).setItems(items).setItemsDefaultColorTo(.white).setItemsTitleColorTo(.white).setItemsActiveColorTo(.darkGray).setItemsTitleSizeTo(20.0).setBackgroundColorTo(.white, withAlpha: 0.2).build()
        shareBackground.addGestureRecognizer(contextMenu)
        orientation.menu = orientationMenu
        orientation.showsMenuAsPrimaryAction = true
        square.layer.masksToBounds = true
        square.layer.cornerRadius = 20.0
        portrait.layer.masksToBounds = true
        portrait.layer.cornerRadius = 20.0
        landscape.layer.masksToBounds = true
        landscape.layer.cornerRadius = 20.0
        shareBackground.layer.masksToBounds = true
        shareBackground.layer.cornerRadius = 20.0
        artistTitle.layer.masksToBounds = true
        artistTitle.layer.cornerRadius = 15.0
        orientation.layer.masksToBounds = true
        orientation.layer.cornerRadius = 15.0
        orientationTitle.layer.masksToBounds = true
        orientationTitle.layer.cornerRadius = 15.0
        portrait.image = UIImage(named: "noImage.png")
        landscape.image = UIImage(named: "noImage.png")
        portrait.alpha = 0.0
        landscape.alpha = 0.0
        let photo = PexelSearchViewController.pexelImages[PexelOptionsViewController.select]
        square.image = photo.image
        artistTitle.text = photo.owner
        retrievePortraitAndLandscape(portraitID: photo.portrait, landscapeID: photo.landscape)
    }
    
    //MARK: - Menu Functions
    
    @objc func retrievePortraitAndLandscape(portraitID: String, landscapeID: String) {
        let portraitUrl = URL(string: portraitID)
        let dataP = (try? Data(contentsOf: portraitUrl!))!
        let portraitFound = UIImage(data: dataP)
        portrait.image = portraitFound
        let landscapeUrl = URL(string: landscapeID)
        let dataL = (try? Data(contentsOf: landscapeUrl!))!
        let landscapeFound = UIImage(data: dataL)
        landscape.image = landscapeFound
    }
    
    func hideArtist() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.artistTitle.alpha = 0.0
            self.photographerTitle.alpha = 0.0
            self.artistLineSeparator.alpha = 0.0
        }, completion: nil)
    }
    
    func showArtist() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.artistTitle.alpha = 1.0
            self.photographerTitle.alpha = 1.0
            self.artistLineSeparator.alpha = 1.0
        }, completion: nil)
    }
    
    func menuOpened() {
        hideArtist()
    }
    
    func menuClosed() {
        showArtist()
    }
    
    func menuItemWasSelected(item: JonItem) {
        if item.id == 1 {
            print("Saving photo")
            switch imageSelect {
                case .square:
                    UIImageWriteToSavedPhotosAlbum(square.image!, nil, nil, nil)
                    successAlert()
                case .portrait:
                    UIImageWriteToSavedPhotosAlbum(portrait.image!, nil, nil, nil)
                    successAlert()
                case .landscape:
                    UIImageWriteToSavedPhotosAlbum(landscape.image!, nil, nil, nil)
                    successAlert()
            }
            
        } else if item.id == 2 {
            print("Save all photo")
            UIImageWriteToSavedPhotosAlbum(square.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(portrait.image!, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(landscape.image!, nil, nil, nil)
            let alert = UIAlertController(title: "Images Saved", message: "All three photo sizes have been saved to your photos.", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else if item.id == 3 {
            print("Share photo")
            switch imageSelect {
                case .square:
                    sharePhoto(item: square.image!)
                case .portrait:
                    sharePhoto(item: portrait.image!)
                case .landscape:
                    sharePhoto(item: landscape.image!)
            }
        } else if item.id == 4 {
            print("Navigating to Photos")
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        }
    }
    
    func menuItemWasActivated(item: JonItem) {
        shareBackground.layer.masksToBounds = true
        shareBackground.layer.cornerRadius = 20.0
    }
    
    func menuItemWasDeactivated(item: JonItem) {
    }
    
    //MARK: - Share Function

    @objc func sharePhoto(item: UIImage) {
        let image : UIImage = item
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Alert Function
    
    @objc func successAlert() {
        let alert = UIAlertController(title: "Image Saved", message: "Your image has been saved to your photos.", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
