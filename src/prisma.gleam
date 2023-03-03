import gleam/io
import gleam/string
import utils
import jsonrpc

pub fn main() {
  use read <- utils.read_stdin()

  let resp = jsonrpc.handle_rpc_request(jsonrpc.parse(read))

  io.println(string.inspect(resp))

  case resp {
    Ok(resp) -> {
      io.println(jsonrpc.to_json_string(resp))
      jsonrpc.send(resp)
    }
    Error(message) -> io.println(message)
  }

  main()
}
