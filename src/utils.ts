export function read_stdin<T>(callback: (_: string) => T): T {
    const buf = new Uint8Array(1024);
    return Deno.stdin.read(buf).then(
        n => {
            if (n == Deno.EOF) {
                return callback("ERROR")
            } else {
                return callback(new TextDecoder().decode(buf.subarray(0, n)));
            }
        }
    );
}
