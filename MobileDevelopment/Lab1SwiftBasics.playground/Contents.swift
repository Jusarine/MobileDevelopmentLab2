//: ## Лабораторная №1. Основы Swift
import Foundation
//: 1. Дана строка: "студент1 группа1; студент2 группа2; ..."
let studentsStr = "Хаустова Екатерина 4.1; Кириллова Елена 4.1; Марков Иван 4.1; Пашков Данил 4.1; Бакуменко Олег 4.1; Кириченко Анастасия 4.1; Гусев Евгений 4.1; Белоконь Александр 4.2; Архипов Антон 4.1; Кравцов Роман 4.1; Нинидзе Давид 4.2; Кашилов Иван 4.2; Кравцов Максим 4.2; Коваленко Алексей 4.2; Бочкарёва Дария 4.2; Ульянов Михаил 4.2; Сенчукова Ангелина 4.1; Лебедев Евгений 4.1; Галайчук Виталий 4.2"
//: Сформировать массив студентов в алфавитном поряке.
//:
//: _Для разделения строки можно использовать `String.components(separatedBy: String) -> [String]`._
//:
//: _Для сортировки подойдёт стандартный метод `Sequence.sort()`._
let studentsArr: [String] = studentsStr.components(separatedBy: "; ").sorted()
//studentsArr.forEach({print($0)})

//:
//: _Перед использованием массив нужно инициализировать_
//: ```
//: if studentsGroups["1.1"] == nil {
//:     studentsGroups["1.1"] = []
//: }
//:```
var groupStudents: [String: [String]] = [:]

for studGroup in studentsArr {
    let parts: [String] = studGroup.components(separatedBy: " ")
    
    if groupStudents[parts[2]] == nil {
        groupStudents[parts[2]] = []
    }
    groupStudents[parts[2]]?.append(studGroup)
}
//print(groupStudents)
//: 2. Дан словарь баллов по лабораторным.
//:
//: _Получить доступ к последовательности ключей или значений словаря можно,
//: используя поля `Dictionary.keys` и `Dictionary.values`._
let points: [String: Int] = ["Основы Swift" : 5,
                             "Классы Swift" : 5,
                             "Делегирование" : 10,
                             "Интерфейс" : 10,
                             "Хранение данных" : 10,
                             "Core Data" : 10,
                             "Лаб 7" : 10,
                             "Лаб 8" : 15,
                             "Лаб 9" : 15,
                             "Лаб 10" : 10]

let labCount: Int = points.count
//: Сформировать словарь студент : мaссив баллов по лабораторным.
//:
//: _Баллы заполнить случайными значениями (с учетом максимальных баллов)._
//: ```
//: let randomUInt = arc4random()
//: let randomUpTo5 = arc4random_uniform(5)
//: let randomDouble = drand48()
//: ```
var studentPoints: [String: [Int]] = [:]
for student in studentsArr {
    studentPoints[student] = points.values.map{ maxPoint in Int(arc4random_uniform(UInt32(maxPoint))) }
}
//print(studentPoints)
//: 3. Посчитать суммарный балл для каждого студента.
//:
//: _Для накопления суммы можно использовать метод аггрегации данных: `reduce()`._
//: ```
//: points.values.reduce(0) { sum, point in
//:     return sum + point
//: }
//: ```
//: _Преобразование коллекций можно делать с помощью `map()` или `flatMap()`._
//: ```
//: points.map { (name, point) in
//:     return name
//: }
//: points.flatMap { (name, point) in
//:    if point == 10 {
//:        return name
//:    }
//:    return nil
//: }
//: ```
//: _Отсеивание значений удобно делать методом `filter()`._
//: ```
//: points.filter { (name,point) in
//:     return point > 5
//: }
//: ```
var sumPoints: [String: Int] = [:]

for (student, points) in studentPoints {
    sumPoints[student] = points.reduce(0, +)
}
//print(sumPoints)
//: Для каждой группы посчитать средний балл, массив студентов сдавших и не сдавших курс.
var groupAvg: [String: Float] = [:]
var passedPerGroup: [String: [String]] = [:]
var restOfStudentsPerGroup: [String: [String]] = [:]

for (group, students) in groupStudents {
    groupAvg[group] = students.map({ Float(sumPoints[$0]!) / Float(labCount) }).reduce(0, +)
}
//print(groupAvg)

let minPoint: Float = 60
for (group, students) in groupStudents {
    passedPerGroup[group] = students.filter({ Float(sumPoints[$0]!) >= minPoint })
    restOfStudentsPerGroup[group] = students.filter({ Float(sumPoints[$0]!) < minPoint })
}
//print(passedPerGroup)
//print(restOfStudentsPerGroup)

