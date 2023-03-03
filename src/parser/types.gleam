pub type Element {
  Datasource(provider: String, url: String)
  Generator(provider: String, output: String)
  Model(fields: List(Field), block_attributes: List(Attribute))
  Enum(fields: List(String))
}

pub type Field {
  Field(name: String, type_: Type)
}

pub type Type {
  Type(type_: Type, nullable: Bool, list: Bool)
}

pub type Attribute {
  EmptyAttribute(name: String)
  ConstantAttribute(name: String, constant: String)
  FunctionAttribute(name: String, function: String)
}

pub fn to_string(e: Element) -> String {
  case e {
    Datasource(_, _) -> "Datasource"
    Generator(_, _) -> "Generator"
    Model(_, _) -> "Model"
    Enum(_) -> "Enum"
  }
}
