//
//  SearchViewController.swift
//  BlackScholes
//
//  Created by Vinny Lazzara on 2/25/23.
//
//FONTS:
/* family: Avenir Next
 font: AvenirNext-Regular
 font: AvenirNext-Medium
 font: AvenirNext-DemiBold
 font: AvenirNext-Bold
 font: AvenirNext-Heavy*/

import UIKit
import Combine
import MBProgressHUD

private let reuseIdentifier = "StockCell"

class SearchViewController: UITableViewController, UIAnimateable {
    
    private var SearchResults: SearchResults?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //MARK: Properties
    
    private enum Mode {
        case onboarding
        case search
    }
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a comapny name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        sc.delegate = self
        return sc
    }()
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    
    @Published private var mode: Mode = .onboarding
    
    var latestStockPriceSelection: Double?
    var latestStockSelection: SearchResult?
    
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configure()
        observeForm()
    }
    
    func configure(){
        navigationItem.searchController = searchController
        searchController.delegate = self
        tableView.register(StockCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Search"
        
    }
    
  
    
    func observeForm(){
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else {return}
                showLoadingAnimation()
                //.sink used to handle potential errors (completion) and success (value)
                apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
                    hideLoadingAnimation()
                    switch completion{
                    case .failure(let error): print(error.localizedDescription)
                    case .finished: break
                    }
                } receiveValue: { (searchResults) in
                    //self.SearchResults?.items.removeAll()
                    self.tableView.isScrollEnabled = true
                    self.SearchResults = searchResults
                //This creates the publisher, not the subscriber
                }.store(in: &self.subscribers)
                
                
                
            }.store(in: &subscribers)
        
        $mode.sink{ [unowned self] (mode) in
            switch mode{
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
                self.clearTableView()
            case .search: self.tableView.backgroundView = nil
            }
        }.store(in: &self.subscribers)
        
    }
    
    
    //MARK: TableView Source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! StockCell
        
        if let searchResults = self.SearchResults{
            let searchResult = searchResults.items[indexPath.row]
            cell.configureData(with: searchResult)
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let searchResults = self.SearchResults{
            let symbol = searchResults.items[indexPath.item].symbol
            latestStockSelection = searchResults.items[indexPath.item]
            handleSelection(for: symbol)
        }
        
    }
    
    func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator"{
            let destination = segue.destination as? CalculateViewController
            destination?.companyInfo = latestStockSelection
            destination?.stockPrice = latestStockPriceSelection ?? 0.00
        }
    }
    
    private func handleSelection(for symbol: String){
        showLoadingAnimation()
        apiService.fetchStockPrice(keywords: symbol).sink { (completionResult) in
            switch completionResult{
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { (timeSeriesDailyAdjusted) in
            self.hideLoadingAnimation()
            self.latestStockPriceSelection = timeSeriesDailyAdjusted.getIntraInfo()[0].adjustedClose
            self.performSegue(withIdentifier: "showCalculator", sender: nil)
        }.store(in: &subscribers)

        
        
        
    }
    
    

}

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.isActive {
                clearTableView()
            }
        
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {return}
        
        self.searchQuery = searchQuery
        
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        clearTableView()
        mode = .onboarding
    }

    
    func clearTableView(){
        self.SearchResults?.items.removeAll()
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = false
    }
   
}
