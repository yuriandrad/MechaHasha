#!/usr/bin/env bash

file_exists() {
    local file_path="$1"
    [[ -f "$file_path" ]]
}

is_valid_hash() {
    local hash_value="$1"
    [[ "$hash_value" =~ ^[a-fA-F0-9]{32}$|^[a-fA-F0-9]{40}$|^[a-fA-F0-9]{64}$ ]]
}
