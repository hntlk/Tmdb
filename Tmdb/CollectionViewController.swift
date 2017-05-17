//
//  CollectionViewController.swift
//  Tmdb
//
//  Created by Cntt22 on 5/17/17.
//  Copyright © 2017 Cntt22. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
// Class hỗ trợ tải hình ảnh từ một URL xác định
class Downloader {
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}
class CollectionViewController: UICollectionViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var movies: [Movie] = {
        return MovieList.movies()
    }()
    var queue = OperationQueue()
    var loadingData = false
    var refreshPage = 20
    var p = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        loadMovie(page: p)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        // Configure the cell
        cell.imageView?.image = #imageLiteral(resourceName: "default")
        queue.addOperation { () -> Void in
            if let img = Downloader.downloadImageWithURL("\(prefixImg)\(self.movies[indexPath.row].poster!)") {
                OperationQueue.main.addOperation({
                    self.movies[indexPath.row].image = img
                    cell.imageView?.image = img
                })
            }
        }
        //cell.textLabel?.text = movies[indexPath.row].title
        //cell.detailTextLabel?.text = movies[indexPath.row].overview
        return cell
    }
    // Hàm gửi yêu cầu lên trang The MovieDB để lấy dữ liệu các bộ phim đang chiếu về (Now Playing Movies)
    func loadMovie(page:Int) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API)&language=en-US&page=\(page)")
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            // Lấy các thông tin cần thiết từ mảng results được trang web trả về
                            if let array: AnyObject = response["results"] {
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let title = movieDictonary["title"] as? String {
                                        let movie_id = movieDictonary["id"] as? Int
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        self.movies.append(Movie(id: movie_id, title: title, poster: poster, overview: overview, releaseDate: releaseDate, image: #imageLiteral(resourceName: "default")))
                                    } else {
                                        print("Not a dictionary")
                                    }
                                }
                                self.p += 1
                            } else {
                                print("Results key not found in dictionary")
                            }
                        } else {
                            print("JSON Error")
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.collectionView?.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    
    func loadMovie2(page:Int) {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API)&language=en-US&page=\(page)")
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            // Lấy các thông tin cần thiết từ mảng results được trang web trả về
                            if let array: AnyObject = response["results"] {
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let title = movieDictonary["title"] as? String {
                                        let movie_id = movieDictonary["id"] as? Int
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        self.movies.append(Movie(id: movie_id, title: title, poster: poster, overview: overview, releaseDate: releaseDate, image: #imageLiteral(resourceName: "default")))
                                    } else {
                                        print("Not a dictionary")
                                    }
                                }
                                self.refreshPage += 20
                                self.collectionView?.reloadData()
                                self.loader.stopAnimating()
                                self.loadingData = false
                                self.p += 1
                            } else {
                                print("Results key not found in dictionary")
                            }
                        } else {
                            print("JSON Error")
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.collectionView?.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    // MARK: - Navigation
    // Chuẩn bị các thông tin cần thiết để điều hướng sang view Movie Detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let cell = sender as! CollectionViewCell
                let movieDetailVC = segue.destination as! DetailViewController
                let indexPath = collectionView?.indexPath(for: cell)
                
                    movieDetailVC.id = idAtIndexPath(indexPath: indexPath! as NSIndexPath)
                    movieDetailVC.image = imageAtIndexPath(indexPath: indexPath! as NSIndexPath)
                
         }
    }
    
    // MARK: - Helper Method
    
    func idAtIndexPath(indexPath: NSIndexPath) -> Int
    {
        return movies[indexPath.row].id!
    }
    
    func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage
    {
        return movies[indexPath.row].image!
        
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
*/



}
