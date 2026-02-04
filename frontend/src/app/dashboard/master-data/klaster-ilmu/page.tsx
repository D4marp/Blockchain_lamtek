'use client';

import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import toast from 'react-hot-toast';
import {
  Card,
  Button,
  Input,
  Table,
} from '@/components/ui';
import { FormSection, FormGrid, FormActions } from '@/components/ui/FormComponents';
import {
  Plus,
  Search,
  Edit2,
  Trash2,
  X,
  Save,
} from 'lucide-react';

const klasterIlmuSchema = z.object({
  namaKlaster: z.string().min(1, 'Nama klaster wajib diisi'),
  kodeKlaster: z.string().optional(),
});

type KlasterIlmuFormData = z.infer<typeof klasterIlmuSchema>;

const dummyKlasterIlmu = [
  { id: 1, namaKlaster: 'Teknik Sipil', kodeKlaster: 'TS' },
  { id: 2, namaKlaster: 'Teknik Elektro', kodeKlaster: 'TE' },
  { id: 3, namaKlaster: 'Teknik Mesin', kodeKlaster: 'TM' },
  { id: 4, namaKlaster: 'Teknik Industri', kodeKlaster: 'TI' },
  { id: 5, namaKlaster: 'Teknik Kimia', kodeKlaster: 'TK' },
  { id: 6, namaKlaster: 'Teknik Lingkungan', kodeKlaster: 'TL' },
  { id: 7, namaKlaster: 'Teknik Pertambangan', kodeKlaster: 'TP' },
  { id: 8, namaKlaster: 'Teknik Geologi', kodeKlaster: 'TG' },
  { id: 9, namaKlaster: 'Teknik Geodesi', kodeKlaster: 'TGD' },
  { id: 10, namaKlaster: 'Teknik Material', kodeKlaster: 'TMT' },
  { id: 11, namaKlaster: 'Profesi Insinyur', kodeKlaster: 'PI' },
];

export default function KlasterIlmuPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [data, setData] = useState(dummyKlasterIlmu);

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<KlasterIlmuFormData>({
    resolver: zodResolver(klasterIlmuSchema),
  });

  const onSubmit = async (formData: KlasterIlmuFormData) => {
    try {
      await new Promise((resolve) => setTimeout(resolve, 1000));

      if (editingId) {
        setData((prev) =>
          prev.map((item) =>
            item.id === editingId
              ? { ...item, ...formData }
              : item
          )
        );
        toast.success('Klaster ilmu berhasil diperbarui');
      } else {
        const newItem = {
          id: Date.now(),
          namaKlaster: formData.namaKlaster,
          kodeKlaster: formData.kodeKlaster || '',
        };
        setData((prev) => [...prev, newItem]);
        toast.success('Klaster ilmu berhasil ditambahkan');
      }

      setIsFormOpen(false);
      setEditingId(null);
      reset();
    } catch (error) {
      toast.error('Gagal menyimpan data');
    }
  };

  const handleEdit = (item: typeof dummyKlasterIlmu[0]) => {
    setEditingId(item.id);
    reset({
      namaKlaster: item.namaKlaster,
      kodeKlaster: item.kodeKlaster,
    });
    setIsFormOpen(true);
  };

  const handleDelete = (id: number) => {
    if (confirm('Yakin ingin menghapus klaster ilmu ini?')) {
      setData((prev) => prev.filter((item) => item.id !== id));
      toast.success('Klaster ilmu berhasil dihapus');
    }
  };

  const handleCancel = () => {
    setIsFormOpen(false);
    setEditingId(null);
    reset();
  };

  const filteredData = data.filter((item) =>
    item.namaKlaster.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const columns = [
    { key: 'kodeKlaster', label: 'Kode' },
    { key: 'namaKlaster', label: 'Nama Klaster Ilmu' },
    {
      key: 'actions',
      label: 'Aksi',
      render: (_: unknown, row: typeof dummyKlasterIlmu[0]) => (
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
          <h1 className="text-2xl font-bold text-secondary-900">Klaster Ilmu</h1>
          <p className="text-secondary-500 mt-1">Kelola data klaster ilmu teknik</p>
        </div>
        <Button onClick={() => setIsFormOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Tambah Klaster
        </Button>
      </div>

      {isFormOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-md max-h-[90vh] overflow-y-auto m-4">
            <div className="flex items-center justify-between px-6 py-4 border-b border-secondary-200">
              <h2 className="text-lg font-semibold text-secondary-900">
                {editingId ? 'Edit Klaster Ilmu' : 'Tambah Klaster Ilmu Baru'}
              </h2>
              <button onClick={handleCancel} className="p-1 hover:bg-secondary-100 rounded-lg">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
              <FormSection title="Informasi Klaster">
                <FormGrid cols={1}>
                  <Input
                    label="Kode Klaster"
                    placeholder="Contoh: TS"
                    {...register('kodeKlaster')}
                  />
                  <Input
                    label="Nama Klaster"
                    placeholder="Contoh: Teknik Sipil"
                    error={errors.namaKlaster?.message}
                    {...register('namaKlaster')}
                  />
                </FormGrid>
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

      <Card>
        <div className="p-4 border-b border-secondary-200">
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-secondary-400" />
            <input
              type="text"
              placeholder="Cari klaster ilmu..."
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
