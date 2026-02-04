# Login Credentials - LAM Teknik SaaS Blockchain

## Test Account (Berhasil Register & Login)
- **Email**: test@test.com
- **Password**: test123
- **Role**: USER

## Admin Account (Dari Database Seed)
- **Email**: admin@lamtek.ac.id  
- **Password**: password123 *(belum ditest, hash perlu diverifikasi)*
- **Role**: ADMIN

## API Endpoints Working
- ✅ POST `/api/v1/auth/register` - Register user baru
- ✅ POST `/api/v1/auth/login` - Login dan dapatkan JWT token
- ✅ GET `/api/v1/auth/me` - Get user profile (dengan JWT token)
- ✅ POST `/api/v1/auth/profile` - Update user profile

## How to Test Login from Frontend

1. Start frontend development server:
```bash
cd frontend
npm run dev
```

2. Open http://localhost:3002
3. Login dengan email: test@test.com dan password: test123
4. Atau register user baru dari halaman register

## Backend API Info
- **Base URL**: http://localhost:3001
- **API Prefix**: /api/v1
- **Swagger Docs**: http://localhost:3001/api/docs

## Database Tables Created
- ✅ users (id, name, email, password, role, tenantId, noIdentitas, noSertifikatEdukatif, isActive, createdAt, updatedAt)
- ✅ tenants
- ✅ blockchain_transactions  
- ✅ ipfs_documents
- ✅ audit_logs

## Problems Fixed
1. ❌ Missing users table → ✅ Created via SQL migration
2. ❌ Bcrypt not installed → ✅ Added to package.json and rebuilt
3. ❌ Auth routes not loading → ✅ Fixed by full container rebuild
4. ❌ Wrong API port (3002 vs 3000) → ✅ Added PORT=3000 env var
5. ❌ TypeORM seed error → ✅ Fixed getDataSource → DataSource import

## Next Steps
- Update admin password hash in database for admin@lamtek.ac.id account
- Test frontend login integration
- Implement protected routes with JWT verification
