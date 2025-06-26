#!/usr/bin/env -S deno run --allow-all

import "npm:zx@8.6.0/globals";

echo(await $`echo "Hello, world!"`)
