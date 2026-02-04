'use client';

import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import { useRouter } from 'next/navigation';
import { registrasiAkreditasiApi, institusiApi, uppsApi, prodiApi, jenjangApi, skemaPembayaranApi, bankApi } from '@/lib/api';
import {
  Card,
  CardHeader,
  Button,
  Input,
  Select,
} from '@/components/ui';
import { FormSection, FormGrid, FormActions, TextareaField, FileUploadField, SwitchField } from '@/components/ui/FormComponents';
import {
  ArrowLeft,
  Save,
  Send,
} from 'lucide-react';

const registrasiSchema = z.object({
  // Data Program Studi
  prodiId: z.string().min(1, 'Program studi wajib dipilih'),
  uppsId: z.string().min(1, 'UPPS wajib dipilih'),
  institusiId: z.string().min(1, 'Institusi wajib dipilih'),
  jenjangId: z.string().min(1, 'Jenjang wajib dipilih'),
  
  // Data Akreditasi
  tipeAkreditasi: z.string().min(1, 'Tipe akreditasi wajib dipilih'),
  peringkatSaatIni: z.string().optional(),
  noSkTerakhir: z.string().optional(),
  tanggalSkTerakhir: z.string().optional(),
  masaBerlakuSk: z.string().optional(),
  
  // Data Dokumen
  urlLed: z.string().url('URL tidak valid').optional().or(z.literal('')),
  urlLkps: z.string().url('URL tidak valid').optional().or(z.literal('')),
  
  // Data Pembayaran
  skemaPembayaranId: z.string().optional(),
  bankId: z.string().optional(),
  
  // Catatan
  catatan: z.string().optional(),
  
  // Status
  isDraft: z.boolean().default(true),
});

type RegistrasiFormData = z.infer<typeof registrasiSchema>;

// Static options for tipe akreditasi and peringkat

const tipeAkreditasiOptions = [
  { value: '', label: 'Pilih tipe akreditasi' },
  { value: 'BARU', label: 'Akreditasi Baru' },
  { value: 'PERPANJANGAN', label: 'Perpanjangan Akreditasi' },
  { value: 'REAKREDITASI', label: 'Re-Akreditasi' },
  { value: 'PENINGKATAN', label: 'Peningkatan Peringkat' },
];

const peringkatOptions = [
  { value: '', label: 'Pilih peringkat' },
  { value: 'UNGGUL', label: 'Unggul' },
  { value: 'BAIK_SEKALI', label: 'Baik Sekali' },
  { value: 'BAIK', label: 'Baik' },
  { value: 'A', label: 'A' },
  { value: 'B', label: 'B' },
  { value: 'C', label: 'C' },
  { value: 'BELUM_TERAKREDITASI', label: 'Belum Terakreditasi' },
];

