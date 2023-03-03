import gleam/io
import utils

pub fn main() {
  use read <- utils.read_stdin()
  io.println(read)
  main()
}
