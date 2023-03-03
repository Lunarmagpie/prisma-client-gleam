import gleam/io
import gleam/dynamic as d
import gleam/json
import gleam/result
import gleam/string

pub fn jsonrpc_version() -> String {
  "2.0"
}

pub type Request {
  Request(jsonrpc: String, id: Int, method: String, params: d.Dynamic)
}

pub type Response {
  /// The request from the prisma server to generate..
  GenerateResponse(id: Int)
  /// Reply to the prisma server with manifest info.
  ManifestResponse(
    id: Int,
    name: String,
    default_output: String,
    requires_engines: List(String),
  )
  /// The request from the prisma was not handled successfully.
  ErrorResponse(id: Int, code: Int, message: String)
}

pub fn to_json_string(resp: Response) -> String {
  case resp {
    GenerateResponse(id) -> [#("id", json.int(id))]
    ManifestResponse(id, name, default_output, requires_engines) -> [
      #("id", json.int(id)),
      #("jsonrpc", json.string(jsonrpc_version())),
      #(
        "result",
        json.object([
          #(
            "manifest",
            json.object([
              #("prettyName", json.string(name)),
              #("defaultOutput", json.string(default_output)),
              #("denylist", json.null()),
              #(
                "requiresEngines",
                json.array(requires_engines, of: json.string),
              ),
            ]),
          ),
        ]),
      ),
    ]
    ErrorResponse(id, code, message) -> [
      #("id", json.int(id)),
      #("code", json.int(code)),
      #("message", json.string(message)),
    ]
  }
  |> json.object
  |> json.to_string
}

pub type ResponseError {
  ResponseError(reason: String)
}

pub fn parse(json_string: String) -> Result(Request, ResponseError) {
  io.println(json_string)
  let response_decoder =
    d.decode4(
      Request,
      d.field("jsonrpc", of: d.string),
      d.field("id", of: d.int),
      d.field("method", of: d.string),
      d.field("params", of: d.dynamic),
    )

  result.map_error(
    json.decode(from: json_string, using: response_decoder),
    fn(err: json.DecodeError) {
      ResponseError(
        "payload could not be decoded: " <> json_string <> ". Unexpected error: " <> string.inspect(
          err,
        ),
      )
    },
  )
}

fn get_manifest(id: Int) -> Response {
  ManifestResponse(
    id: id,
    name: "Prisma Client Gleam (v development)",
    default_output: ".",
    requires_engines: ["queryEngine"],
  )
}

/// Convert a request to a Response object to be sent to prisma
pub fn handle_rpc_request(
  request: Result(Request, ResponseError),
) -> Result(Response, String) {
  case request {
    Ok(value) ->
      case value.method {
        "getManifest" -> get_manifest(value.id)
        "generate" -> GenerateResponse(id: value.id)
        _ ->
          ErrorResponse(id: value.id, code: -32_000, message: "Unknown command")
      }
      |> Ok

    Error(error) ->
      "Recieved an invalid payload. I can't do anything about that :(\n" <> string.inspect(
        error,
      )
      |> Error
  }
}

pub fn send(resp: Response) -> Nil {
  resp
  |> to_json_string
  // Prisma reads stderr for IPC
  |> io.println_error
}
