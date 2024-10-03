

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginBtnTapped(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
            print("Email and password cannot be empty.")
            return
        }
        loginUser(email: email, password: password)
    }
    
    func loginUser(email: String, password: String) {
        if email == "admin@gmail.com" && password == "admin123" {
            let adminVC = self.storyboard?.instantiateViewController(withIdentifier: "AdminVC") as! AdminVC
            self.navigationController?.pushViewController(adminVC, animated: true)
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                self.emailTF.text = ""
                self.passwordTF.text = ""
                
                print("User logged in successfully: \(authResult?.user.uid ?? "")")
                let userPageVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPage1") as! UserPage1
                self.navigationController?.pushViewController(userPageVC, animated: true)
            }
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func registerBtnTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
