
import UIKit
import CoreData

class AdminVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var posts: [Post] = [] 

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "adminTVC", bundle: .main), forCellReuseIdentifier: "adminTVC")
        
        // Fetch all posts
        fetchPosts()
    }
    
    func fetchPosts() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            posts = try context.fetch(fetchRequest)
            tableview.reloadData()
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AdminVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminTVC", for: indexPath) as! adminTVC
        let post = posts[indexPath.row]
        
        
        cell.postLbl.text = post.content
        cell.dateLbl.text = DateFormatter.localizedString(from: post.date ?? Date(), dateStyle: .short, timeStyle: .short)
        cell.CreatedbyLbl.text = post.createdBy
        
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deletePost(_:)), for: .touchUpInside)
        
        return cell
    }

    @objc func deletePost(_ sender: UIButton) {
        let postIndex = sender.tag
        let postToDelete = posts[postIndex]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(postToDelete)
        
        do {
            try context.save()
            posts.remove(at: postIndex)
            tableview.deleteRows(at: [IndexPath(row: postIndex, section: 0)], with: .automatic)
            print("Post deleted successfully!")
        } catch {
            print("Error deleting post: \(error.localizedDescription)")
        }
    }
}
