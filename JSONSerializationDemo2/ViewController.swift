//
//  ViewController.swift
//  JSONSerializationDemo2
//
//  Created by Mac on 13/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var photosTableView: UITableView!
    var url : URL?
    var urlRequest : URLRequest?
    var urlSession : URLSession?
    var photo : [Photo] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        JSONSerialization()
        photosTableView.dataSource = self
    }
    
    private func JSONSerialization(){
        url = URL(string: Constants.photosUrl)
        urlRequest = URLRequest(url:url!)
        urlRequest?.httpMethod = "GET"
        urlSession = URLSession(configuration:.default)
        
        let photoDataTask = urlSession?.dataTask(with: urlRequest!, completionHandler:{ data,error,response in
            
            let photoAPIResponse = try! Foundation.JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for eachPhoto in photoAPIResponse{
              
                let eachId = eachPhoto["id"] as! Int
                let eachPhotoTitle = eachPhoto["title"] as! String
                let eachPhotoURL = eachPhoto["url"] as! String
                let eachPhotoThumbnailURL = eachPhoto["thumbnailUrl"] as! String
                
                self.photo.append(Photo(id: eachId, title: eachPhotoTitle, url: eachPhotoURL, thumbnailUrl: eachPhotoThumbnailURL))
                                  
                                  }
                                  DispatchQueue.main.async {
                                      self.photosTableView.reloadData()
                                  }
                                  
                                  print(self.photo)
                              })
                              photoDataTask?.resume()
                          }
                      


}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.photosTableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoTableViewCell
        
        cell.idLabel.text = String(photo[indexPath.row].id)
        cell.titleLabel.text = String(photo[indexPath.row].title)
        cell.urlLabel.text = String(photo[indexPath.row].url)
        cell.thumbnailUrl.text = String(photo[indexPath.row].thumbnailUrl)
        
        return cell
    }
    
}
