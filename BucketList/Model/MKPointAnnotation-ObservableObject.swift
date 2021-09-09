//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Milo Wyner on 9/6/21.
//

import MapKit

extension MKPointAnnotation: ObservableObject, Identifiable {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }

        set {
            title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }

        set {
            subtitle = newValue
        }
    }
}
