import UIKit
import RxSwift
import RxCocoa

class ThreadsViewController: UITableViewController {
    let disposeBag = DisposeBag()
    var selectedLabel: Label!
    var mode: ThreadsQueryMode!

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = ThreadsViewModelInputs (
            selectedLabel: selectedLabel,
            mode: mode
        )

        tableView.dataSource = nil

        let outputs = global.threadsViewModel(inputs)

        outputs.threadHeaders.bindTo(tableView.rx.items(cellIdentifier: "ThreadCell")) { index, thread, cell in
            cell.textLabel?.text = thread.subject
            cell.detailTextLabel?.text = thread.sender
        }
        .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(Thread.self)
            .asObservable()
            .subscribe(onNext: {
                self.performSegue(withIdentifier: "ShowThreadMessages", sender: $0)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let threadMessagesVC = segue.destination as! ThreadMessagesViewController
        let selectedThread = sender as! Thread
        threadMessagesVC.threadId = selectedThread.identifier
    }
}
