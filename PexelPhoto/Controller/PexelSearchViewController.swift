//
//  PexelSearchViewController.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import UIKit
import TableViewReloadAnimation

class PexelSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    static var pexelList:[Photo] = []
    
    static var pexelImages:[PexelImages] = []
    
    var initialSearch = true
    
    var searching = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let cellReuseIdentifier = "pexel"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    @objc func setUp() {
        actionButton.titleLabel?.text = "Search"
        actionButton.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        tableView.rowHeight = 320
        tableView.register(UINib(nibName: "PexelsTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "pexel")
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 30.0
        titleLabel.layer.shadowColor = UIColor.lightGray.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        titleLabel.layer.shadowRadius = 15.0
        search.layer.masksToBounds = true
        search.layer.cornerRadius = 15.0
        search.layer.borderColor = UIColor.white.cgColor
        search.layer.borderWidth = 1.0
        search.layer.shadowColor = UIColor.lightGray.cgColor
        search.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        search.layer.shadowRadius = 15.0
        loadNotifications()
    }
    
    @objc func loadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(imagesReload), name: .picturesLoaded, object: nil)
    }
    
    @objc func imagesReload() {
        DispatchQueue.main.async {
            if !self.initialSearch {
                let index = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: index, at: .top, animated: true)
            }
            self.initialSearch = false
            self.searching = false
            self.tableView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                self.tableView.alpha = 1.0
            }, completion: nil)
            self.activity.stopAnimating()
            self.tableView.reloadData(
                with: .simple(duration: 0.75, direction: .rotation3D(type: .doctorStrange),
                              constantDelay: 0))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount = PexelSearchViewController.pexelImages.count
        NSLog("Amount of images found: \(amount)")
        return amount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pexel") as! PexelsTableViewCell
        let item = PexelSearchViewController.pexelImages
        let image = item[indexPath.row].image.jpegData(compressionQuality: 1.0)
        let artist = item[indexPath.row].owner
        cell.pexelImage.image = UIImage(data: image!)
        cell.pexelArtist.text = artist!.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selection = indexPath.row
        PexelOptionsViewController.select = selection
        performSegue(withIdentifier: "viewImageSegue", sender: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.tableView.alpha = 0.2
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searching {
            print("Searching for images...")
        } else {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                self.tableView.alpha = 1.0
                self.tableView.isUserInteractionEnabled = true
            }, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searching = true
        textField.resignFirstResponder()
        searchItem()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func searchOrLoad(_ sender: UIButton) {
        searchItem()
    }
    
    @objc func searchItem() {
        if search.text == "" {
            NSLog("No Text entered")
            return
        }
        tableView.isUserInteractionEnabled = false
        activity.startAnimating()
        let unsafeChars = CharacterSet.alphanumerics.inverted
        let item = search.text?.replacingOccurrences(of: " ", with: "+")
        let searchItem = item!.components(separatedBy: unsafeChars).joined(separator: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let lookup = searchItem
            PexelNetworkCalls().pexelSearch(title: lookup)
        }
    }
    
}
