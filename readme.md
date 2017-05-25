# DreamLister App

- This application leverages Core Data for local persistence.

- Add lists of items that you wish you had.

## Sample Code for auto updating the table view as data changes
```

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    tableView.beginUpdates()

}

func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    tableView.endUpdates()

}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

    switch(type) {

    case.insert:
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
        break
    case.delete:
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        break
    case.update:
        if let indexPath = indexPath {
            let cell = tableView.cellForRow(at: indexPath) as! ItemCell
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        }
        break
    case.move:
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
        break
    }

}

```

## Youtube Video
[![Video](https://img.youtube.com/vi/PWtox2cgelw/0.jpg)](https://www.youtube.com/watch?v=PWtox2cgelw)

## License

    Copyright [2017] [Eric Chu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
