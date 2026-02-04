'use client';

import React, { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import Link from 'next/link';
import {
  Card,
  CardHeader,
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
  Building2,
  X,
  Save,
  Loader2,
  AlertCircle,
  RefreshCw,
} from 'lucide-react';
import { institusiApi, provinsiApi } from '@/lib/api';
import { useCrud, useDebounce } from '@/lib/hooks';

// Schema
const institusiSchema = z.object({
  nama: z.string().min(1, 'Nama institusi wajib diisi'),
  statusInstitusi: z.string().optional(),
  alamat: z.string().optional(),
  kota: z.string().optional(),
  provinsiId: z.coerce.number().optional(),
  kodeInstitusiPddikti: z.string().optional(),
  isAktif: z.boolean().default(true),
});

type InstitusiFormData = z.infer<typeof institusiSchema>;

interface Institusi {
  id: number;
  nama: string;
  statusInstitusi?: string;
  alamat?: string;
  kota?: string;
  provinsiId?: number;
  kodeInstitusiPddikti?: string;
  isAktif: boolean;
}

const statusOptions = [
  { value: '', label: 'Pilih status' },
  { value: 'PTN', label: 'PTN (Perguruan Tinggi Negeri)' },
  { value: 'PTN-BH', label: 'PTN-BH (PTN Badan Hukum)' },
  { value: 'PTS', label: 'PTS (Perguruan Tinggi Swasta)' },
  { value: 'POLITEKNIK', label: 'Politeknik' },
];

export default function InstitusiPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const debouncedSearch = useDebounce(searchQuery, 300);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [provinsiOptions, setProvinsiOptions] = useState([{ value: '', label: 'Pilih provinsi' }]);

  // Use CRUD hook for API operations
  const { data, loading, error, saving, fetchAll, create, update, remove } = useCrud<Institusi>(institusiApi);

  // Load provinsi options
  useEffect(() => {
    provinsiApi.getAll().then((res) => {
      const options = [
        { value: '', label: 'Pilih provinsi' },
        ...res.data.map((p: any) => ({ value: String(p.id), label: p.nama })),
      ];
      setProvinsiOptions(options);
    }).catch(() => {
      // Fallback if API fails
      setProvinsiOptions([
        { value: '', label: 'Pilih provinsi' },
        { value: '11', label: 'DKI Jakarta' },
        { value: '12', label: 'Jawa Barat' },
        { value: '13', label: 'Jawa Tengah' },
        { value: '14', label: 'DI Yogyakarta' },
        { value: '15', label: 'Jawa Timur' },
      ]);
    });
  }, []);

  const {
    register,
    handleSubmit,
    reset,
    watch,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<InstitusiFormData>({
    resolver: zodResolver(institusiSchema),
    defaultValues: {
      isAktif: true,
    },
  });

  const isAktif = watch('isAktif');

  const onSubmit = async (formData: InstitusiFormData) => {
    try {
      if (editingId) {
        await update(editingId, formData);
        toast.success('Institusi berhasil diperbarui');
      } else {
        await create(formData);
        toast.success('Institusi berhasil ditambahkan');
      }
      setIsFormOpen(false);
      setEditingId(null);
      reset();
    } catch (err: any) {
      toast.error(err.response?.data?.message || 'Gagal menyimpan data');
    }
  };

  const handleEdit = (item: Institusi) => {
    setEditingId(item.id);
    reset({
      nama: item.nama,
      statusInstitusi: item.statusInstitusi || '',
      alamat: item.alamat || '',
      kota: item.kota || '',
      provinsiId: item.provinsiId,
      kodeInstitusiPddikti: item.kodeInstitusiPddikti || '',
      isAktif: item.isAktif,
    });
    setIsFormOpen(true);
  };

  const handleDelete = async (id: number) => {
    if (confirm('Yakin ingin menghapus institusi ini?')) {
      try {
        await remove(id);
        toast.success('Institusi berhasil dihapus');
      } catch (err: any) {
        toast.error(err.response?.data?.message || 'Gagal menghapus data');
      }
    }
  };

  const handleCancel = () => {
    setIsFormOpen(false);
    setEditingId(null);
    reset();
  };

  const filteredData = data.filter((item) =>
    item.nama.toLowerCase().includes(debouncedSearch.toLowerCase())
  );

  const columns = [
    { key: 'nama', label: 'Nama Institusi' },
    { key: 'statusInstitusi', label: 'Status' },
    { key: 'kota', label: 'Kota' },
    {
      key: 'isAktif',
      label: 'Status Aktif',
      render: (value: boolean) => (
        <Badge variant={value ? 'success' : 'danger'}>
          {value ? 'Aktif' : 'Tidak Aktif'}
        </Badge>
      ),
    },
    {
      key: 'actions',
      label: 'Aksi',
      render: (_: unknown, row: Institusi) => (
        <div className="flex items-center gap-2">
          <button
            onClick={() => handleEdit(row)}
            className="p-1.5 text-secondary-500 hover:text-primary-600 hover:bg-primary-50 rounded-lg"
            disabled={saving}
          >
            <Edit2 className="w-4 h-4" />
          </button>
          <button
            onClick={() => handleDelete(row.id)}
            className="p-1.5 text-secondary-500 hover:text-red-600 hover:bg-red-50 rounded-lg"
            disabled={saving}
          >
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  // Loading state
  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600 mx-auto" />
          <p className="mt-2 text-secondary-600">Memuat data...</p>
        </div>
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <AlertCircle className="w-12 h-12 text-red-500 mx-auto" />
          <p className="mt-2 text-secondary-900 font-medium">Gagal memuat data</p>
          <p className="text-secondary-500 text-sm">{error}</p>
          <Button onClick={() => fetchAll()} className="mt-4">
            <RefreshCw className="w-4 h-4 mr-2" />
            Coba Lagi
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">Data Institusi</h1>
          <p className="text-secondary-500 mt-1">Kelola data institusi / perguruan tinggi</p>
        </div>
        <Button onClick={() => setIsFormOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Tambah Institusi
        </Button>
      </div>

      {/* Form Modal */}
      {isFormOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto m-4">
            <div className="flex items-center justify-between px-6 py-4 border-b border-secondary-200">
              <h2 className="text-lg font-semibold text-secondary-900">
                {editingId ? 'Edit Institusi' : 'Tambah Institusi Baru'}
              </h2>
              <button onClick={handleCancel} className="p-1 hover:bg-secondary-100 rounded-lg">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
              <FormSection title="Informasi Dasar" subtitle="Data utama institusi">
                <FormGrid cols={2}>
                  <div className="col-span-2">
                    <Input
                      label="Nama Institusi"
                      placeholder="Contoh: Universitas Indonesia"
                      error={errors.nama?.message}
                      {...register('nama')}
                    />
                  </div>
                  <Select
                    label="Status Institusi"
                    options={statusOptions}
                    error={errors.statusInstitusi?.message}
                    {...register('statusInstitusi')}
                  />
                  <Input
                    label="Kode PDDIKTI"
                    placeholder="Masukkan kode institusi"
                    {...register('kodeInstitusiPddikti')}
                  />
                </FormGrid>
              </FormSection>

              <FormSection title="Lokasi" subtitle="Alamat dan wilayah institusi">
                <FormGrid cols={2}>
                  <div className="col-span-2">
                    <Input
                      label="Alamat"
                      placeholder="Alamat lengkap institusi"
                      {...register('alamat')}
                    />
                  </div>
                  <Input
                    label="Kota"
                    placeholder="Nama kota"
                    {...register('kota')}
                  />
                  <Select
                    label="Provinsi"
                    options={provinsiOptions}
                    {...register('provinsiId')}
                  />
                </FormGrid>
              </FormSection>

              <FormSection title="Status" subtitle="Status aktif institusi">
                <SwitchField
                  label="Aktif"
                  description="Institusi yang tidak aktif tidak akan muncul dalam pilihan"
                  checked={isAktif}
                  onChange={(val) => setValue('isAktif', val)}
                />
              </FormSection>

              <FormActions>
                <Button type="button" variant="ghost" onClick={handleCancel}>
                  Batal
                </Button>
                <Button type="submit" isLoading={isSubmitting}>
                  <Save className="w-4 h-4 mr-2" />
                  {editingId ? 'Perbarui' : 'Simpan'}
                </Button>
              </FormActions>
            </form>
          </div>
        </div>
      )}

      {/* Search & Table */}
      <Card>
        <div className="p-4 border-b border-secondary-200">
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-secondary-400" />
            <input
              type="text"
              placeholder="Cari institusi..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-secondary-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            />
          </div>
        </div>
        <Table columns={columns} data={filteredData} />
      </Card>
    </div>
  );
}
