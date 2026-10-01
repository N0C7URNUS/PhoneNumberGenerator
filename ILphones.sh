#!/usr/bin/env bash

OUTPUT_FILE="israel_phone_numbers.txt"

echo "Generating Israeli phone numbers into '$OUTPUT_FILE'..."
echo "Total expected lines: 360,000,000 (~4.7 GB)"

python3 -c '
import sys

output_file = "israel_phone_numbers.txt"
chunk_size = 500000

prefixes_8 = ["+9725", "9725", "05"]
prefixes_7 = ["+9728", "9728", "08", "+9723", "9723", "03"]

with open(output_file, "w", buffering=16*1024*1024) as f:
    for prefix in prefixes_8:
        print(f"Processing pattern: {prefix}XXXXXXXX (100M numbers)...", file=sys.stderr)
        lines = []
        for i in range(100000000):
            lines.append(f"{prefix}{i:08d}\n")
            if len(lines) >= chunk_size:
                f.writelines(lines)
                lines.clear()
        if lines:
            f.writelines(lines)
            lines.clear()

    for prefix in prefixes_7:
        print(f"Processing pattern: {prefix}XXXXXXX (10M numbers)...", file=sys.stderr)
        lines = []
        for i in range(10000000):
            lines.append(f"{prefix}{i:07d}\n")
            if len(lines) >= chunk_size:
                f.writelines(lines)
                lines.clear()
        if lines:
            f.writelines(lines)
            lines.clear()

print("Generation complete!", file=sys.stderr)
'

echo "Finished. Output written to $OUTPUT_FILE"
