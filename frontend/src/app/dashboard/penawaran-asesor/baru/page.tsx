'use client';

import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import { useRouter } from 'next/navigation';
import {
  Card,
  Button,
  Input,
  Select,
} from '@/components/ui';
import { FormSection, FormGrid, FormActions, TextareaField } from '@/components/ui/FormComponents';
import {
  ArrowLeft,
  Send,
} from 'lucide-react';

const penawaranSchema = z.object({
  akreditasiId: z.string().min(1, 'Akreditasi wajib dipilih'),
  asesorId: z.string().min(1, 'Asesor wajib dipilih'),
  tanggalBatasRespon: z.string().min(1, 'Batas respon wajib diisi'),
  catatanPenawaran: z.string().optional(),
});

type PenawaranFormData = z.infer<typeof penawaranSchema>;

const akreditasiOptions = [
  { value: '', label: 'Pilih akreditasi' },
  { value: '1', label: 'REG-2024-001 - Teknik Kimia (Universitas Borneo)' },
  { value: '2', label: 'REG-2024-002 - Teknik Mesin (Universitas Garuda)' },
  { value: '3', label: 'REG-2024-003 - Teknik Elektro (Universitas Cakra)' },
];

const asesorOptions = [
  { value: '', label: 'Pilih asesor' },
  { value: '37', label: 'Prof. Dr. Abdul Chalim - Teknik Mesin' },
  { value: '122', label: 'Prof. Dr. Abdul Ghafur - Teknik Kimia' },
  { value: '189', label: 'Prof. Dr. Abdul Rahman - Teknik Kimia' },
  { value: '197', label: 'Dr. Ir. Abdul Muis - Teknik Mesin' },
];

export default function PenawaranBaruPage() {
  const router = useRouter();

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<PenawaranFormData>({
    resolver: zodResolver(penawaranSchema),
  });

  const onSubmit = async (data: PenawaranFormData) => {
    try {
      await new Promise((resolve) => setTimeout(resolve, 1500));
      toast.success('Penawaran berhasil dikirim');
      router.push('/dashboard/penawaran-asesor');
    } catch (error) {
      toast.error('Gagal mengirim penawaran');
    }
  };

  return (
    <div className="space-y-6 max-w-2xl">
      {/* Header */}
      <div className="flex items-center gap-4">
        <button
          onClick={() => router.back()}
          className="p-2 hover:bg-secondary-100 rounded-lg"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">Buat Penawaran Asesor</h1>
          <p className="text-secondary-500 mt-1">Kirim penawaran tugas asesmen kepada asesor</p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)}>
        <Card className="p-6 space-y-6">
          <FormSection title="Data Penawaran" subtitle="Pilih akreditasi dan asesor yang akan ditawarkan">
            <FormGrid cols={1}>
              <Select
                label="Akreditasi"
                options={akreditasiOptions}
                error={errors.akreditasiId?.message}
                {...register('akreditasiId')}
              />
              <Select
                label="Asesor"
                options={asesorOptions}
                error={errors.asesorId?.message}
                {...register('asesorId')}
              />
              <Input
                label="Batas Waktu Respon"
                type="date"
                error={errors.tanggalBatasRespon?.message}
                {...register('tanggalBatasRespon')}
              />
            </FormGrid>
          </FormSection>

          <FormSection title="Catatan" subtitle="Tambahkan catatan untuk asesor (opsional)">
            <TextareaField
              label="Catatan Penawaran"
              placeholder="Informasi tambahan untuk asesor..."
              value={watch('catatanPenawaran') || ''}
              onChange={(val) => setValue('catatanPenawaran', val)}
              rows={4}
            />
          </FormSection>

          <FormActions>
            <Button type="button" variant="ghost" onClick={() => router.back()}>
              Batal
            </Button>
            <Button type="submit" isLoading={isSubmitting}>
              <Send className="w-4 h-4 mr-2" />
              Kirim Penawaran
            </Button>
          </FormActions>
        </Card>
      </form>
    </div>
  );
}
