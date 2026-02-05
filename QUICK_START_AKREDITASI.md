# 🚀 QUICK START - Akreditasi Reguler Data Injection

## ⚡ TL;DR - One Command

```bash
cd /Users/HCMPublic/Kuliah/Project/Saas_Blockchain_Lamtek

# Step 1: Get Token (one-time, valid 24 hours)
TOKEN=$(./GET_TOKEN.sh admin@lamtek.ac.id password123 | grep "Token Anda:" -A 1 | tail -1 | tr -d ' ')

# Step 2: Inject Data
./INJECT_AKREDITASI_COMPLETE.sh "$TOKEN"
```

## ✅ What Was Injected

```
Master Data:
├── Jenjang S1 ...................... ID: 1
├── Program Studi TI ................. ID: 1
└── UPPS Penjaminan Mutu ............ ID: 1

Akreditasi Reguler (3 records):
├── Tahun 2024 (SELESAI) ............ ID: 1
├── Tahun 2025 (SELESAI) ............ ID: 2
└── Tahun 2026 (SELESAI) ............ ID: 3

Workflow Stages per Record:
└── 11 stages: REGISTRASI → ... → SELESAI
```

## 📊 Verification

```bash
# Check in database
mysql -u root -p lamtek_db -e "SELECT id, tahun, tipe, status FROM akreditasi LIMIT 3;"

# Expected:
# id | tahun | tipe    | status
# 1  | 2024  | REGULER | SELESAI
# 2  | 2025  | REGULER | SELESAI
# 3  | 2026  | REGULER | SELESAI
```

## 📝 Files Reference

| File | Purpose |
|------|---------|
| `GET_TOKEN.sh` | Get JWT token |
| `INJECT_AKREDITASI_COMPLETE.sh` | Inject all data |
| `AKREDITASI_INJECTION_SUMMARY.md` | Full documentation |
| `AKREDITASI_REGULER_GUIDE.md` | Original guide |

## 🔐 Credentials

```
Email: admin@lamtek.ac.id
Password: password123
Role: PRODI
```

## 🎯 Next Steps

1. **Create Frontend Pages**
   ```
   src/app/dashboard/akreditasi/
   ```

2. **Setup Blockchain Integration**
   - Use `AkreditasiRegistry.sol`
   - Record decisions on-chain

3. **Create Notifications**
   - Email alerts on status changes
   - Activity logging

## ⏱️ Timing

- Token acquisition: ~1 second
- Data injection: ~5 seconds
- Total: **~6 seconds**

---

**Status**: ✅ Complete and Verified  
**Date**: February 5, 2026
