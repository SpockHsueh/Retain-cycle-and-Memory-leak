# Proved the Retain-cycle caused to Memory-leak in Closure and Delegate
***

# Part1. Closure
>### To prove that using a closure will result in retain cycle, I created a simple model: a ViewController (VC1), and a custom DetailViewController class (VC2) will pass the information to the VC1 through the closure, and switch to another ViewController (VC3)

>### Also I want to confirm if the DetailViewController will disappear in the memory, because if it does not disappear, it means that **VC1 and VC2 are strongly connected to each other, causing the memory leak**.

### To figure out the location of the variable in memory:
```javascript
    var completionHandler: ((_ data: String) -> Void)? {
        didSet {
            print(self.completionHandler)
        }
    } 
```
### If the DetailViewController disappear in the memory will print the string:
```javascript
    deinit {
        print("----------------------")
        print("VC2 is bring removed from memory")
    }
```
### pass the data to the VC1 through the closure:
```javascript
    func requestData() {
        let data = "Data from VC2"
        completionHandler?(data)
    }
```

>### In VC1 I only need to do is use this closure and use the rootviewController to switch screens.


### To Use the closure I just create, need to instance the DetailViewController :
```javascript
	var detailVC: DetailViewController? = 
		DetailViewController()

```
### Just print the data when we got it:
```javascript
	detailVC?.completionHandler = { (data) in
            print("detailVC: \(self.detailVC!)")
            print(data)
        }
```

### Change the RootView to VC3:
```javascript
 	let storyboard = UIStoryboard(name: "Main", bundle: nil)
 	let viewController = storyboard.instantiateViewController(withIdentifier: "VC3")
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.window?.rootViewController = viewController
```


>### Although the data from the DataModel can be obtained normally, the VC2 has not disappeared and remains in the memory. It can be seen from the tool that Memory Leak has been caused.

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-02%20%E4%B8%8B%E5%8D%888.54.38.png)

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-02%20%E4%B8%8B%E5%8D%888.54.54.png)

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-02%20%E4%B8%8B%E5%8D%889.00.22.png)

>### The solution is to add [weak self] in VC1:

```javascript
   detailVC?.completionHandler = { [weak self] (data) in
            print("detailVC: \(self.detailVC!)")
            print(data)
        }
```
>### Now if we use tool again, the memory leak error will gone, everything is good:

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-02%20%E4%B8%8B%E5%8D%889.05.01.png)
***

# Part2. Delegate
>### To use the delegate, first define the protocol, then obey the method inside the protocol, and pass the data to VC1.

### Define the protocol:
```javascript
	protocol DataModelDelegate: class {
    	func didPassData(data: String)
}

    weak var delegate: DataModelDelegate? {
       didSet {
            print("Ya")
            print(self.delegate)
        }
    }
```
### Use protocol pass data to VC1:
```javascript
    let data = "Data from VC2"
       delegate?.didPassData(data: data)
```

>### Similarly, we observe whether vc2 disappears into the memory:

```javascript
   deinit {
        print("----------------------")
        print("VC2 is bring removed from memory")
    }
```

>### Unfortunately the VC2 also has not disappeared and remains in the memory. It can be seen from the tool that Memory Leak has been caused:

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-03%20%E4%B8%8A%E5%8D%8812.36.14.png)

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-03%20%E4%B8%8A%E5%8D%8812.36.20.png)

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-03%20%E4%B8%8A%E5%8D%8812.37.47.png)

>### The solution is to add weak keyword in VC2:
```javascript
   weak var delegate: DataModelDelegate? {
        didSet {
            print("Ya")
            print(self.delegate)
        }
    }
```

>### Now if we use tool again, the memory leak error will gone, everything is good:

![image](https://github.com/SpockHsueh/Retain-cycle-and-Memory-leak/blob/master/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202018-09-03%20%E4%B8%8A%E5%8D%8812.43.55.png)
