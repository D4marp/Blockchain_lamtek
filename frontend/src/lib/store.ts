import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  name: string;
  email: string;
  role: string;
  tenantId: string;
  noIdentitas?: string;
  noSertifikatEdukatif?: string;
  isActive?: boolean;
  createdAt?: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  tenantId: string | null;
  isAuthenticated: boolean;
  setAuth: (user: User, token: string) => void;
  setTenant: (tenantId: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      tenantId: null,
      isAuthenticated: false,
      setAuth: (user, token) => {
        set({ user, token, tenantId: user.tenantId, isAuthenticated: true });
        localStorage.setItem('token', token);
        localStorage.setItem('tenantId', user.tenantId);
      },
      setTenant: (tenantId) => {
        set({ tenantId });
        localStorage.setItem('tenantId', tenantId);
      },
      logout: () => {
        set({ user: null, token: null, tenantId: null, isAuthenticated: false });
        localStorage.removeItem('token');
        localStorage.removeItem('tenantId');
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);

interface SidebarState {
  isOpen: boolean;
  toggle: () => void;
  open: () => void;
  close: () => void;
}

export const useSidebarStore = create<SidebarState>((set) => ({
  isOpen: true,
  toggle: () => set((state) => ({ isOpen: !state.isOpen })),
  open: () => set({ isOpen: true }),
  close: () => set({ isOpen: false }),
}));

interface NotificationState {
  unreadCount: number;
  setUnreadCount: (count: number) => void;
  incrementUnread: () => void;
  clearUnread: () => void;
}

export const useNotificationStore = create<NotificationState>((set) => ({
  unreadCount: 0,
  setUnreadCount: (count) => set({ unreadCount: count }),
  incrementUnread: () => set((state) => ({ unreadCount: state.unreadCount + 1 })),
  clearUnread: () => set({ unreadCount: 0 }),
}));
