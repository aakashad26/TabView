//
//  ImagesViewController.swift
//  TabView
//
//  Created by Aakash Adhikari on 5/19/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.
//

//http://www.kaleidosblog.com/tutorial/get_images.php

import UIKit

class ImagesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var imagesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        fetchImages{
             DispatchQueue.main.async {
                self.tableView.reloadData()}
            print("Successful.")
        }

        tableView.tableFooterView = UIView()
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
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    // try to read out a string array
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

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return imagesArray.count
    
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesCell") as? ImagesCell else {return UITableViewCell()}
        
        
        
        cell.imgView.layer.cornerRadius = 20
        //cell.imgView.clipsToBounds = true
        cell.imgView.layer.masksToBounds = true
        
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
  
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
           return 274
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return UITableView.automaticDimension
      
    }
}

extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    
}

