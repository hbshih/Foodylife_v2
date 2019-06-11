//
//  messageGenerator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct messageGenerator {
    
    var messageList : [String] = []
    var Max: Double?
    var Min: Double?
    var nList: [Double] = []
    let locale = NSLocale.current.languageCode
    
    func setGreetingMessages() -> String
    {
        var Greetings: [String] = []
        
        if (locale == "zh")
        {
            Greetings = ["嗨","您好","吃飯了嗎","最近還好嗎？","早安","汪汪"]
        }
            else if (locale == "zh-Hans")
             {
             Greetings = ["嗨","您好","吃饭了吗","最近还好吗？","早安","汪汪"]
             }
 
        else
        {
            Greetings = ["Hi", "Nice to see you again", "Hey man", "Hey", "How's it going?", "What's up?","What's going on?","How's everything","How are things?","How's life","How's your day?", "Good to see you","Yo!","Are you OK","Howdy!","WHAZZUP!","Good day mate","Hiya!"]
        }
        
        let diceRoll:Int = Int(arc4random_uniform(UInt32(Greetings.count - 1)))
        return Greetings[diceRoll]
    }
    
    var momo: [String] = []
    var Databasecalled = false
    
    func setInformationMessages() -> [String] // Three type of message
    {
        var Least = ""
        
        switch Min
        {
        case nList[0]?:
            Least = "vegetable".localized()
        case nList[1]?:
            Least = "protein".localized()
        case nList[2]?:
            Least = "grain".localized()
        case nList[3]?:
            Least = "fruit".localized()
        case nList[4]?:
            Least = "dairy".localized()
        default:
            Least = ""
        }
        
        var lackMessage: [String] = []
        if Min! < 5.0
        {
            if (locale == "zh")
            {
                lackMessage =
                    [
                        "建議你多吃一點 \(Least)",
                        "每天要多吃點\(Least)",
                        "讓你飲食更均衡的方法是吃多一點\(Least)",
                        "在你的盤子裡面多增加一點 \(Least)！",
                ]
            }else if (locale == "zh-Hans")
            {
                lackMessage =
                    [
                        "建议你多吃一点 \(Least)",
                        "每天要多吃点\(Least)",
                        "让你饮食更均衡的方法是吃多一点\(Least)",
                        "在你的盘子里面多增加一点 \(Least)！",
                ]
            }else
            {
                lackMessage =
                    [
                        "Consider to eat more \(Least)",
                        "Try to eat more \(Least), your score is low",
                        "One way to improve your balance is eat more \(Least)",
                        "Add more \(Least) to your plate!",
                ]
            }
        }else
        {
            if (locale == "zh")
            {
                lackMessage =
                    [
                        "你最近的飲食狀況不錯喔",
                        "每個人都有自己的飲食習慣，重點是吃之前想想會不會造成你身體的負擔",
                        "記得要多做運動！一週大約兩三小時 :-)"
                ]
            }
            else if (locale == "zh-Hans")
            {
                lackMessage =
                    [
                        "你最近的饮食状况不错喔",
                        "每个人都有自己的饮食习惯，重点是吃之前想想会不会造成你身体的负担",
                        "记得要多做运动！一周大约两三小时 :-)"
                ]
            }
                
            else
            {
                lackMessage =
                    [
                        "You are doing a great job balancing your diet",
                        "There is more than one way to eat healthfully and everyone has their own eating style.",
                        "Be physically active at least 2 1/2 hours per week."
                ]
            }
        }
        
        
        var message : [String] = []
        let diceRoll:Int = Int(arc4random_uniform(UInt32(lackMessage.count - 1)))
        message = [lackMessage[diceRoll]]
        return message
    }
    
    func healthQuotes() -> [String]
    {
        var healthQuote : [String] = []
        if (locale == "zh")
        {
            healthQuote = ["均衡飲食是維持健康的要素",
                           "以穀物類為主，並多吃蔬菜及水果，進食適量的肉、魚、蛋和奶類及其代替品，減少鹽、油、糖分",
                           "不同食物有不同的營養價值，因此身體不能從單一食物中得到全部所需營養素",
                           "進食太多或太少都不利於身體健康，我們的身體每天需要一定分量的營養素來維持最佳狀態",
                           "少吃高脂肪、高膽固醇的食品",
                           "飲食定時和定量，每日三餐不可少。",
            ]
        }
        else if (locale == "zh-Hans")
        {
            healthQuote = ["均衡饮食是维持健康的要素",
                           "以谷物类为主，并多吃蔬菜及水果，进食适量的肉、鱼、蛋和奶类及其代替品，减少盐、油、糖分",
                           "不同食物有不同的营养价值，因此身体不能从单一食物中得到全部所需营养素",
                           "进食太多或太少都不利于身体健康，我们的身体每天需要一定分量的营养素来维持最佳状态",
                           "少吃高脂肪、高胆固醇的食品",
                           "饮食定时和定量，每日三餐不可少。",
            ]
        }
        else
        {
            healthQuote = ["Balance your diet prevents you from getting diseases and infections",
                           "Everything You Eat and Drink Matters — Focus on Variety, Amount, and Nutrition",
                           "Choose Foods and Beverages with Less Saturated Fat, Sodium, and Added Sugars",
                           "A balanced diet may be the best medicine",
                           "A balanced diet, adequate exercise, and common sense keep the doctor away",
                           "When diet is wrong, medicine is of no use.",
                           "Keep calm and eat well",
                           "Focus on whole fruits. Whole fruits include fresh, frozen, dried, and canned options. Choose whole fruits more often than 100% fruit juice.",
                           "Vary your veggies. Vegetables are divided into five subgroups and include dark-green vegetables, red and orange vegetables, legumes (beans and peas), starchy vegetables, and other vegetables.",
                           "Make half your grains whole grains. Grains include whole grains and refined, enriched grains. Choose whole grains more often.",
                           "Vary your protein routine. Protein foods include both animal and plant sources. Choose a variety of lean protein foods from both plant and animal sources.",
                           "Move to low-fat or fat-free milk or yogurt. Dairy includes milk, yogurt, cheese, and calcium-fortified soy beverages (soymilk)."
            ]
        }
        let diceRoll:Int = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        var diceRoll2:Int = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        
        if diceRoll == diceRoll2
        {
            diceRoll2 = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        }
        
        return [healthQuote[diceRoll2],healthQuote[diceRoll]]
        
    }
    
    func setAnnoyingMessages() -> [String] // Start annoying
    {
        let noMore_Message =
            [
                "Come back tomorrow, maybe I will give you more advices",
                "I am running out of ideas, come back tomorrow"
        ]
        let opening_Message =
            ["I think you are just enjoying poking my face",
             "I have given you enough advices",
             "Are you enjoying this?",
             "Stop before I get angry :-)",
             "Could you stop?",
             "Poking me is quite fun ah?",
             "Do you know you are poking at MY FACE?"
        ]
        let moderate_Message =
            ["Tapping it does abosolutely nothing except irritate me",
             "I know I conditioned you to tap my face in my counterpart apps, but I'm really serious: it doesn't do anything now"]
        let more_Message =
            [
                ["You can do a lot more things with this app","Look at your diary for example","Try checking your all-time report?"],
                ["If you are bored alone at home","You can do something interesting","Send post card to your friends?","Do a puzzle?","Plant a herb?"]
        ]
        let angry_Message =
            [
                ["Stop","Stop","Stop","Stop","Stop","I am not gonna talk ANYMORE"],
                ["Stop","S","T","O","P","ARHHHHHHH","If you don't stop","then I WILL STOP!!"],
                ["Okay Stop, that's my face","It's not funny","Stop","HEY!!!!","You made me do this"],
                ["I will poke your face when you go sleeping","Stop","I will revenge","Stop"],
                ["No more pocking","Stop it","That my face, you know?","Okay, Stop"],
                ["Alright, time for bed","No more pocking","Bye"],
                ]
        
        var message : [String] = []
        var diceRoll:Int = Int(arc4random_uniform(UInt32(noMore_Message.count - 1)))
        message.append(noMore_Message[diceRoll])
        diceRoll = Int(arc4random_uniform(UInt32(opening_Message.count - 1)))
        message.append(opening_Message[diceRoll])
        diceRoll = Int(arc4random_uniform(UInt32(moderate_Message.count - 1)))
        message.append(moderate_Message[diceRoll])
        diceRoll = Int(arc4random_uniform(UInt32(more_Message.count - 1)))
        for i in more_Message[diceRoll]
        {
            message.append(i)
        }
        diceRoll = Int(arc4random_uniform(UInt32(angry_Message.count - 1)))
        for i in angry_Message[diceRoll]
        {
            message.append(i)
        }
        
        let zh_message =
            [
                "你是不是覺得戳我的臉很好玩",
                "不要再戳了喔^^",
                "不",
                "要",
                "戳",
                "我的臉！！！！",
                "嗯",
                "嗯",
                "不講話就是不講話",
                "恩恩恩恩恩恩",
                "很喜歡戳我嗎？",
                "但工程師已經想不到可以讓我講什麼了",
                "工程師在崩潰中",
                "我也要崩潰了"
        ]
        let zhHans_message =
            [
                "你是不是觉得戳我的脸很好玩",
                "不要再戳了喔^^",
                "不",
                "要",
                "戳",
                "我的脸！！！！",
                "嗯",
                "嗯",
                "不讲话就是不讲话",
                "恩恩恩恩恩恩",
                "很喜欢戳我吗？",
                "但工程师已经想不到可以让我讲什么了",
                "工程师在崩溃中",
                "我也要崩溃了"
        ]
        if (locale == "zh")
        {
            return zh_message
        }
        else if (locale == "zh-Hans")
        {
            return zhHans_message
        }
        else
        {
            return message
        }
    }
    
    init(nList: [Double], count: Int)
    {
        messageList.removeAll()
        self.nList = nList
        //[vegetablePercentage,proteinPercentage,grainPercentage,fruitPercentage,dairyPercentage]
        Max = nList.max()
        Min = nList.min()
        messageList.append(setGreetingMessages())
        if count > 2
        {
            messageList += setInformationMessages()
        }
        messageList += healthQuotes()
        messageList += setAnnoyingMessages()
    }
    
    func getMessage() -> [String]
    {
        return messageList
    }
    
    
}
