//
//  FeedViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 11/06/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Cloudinary
import Alamofire
import AlamofireImage
import SwiftyGif



class FeedViewController: UIViewController {
    
    @IBOutlet weak var universitariosTableView: UITableView!
    var searchBar: UISearchBar!
    var btnFilter: UIButton!
    
    var headerView: Header!
    
    var imageView = ProfileImageView(image: UIImage(named: "semFoto-2"))
    
    var notFound: UIImageView = UIImageView()
    
    let config = CLDConfiguration(cloudName: "dny7llci8", apiKey: "434561441216885")
    var cloudinary: CLDCloudinary?
    
    var universitariosBackup: [Universitario] = []
    var universitarios: [Universitario] = []
    var filteredUni: [Universitario] = []
    var searchActive: Bool = false
    var finishedLoadingInitialTableCell = false
    
    let URL_GET_DATA = "https://jamb-api.herokuapp.com/students/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudinary = CLDCloudinary(configuration: config)
        imageView.setupUI(controller: self)
        
//        notFound.image = #imageLiteral(resourceName: "notFound-2")
        notFound.image = #imageLiteral(resourceName: "notfound-vector")

        self.view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        universitariosTableView.register(UINib(nibName: "CardUniversitarioTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let headerNib = UINib.init(nibName: "HeaderView", bundle: nil)
        universitariosTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "Header")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.clipsToBounds = true
        imageView.gradientBorder()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.endEditing(true)
        imageView.showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.isHidden = false
        imageView.showImage(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUser()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        performSegue(withIdentifier: "profile", sender: nil)
    }
    
    
    func checkUser() {
        if(UserDefaults.standard.object(forKey: "SavedUniversitario") == nil) {
            performSegue(withIdentifier: "login", sender: nil)
        } else{
            if let savedUniversitario = UserDefaults.standard.object(forKey: "SavedUniversitario") as? Data {
                let decoder = JSONDecoder()
                
                print(savedUniversitario)
                
                if let loadedUniversitario = try? decoder.decode(Universitario.self, from: savedUniversitario) {
                    imageView.cldSetImage(loadedUniversitario.imageUrl, cloudinary: cloudinary!)
                    
                    print(loadedUniversitario)
                    
                    Alamofire.request(URL_GET_DATA).responseJSON { json in
                        
                        
 
                        self.universitarios = []
                        
                        guard let data = json.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(Response.self, from: data)
                            self.universitarios = response.data.filter({ (universitario) -> Bool in
                                universitario.id != loadedUniversitario.id
                            })
                            self.universitariosBackup = self.universitarios
                            
                        } catch let err {
                            print("Err", err)
                        }
                        self.universitariosTableView.reloadData()
                        
                        
                    }

                } else {
                    print("Error")
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearUser(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "SavedUniversitario")
        checkUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhes" {
            let controller = segue.destination as! UniversitarioViewController
            controller.universitario = sender as! Universitario
        }
        if segue.identifier == "filter" {
            let controller = segue.destination as! FilterViewController
            controller.delegate = self
        }
    }
    
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            print(filteredUni.count)
            return filteredUni.count
        }
        print(universitarios.count)
        return universitarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardUniversitarioTableViewCell
            var array : [Universitario]
        
            if searchActive {
                if self.filteredUni.isEmpty {
                    array = self.universitarios
                } else {
                array = self.filteredUni
                }
            } else {
                array = self.universitarios
            }
        
            let universitario = array[indexPath.row]
            
            cell.nomeLabel.text = universitario.name
            cell.universidadeLabel.text = universitario.university
            cell.cursoLabel.text = universitario.major
            cell.fotoImageView.af_setImage(withURL: URL(string: universitario.imageUrl)!)
        
            let bgColorView = UIView()
            bgColorView.backgroundColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
            cell.selectedBackgroundView = bgColorView
            
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let universitario = universitarios[indexPath.row]
        imageView.isHidden = true
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        performSegue(withIdentifier: "detalhes", sender: universitario)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! Header
        searchBar = headerView.searchBar
        searchBar.placeholder = "Search by name or major..."
        searchBar.delegate = self
        
        headerView.delegate = self
        
        btnFilter = headerView.filterBtn
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var lastInitialDisplaybleCell = false
        
        if universitarios.count > 0 && !finishedLoadingInitialTableCell {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows, let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplaybleCell = true
            }
        }
        
        if !finishedLoadingInitialTableCell {
            if lastInitialDisplaybleCell {
                finishedLoadingInitialTableCell = true
            }
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.rowHeight/2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    //SEARCH BAR
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing")
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUni = universitarios.filter({ (universitario : Universitario) -> Bool in
            return universitario.name.lowercased().contains(searchText.lowercased()) || universitario.major.lowercased().contains(searchText.lowercased())
            
        })
        
        if (filteredUni.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        
        self.universitariosTableView.reloadData()
    }

}


extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        imageView.moveAndResizeImage(for: height)
        
    }
}

extension FeedViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension FeedViewController: HeaderDelegate, FilterDelegate {
    func applyFilter(fields: [String], universities: [String]) {
        print(fields)
        print(universities)
        
        let header = universitariosTableView.headerView(forSection: 0) as! Header
        header.filterBtn.setImage(#imageLiteral(resourceName: "filterBluFill"), for: .normal)
        
        self.universitarios = universitariosBackup
        
        var filtered : [Universitario]
        
        if(fields.isEmpty && universities.isEmpty){
            header.filterBtn.setImage(#imageLiteral(resourceName: "filterBlu-1"), for: .normal)
            universitariosTableView.reloadData()
            notFound.removeFromSuperview()
            return
        }
        else if(!fields.isEmpty && universities.isEmpty){
            filtered = self.universitarios.filter {fields.contains($0.area)}
            notFound.removeFromSuperview()
        }
        else if(fields.isEmpty && !universities.isEmpty){
            filtered = self.universitarios.filter {universities.contains($0.university)}
            notFound.removeFromSuperview()
        }
        else {
            filtered = self.universitarios.filter { universities.contains($0.university) && fields.contains($0.area)}
            
        }
        
        if filtered.isEmpty {
            
            universitariosTableView.addSubview(notFound)
            
            notFound.translatesAutoresizingMaskIntoConstraints = false
            notFound.centerXAnchor.constraint(equalTo: universitariosTableView.centerXAnchor).isActive = true
            notFound.topAnchor.constraint(equalTo: universitariosTableView.topAnchor, constant: 60).isActive = true
            notFound.trailingAnchor.constraint(equalTo: universitariosTableView.trailingAnchor, constant: -20).isActive = true
            notFound.leadingAnchor.constraint(equalTo: universitariosTableView.leadingAnchor, constant: 20).isActive = true
            notFound.heightAnchor.constraint(equalToConstant: 450).isActive = true
            
            notFound.contentMode = .center
            
        }
        
        self.universitarios = filtered
        //notFound.removeFromSuperview()
        universitariosTableView.reloadData()
    }
    
    func filterTapped() {
        searchBar.endEditing(true)
        //searchActive = false
        performSegue(withIdentifier: "filter", sender: self)
    }
    
}


