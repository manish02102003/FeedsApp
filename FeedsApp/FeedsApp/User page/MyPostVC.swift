import UIKit
import CoreData

class MyPostVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MyPostTVC", bundle: .main), forCellReuseIdentifier: "MyPostTVC")
        fetchPosts()
    }
    func fetchPosts() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            posts = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension MyPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostTVC", for: indexPath) as! MyPostTVC
        let post = posts[indexPath.row]
        
        cell.postName.text = post.content
        cell.dateLbl.text = DateFormatter.localizedString(from: post.date ?? Date(), dateStyle: .short, timeStyle: .short)
        cell.CretaedByLbl.text = post.createdBy
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deletePost(_:)), for: .touchUpInside)

        
        cell.updateBtn.tag = indexPath.row
        cell.updateBtn.addTarget(self, action: #selector(updatePost(_:)), for: .touchUpInside)
        
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
            tableView.deleteRows(at: [IndexPath(row: postIndex, section: 0)], with: .automatic)
            print("Post deleted successfully!")
        } catch {
            print("Error deleting post: \(error.localizedDescription)")
        }
    }

    @objc func updatePost(_ sender: UIButton) {
        let postIndex = sender.tag
        let post = posts[postIndex]
        
        let alert = UIAlertController(title: "Update Post", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = post.content
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let newContent = alert.textFields?.first?.text, !newContent.isEmpty else { return }
            self?.saveUpdatedPost(post: post, newContent: newContent)
            self?.fetchPosts() 
        }
        
        alert.addAction(updateAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }


    func saveUpdatedPost(post: Post, newContent: String) {
        post.content = newContent
        post.date = Date()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
            print("Post updated successfully!")
        } catch {
            print("Error updating post: \(error.localizedDescription)")
        }
    }
}
