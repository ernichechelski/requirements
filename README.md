



#  Requirements 🧐 [WIP]

<img src="rqms.png" alt="rqms" style="zoom:25%;" />


I cannot find anywhere simple requirements management tool for my project, so I decided to write one.

Current status 💡

1️⃣✅parsing swift source code

2️⃣✅parsing `reqfile`

3️⃣✅requiments fullfillment raport printed into standard output

4️⃣🔴distribute this tool by homebrew

5️⃣🔴generate nicely formatted raport file (HTML, Markdown)


How it works?

You need
- file named `reqfile` with listed all requirements with following format
```
[RQ:requirement_id1:requirement_short_description]
[RQ:requirement_id2:requirement_short_description2]
```
- `.swift` files with source code.

Let's assume that your app has a lot of requirements (for example. when the user don't interact with app for 3 minutes, app must force log-out).
How to not forget about them? 🧐
List them into one place, assign some id, and when you fullfill some requirement  in your app implementation, just place comment with this requirement 😄
This tool is created for automated process of checking, which requirements are fullfilled, and which aren't.

For example:

`reqfile`
```
[RQ:app_force_logout:The app must force logout user after 5 minutes]
```

And example file 
`LoginSessionManager.swift`
```swift

class LoginSessionManager {

    // [RQ:app_force_logout:force logout user]
    func checkTime(){
        if currentSessionTime > TimeInterval.minutes * 3 {
            forceLogout()
        }
    }
    
    //... Any other code which is required here 😅
}
```

Will example following output:
```
Requirements
Fullfilled requirements
Requirement(id: "app_force_logout", description: "The app must force logout user after 5 minutes")
Not fullfilled requirements
Empty
Unknown requirements
Empty
Fullfillment percentage 100.0%
Program ended with exit code: 0
```

# Requirements! 🧐

| ID             | State | Description             |
| -------------- | ----- | ----------------------- |
| app_force_logout    | ✅     | The app must force logout user after 5 minutes |

Fullfillment percentage 100.0%

Generated at 2020-04-30 11:24:47 +0000


