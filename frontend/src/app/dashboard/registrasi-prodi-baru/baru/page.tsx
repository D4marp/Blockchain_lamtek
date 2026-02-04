'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import {
  Card,
  Button,
} from '@/components/ui';
import { 
  FormSection, 
  FormGrid, 
  FormActions,
  TextareaField,
  FileUploadField,
} from '@/components/ui/FormComponents';
import {
  ArrowLeft,
  Save,
  Building,
  FileText,
  GraduationCap,
} from 'lucide-react';

const schema = z.object({
  institusiId: z.string().min(1, 'Institusi wajib dipilih'),
  namaProdi: z.string().min(1, 'Nama Program Studi wajib diisi'),
  jenjang: z.string().min(1, 'Jenjang wajib dipilih'),
  jenisPT: z.string().min(1, 'Jenis PT wajib dipilih'),
  noSkPendirian: z.string().min(1, 'No. SK Pendirian wajib diisi'),
  tanggalSkPendirian: z.string().min(1, 'Tanggal SK wajib diisi'),
  alamatProdi: z.string().min(1, 'Alamat wajib diisi'),
  telepon: z.string().min(1, 'Telepon wajib diisi'),
  email: z.string().email('Email tidak valid'),
  website: z.string().optional(),
  catatan: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

const dummyInstitusi = [
  { id: '1', nama: 'Universitas Indonesia', jenisPT: 'PTN_BH' },
  { id: '2', nama: 'Institut Teknologi Bandung', jenisPT: 'PTN_BH' },
  { id: '3', nama: 'Universitas Gadjah Mada', jenisPT: 'PTN_BH' },
  { id: '4', nama: 'Universitas Negeri Jakarta', jenisPT: 'PTN' },
  { id: '5', nama: 'Universitas Swasta ABC', jenisPT: 'PTS' },
];

const jenjangOptions = [
  { value: 'D3', label: 'D3 - Diploma Tiga' },
  { value: 'D4', label: 'D4 - Diploma Empat' },
  { value: 'S1', label: 'S1 - Sarjana' },
  { value: 'S2', label: 'S2 - Magister' },
  { value: 'S3', label: 'S3 - Doktor' },
];

export default function FormRegistrasiProdiBaruPage() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedInstitusi, setSelectedInstitusi] = useState<typeof dummyInstitusi[0] | null>(null);
  const [dokumen, setDokumen] = useState({
    proposal: null as File | null,
    kurikulum: null as File | null,
    suratIzin: null as File | null,
    dokumenDosen: null as File | null,
    sarpras: null as File | null,
  });

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
  });

  const handleInstitusiChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const id = e.target.value;
    setValue('institusiId', id);
    const institusi = dummyInstitusi.find((i) => i.id === id);
    setSelectedInstitusi(institusi || null);
    if (institusi) {
      setValue('jenisPT', institusi.jenisPT);
    }
  };

  const onSubmit = async (data: FormData) => {
    setIsSubmitting(true);
    try {
      await new Promise((resolve) => setTimeout(resolve, 1500));
      toast.success('Registrasi Prodi Baru berhasil diajukan');
      router.push('/dashboard/registrasi-prodi-baru');
    } catch (error) {
      toast.error('Gagal menyimpan data');
    } finally {
      setIsSubmitting(false);
    }
  };

  const jenisPT = watch('jenisPT');

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <button
          onClick={() => router.back()}
          className="p-2 hover:bg-secondary-100 rounded-lg"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">Registrasi Prodi Baru</h1>
          <p className="text-secondary-500 mt-1">Form registrasi akreditasi Program Studi Baru</p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)}>
        {/* Info Institusi */}
        <Card className="p-6 mb-6">
          <FormSection
            title="Informasi Institusi"
            subtitle="Pilih institusi yang mengajukan akreditasi prodi baru"
            icon={Building}
          >
            <FormGrid>
              <div className="col-span-2">
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Institusi <span className="text-red-500">*</span>
                </label>
                <select
                  {...register('institusiId')}
                  onChange={handleInstitusiChange}
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">-- Pilih Institusi --</option>
                  {dummyInstitusi.map((institusi) => (
                    <option key={institusi.id} value={institusi.id}>
                      {institusi.nama} ({institusi.jenisPT.replace('_', ' ')})
                    </option>
                  ))}
                </select>
                {errors.institusiId && (
                  <p className="text-red-500 text-sm mt-1">{errors.institusiId.message}</p>
                )}
              </div>
            </FormGrid>

            {selectedInstitusi && (
              <div className={`mt-4 p-4 rounded-lg ${
                selectedInstitusi.jenisPT === 'PTN_BH' 
                  ? 'bg-purple-50 border border-purple-200' 
                  : 'bg-blue-50 border border-blue-200'
              }`}>
                <div className="flex items-center gap-3">
                  <GraduationCap className={`w-5 h-5 ${
                    selectedInstitusi.jenisPT === 'PTN_BH' ? 'text-purple-600' : 'text-blue-600'
                  }`} />
                  <div>
                    <p className={`font-medium ${
                      selectedInstitusi.jenisPT === 'PTN_BH' ? 'text-purple-900' : 'text-blue-900'
                    }`}>
                      {selectedInstitusi.jenisPT === 'PTN_BH' ? 'PTN Badan Hukum' : 
                       selectedInstitusi.jenisPT === 'PTN' ? 'PTN Non-BH' : 'PTS'}
                    </p>
                    <p className={`text-sm ${
                      selectedInstitusi.jenisPT === 'PTN_BH' ? 'text-purple-700' : 'text-blue-700'
                    }`}>
                      {selectedInstitusi.jenisPT === 'PTN_BH' 
                        ? 'Tidak perlu pembayaran biaya akreditasi. Langsung ke tahap penunjukan validator.'
                        : 'Perlu pembayaran biaya akreditasi setelah verifikasi dokumen disetujui.'}
                    </p>
                  </div>
                </div>
              </div>
            )}
          </FormSection>
        </Card>

        {/* Info Prodi */}
        <Card className="p-6 mb-6">
          <FormSection
            title="Informasi Program Studi"
            subtitle="Data program studi baru yang akan diakreditasi"
            icon={GraduationCap}
          >
            <FormGrid>
              <div className="col-span-2">
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Nama Program Studi <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('namaProdi')}
                  type="text"
                  placeholder="Contoh: Teknik Biomedis"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
                {errors.namaProdi && (
                  <p className="text-red-500 text-sm mt-1">{errors.namaProdi.message}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Jenjang <span className="text-red-500">*</span>
                </label>
                <select
                  {...register('jenjang')}
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">-- Pilih Jenjang --</option>
                  {jenjangOptions.map((opt) => (
                    <option key={opt.value} value={opt.value}>{opt.label}</option>
                  ))}
                </select>
                {errors.jenjang && (
                  <p className="text-red-500 text-sm mt-1">{errors.jenjang.message}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  No. SK Pendirian <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('noSkPendirian')}
                  type="text"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Tanggal SK Pendirian <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('tanggalSkPendirian')}
                  type="date"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Telepon <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('telepon')}
                  type="text"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div className="col-span-2">
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Alamat <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('alamatProdi')}
                  type="text"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Email <span className="text-red-500">*</span>
                </label>
                <input
                  {...register('email')}
                  type="email"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-secondary-700 mb-1">
                  Website
                </label>
                <input
                  {...register('website')}
                  type="text"
                  placeholder="https://"
                  className="w-full px-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
            </FormGrid>
          </FormSection>
        </Card>

        {/* Dokumen */}
        <Card className="p-6 mb-6">
          <FormSection
            title="Dokumen Registrasi"
            subtitle="Upload dokumen yang diperlukan untuk registrasi prodi baru"
            icon={FileText}
          >
            <div className="space-y-4">
              <FileUploadField
                label="Proposal Pembukaan Prodi"
                required
                accept=".pdf"
                value={dokumen.proposal}
                onChange={(file) => setDokumen({ ...dokumen, proposal: file })}
              />
              <FileUploadField
                label="Kurikulum"
                required
                accept=".pdf"
                value={dokumen.kurikulum}
                onChange={(file) => setDokumen({ ...dokumen, kurikulum: file })}
              />
              <FileUploadField
                label="Surat Izin Mendikbud"
                required
                accept=".pdf"
                value={dokumen.suratIzin}
                onChange={(file) => setDokumen({ ...dokumen, suratIzin: file })}
              />
              <FileUploadField
                label="Dokumen Dosen"
                required
                accept=".pdf"
                value={dokumen.dokumenDosen}
                onChange={(file) => setDokumen({ ...dokumen, dokumenDosen: file })}
              />
              <FileUploadField
                label="Dokumen Sarana dan Prasarana"
                required
                accept=".pdf"
                value={dokumen.sarpras}
                onChange={(file) => setDokumen({ ...dokumen, sarpras: file })}
              />
            </div>
          </FormSection>
        </Card>

        {/* Catatan */}
        <Card className="p-6 mb-6">
          <TextareaField
            label="Catatan"
            placeholder="Catatan tambahan..."
            value={watch('catatan') || ''}
            onChange={(val) => setValue('catatan', val)}
            rows={3}
          />
        </Card>

        {/* Actions */}
        <FormActions
          onCancel={() => router.back()}
          isSubmitting={isSubmitting}
          submitText="Ajukan Registrasi"
        />
      </form>
    </div>
  );
}
