export function read_stdin<T>(callback: (_: string) => T): T {
    const buf = new Uint8Array(1024);
    return Deno.stdin.read(buf).then(
        next_line => {
            if (next_line == Deno.EOF) {
                return callback("")
            } else {
                return callback(new TextDecoder().decode(buf.subarray(0, next_line)));
            }
        }
    );
}
