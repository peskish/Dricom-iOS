struct SettingsViewData {
    struct Select {
        let title: String
        let displayingValue: String
        let onTap: (() -> ())?
    }
    
    struct Switcher {
        let title: String
        let isOn: Bool
        let onValueChange: ((_ isEnabled: Bool) -> ())?
    }
    
    struct Action {
        let title: String
        let onTap: (() -> ())?
    }
    
    enum Row {
        case select(Select)
        case switcher(Switcher)
        case action(Action)
    }
    
    struct Section {
        let items: [Row]
    }
    
    let sections: [Section]
}

