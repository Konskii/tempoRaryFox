//
//  JudgeForExample.swift
//  Fox19
//
//  Created by Калинин Артем Валериевич on 14.10.2020.
//

import UIKit

//Test Stuct
struct JudgeForExample {
    
    var judgePhoto: UIImage
    var judgeName: String
    var properties: String
    
}

func setJudges() -> [JudgeForExample] {
    let judgeImage = UIImage(named: "judge")

    let judge = JudgeForExample(judgePhoto: judgeImage!, judgeName: "Mabel Hansen", properties: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
    let judge1 = JudgeForExample(judgePhoto: judgeImage!, judgeName: "Jhon Hansen", properties: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
    
    return [judge, judge1, judge, judge, judge, judge, judge, judge, judge]
}
