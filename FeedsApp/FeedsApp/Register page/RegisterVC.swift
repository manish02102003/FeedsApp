
import UIKit
import Firebase
import FirebaseFirestore

class RegisterVC: UIViewController {

    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func RegisterBtnTapped(_ sender: UIButton) {  
        guard let username = usernameTF.text,
              let email = emailTF.text,
              let password = passwordTF.text,
              let phone = phoneNoTF.text else {return}
        registerUser(username: username, email: email, password: password, phoneNumber: phone)
        
    }
    func registerUser(username:String, email:String , password: String , phoneNumber:String){
        Auth.auth().createUser(withEmail: email, password: password){ authResult,error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let userId = authResult?.user.uid else {
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(userId).setData([
                "username":username,
                "phoneNumber":phoneNumber
            ])
            {
                error in
                if let error = error{
                    print("Error in saving user data: \(error.localizedDescription)")
                }else{
                    print("User registered and data saved")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
   
}
