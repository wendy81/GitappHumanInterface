import UIKit

public class Errors:UIViewController {
    func hostNameisNil(_ hostName: String?) {
        if (hostName == nil) {
            let alert = UIAlertController(title: "Host Name", message: "No host, please give a host name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
