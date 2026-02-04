'use client';

import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import {
  Card,
  Button,
  Input,
  Select,
  Table,
  Badge,
} from '@/components/ui';
import { FormSection, FormGrid, FormActions, SwitchField } from '@/components/ui/FormComponents';
import {
  Plus,
  Search,
  Edit2,
  Trash2,
  X,
  Save,
  Loader2,
  AlertCircle,
} from 'lucide-react';
import { uppsApi, institusiApi } from '@/lib/api';
import { useCrud, useDebounce } from '@/lib/hooks';

const uppsSchema = z.object({
  namaUPPS: z.string().min(1, 'Nama UPPS wajib diisi'),
  institusiId: z.string().min(1, 'Institusi wajib dipilih'),
  namaPimpinan: z.string().optional(),
  email: z.string().email('Email tidak valid').optional().or(z.literal('')),
  telpNo: z.string().optional(),
  isActive: z.boolean().default(true),
});

type UPPSFormData = z.infer<typeof uppsSchema>;

interface UPPS {
  id: number;
  namaUPPS: string;
  institusiId?: number;
  institusi?: { id: number; nama: string };
  namaPimpinan?: string;
  email?: string;
  telpNo?: string;
  isActive: boolean;
}

export default function UPPSPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const debouncedSearch = useDebounce(searchQuery, 300);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [institusiOptions, setInstitusiOptions] = useState<{ value: string; label: string }[]>([{ value: '', label: 'Pilih institusi' }]);

  const { data, loading, error, saving, fetchAll, create, update, remove } = useCrud<UPPS>(uppsApi);

  useEffect(() => {
    fetchAll({ search: debouncedSearch });
  }, [debouncedSearch]);

  useEffect(() => {
    const loadInstitusi = async () => {
      try {
        const response = await institusiApi.getAll();
        setInstitusiOptions([{ value: '', label: 'Pilih institusi' }, ...(response.data || []).map((i: { id: number; nama: string }) => ({ value: String(i.id), label: i.nama }))]);
      } catch (err) {
        console.error('Failed to load institusi', err);
      }
    };
    loadInstitusi();
  }, []);

  const {
    register,
    handleSubmit,
    reset,
    watch,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<UPPSFormData>({
    resolver: zodResolver(uppsSchema),
    defaultValues: {
      isActive: true,
    },
  });

  const isActive = watch('isActive');

  const onSubmit = async (formData: UPPSFormData) => {
    try {
      const payload = {
        namaUPPS: formData.namaUPPS,
        institusiId: formData.institusiId ? Number(formData.institusiId) : undefined,
        namaPimpinan: formData.namaPimpinan,
        email: formData.email,
        telpNo: formData.telpNo,
        isActive: formData.isActive,
      };

      if (editingId) {
        await update(editingId, payload);
        toast.success('UPPS berhasil diperbarui');
      } else {
        await create(payload);
        toast.success('UPPS berhasil ditambahkan');
      }

      setIsFormOpen(false);
      setEditingId(null);
      reset();
    } catch (err) {
      toast.error('Gagal menyimpan data');
    }
  };

  const handleEdit = (item: UPPS) => {
    setEditingId(item.id);
    reset({
      namaUPPS: item.namaUPPS,
      institusiId: item.institusiId ? String(item.institusiId) : '',
      namaPimpinan: item.namaPimpinan || '',
      email: item.email || '',
      telpNo: item.telpNo || '',
      isActive: item.isActive,
    });
    setIsFormOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (confirm('Yakin ingin menghapus UPPS ini?')) {
      try {
        await remove(id);
        toast.success('UPPS berhasil dihapus');
      } catch (err) {
        toast.error('Gagal menghapus data');
      }
    }
  };

  const handleCancel = () => {
    setIsFormOpen(false);
    setEditingId(null);
    reset();
  };

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center h-64 text-red-500">
        <AlertCircle className="w-12 h-12 mb-4" />
        <p>Gagal memuat data: {error}</p>
        <Button onClick={() => fetchAll()} className="mt-4">Coba Lagi</Button>
      </div>
    );
  }

  const columns = [
    { key: 'namaUPPS', label: 'Nama UPPS' },
    { 
      key: 'institusi', 
      label: 'Institusi',
      render: (_: unknown, row: UPPS) => row.institusi?.nama || '-'
    },
    { key: 'namaPimpinan', label: 'Pimpinan' },
    {
      key: 'isActive',
      label: 'Status',
      render: (value: boolean) => (
        <Badge variant={value ? 'success' : 'danger'}>
          {value ? 'Aktif' : 'Tidak Aktif'}
        </Badge>
      ),
    },
    {
      key: 'actions',
      label: 'Aksi',
      render: (_: unknown, row: UPPS) => (
        <div className="flex items-center gap-2">
          <button
            onClick={() => handleEdit(row)}
            className="p-1.5 text-secondary-500 hover:text-primary-600 hover:bg-primary-50 rounded-lg"
          >
            <Edit2 className="w-4 h-4" />
          </button>
          <button
            onClick={() => handleDelete(row.id)}
            className="p-1.5 text-secondary-500 hover:text-red-600 hover:bg-red-50 rounded-lg"
          >
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">UPPS</h1>
          <p className="text-secondary-500 mt-1">Unit Pengelola Program Studi (Fakultas/Jurusan)</p>
        </div>
        <Button onClick={() => setIsFormOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Tambah UPPS
        </Button>
      </div>

      {isFormOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-lg max-h-[90vh] overflow-y-auto m-4">
            <div className="flex items-center justify-between px-6 py-4 border-b border-secondary-200">
              <h2 className="text-lg font-semibold text-secondary-900">
                {editingId ? 'Edit UPPS' : 'Tambah UPPS Baru'}
              </h2>
              <button onClick={handleCancel} className="p-1 hover:bg-secondary-100 rounded-lg">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
              <FormSection title="Informasi UPPS">
                <FormGrid cols={1}>
                  <Input
                    label="Nama UPPS"
                    placeholder="Contoh: Fakultas Teknik"
                    error={errors.namaUPPS?.message}
                    {...register('namaUPPS')}
                  />
                  <Select
                    label="Institusi"
                    options={institusiOptions}
                    error={errors.institusiId?.message}
                    {...register('institusiId')}
                  />
                  <Input
                    label="Nama Pimpinan"
                    placeholder="Nama dekan/pimpinan"
                    {...register('namaPimpinan')}
                  />
                  <Input
                    label="Email"
                    type="email"
                    placeholder="email@domain.com"
                    {...register('email')}
                  />
                  <Input
                    label="Nomor Telepon"
                    placeholder="08123456789"
                    {...register('telpNo')}
                  />
                </FormGrid>
              </FormSection>

              <FormSection title="Status">
                <SwitchField
                  label="Status Aktif"
                  description="UPPS aktif dalam sistem"
                  checked={isActive}
                  onChange={(val) => setValue('isActive', val)}
                />
              </FormSection>

              <FormActions>
                <Button type="button" variant="ghost" onClick={handleCancel}>
                  Batal
                </Button>
                <Button type="submit" isLoading={saving}>
                  <Save className="w-4 h-4 mr-2" />
                  {editingId ? 'Perbarui' : 'Simpan'}
                </Button>
              </FormActions>
            </form>
          </div>
        </div>
      )}

      <Card>
        <div className="p-4 border-b border-secondary-200">
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-secondary-400" />
            <input
              type="text"
              placeholder="Cari UPPS..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            />
          </div>
        </div>
        {loading ? (
          <div className="flex items-center justify-center h-48">
            <Loader2 className="w-8 h-8 animate-spin text-primary-500" />
          </div>
        ) : (
          <Table columns={columns} data={data} />
        )}
      </Card>
    </div>
  );
}
