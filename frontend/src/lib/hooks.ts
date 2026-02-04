'use client';

import { useState, useEffect, useCallback } from 'react';
import { AxiosResponse } from 'axios';

// Generic API state
interface ApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

// Hook for fetching data with loading and error states
export function useApi<T>(
  fetchFn: () => Promise<AxiosResponse<T>>,
  dependencies: any[] = []
) {
  const [state, setState] = useState<ApiState<T>>({
    data: null,
    loading: true,
    error: null,
  });

  const refetch = useCallback(async () => {
    setState((prev) => ({ ...prev, loading: true, error: null }));
    try {
      const response = await fetchFn();
      setState({ data: response.data, loading: false, error: null });
    } catch (err: any) {
      const message = err.response?.data?.message || err.message || 'Terjadi kesalahan';
      setState({ data: null, loading: false, error: message });
    }
  }, [fetchFn]);

  useEffect(() => {
    refetch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, dependencies);

  return { ...state, refetch };
}

// Hook for CRUD operations with optimistic updates
export function useCrud<T extends { id: number | string }>(
  api: {
    getAll: (params?: Record<string, any>) => Promise<AxiosResponse<T[]>>;
    create: (data: Partial<T>) => Promise<AxiosResponse<T>>;
    update: (id: number | string, data: Partial<T>) => Promise<AxiosResponse<T>>;
    delete: (id: number | string) => Promise<AxiosResponse<void>>;
  },
  initialParams?: Record<string, any>
) {
  const [data, setData] = useState<T[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchAll = useCallback(async (params?: Record<string, any>) => {
    setLoading(true);
    setError(null);
    try {
      const response = await api.getAll(params || initialParams);
      setData(response.data);
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Gagal memuat data');
    } finally {
      setLoading(false);
    }
  }, [api, initialParams]);

  const create = useCallback(async (newData: Partial<T>): Promise<T | null> => {
    setSaving(true);
    setError(null);
    try {
      const response = await api.create(newData);
      setData((prev) => [...prev, response.data]);
      return response.data;
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Gagal menyimpan data');
      throw err;
    } finally {
      setSaving(false);
    }
  }, [api]);

  const update = useCallback(async (id: number | string, updateData: Partial<T>): Promise<T | null> => {
    setSaving(true);
    setError(null);
    try {
      const response = await api.update(id, updateData);
      setData((prev) =>
        prev.map((item) => (item.id === id ? response.data : item))
      );
      return response.data;
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Gagal memperbarui data');
      throw err;
    } finally {
      setSaving(false);
    }
  }, [api]);

  const remove = useCallback(async (id: number | string): Promise<void> => {
    setSaving(true);
    setError(null);
    try {
      await api.delete(id);
      setData((prev) => prev.filter((item) => item.id !== id));
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Gagal menghapus data');
      throw err;
    } finally {
      setSaving(false);
    }
  }, [api]);

  useEffect(() => {
    fetchAll();
  }, [fetchAll]);

  return {
    data,
    loading,
    error,
    saving,
    fetchAll,
    create,
    update,
    remove,
    setData,
  };
}

// Hook for authentication
export function useAuth() {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      // TODO: Validate token with API
      setIsAuthenticated(true);
      const userData = localStorage.getItem('user');
      if (userData) {
        try {
          setUser(JSON.parse(userData));
        } catch {
          setUser(null);
        }
      }
    }
    setLoading(false);
  }, []);

  const login = useCallback(async (token: string, userData: any) => {
    localStorage.setItem('token', token);
    localStorage.setItem('user', JSON.stringify(userData));
    setUser(userData);
    setIsAuthenticated(true);
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    localStorage.removeItem('tenantId');
    setUser(null);
    setIsAuthenticated(false);
    window.location.href = '/login';
  }, []);

  return { user, loading, isAuthenticated, login, logout };
}

// Hook for pagination
export function usePagination<T>(
  fetchFn: (params: { page: number; limit: number }) => Promise<AxiosResponse<{ data: T[]; total: number }>>,
  initialLimit = 10
) {
  const [data, setData] = useState<T[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(initialLimit);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetchFn({ page, limit });
      setData(response.data.data);
      setTotal(response.data.total);
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Gagal memuat data');
    } finally {
      setLoading(false);
    }
  }, [fetchFn, page, limit]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const totalPages = Math.ceil(total / limit);

  return {
    data,
    total,
    page,
    limit,
    totalPages,
    loading,
    error,
    setPage,
    setLimit,
    refetch: fetchData,
  };
}

// Debounce hook for search
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}