export default function RegistrasiBaruPage() {
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(true);
  
  // Dynamic options from API
  const [institusiOptions, setInstitusiOptions] = useState([{ value: '', label: 'Pilih institusi' }]);
  const [uppsOptions, setUppsOptions] = useState([{ value: '', label: 'Pilih UPPS' }]);
  const [prodiOptions, setProdiOptions] = useState([{ value: '', label: 'Pilih program studi' }]);
  const [jenjangOptions, setJenjangOptions] = useState([{ value: '', label: 'Pilih jenjang' }]);
  const [skemaOptions, setSkemaOptions] = useState([{ value: '', label: 'Pilih skema pembayaran' }]);
  const [bankOptions, setBankOptions] = useState([{ value: '', label: 'Pilih bank' }]);

  // Fetch master data on mount
  useEffect(() => {
    const fetchMasterData = async () => {
      try {
        const [institusiRes, jenjangRes, skemaRes, bankRes] = await Promise.all([
          institusiApi.getAll(),
          jenjangApi.getAll(),
          skemaPembayaranApi.getActive(),
          bankApi.getAll(),
        ]);

        setInstitusiOptions([
          { value: '', label: 'Pilih institusi' },
          ...((institusiRes.data as any[]) || []).map((i: any) => ({ value: i.id.toString(), label: i.nama })),
        ]);
        setJenjangOptions([
          { value: '', label: 'Pilih jenjang' },
          ...((jenjangRes.data as any[]) || []).map((j: any) => ({ value: j.id.toString(), label: j.nama })),
        ]);
        setSkemaOptions([
          { value: '', label: 'Pilih skema pembayaran' },
          ...((skemaRes.data as any[]) || []).map((s: any) => ({ value: s.id.toString(), label: s.nama })),
        ]);
        setBankOptions([
          { value: '', label: 'Pilih bank' },
          ...((bankRes.data as any[]) || []).map((b: any) => ({ value: b.id.toString(), label: b.nama })),
        ]);
      } catch (error) {
        console.error('Failed to fetch master data:', error);
        toast.error('Gagal memuat data master');
      } finally {
        setLoading(false);
      }
    };

    fetchMasterData();
  }, []);

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<RegistrasiFormData>({
    resolver: zodResolver(registrasiSchema),
  });

  // Fetch UPPS when institusi changes
  const watchedInstitusiId = watch('institusiId');
  useEffect(() => {
    if (watchedInstitusiId) {
      uppsApi.getByInstitusi(parseInt(watchedInstitusiId)).then((res) => {
        setUppsOptions([
          { value: '', label: 'Pilih UPPS' },
          ...((res.data as any[]) || []).map((u: any) => ({ value: u.id.toString(), label: u.nama })),
        ]);
      }).catch(() => {
        setUppsOptions([{ value: '', label: 'Pilih UPPS' }]);
      });
    }
  }, [watchedInstitusiId]);

  // Fetch Prodi when UPPS changes
  const watchedUppsId = watch('uppsId');
  useEffect(() => {
    if (watchedUppsId) {
      prodiApi.getAll({ uppsId: parseInt(watchedUppsId) } as any).then((res) => {
        setProdiOptions([
          { value: '', label: 'Pilih program studi' },
          ...((res.data as any[]) || []).map((p: any) => ({ value: p.id.toString(), label: p.nama })),
        ]);
      }).catch(() => {
        setProdiOptions([{ value: '', label: 'Pilih program studi' }]);
      });
    }
  }, [watchedUppsId]);
  
  const isDraft = watch('isDraft');
  const tipeAkreditasi = watch('tipeAkreditasi');

  const onSubmit = async (data: RegistrasiFormData) => {
    try {
      const payload = {
        prodiId: parseInt(data.prodiId),
        uppsId: parseInt(data.uppsId),
        institusiId: parseInt(data.institusiId),
        jenjangId: parseInt(data.jenjangId),
        tipeAkreditasi: data.tipeAkreditasi,
        peringkatSaatIni: data.peringkatSaatIni || null,
        noSkTerakhir: data.noSkTerakhir || null,
        tanggalSkTerakhir: data.tanggalSkTerakhir || null,
        masaBerlakuSk: data.masaBerlakuSk || null,
        urlLed: data.urlLed || null,
        urlLkps: data.urlLkps || null,
        skemaPembayaranId: data.skemaPembayaranId ? parseInt(data.skemaPembayaranId) : null,
        bankId: data.bankId ? parseInt(data.bankId) : null,
        catatan: data.catatan || null,
        isDraft: data.isDraft,
      };

      await registrasiAkreditasiApi.create(payload);
      
      if (data.isDraft) {
        toast.success('Registrasi berhasil disimpan sebagai draft');
      } else {
        toast.success('Registrasi berhasil diajukan');
      }
      
      router.push('/dashboard/registrasi');
    } catch (error: any) {
      const message = error.response?.data?.message || 'Gagal menyimpan registrasi';
      toast.error(message);
    }
  };

  const handleSaveDraft = () => {
    setValue('isDraft', true);
  };

  const handleSubmitFinal = () => {
    setValue('isDraft', false);
  };

  return (
    <div className="space-y-6 max-w-4xl">
      {/* Header */}
      <div className="flex items-center gap-4">
        <button
          onClick={() => router.back()}
          className="p-2 hover:bg-secondary-100 rounded-lg"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">Registrasi Akreditasi Baru</h1>
          <p className="text-secondary-500 mt-1">Ajukan permohonan akreditasi program studi</p>
        </div>
      </div>

      {/* Progress Steps */}
      <div className="flex items-center justify-between px-4">
        {[
          { num: 1, label: 'Data Prodi' },
          { num: 2, label: 'Data Akreditasi' },
          { num: 3, label: 'Dokumen' },
          { num: 4, label: 'Pembayaran' },
        ].map((s, idx) => (
          <React.Fragment key={s.num}>
            <div className="flex flex-col items-center">
              <div
                className={`w-10 h-10 rounded-full flex items-center justify-center font-semibold ${
                  step >= s.num
                    ? 'bg-primary-600 text-white'
                    : 'bg-secondary-200 text-secondary-500'
                }`}
              >
                {s.num}
              </div>
              <span className={`text-sm mt-2 ${step >= s.num ? 'text-primary-600 font-medium' : 'text-secondary-500'}`}>
                {s.label}
              </span>
            </div>
            {idx < 3 && (
              <div className={`flex-1 h-1 mx-2 rounded ${step > s.num ? 'bg-primary-600' : 'bg-secondary-200'}`} />
            )}
          </React.Fragment>
        ))}
      </div>

      <form onSubmit={handleSubmit(onSubmit)}>
        <Card className="p-6">
          {/* Step 1: Data Prodi */}
          {step === 1 && (
            <div className="space-y-6">
              <FormSection title="Data Program Studi" subtitle="Informasi program studi yang akan diakreditasi">
                <FormGrid cols={2}>
                  <Select
                    label="Institusi"
                    options={institusiOptions}
                    error={errors.institusiId?.message}
                    {...register('institusiId')}
                  />
                  <Select
                    label="UPPS (Fakultas/Jurusan)"
                    options={uppsOptions}
                    error={errors.uppsId?.message}
                    {...register('uppsId')}
                  />
                  <Select
                    label="Program Studi"
                    options={prodiOptions}
                    error={errors.prodiId?.message}
                    {...register('prodiId')}
                  />
                  <Select
                    label="Jenjang"
                    options={jenjangOptions}
                    error={errors.jenjangId?.message}
                    {...register('jenjangId')}
                  />
                </FormGrid>
              </FormSection>

              <div className="flex justify-end">
                <Button type="button" onClick={() => setStep(2)}>
                  Selanjutnya
                </Button>
              </div>
            </div>
          )}

          {/* Step 2: Data Akreditasi */}
          {step === 2 && (
            <div className="space-y-6">
              <FormSection title="Data Akreditasi" subtitle="Informasi tipe dan status akreditasi">
                <FormGrid cols={2}>
                  <Select
                    label="Tipe Akreditasi"
                    options={tipeAkreditasiOptions}
                    error={errors.tipeAkreditasi?.message}
                    {...register('tipeAkreditasi')}
                  />
                  <Select
                    label="Peringkat Saat Ini"
                    options={peringkatOptions}
                    {...register('peringkatSaatIni')}
                  />
                </FormGrid>
              </FormSection>

              {tipeAkreditasi && tipeAkreditasi !== 'BARU' && (
                <FormSection title="Data SK Sebelumnya" subtitle="Informasi SK akreditasi terakhir">
                  <FormGrid cols={2}>
                    <Input
                      label="Nomor SK Terakhir"
                      placeholder="Contoh: 1234/SK/LAM-TEKNIK/XII/2023"
                      {...register('noSkTerakhir')}
                    />
                    <Input
                      label="Tanggal SK Terakhir"
                      type="date"
                      {...register('tanggalSkTerakhir')}
                    />
                    <Input
                      label="Masa Berlaku SK"
                      type="date"
                      {...register('masaBerlakuSk')}
                    />
                  </FormGrid>
                </FormSection>
              )}

              <div className="flex justify-between">
                <Button type="button" variant="ghost" onClick={() => setStep(1)}>
                  Sebelumnya
                </Button>
                <Button type="button" onClick={() => setStep(3)}>
                  Selanjutnya
                </Button>
              </div>
            </div>
          )}

          {/* Step 3: Dokumen */}
          {step === 3 && (
            <div className="space-y-6">
              <FormSection title="Dokumen Akreditasi" subtitle="Unggah dokumen LED dan LKPS">
                <FormGrid cols={1}>
                  <Input
                    label="URL LED (Laporan Evaluasi Diri)"
                    placeholder="https://drive.google.com/..."
                    error={errors.urlLed?.message}
                    {...register('urlLed')}
                  />
                  <Input
                    label="URL LKPS (Lembar Kinerja Program Studi)"
                    placeholder="https://drive.google.com/..."
                    error={errors.urlLkps?.message}
                    {...register('urlLkps')}
                  />
                </FormGrid>
                
                <div className="mt-4 p-4 bg-secondary-50 rounded-lg">
                  <h4 className="font-medium text-secondary-900 mb-2">Catatan:</h4>
                  <ul className="list-disc list-inside text-sm text-secondary-600 space-y-1">
                    <li>Pastikan dokumen dapat diakses publik</li>
                    <li>Format dokumen: PDF</li>
                    <li>Maksimal ukuran file: 50MB per dokumen</li>
                  </ul>
                </div>
              </FormSection>

              <FormSection title="Catatan Tambahan" subtitle="Catatan atau informasi tambahan">
                <TextareaField
                  label="Catatan"
                  placeholder="Tambahkan catatan jika diperlukan..."
                  value={watch('catatan') || ''}
                  onChange={(val) => setValue('catatan', val)}
                  rows={4}
                />
              </FormSection>

              <div className="flex justify-between">
                <Button type="button" variant="ghost" onClick={() => setStep(2)}>
                  Sebelumnya
                </Button>
                <Button type="button" onClick={() => setStep(4)}>
                  Selanjutnya
                </Button>
              </div>
            </div>
          )}

          {/* Step 4: Pembayaran */}
          {step === 4 && (
            <div className="space-y-6">
              <FormSection title="Informasi Pembayaran" subtitle="Pilih skema pembayaran akreditasi">
                <FormGrid cols={2}>
                  <Select
                    label="Skema Pembayaran"
                    options={skemaOptions}
                    {...register('skemaPembayaranId')}
                  />
                  <Select
                    label="Bank Pembayaran"
                    options={bankOptions}
                    {...register('bankId')}
                  />
                </FormGrid>

                <div className="mt-4 p-4 bg-blue-50 rounded-lg">
                  <h4 className="font-medium text-blue-900 mb-2">Estimasi Biaya:</h4>
                  <p className="text-2xl font-bold text-blue-600">Rp 15.000.000</p>
                  <p className="text-sm text-blue-700 mt-1">*Biaya dapat berubah sesuai kebijakan</p>
                </div>
              </FormSection>

              <FormSection title="Konfirmasi" subtitle="Periksa kembali data sebelum mengirim">
                <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
                  <p className="text-sm text-amber-800">
                    Dengan mengirim formulir ini, Anda menyatakan bahwa semua data yang diisi adalah benar
                    dan dapat dipertanggungjawabkan. Dokumen yang diunggah telah sesuai dengan ketentuan
                    yang berlaku.
                  </p>
                </div>
              </FormSection>

              <div className="flex justify-between">
                <Button type="button" variant="ghost" onClick={() => setStep(3)}>
                  Sebelumnya
                </Button>
                <div className="flex gap-3">
                  <Button
                    type="submit"
                    variant="outline"
                    onClick={handleSaveDraft}
                    isLoading={isSubmitting && isDraft}
                  >
                    <Save className="w-4 h-4 mr-2" />
                    Simpan Draft
                  </Button>
                  <Button
                    type="submit"
                    onClick={handleSubmitFinal}
                    isLoading={isSubmitting && !isDraft}
                  >
                    <Send className="w-4 h-4 mr-2" />
                    Ajukan Registrasi
                  </Button>
                </div>
              </div>
            </div>
          )}
        </Card>
      </form>
    </div>
  );
}
