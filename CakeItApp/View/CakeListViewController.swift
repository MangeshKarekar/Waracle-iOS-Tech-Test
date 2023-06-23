//
//  CakeListViewController.swift
//  CakeItApp
//
//  Created by David McCallum on 20/01/2021.
//

import UIKit

class CakeListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var i = 0
    var cakes: [Cake] = []

    private let controller = CakeListController()
    private let refreshControl = UIRefreshControl()
    private let cakeDetailssegue = "cakeDetailssegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchCakesList()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cakeDetailssegue {
            (segue.destination as? CakeDetailViewController)?.cake = sender as? Cake
        }
    }
    
    private func setup() {
        title = "🎂CakeItApp🍰"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchCakesList), for: .valueChanged)
    }
    
    @objc private func fetchCakesList() {
        
        controller.getCakeList {[weak self] cakes in // populate the table
            self?.cakes = cakes
            self?.reloadTable()
        } onFailure: {[weak self] error in // empty the table
            self?.cakes = []
            self?.reloadTable()
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension CakeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: cakeDetailssegue, sender: cakes[indexPath.row])
    }
    
}

extension CakeListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CakeTableViewCell
        let cake = cakes[indexPath.row]
        cell.titleLabel.text = cake.title
        cell.descLabel.text = cake.desc
        
        
        
        
        let imageURL = URL(string: cake.image)!
        
        guard let imageData = try? Data(contentsOf: imageURL) else { return cell }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
            cell.cakeImageView.image = image
            }
        return cell
    }
}

