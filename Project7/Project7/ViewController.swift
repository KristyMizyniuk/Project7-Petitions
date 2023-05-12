//
//  ViewController.swift
//  Project7
//
//  Created by Христина Мізинюк on 11/4/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(didTapCreditsButton))
        
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
            
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.parse(json: data)
                    return
                
                }
                
            }.resume()
            
        }
        
    }
    
    
    @objc func didTapCreditsButton() {
        let ac = UIAlertController(title: "Alert", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(submitAction)
        
    present(ac, animated: true)
}
  
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

