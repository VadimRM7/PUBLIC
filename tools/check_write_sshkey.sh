#!/bin/bash

ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCt/eZQbgjovlyiMVBmvSMFmjYb/pgQMVcs8AeYiI3lZ3grL5dnvflrJZM8vbJb2IvQoMu9pg1t5s6MU+sl5cIt7LzFfHoMUnOHKDMxqks/WBP/CDCCEkC4iPnG6vPejZninpzhEETN2rSjGRKq9fDQ1qBvHsy+sHWfGsPkjdCpn8UpoMLfWAJBKU+VkHCE4Jg3GtZBpPjcvaooVSXyfP2o9x7bijuRN65HkV0g6W0yv7iiOOX7nTQRkLVdnOhcEG4+AbY+8fOjc3MxEuoNsktV88lNcgTFjDGOvEjPo7UmPe8rfCWjpeAUCTVete1ATNR7dnDDt/l8ReAIJ9Xd/0e380YT3W/Cxw/cSo8z9d3hATJON6HyjvcQ7o6iudggPxNBM/mP4Npxng7ttQzPfHEQP6Z8wEpc1NRstQh1ctr6s+cX7sbkKBr6D6TF+qiPdNYIiJCvN+XHEkwA4qq07Z5wkErHRnPly0SACba0MpJkWC4KDQiesd4gy7jakBxaf7IoY5qIV4M9uGDrfmG9TYnjW4FIDQHYM4ntJJcdX+J9xtI0AvPskF+QsoxJELNEPWsdkL+jxnQ0Zam6ulk1OJLURVotDQkd7RxjXG2NbsWvJaCXQm1dtAalLbAP2WgX9sR4BkrLbtCfqb9M/2eb58Jx7OzoyKoeZ8xQS9/YbimZQ== VadimRom"

authorized_keys_file="$HOME/.ssh/authorized_keys"

if grep -q "$ssh_key" "$authorized_keys_file"; then
    echo "Ключ уже есть"
else
    echo "$ssh_key" >> "$authorized_keys_file"
    echo "Ключ успешно записан"
    systemctl restart sshd
fi
