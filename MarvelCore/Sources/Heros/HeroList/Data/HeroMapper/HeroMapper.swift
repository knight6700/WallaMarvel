import Dependencies

struct HeroMapper {
}

extension HeroMapper: DependencyKey {
    static var liveValue: Self {
        .init()
    }
}

extension HeroMapper: TestDependencyKey {
    static var testValue: Self {
        .init()
    }
    
    static var previewValue: Self {
        .init()
    }
}


extension DependencyValues {
    var heroMapper: HeroMapper {
    get { self[HeroMapper.self] }
    set { self[HeroMapper.self] = newValue }
  }
}
