//
//  collectionViewController.swift
//  TabView
//
//  Created by Aakash Adhikari on 5/20/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.
//

import UIKit

class collectionViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchImages {
             DispatchQueue.main.async {
                    self.collectionView.reloadData()}
                    print("Successful.")
        }
        
    }

    
    func fetchImages(completionHandler: @escaping ()->()) {
        
        let url = URL(string: "http://www.kaleidosblog.com/tutorial/get_images.php")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }
            
            if let data = data {
                print("data: \(data)")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                        print("json array: \(json)")
                        self.imagesArray = json
                        
                        completionHandler()
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    //    func fetchImages(){
    //
    //        AF.request("http://www.kaleidosblog.com/tutorial/get_images.php", method: .get)
    //            .responseJSON { (response) in
    //                switch response.result {
    //                case .success(let value):
    //                    // if let result = response.result.value {
    //                    let response = value as! [String]
    //                    print(response)
    //                    self.imagesArray = response
    //
    //                    self.collectionView.reloadData()
    //
    //                    print(response)
    //                case .failure(let error):
    //                    print(error)
    //
    //                }
    //        }
    //
    //    }
}

extension collectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? collectionViewCell {
            
            if let imageURL = URL(string: imagesArray[indexPath.row]){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.imgView.image = image
                            
                        }
                    }
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
}

extension collectionViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Selected Image: \(imagesArray[indexPath.row])")
    }
}


