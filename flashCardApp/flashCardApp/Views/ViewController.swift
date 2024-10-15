//
//  ViewController.swift
//  flashCardApp
//
//  Created by karim hamed ashour on 10/7/24.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
   
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let viewModel=FetchViewModel()
    var flashCards:[Content]!
    var quizes=[[Quiz]]()
    var currentQuiz=[Quiz]()
    var categoriess:[String]=[]
    var filteredCategories:[String]=[]
    var searching=false
    var links=["https://the-trivia-api.com/v2/questions?categories=sports&limit=10","https://the-trivia-api.com/v2/questions?categories=music&limit=10","https://the-trivia-api.com/v2/questions?categories=history&limit=10","https://the-trivia-api.com/v2/questions?categories=arts_and_literature&limit=10","https://the-trivia-api.com/v2/questions?categories=general_knowledge&limit=10","https://the-trivia-api.com/v2/questions?categories=film&limit=10"]
    var addButton:UIBarButtonItem!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
       
     
        
         addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.isEnabled=false
        activityIndicator.isHidden=false
        activityIndicator.startAnimating()
        
        for link in links{
            var i = 0
            viewModel.fetchQuiz(link: link) {[weak self] quizes in
                self?.quizes.append(quizes)
                self?.categoriess.append(quizes[0].category)
                if self?.categoriess.count==self?.links.count{
                    DispatchQueue.main.async{
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden=true
                        self?.tableView.reloadData()
                        self?.navigationItem.rightBarButtonItem=self?.addButton
                        self?.addButton.isEnabled=true
                    } }
                print(self?.quizes)
            }
           i+=1
        }
        
        print(quizes)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searching=false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedQuizIndex: Int
        
        if searching {
            // Get the index of the selected category in the original categories array
            let selectedCategory = filteredCategories[indexPath.row]
            if let index = categoriess.firstIndex(of: selectedCategory) {
                selectedQuizIndex = index
            } else {
                // Handle the case where the selected category is not found in the original categories array
                return
            }
        } else {
            // Get the index of the selected category directly
            selectedQuizIndex = indexPath.row
        }
        
        currentQuiz = quizes[selectedQuizIndex]
        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "quizViewController") as! QuizViewController
        Vc.flashCards = currentQuiz
        Vc.currentIndex = selectedQuizIndex
        self.navigationController?.pushViewController(Vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategories.removeAll()
        if !searchText.isEmpty{
            filteredCategories=categoriess.filter{$0.lowercased().contains(searchText.lowercased())}
            searching = true
        }else{
            searching=false
        }
        
        tableView.reloadData()
        
    }
    private func filterTopics(_ query:String){
        
        filteredCategories.removeAll()
        
        for category in categoriess{
            if category.lowercased().contains(query.lowercased()){
                filteredCategories.append(category)
            }
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quizes.isEmpty {return 0}
        else{
            if searching{
                return filteredCategories.count
            }else{
                return categoriess.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searching{
            
            cell.textLabel?.text=filteredCategories[indexPath.row].replacingOccurrences(of: "_", with: " ")
        }else{
            let name = categoriess[indexPath.row]
            cell.textLabel?.text=name.replacingOccurrences(of: "_", with: " ")
        }
        return cell
    }
    @objc func addButtonTapped(){
        print("tapped")
        let alertController = UIAlertController(title: "Name Quiz", message: nil, preferredStyle: .alert)
        alertController.addTextField{textField in
            textField.placeholder="Enter Quiz Name"
            
        }
        let action = UIAlertAction(title: "Add", style: .default) {[weak self] _ in
            if let textField = alertController.textFields?.first , let text = textField.text{
                self?.categoriess.append(text)
                self?.quizes.append([])
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}

    
        
    
    

