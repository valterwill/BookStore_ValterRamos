//
//  Repository.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 09/07/21.
//

import Foundation

protocol Repository {
    func save(volume: Volume)
    func delete(withVolumeId volumeId: String)
    func getVolume(withVolumeId volumeId: String) -> Volume?
    func getVolumes() -> [Volume]
}

