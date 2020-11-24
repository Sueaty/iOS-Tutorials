<img width = 250, src = "https://user-images.githubusercontent.com/34840140/100117150-dad1af80-2eb7-11eb-8824-d5204f1c470f.gif">

## Use of UIResponder's Keyboard notifications
### When contentTextView is selected
  * keyboard appears
  * view's y position changes
  * constant value of bottom constraint changes

```swift
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        if contentTextView.isFirstResponder {
            view.frame.origin.y = -titleTextField.frame.minY + 50
            bottomConstraint.constant = keyboardHeight - (titleTextField.frame.height + navigationController!.navigationBar.frame.height) + 10
        }
    }
```

### When non-TextView is touched
  * keyboard disappears
  * view returns to its original position
  * constant value of bottom constraint returns to its original value
  
```swift
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
        bottomConstraint.constant = 100
    }
```
