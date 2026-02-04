'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { Card, CardHeader, Badge, Progress, Button } from '@/components/ui';
import { useAuthStore } from '@/lib/store';
import { akreditasiApi, dashboardApi } from '@/lib/api';
import {
  GraduationCap,
  FileText,
  ClipboardCheck,
  Users,
  TrendingUp,
  ArrowUpRight,
  ArrowRight,
  Shield,
  Clock,
  CheckCircle,
  AlertCircle,
} from 'lucide-react';

const getStatusVariant = (status: string) => {
  const variants: Record<string, 'primary' | 'secondary' | 'success' | 'warning' | 'danger'> = {
    PENGAJUAN: 'secondary',
    VERIFIKASI_DOKUMEN: 'primary',
    ASESMEN_KECUKUPAN: 'primary',
    ASESMEN_LAPANGAN: 'warning',
    VALIDASI: 'warning',
    PENETAPAN: 'success',
    SELESAI: 'success',
    DITOLAK: 'danger',
  };
  return variants[status] || 'secondary';
};

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    PENGAJUAN: 'Pengajuan',
    VERIFIKASI_DOKUMEN: 'Verifikasi',
    ASESMEN_KECUKUPAN: 'AK',
    ASESMEN_LAPANGAN: 'AL',
    VALIDASI: 'Validasi',
    PENETAPAN: 'Penetapan',
    SELESAI: 'Selesai',
    DITOLAK: 'Ditolak',
  };
  return labels[status] || status;
};

interface AkreditasiItem {
  id: string;
  nomorPengajuan: string;
  namaProdi: string;
  universitas: string;
  status: string;
  progress: number;
  tanggal: string;
}

interface Activity {
  id: string;
  action: string;
  subject: string;
  actor: string;
  time: string;
  type: string;
}

