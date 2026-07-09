# magis-rent-watch

[magisrealestate.com/for-rent](https://magisrealestate.com/for-rent) sayfasında **yeni ilan çıkınca** Telegram kanalına bildirim atar. PC açık olmasına gerek yok — GitHub Actions'ta 5 dakikada bir çalışır.

## Başkaları nasıl kullanır?

Bir şey kurmalarına gerek yok. Sadece Telegram kanalına katılsınlar:

👉 **https://t.me/KANAL_ADIN**

## Kurulum (tek seferlik, repo sahibi)

1. **Bot oluştur:** Telegram'da [@BotFather](https://t.me/BotFather) → `/newbot` → **token**'ı al.
2. **Kanal oluştur:** yeni bir *public channel* aç (ör. `@magisrentals`), botu kanala **admin** yap.
3. **Repo secret/variable ekle** (Settings → Secrets and variables → Actions):
   - Secret: `TG_BOT_TOKEN` = BotFather token'ı
   - Variable: `TG_CHAT_ID` = `@kanaladin`
4. Actions sekmesi → **magis-watch** → **Run workflow** ile ilk çalıştır.

## Nasıl çalışır

- `watch.sh` sayfadaki müsait ilan linklerini çeker (`for-rent/<bina>/<unit>`).
- `seen.txt` (repoda tutulur) ile karşılaştırır; yeni link varsa kanala mesaj atar.
- Güncel durumu tekrar `seen.txt`'e commitler.

Bağımlılık yok — sadece `curl` + `bash`. Site JS render değil, API'ye gerek yok.

## Notlar

- GitHub cron minimumu 5 dk'dır ve yoğunlukta birkaç dk gecikebilir (garanti değil).
- Yerelde de çalışır: `TG_BOT_TOKEN=... TG_CHAT_ID=@kanal bash watch.sh`
