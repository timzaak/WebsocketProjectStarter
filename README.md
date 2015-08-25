### Websocket Project Starter

This is not a framework, it just a demo about how to manage websocket in a swift project.

It uses `prmoise/future` to wrap `websocket`, and offer auto-connect. You need to read `WebsocketWrapper.swift`, because it
dose not offer any `protocol`. 

First of all, the message protocol we must know.


```json

//send:
{
    p0:$param0,
    p1:$param1,
    p2:$param3,
//  ....       
    pn:$paramn
    m:$mark
}

```

`p0...pn` you kan defined anything, but I did recommand the `p0` would be a string to tell ios what the message is.
`m` is what front end defined that the back end need send back with responses.



```json

//ios receive:
{
    h:{
        p0:$param0,
        p1:$param1,
        p2:$param3,
    //  ....       
        pn:$paramn
        m:$mark
    },
    r:{
        r:$result
        e:$error
    }
}

```

the data in `h` is what IOS has sended, and the data in `r` is the response, it could be right in `r.r` or wrong in `r.e`

```json

//back end  auto push
{
    e:$actionString
    r:$Message
}

```

`e` has a string value, tells ios what it is. and `r` is the message ios need to analyze and manage. 


###HOW TO RUN

This demo uses `pod` to manage 3rd dependencies, so run `pod install` firstly.


####PS:

It uses `GDC` to manage messages, and when you need to refresh UI, you would write

```swift

dispatch_async(dispatch_get_main_queque,{[weak self] Void in
    //TODO:...
})

```

please use `[weak self]` in the block, because you don`t know when the message would come.


  


