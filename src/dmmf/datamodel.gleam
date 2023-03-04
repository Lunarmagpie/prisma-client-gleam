import gleam/option.{Option}

pub type Model {
  Model(
    name: String,
    db_name: Option(String),
    fields: List(Field),
    enums: List(Enum),
    primary_key: Option(Constraint),
    unique_fields: List(Constraint),
    // TODO: Check Type of unique_fields
    unique_indexes: List(Constraint),
    is_generated: Bool,
  )
}

pub type Constraint {
  Constraint(name: String, fields: List(String))
}

pub type Field {
  Field(
    name: String,
    kind: String,
    is_list: Bool,
    is_required: Bool,
    is_unique: Bool,
    is_id: Bool,
    is_read_only: Bool,
    has_default_value: Bool,
    default: Option(Default),
    type_: String,
    relation_name: String,
    relation_from_fields: List(String),
    relation_to_fields: List(String),
    is_generated: Bool,
    is_updated_at: Bool,
  )
}

pub type Default {
  Default(name: String, args: List(String))
}
// TODO Check type of args

pub type Enum {
  Enum(
    name: String,
    values: List(EnumValue),
    db_name: Option(String),
  )
}

pub type EnumValue {
  EnumValue(
    name: String,
    db_name: Option(String),
  )
}
