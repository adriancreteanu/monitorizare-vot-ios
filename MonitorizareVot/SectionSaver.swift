//
//  SectionSaver.swift
//  MonitorizareVot
//
//  Created by Andrei Nastasiu on 12/7/16.
//  Copyright © 2016 Code4Ro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import CoreData

class SectionSaver {
    
    func save(presidingOfficer: MVPresidingOfficer, completion: AnsweredQuestionSaverCompletion?) {
        connectionState { (connected) in
            if connected {
                let url = APIURLs.section.url
                if let token = KeychainWrapper.standard.string(forKey: "token") {
                    let headers = ["Content-Type": "application/json",
                                   "Authorization" :"Bearer " + token]
                    var medium = ""
                    if let selectedMedium = presidingOfficer.medium {
                        medium = selectedMedium
                    }
                    
                    var genre = ""
                    if let selectedGenre = presidingOfficer.genre {
                        genre = selectedGenre
                    }
                        
                    let params: [String : Any] = ["codJudet": presidingOfficer.judet!,
                                                   "numarSectie": presidingOfficer.sectie!,
                                                   "oraSosirii": presidingOfficer.arriveHour + ":" + presidingOfficer.arriveMinute,
                                                   "oraPlecarii": presidingOfficer.leftHour + ":" + presidingOfficer.leftMinute,
                                                   "esteZonaUrbana": medium == "urban" ? true : false,
                                                   "presedinteBesvesteFemeie": genre == "feminin" ? true : false ]
                    
                    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (response) in
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            self.localUpdateSectie(presidingOfficer: presidingOfficer, synced: true)
                            completion?(false)
                        } else if let statusCode = response.response?.statusCode, statusCode == 401 {
                            
                        } else {
                            self.localUpdateSectie(presidingOfficer: presidingOfficer, synced: false)
                            completion?(false)
                        }
                    })
                } else {
                    completion?(true)
                }
            }
        }
    }

    private func localSaveSectie(presidingOfficer: MVPresidingOfficer, synced: Bool) {
        let infoSectie = NSEntityDescription.insertNewObject(forEntityName: "PresidingOfficer", into: CoreData.context)
        infoSectie.setValue(presidingOfficer.judet, forKey: "judet")
        infoSectie.setValue(presidingOfficer.sectie, forKey: "sectie")
        infoSectie.setValue(presidingOfficer.arriveHour, forKey: "arriveHour")
        infoSectie.setValue(presidingOfficer.arriveMinute, forKey: "arriveMinute")
        infoSectie.setValue(presidingOfficer.leftHour, forKey: "leftHour")
        infoSectie.setValue(presidingOfficer.leftMinute, forKey: "leftMinute")
        infoSectie.setValue(presidingOfficer.genre, forKey: "genre")
        infoSectie.setValue(presidingOfficer.medium, forKey: "medium")
        try! CoreData.save()
    }
    
    func localUpdateSectie(presidingOfficer: MVPresidingOfficer, synced: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PresidingOfficer")
        if let judet = presidingOfficer.judet, let sectie = presidingOfficer.sectie {
            request.predicate = NSPredicate(format: "judet == %@ && sectie == %@", judet, sectie)
        }
        let results = CoreData.fetch(request)
        if results.count > 0 {
            let dbSyncer = DBSyncer()
            localSaveSectie(presidingOfficer: dbSyncer.parsePresidingOfficer(presidingOfficer: results[0]), synced: synced)
        }
    }

}
