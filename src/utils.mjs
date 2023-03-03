import * as readline from 'node:readline';

export function read_stdin(callback) {
    const rl = readline.createInterface({
        input: process.stdin
    });

    rl.prompt();
    rl.on('line', (line) => {
        rl.close();
        callback(line)
    });
}