export default function DashboardPage() {
  const { user } = useAuthStore();
  const [recentAkreditasi, setRecentAkreditasi] = useState<AkreditasiItem[]>([]);
  const [activities, setActivities] = useState<Activity[]>([]);
  
  // Fallback activities when API fails or returns empty
  const fallbackActivities: Activity[] = [
    { id: '1', action: 'Dokumen diunggah', subject: 'Menunggu data...', actor: 'System', time: 'Baru saja', type: 'document' },
    { id: '2', action: 'Status diperbarui', subject: 'Memuat...', actor: 'System', time: '-', type: 'status' },
  ];
  
  const [stats, setStats] = useState([
    {
      title: 'Total Akreditasi',
      value: '...',
      change: '+0%',
      changeType: 'positive' as const,
      icon: GraduationCap,
      color: 'bg-primary-100 text-primary-600',
    },
    {
      title: 'Dalam Proses',
      value: '...',
      change: '+0%',
      changeType: 'positive' as const,
      icon: Clock,
      color: 'bg-warning-100 text-warning-600',
    },
    {
      title: 'Selesai Bulan Ini',
      value: '...',
      change: '+0%',
      changeType: 'positive' as const,
      icon: CheckCircle,
      color: 'bg-success-100 text-success-600',
    },
    {
      title: 'Menunggu Asesmen',
      value: '...',
      change: '+0%',
      changeType: 'negative' as const,
      icon: AlertCircle,
      color: 'bg-danger-100 text-danger-600',
    },
  ]);
  const [loading, setLoading] = useState(true);

  // Fetch dashboard stats on mount
  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [statsResponse, akreditasiResponse, activitiesResponse] = await Promise.allSettled([
          akreditasiApi.getStats(),
          akreditasiApi.getAll({ limit: 4 }),
          dashboardApi.getRecentActivities(),
        ]);

        // Handle stats
        if (statsResponse.status === 'fulfilled') {
          const data = statsResponse.value.data;
          setStats([
            {
              title: 'Total Akreditasi',
              value: data.total?.toString() || '0',
              change: '+12%',
              changeType: 'positive',
              icon: GraduationCap,
              color: 'bg-primary-100 text-primary-600',
            },
            {
              title: 'Dalam Proses',
              value: data.inProgress?.toString() || '0',
              change: '+5%',
              changeType: 'positive',
              icon: Clock,
              color: 'bg-warning-100 text-warning-600',
            },
            {
              title: 'Selesai Bulan Ini',
              value: data.completedThisMonth?.toString() || '0',
              change: '+23%',
              changeType: 'positive',
              icon: CheckCircle,
              color: 'bg-success-100 text-success-600',
            },
            {
              title: 'Menunggu Asesmen',
              value: data.waitingAssessment?.toString() || '0',
              change: '-8%',
              changeType: 'negative',
              icon: AlertCircle,
              color: 'bg-danger-100 text-danger-600',
            },
          ]);
        }

        // Handle akreditasi list
        if (akreditasiResponse.status === 'fulfilled') {
          const akrData = akreditasiResponse.value.data as any;
          const items = akrData.data || akrData || [];
          setRecentAkreditasi(items.slice(0, 4).map((a: any) => ({
            id: a.id?.toString() || '',
            nomorPengajuan: a.nomorPengajuan || a.kode || `AKR-${a.id}`,
            namaProdi: a.prodi?.nama || a.namaProdi || 'N/A',
            universitas: a.institusi?.nama || a.universitas || 'N/A',
            status: a.status || 'PENGAJUAN',
            progress: calculateProgress(a.status),
            tanggal: a.createdAt?.split('T')[0] || a.tanggal || '',
          })));
        }

        // Handle activities
        if (activitiesResponse.status === 'fulfilled') {
          const actData = activitiesResponse.value.data as any;
          const actItems = actData.data || actData || [];
          setActivities(actItems.slice(0, 4).map((act: any) => ({
            id: act.id?.toString() || '',
            action: act.action || act.tipe || 'Aktivitas',
            subject: act.subject || act.deskripsi || '',
            actor: act.actor || act.user?.name || 'System',
            time: formatTimeAgo(act.createdAt) || act.time || '',
            type: act.type || 'status',
          })));
        }

        setLoading(false);
      } catch (error) {
        console.error('Failed to fetch dashboard data:', error);
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  // Helper to calculate progress based on status
  const calculateProgress = (status: string): number => {
    const progressMap: Record<string, number> = {
      PENGAJUAN: 10,
      VERIFIKASI_DOKUMEN: 25,
      ASESMEN_KECUKUPAN: 50,
      ASESMEN_LAPANGAN: 75,
      VALIDASI: 85,
      PENETAPAN: 95,
      SELESAI: 100,
      DITOLAK: 0,
    };
    return progressMap[status] || 0;
  };

  // Helper to format time ago
  const formatTimeAgo = (dateString: string): string => {
    if (!dateString) return '';
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 60) return `${diffMins} menit lalu`;
    if (diffHours < 24) return `${diffHours} jam lalu`;
    return `${diffDays} hari lalu`;
  };

  return (
    <div className="space-y-6">
      {/* Welcome Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-secondary-900">
            Selamat Datang, {user?.name || 'Admin'}!
          </h1>
          <p className="text-secondary-500 mt-1">
            Berikut ringkasan aktivitas akreditasi hari ini
          </p>
        </div>
        <Link href="/dashboard/akreditasi/new">
          <Button leftIcon={<GraduationCap className="w-4 h-4" />}>
            Pengajuan Baru
          </Button>
        </Link>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => (
          <Card key={stat.title} className="hover:shadow-soft transition-shadow">
            <div className="flex items-start justify-between">
              <div className={`p-3 rounded-xl ${stat.color}`}>
                <stat.icon className="w-6 h-6" />
              </div>
              <div className={`flex items-center gap-1 text-sm font-medium ${
                stat.changeType === 'positive' ? 'text-success-600' : 'text-danger-600'
              }`}>
                <TrendingUp className={`w-4 h-4 ${stat.changeType === 'negative' && 'rotate-180'}`} />
                {stat.change}
              </div>
            </div>
            <div className="mt-4">
              <p className="text-3xl font-bold text-secondary-900">{stat.value}</p>
              <p className="text-secondary-500 text-sm mt-1">{stat.title}</p>
            </div>
          </Card>
        ))}
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Recent Akreditasi */}
        <div className="lg:col-span-2">
          <Card padding="none">
            <div className="px-6 py-4 border-b border-secondary-200 flex items-center justify-between">
              <div>
                <h2 className="font-semibold text-secondary-900">Akreditasi Terbaru</h2>
                <p className="text-sm text-secondary-500">Daftar pengajuan akreditasi terkini</p>
              </div>
              <Link href="/dashboard/akreditasi">
                <Button variant="ghost" size="sm" rightIcon={<ArrowRight className="w-4 h-4" />}>
                  Lihat Semua
                </Button>
              </Link>
            </div>
            <div className="divide-y divide-secondary-100">
              {recentAkreditasi.map((akr) => (
                <Link
                  key={akr.id}
                  href={`/dashboard/akreditasi/${akr.id}`}
                  className="flex items-center justify-between px-6 py-4 hover:bg-secondary-50 transition-colors"
                >
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-3">
                      <p className="font-medium text-secondary-900 truncate">{akr.namaProdi}</p>
                      <Badge variant={getStatusVariant(akr.status)} size="sm">
                        {getStatusLabel(akr.status)}
                      </Badge>
                    </div>
                    <div className="flex items-center gap-2 mt-1">
                      <p className="text-sm text-secondary-500">{akr.universitas}</p>
                      <span className="text-secondary-300">•</span>
                      <p className="text-sm text-secondary-400">{akr.nomorPengajuan}</p>
                    </div>
                  </div>
                  <div className="ml-4 flex items-center gap-4">
                    <div className="w-32 hidden sm:block">
                      <Progress value={akr.progress} size="sm" />
                    </div>
                    <ArrowUpRight className="w-4 h-4 text-secondary-400" />
                  </div>
                </Link>
              ))}
            </div>
          </Card>
        </div>

        {/* Recent Activities */}
        <div>
          <Card padding="none">
            <div className="px-6 py-4 border-b border-secondary-200">
              <h2 className="font-semibold text-secondary-900">Aktivitas Terbaru</h2>
              <p className="text-sm text-secondary-500">Log aktivitas sistem</p>
            </div>
            <div className="divide-y divide-secondary-100">
              {(activities.length > 0 ? activities : fallbackActivities).map((activity) => (
                <div key={activity.id} className="px-6 py-4">
                  <div className="flex items-start gap-3">
                    <div className={`p-2 rounded-lg ${
                      activity.type === 'blockchain' ? 'bg-primary-100 text-primary-600' :
                      activity.type === 'document' ? 'bg-success-100 text-success-600' :
                      activity.type === 'status' ? 'bg-warning-100 text-warning-600' :
                      'bg-secondary-100 text-secondary-600'
                    }`}>
                      {activity.type === 'blockchain' ? <Shield className="w-4 h-4" /> :
                       activity.type === 'document' ? <FileText className="w-4 h-4" /> :
                       activity.type === 'status' ? <ClipboardCheck className="w-4 h-4" /> :
                       <Users className="w-4 h-4" />}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-secondary-900">{activity.action}</p>
                      <p className="text-sm text-secondary-500 truncate">{activity.subject}</p>
                      <p className="text-xs text-secondary-400 mt-1">{activity.time}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </Card>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardHeader title="Distribusi Peringkat" subtitle="Akreditasi aktif" />
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-sm text-secondary-600">Unggul</span>
              <div className="flex items-center gap-2">
                <div className="w-32 bg-secondary-200 rounded-full h-2">
                  <div className="bg-success-500 h-2 rounded-full" style={{ width: '45%' }} />
                </div>
                <span className="text-sm font-medium text-secondary-900 w-10">45%</span>
              </div>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm text-secondary-600">Baik Sekali</span>
              <div className="flex items-center gap-2">
                <div className="w-32 bg-secondary-200 rounded-full h-2">
                  <div className="bg-primary-500 h-2 rounded-full" style={{ width: '35%' }} />
                </div>
                <span className="text-sm font-medium text-secondary-900 w-10">35%</span>
              </div>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm text-secondary-600">Baik</span>
              <div className="flex items-center gap-2">
                <div className="w-32 bg-secondary-200 rounded-full h-2">
                  <div className="bg-warning-500 h-2 rounded-full" style={{ width: '20%' }} />
                </div>
                <span className="text-sm font-medium text-secondary-900 w-10">20%</span>
              </div>
            </div>
          </div>
        </Card>

        <Card>
          <CardHeader title="Status Blockchain" subtitle="Hyperledger Besu" />
          <div className="space-y-3">
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Network Status</span>
              <Badge variant="success">Online</Badge>
            </div>
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Total Blocks</span>
              <span className="text-sm font-medium text-secondary-900">12,456</span>
            </div>
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Pending Tx</span>
              <span className="text-sm font-medium text-secondary-900">3</span>
            </div>
          </div>
        </Card>

        <Card>
          <CardHeader title="Status IPFS" subtitle="Document Storage" />
          <div className="space-y-3">
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Node Status</span>
              <Badge variant="success">Connected</Badge>
            </div>
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Total Files</span>
              <span className="text-sm font-medium text-secondary-900">2,847</span>
            </div>
            <div className="flex items-center justify-between py-2">
              <span className="text-sm text-secondary-600">Storage Used</span>
              <span className="text-sm font-medium text-secondary-900">15.2 GB</span>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
