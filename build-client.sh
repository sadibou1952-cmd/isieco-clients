#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE="${ROOT_DIR}/.render-source/client-source.tar.xz"

if [[ ! -d "${ROOT_DIR}/.render-source" ]]; then
  echo "Source archive is missing: .render-source/" >&2
  exit 1
fi

cat "${ROOT_DIR}"/.render-source/part-* | base64 --decode > "${ARCHIVE}"
tar -tJf "${ARCHIVE}" >/dev/null
tar -xJf "${ARCHIVE}" -C "${ROOT_DIR}"

cd "${ROOT_DIR}/client"
npm install --include=dev --no-audit --no-fund
npm run build
