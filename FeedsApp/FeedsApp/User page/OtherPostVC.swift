
import UIKit
import Firebase
import CoreData

class OtherPostVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "OthersPostTVC", bundle: .main), forCellReuseIdentifier: "OthersPostTVC")
        fetchOtherPosts()
    }
    
    func fetchOtherPosts() {
        guard let user = Auth.auth().currentUser else {
            print("No user is currently logged in.")
            return
        }

        print("Current user's email: \(user.email ?? "No email")")

       
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "createdBy != %@", user.email ?? "")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            posts = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension OtherPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of posts: \(posts.count)")
        return posts.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OthersPostTVC", for: indexPath) as! OthersPostTVC
        let post = posts[indexPath.row]
        cell.PostLbl.text = post.content
        cell.dateLbl.text = DateFormatter.localizedString(from: post.date ?? Date(), dateStyle: .short, timeStyle: .short)
        cell.CreatedByLabel.text = post.createdBy
        
        return cell
    }
}
