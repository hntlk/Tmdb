//
//  DetailViewController.swift
//  Tmdb
//
//  Created by Cntt22 on 5/17/17.
//  Copyright © 2017 Cntt22. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tv_overView: UIScrollView!
    @IBOutlet weak var lbl_revenue: UILabel!
    @IBOutlet weak var lbl_budget: UILabel!
    @IBOutlet weak var lbl_vote: UILabel!
    @IBOutlet weak var lbl_release: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_overView: UILabel!
    var id: Int?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
        title = "Movie Detail"
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hàm lấy thông tin chi tiết phim từ trang The MovieDB
    func getMovieDetail() {
        if let movieId = id {
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(API)&language=en-US")
            var detail = [String:Any]()
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
            request.httpMethod = "GET"
            _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (Data, URLResponse, Error) in
                if (Error != nil) {
                    print(Error!)
                } else {
                    do {
                        detail = try JSONSerialization.jsonObject(with: Data!, options: .allowFragments) as! [String:Any]
                        DispatchQueue.main.async {
                            self.lbl_title.text = detail["title"]! as? String
                            if let day = detail["release_date"] {
                                self.lbl_release.text = "Release Date: \(day)"
                            }
                            if let vote = detail["vote_average"] {
                                self.lbl_vote.text = "⭐️ \(vote)"
                            }
                            if let budget = detail["budget"] {
                                self.lbl_budget.text = "Budget: \(budget)$"
                            }
                            if let revenue = detail["revenue"] {
                                self.lbl_revenue.text = "Revenue: \(revenue)$"
                            }
                            if let overview = detail["overview"] {
                                self.lbl_overView.text  = "Overview: \(overview)"
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }).resume()
        }
    }

}
