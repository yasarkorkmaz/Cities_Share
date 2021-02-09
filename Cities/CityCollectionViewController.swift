//
//  CityCollectionViewController.swift
//  Cities
//
//  Created by Yasar on 29.01.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class CityCollectionViewController: UICollectionViewController {
    
    private var shareEnabled = false
    private var selectedImages : [(image: City, snapshot: UIImage)] = []
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }
    
    @IBOutlet var shareBtn: UIBarButtonItem!
    
    @IBAction func shareBtnTapped(sender: AnyObject){
        
        guard shareEnabled else {
            //Change shareEnabled to YES and change the button text to Done
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareBtn.title = "Done"
            shareBtn.style = UIBarButtonItem.Style.plain
            return
        }
        
        //Make sure the user has selected at least one image
        guard selectedImages.count > 0 else {
            return
        }
        
        //Get the snapshots of the selected images
        let snapshots = selectedImages.map { $0.snapshot }
        
        //Create an activity view controller for sharing
        let activityController = UIActivityViewController(activityItems: snapshots, applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItem, error) in
            
            //Deselect all selected items
            if let indexPaths = self.collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths{
                    self.collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            
            //Remove all items from selectedImages array
            self.selectedImages.removeAll(keepingCapacity: true)
            
            //Change the sharing mode to No
            self.shareEnabled = false
            self.collectionView?.allowsMultipleSelection = false
            self.shareBtn.title = "Share"
            self.shareBtn.style = UIBarButtonItem.Style.plain
            
        }
        present(activityController, animated: true, completion: nil)
        
    }
    
    private var cities : [City] = [ City(image: "Ankara", name: "Ankara"),
                                    City(image: "Antalya", name: "Antalya"),
                                    City(image: "Aydin", name: "Aydin"),
                                    City(image: "Bodrum", name: "Bodrum"),
                                    City(image: "Canakkale", name: "Canakkale"),
                                    City(image: "Cappadocia", name: "Cappadocia"),
                                    City(image: "Efes", name: "Efes"),
                                    City(image: "Eskisehir", name: "Eskisehir"),
                                    City(image: "Fethiye", name: "Fethiye"),
                                    City(image: "Istanbul", name: "Istanbul"),
                                    City(image: "Izmir", name: "Izmir"),
                                    City(image: "Mardin", name: "Mardin"),
                                    City(image: "Nemrut", name: "Nemrut"),
                                    City(image: "Pamukkale", name: "Pamukkale"),
                                    City(image: "Patara", name: "Patara"),
                                    City(image: "Rize", name: "Rize"),
                                    City(image: "Salda", name: "Salda"),
                                    City(image: "Sumela", name: "Sumela")]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cities.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! CityCollectionViewCell
    
        // Configure the cell
        
        let city = cities[indexPath.row]
        cell.cityImageView.image = UIImage(named: city.image)
        cell.cityNameLabel.text = city.name
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "skyBlue"))
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if shareEnabled == false {
            performSegue(withIdentifier: "showDetail", sender: nil)

        } else {
            
        
        //Determine the selected items by using the indexPath and take a snapshot
            let selectedImage = cities[indexPath.row]
        if let snapshot = collectionView.cellForItem(at: indexPath)?.snapshot{
            //Add the selected item into array
            selectedImages.append((image: selectedImage, snapshot: snapshot))
        }
        
    }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //Check if the sharing mode is enabled, otherwise, just leave this method
        guard shareEnabled else {
            return
        }
        let deselectedImage = cities[indexPath.row]
        if let index = selectedImages.firstIndex(where: { $0.image.name == deselectedImage.name}){
            selectedImages.remove(at: index)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPaths = collectionView.indexPathsForSelectedItems{
                let destinationController = segue.destination as! CityDetailViewController
                destinationController.city = cities[indexPaths[0].row]
                collectionView.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }

    
}
