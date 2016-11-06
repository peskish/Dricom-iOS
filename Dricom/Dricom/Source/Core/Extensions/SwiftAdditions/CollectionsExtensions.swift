import Foundation

public func stripNils<T>(_ elements: [T?]) -> [T] {
    var filtered = [T]()
    for element in elements {
        if element != nil {
            filtered.append(element!)
        }
    }
    return filtered
}

public func stripNils<T>(_ elements: T?...) -> [T] {
    var filtered = [T]()
    for element in elements {
        if element != nil {
            filtered.append(element!)
        }
    }
    return filtered
}

// TODO: make generic version
public func joinStrippingNils(_ separator: String, elements: [String?]) -> String? {
    return stripNils(elements).joined(separator: separator)
}

public func joinStrippingNils(_ separator: String, elements: String?...) -> String? {
    return stripNils(elements).joined(separator: separator)
}

public func isEmptyOrNil(_ string: String?) -> Bool {
    return string.map { $0.isEmpty } ?? true
}

public func isEmptyOrNil<C : Collection>(_ collection: C?) -> Bool {
    return collection.map { $0.isEmpty } ?? true
}

public func isEmptyOrNil(_ array: NSArray?) -> Bool {
    return (array?.count ?? 0) == 0
}

public extension Optional where Wrapped: Collection {
    func isEmptyOrNil() -> Bool {
        if let wrapped = self {
            return wrapped.isEmpty
        } else {
            return true
        }
    }
}

public extension NSAttributedString {
    var isEmpty: Bool {
        return length == 0
    }
}

public extension Collection {
    // Returns element at index or nil if index is out of range
    func elementAtIndex(_ index: Index) -> Generator.Element? {
        let intIndex = distance(from: startIndex, to: index)

        if intIndex >= 0 && intIndex < count {
            return self[index]
        } else {
            return nil
        }
    }
}


public extension Collection {
    func first(_ match: (Self.Iterator.Element) throws -> Bool)
        -> Self.Iterator.Element?
    {
        for element in self {
            let matches = try? match(element)
            
            if matches == true {
                return element
            }
        }
        
        return nil
    }
    
    func last(_ match: (Self.Iterator.Element) throws -> Bool)
        -> Self.Iterator.Element?
    {
        for element in self.reversed() {
            let matches = try? match(element)
            
            if matches == true {
                return element
            }
        }
        
        return nil
    }
    
    func firstNonNil<T>(_ transform: (Self.Iterator.Element) throws -> T?) -> T? {
        for element in self {
            if let transformed = try? transform(element) {
                return transformed
            }
        }
        
        return nil
    }
    
    func lastNonNil<T>(_ transform: (Self.Iterator.Element) throws -> T?) -> T? {
        for element in self.reversed() {
            if let transformed = try? transform(element) {
                return transformed
            }
        }
        
        return nil
    }
}

public extension Array {
    mutating func removeFirst(_ match: (Element) throws -> Bool)
        -> Element?
    {
        for (index, element) in self.enumerated() {
            let matches = try? match(element)
            
            if matches == true {
                return remove(at: index)
            }
        }
        
        return nil
    }
    
    mutating func removeLast(_ match: (Element) throws -> Bool)
        -> Element?
    {
        for (index, element) in self.reversed().enumerated() {
            let matches = try? match(element)
            
            if matches == true {
                return remove(at: count - index - 1)
            }
        }
        
        return nil
    }
}

public extension Array {
    func subarray(_ range: Range<Int>) -> Array? {
        if range.lowerBound  >= 0 && range.upperBound < count {
            return Array(self[range])
        } else {
            return nil
        }
    }
}

// Zips 2 arrays, pads arrays if they aren't of same length
public func zip<T>(_ a: [T], _ b: [T], pad: T) -> Zip2Sequence<[T], [T]> {
    var newA = a
    var newB = b
    
    while newA.count < newB.count {
        newA.append(pad)
    }
    while newA.count > newB.count {
        newB.append(pad)
    }
    
    return Swift.zip(newA, newB)
}

public func zipIfCountEquals<T, U>(_ a: [T], _ b: [U]) -> Zip2Sequence<[T], [U]>? {
    if a.count == b.count {
        return Swift.zip(a, b)
    } else {
        return nil
    }
}
