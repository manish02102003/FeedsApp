
import UIKit
import Firebase
import CoreData

class UserPage1: UIViewController {

    @IBOutlet weak var enterPostTF: UITextField!

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedObjectContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    @IBAction func createPostBtnTapped(_ sender: UIButton) {
        guard let postContent = enterPostTF.text, !postContent.isEmpty else {
            print("Post content cannot be empty.")
            return
        }

        createPost(content: postContent)
    }
    
    func createPost(content: String) {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        
        let post = Post(context: managedObjectContext)
        post.createdBy = user.email ?? ""
        post.date = Date()
        post.content = content
        
        do {
            try managedObjectContext.save()
            print("Post created successfully!")
            enterPostTF.text = "" 
        } catch {
            print("Error creating post: \(error.localizedDescription)")
        }
    }

    @IBAction func viewMyPostBtnTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyPostVC") as! MyPostVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func viewOthersPostBtnTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OtherPostVC") as! OtherPostVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
