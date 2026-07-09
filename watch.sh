#!/bin/bash
# Magis Real Estate yeni ilan izleyici.
# Sayfadaki müsait ilan linklerini seen.txt ile karşılaştırır, yeni çıkanı Telegram kanalına yollar.
# TG_BOT_TOKEN ve TG_CHAT_ID (kanal @kullaniciadi) env olarak gelir.
set -euo pipefail

URL="https://magisrealestate.com/for-rent"
DIR="$(cd "$(dirname "$0")" && pwd)"
STATE="$DIR/seen.txt"

current="$(curl -s -A "Mozilla/5.0" "$URL" \
  | grep -oE 'href="https://magisrealestate.com/for-rent/[^"]+"' \
  | sed -E 's/^href="|"$//g' | sort -u)"

# Sayfa boş/hatalı döndüyse dokunma (yanlış "hepsi silindi" sinyali verme).
if [[ -z "$current" ]]; then
  echo "Uyarı: hiç ilan linki bulunamadı, atlanıyor."
  exit 0
fi

if [[ ! -f "$STATE" ]]; then
  printf '%s\n' "$current" > "$STATE"
  echo "İlk çalıştırma, baseline kaydedildi."
  exit 0
fi

new="$(comm -13 "$STATE" <(printf '%s\n' "$current") || true)"

if [[ -n "$new" ]]; then
  # her yeni ilan için okunur link (URL decode) ile mesaj
  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    name="$(printf '%s' "$link" | sed 's#.*/for-rent/##; s/%20/ /g')"
    curl -s "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
      --data-urlencode "chat_id=${TG_CHAT_ID}" \
      --data-urlencode "text=🏠 Yeni ilan: ${name}
${link}" >/dev/null
  done <<< "$new"
  echo "Bildirim atıldı:"; printf '%s\n' "$new"
else
  echo "Yeni ilan yok."
fi

printf '%s\n' "$current" > "$STATE"
