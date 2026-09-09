/* ====================================================
   KRUSHI MITHRA - WEB ADMIN PANEL JARS (ES6 JavaScript)
   Full REST API Integration, SPA Router & UI Controls
   ==================================================== */

const API_BASE = 'http://localhost:8080/api/v1';

let currentView = 'dashboard';
let globalData = {
  users: [],
  farmers: [],
  machines: [],
  workers: [],
  bookings: [],
  marketplace: [],
  store: [],
  categories: {},
  locations: [],
  reviews: [],
  notifications: [],
  banners: [],
  mobileContent: {},
  payments: [],
  support: [],
  adminUsers: [],
  activityLogs: [],
  settings: {},
  providerApplications: [],
};

let currentAdminLang = localStorage.getItem('krushi_admin_lang') || 'en';

const adminNavTranslations = {
  en: {
    dashboard: "Dashboard",
    users: "Users",
    farmers: "Farmers",
    machines: "Machines",
    workers: "Workers & Drivers",
    "provider-approvals": "Provider Approvals",
    bookings: "Bookings",
    marketplace: "Marketplace",
    store: "Agro Store",
    categories: "Categories",
    locations: "Locations",
    "mobile-manager": "Mobile App Manager",
    banners: "Banners & Promotions",
    notifications: "Notifications",
    reviews: "Reviews & Ratings",
    reports: "Reports & Analytics",
    payments: "Payments",
    support: "Support",
    "admin-users": "Admin Users",
    "activity-logs": "Activity Logs",
    settings: "Settings",
    searchPlaceholder: "Global Search: Machines, Farmers, Workers, Bookings..."
  },
  kn: {
    dashboard: "ಮುಖಪುಟ / ಡ್ಯಾಶ್‌ಬೋರ್ಡ್",
    users: "ಬಳಕೆದಾರರು",
    farmers: "ರೈತರು",
    machines: "ಯಂತ್ರಗಳು",
    workers: "ಕಾರ್ಮಿಕರು ಮತ್ತು ಚಾಲಕರು",
    "provider-approvals": "ಸೇವಾ ಪೂರೈಕೆದಾರರ ಅನುಮೋದನೆಗಳು",
    bookings: "ಬುಕಿಂಗ್‌ಗಳು",
    marketplace: "ಬೆಳೆ ಮಾರುಕಟ್ಟೆ",
    store: "ಅಗ್ರೋ ಸ್ಟೋರ್",
    categories: "ವರ್ಗಗಳು",
    locations: "ಸ್ಥಳಗಳು",
    "mobile-manager": "ಮೊಬೈಲ್ ಆ್ಯಪ್ ಮ್ಯಾನೇಜರ್",
    banners: "ಬ್ಯಾನರ್‌ಗಳು ಮತ್ತು ಪ್ರಚಾರಗಳು",
    notifications: "ಸೂಚನೆಗಳು",
    reviews: "ವಿಮರ್ಶೆಗಳು ಮತ್ತು ರೇಟಿಂಗ್‌ಗಳು",
    reports: "ವರದಿಗಳು ಮತ್ತು ವಿಶ್ಲೇಷಣೆ",
    payments: "ಪಾವತಿಗಳು",
    support: "ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ",
    "admin-users": "ಅಡ್ಮಿನ್ ಬಳಕೆದಾರರು",
    "activity-logs": "ಚಟುವಟಿಕೆ ದಾಖಲೆಗಳು",
    settings: "ಸಂಯೋಜನೆಗಳು",
    searchPlaceholder: "ಹುಡುಕಿ: ಯಂತ್ರಗಳು, ರೈತರು, ಕಾರ್ಮಿಕರು, ಬುಕಿಂಗ್‌ಗಳು..."
  },
  hi: {
    dashboard: "डैशबोर्ड",
    users: "उपयोगकर्ता",
    farmers: "किसान",
    machines: "मशीनें",
    workers: "श्रमिक और चालक",
    "provider-approvals": "प्रदाता अनुमोदन",
    bookings: "बुकिंग",
    marketplace: "फसल बाज़ार",
    store: "एग्रो स्टोर",
    categories: "श्रेणियां",
    locations: "स्थान",
    "mobile-manager": "मोबाइल ऐप प्रबंधक",
    banners: "बैनर और प्रचार",
    notifications: "सूचनाएं",
    reviews: "समीक्षाएं और रेटिंग",
    reports: "रिपोर्ट और विश्लेषण",
    payments: "भुगतान",
    support: "सहायता",
    "admin-users": "एडमिन उपयोगकर्ता",
    "activity-logs": "गतिविधि लॉग",
    settings: "सेटिंग्स",
    searchPlaceholder: "खोजें: मशीनें, किसान, श्रमिक, बुकिंग..."
  },
  te: {
    dashboard: "డాష్‌బోర్డ్",
    users: "యూజర్లు",
    farmers: "రైతులు",
    machines: "యంత్రాలు",
    workers: "కూలీలు మరియు డ్రైవర్లు",
    "provider-approvals": "సేవా ప్రదాత ఆమోదాలు",
    bookings: "బుకింగ్‌లు",
    marketplace: "పంట మార్కెట్",
    store: "అగ్రో స్టోర్",
    categories: "వర్గాలు",
    locations: "ప్రాంతాలు",
    "mobile-manager": "మొబైల్ యాప్ మేనేజర్",
    banners: "బ్యానర్లు",
    notifications: "నోటిఫికేషన్లు",
    reviews: "సమీక్షలు",
    reports: "నివేదికలు",
    payments: "చెల్లింపులు",
    support: "సహాయం",
    "admin-users": "అడ్మిన్ యూజర్లు",
    "activity-logs": "యాక్టివిటీ లాగ్‌లు",
    settings: "సెట్టింగ్‌లు",
    searchPlaceholder: "వెతకండి: యంత్రాలు, రైతులు, కూలీలు, బుకింగ్‌లు..."
  },
  ta: {
    dashboard: "டாஷ்போர்டு",
    users: "பயனர்கள்",
    farmers: "விவசாயிகள்",
    machines: "இயந்திரங்கள்",
    workers: "தொழிலாளர்கள்",
    "provider-approvals": "ஒப்புதல்கள்",
    bookings: "முன்பதிவுகள்",
    marketplace: "பயிர் சந்தை",
    store: "அக்ரோ ஸ்டோர்",
    categories: "பிரிவுகள்",
    locations: "இடங்கள்",
    "mobile-manager": "செயலி மேலாளர்",
    banners: "பேனர்கள்",
    notifications: "அறிவிப்புகள்",
    reviews: "மதிப்புரைகள்",
    reports: "அறிக்கைகள்",
    payments: "கட்டணங்கள்",
    support: "ஆதரவு",
    "admin-users": "நிர்வாகிகள்",
    "activity-logs": "செயல்பாடுகள்",
    settings: "அமைப்புகள்",
    searchPlaceholder: "தேடுங்கள்: இயந்திரங்கள், விவசாயிகள், தொழிலாளர்கள்..."
  }
};

function toggleLanguageMenu(event) {
  if (event) event.stopPropagation();
  const menu = document.getElementById('language-dropdown-menu');
  if (menu) {
    menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
  }
}

function changeAdminLanguage(langCode) {
  currentAdminLang = langCode;
  localStorage.setItem('krushi_admin_lang', langCode);
  applyAdminLanguage();
  const menu = document.getElementById('language-dropdown-menu');
  if (menu) menu.style.display = 'none';
  showToast(`Admin panel language updated to ${langCode.toUpperCase()}`, 'success');
}

function applyAdminLanguage() {
  const lang = currentAdminLang || 'en';
  const codeEl = document.getElementById('current-lang-code');
  if (codeEl) codeEl.textContent = lang.toUpperCase();

  const navs = adminNavTranslations[lang] || adminNavTranslations.en;

  document.querySelectorAll('.nav-item').forEach(item => {
    const view = item.dataset.view;
    if (view && navs[view]) {
      const textEl = item.querySelector('.nav-text');
      if (textEl) textEl.textContent = navs[view];
    }
  });

  const searchEl = document.getElementById('global-search');
  if (searchEl && navs.searchPlaceholder) {
    searchEl.placeholder = navs.searchPlaceholder;
  }

  ['en', 'kn', 'hi', 'te', 'ta'].forEach(c => {
    const el = document.getElementById(`lang-opt-${c}`);
    if (el) {
      if (c === lang) el.classList.add('active-lang');
      else el.classList.remove('active-lang');
    }
  });
}

document.addEventListener('click', (e) => {
  const langWrapper = document.querySelector('.language-selector-wrapper');
  const langMenu = document.getElementById('language-dropdown-menu');
  if (langMenu && langWrapper && !langWrapper.contains(e.target)) {
    langMenu.style.display = 'none';
  }
});

document.addEventListener('DOMContentLoaded', () => {
  checkAdminAuth();
});

function checkAdminAuth() {
  const token = localStorage.getItem('krushi_admin_token');
  const loginScreen = document.getElementById('admin-login-screen');
  const appContainer = document.getElementById('app-container');

  if (token) {
    if (loginScreen) loginScreen.style.display = 'none';
    if (appContainer) appContainer.style.display = 'flex';

    const savedUser = JSON.parse(localStorage.getItem('krushi_admin_user') || '{}');
    const nameEl = document.getElementById('current-admin-name');
    const roleEl = document.getElementById('current-admin-role');
    if (nameEl && savedUser.name) nameEl.textContent = savedUser.name;
    if (roleEl && savedUser.role) roleEl.textContent = savedUser.role;

    initSidebar();
    applyAdminLanguage();
    loadAllData().then(() => {
      switchView('dashboard');
    });
  } else {
    if (loginScreen) loginScreen.style.display = 'flex';
    if (appContainer) appContainer.style.display = 'none';
  }
}

async function handleAdminLogin(event) {
  event.preventDefault();
  const emailInput = document.getElementById('admin-email');
  const passwordInput = document.getElementById('admin-password');
  const errorMsg = document.getElementById('login-error-msg');
  const submitBtn = document.getElementById('admin-login-btn');

  const email = emailInput ? emailInput.value.trim() : '';
  const password = passwordInput ? passwordInput.value.trim() : '';

  if (!email || !password) {
    if (errorMsg) {
      errorMsg.textContent = 'Please enter both email and password.';
      errorMsg.style.display = 'block';
    }
    return;
  }

  if (submitBtn) submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Authenticating...';

  try {
    const res = await apiPost('/admin/login', { email, password });
    if (res && res.token) {
      localStorage.setItem('krushi_admin_token', res.token);
      localStorage.setItem('krushi_admin_user', JSON.stringify(res.user || { name: 'Bharath Admin', role: 'Super Administrator' }));

      if (errorMsg) errorMsg.style.display = 'none';
      showToast('Login successful! Welcome to Krushi Mithra Admin Portal.', 'success');
      checkAdminAuth();
    } else {
      if (errorMsg) {
        errorMsg.textContent = (res && res.error) ? res.error : 'Invalid credentials. Try: admin@krushimithra.com / admin123';
        errorMsg.style.display = 'block';
      }
    }
  } catch (e) {
    if (errorMsg) {
      errorMsg.textContent = 'Failed to connect to backend server. Make sure server is running.';
      errorMsg.style.display = 'block';
    }
  } finally {
    if (submitBtn) submitBtn.innerHTML = '<i class="fa-solid fa-right-to-bracket"></i> Sign In to Admin Portal';
  }
}

function quickAdminDemoLogin() {
  const emailInput = document.getElementById('admin-email');
  const passwordInput = document.getElementById('admin-password');
  if (emailInput) emailInput.value = 'admin@krushimithra.com';
  if (passwordInput) passwordInput.value = 'admin123';

  localStorage.setItem('krushi_admin_token', 'krushi_admin_jwt_token_secret_9988');
  localStorage.setItem('krushi_admin_user', JSON.stringify({
    name: 'Bharath Admin',
    role: 'Super Administrator',
    email: 'admin@krushimithra.com'
  }));
  showToast('Logged in as Super Admin!', 'success');
  checkAdminAuth();
}

function toggleAdminPasswordVisibility() {
  const passwordInput = document.getElementById('admin-password');
  const icon = document.getElementById('password-toggle-icon');
  if (!passwordInput) return;
  if (passwordInput.type === 'password') {
    passwordInput.type = 'text';
    if (icon) icon.className = 'fa-solid fa-eye-slash';
  } else {
    passwordInput.type = 'password';
    if (icon) icon.className = 'fa-solid fa-eye';
  }
}

function toggleAdminMenu() {
  const menu = document.getElementById('admin-dropdown-menu');
  if (menu) {
    menu.style.display = menu.style.display === 'none' || menu.style.display === '' ? 'block' : 'none';
  }
}

function handleAdminLogout() {
  localStorage.removeItem('krushi_admin_token');
  localStorage.removeItem('krushi_admin_user');
  const menu = document.getElementById('admin-dropdown-menu');
  if (menu) menu.style.display = 'none';
  showToast('Logged out of Admin Portal.', 'info');
  checkAdminAuth();
}

// --- API FETCH HELPERS ---
async function apiGet(endpoint) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`);
    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
    return await res.json();
  } catch (e) {
    console.warn(`API Get error on ${endpoint}:`, e);
    return null;
  }
}

async function apiPost(endpoint, data) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    const json = await res.json().catch(() => null);
    if (!res.ok) {
      const msg = (json && json.error) ? json.error : `HTTP Error ${res.status}`;
      showToast(`Failed to save data: ${msg}`, 'error');
      return null;
    }
    return json;
  } catch (e) {
    showToast('Failed to save data: Backend server is offline or unreachable', 'error');
    return null;
  }
}

async function apiPut(endpoint, data) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
    const json = await res.json().catch(() => null);
    if (!res.ok) {
      const msg = (json && json.error) ? json.error : `HTTP Error ${res.status}`;
      showToast(`Failed to update data: ${msg}`, 'error');
      return null;
    }
    return json;
  } catch (e) {
    showToast('Failed to update data: Backend server is offline or unreachable', 'error');
    return null;
  }
}

async function apiDelete(endpoint) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, { method: 'DELETE' });
    const json = await res.json().catch(() => null);
    if (!res.ok) {
      const msg = (json && json.error) ? json.error : `HTTP Error ${res.status}`;
      showToast(`Failed to delete item: ${msg}`, 'error');
      return null;
    }
    return json;
  } catch (e) {
    showToast('Failed to delete item: Backend server is offline or unreachable', 'error');
    return null;
  }
}

async function loadAllData() {
  const [
    users, farmers, machines, workers, bookings,
    marketplace, store, categories, locations,
    reviews, notifications, banners, mobileContent,
    payments, support, adminUsers, activityLogs, settings,
    providerApps
  ] = await Promise.all([
    apiGet('/users'),
    apiGet('/farmers'),
    apiGet('/machines'),
    apiGet('/workers'),
    apiGet('/bookings'),
    apiGet('/marketplace'),
    apiGet('/store'),
    apiGet('/categories'),
    apiGet('/locations'),
    apiGet('/reviews'),
    apiGet('/notifications'),
    apiGet('/banners'),
    apiGet('/mobile-content'),
    apiGet('/payments'),
    apiGet('/support'),
    apiGet('/admin-users'),
    apiGet('/activity-logs'),
    apiGet('/settings'),
    apiGet('/admin/provider-applications')
  ]);

  if (users) globalData.users = users;
  if (farmers) globalData.farmers = farmers;
  if (machines) globalData.machines = machines;
  if (workers) globalData.workers = workers;
  if (bookings) globalData.bookings = bookings;
  if (marketplace) globalData.marketplace = marketplace;
  if (store) globalData.store = store;
  if (categories) globalData.categories = categories;
  if (locations) globalData.locations = locations;
  if (reviews) globalData.reviews = reviews;
  if (notifications) globalData.notifications = notifications;
  if (banners) globalData.banners = banners;
  if (mobileContent) globalData.mobileContent = mobileContent;
  if (payments) globalData.payments = payments;
  if (support) globalData.support = support;
  if (adminUsers) globalData.adminUsers = adminUsers;
  if (activityLogs) globalData.activityLogs = activityLogs;
  if (settings) globalData.settings = settings;
  if (providerApps) globalData.providerApplications = providerApps;
}

// --- NAVIGATION & SIDEBAR ---
function initSidebar() {
  const toggleBtn = document.getElementById('toggle-sidebar');
  const sidebar = document.getElementById('sidebar');
  toggleBtn.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');
  });
}

function switchView(viewName) {
  currentView = viewName;
  document.querySelectorAll('.nav-item').forEach(el => {
    el.classList.toggle('active', el.dataset.view === viewName);
  });

  const contentArea = document.getElementById('content-area');
  contentArea.innerHTML = '<div style="padding:40px; text-align:center;"><i class="fa-solid fa-circle-notch fa-spin" style="font-size:32px; color:var(--primary);"></i><p style="margin-top:12px; color:var(--gray-text);">Loading Krushi Mithra Module...</p></div>';

  setTimeout(() => {
    switch (viewName) {
      case 'dashboard': renderDashboardView(); break;
      case 'users': renderUsersView(); break;
      case 'farmers': renderFarmersView(); break;
      case 'machines': renderMachinesView(); break;
      case 'workers': renderWorkersView(); break;
      case 'provider-approvals': renderProviderApprovalsView(); break;
      case 'bookings': renderBookingsView(); break;
      case 'marketplace': renderMarketplaceView(); break;
      case 'store': renderAgroStoreView(); break;
      case 'categories': renderCategoriesView(); break;
      case 'locations': renderLocationsView(); break;
      case 'reviews': renderReviewsView(); break;
      case 'notifications': renderNotificationsView(); break;
      case 'banners': renderBannersView(); break;
      case 'mobile-manager': renderMobileManagerView(); break;
      case 'reports': renderReportsView(); break;
      case 'payments': renderPaymentsView(); break;
      case 'support': renderSupportView(); break;
      case 'admin-users': renderAdminUsersView(); break;
      case 'activity-logs': renderActivityLogsView(); break;
      case 'settings': renderSettingsView(); break;
      default: renderDashboardView();
    }
  }, 100);
}

// ====================================================
// 1. DASHBOARD VIEW
// ====================================================
function renderDashboardView() {
  const container = document.getElementById('content-area');
  const totalMachines = globalData.machines.length;
  const availMachines = globalData.machines.filter(m => m.isAvailable).length;
  const totalWorkers = globalData.workers.length;
  const availWorkers = globalData.workers.filter(w => w.isAvailable).length;
  const pendingApps = globalData.providerApplications.filter(a => a.status === 'PENDING').length;

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title">🌾 Krushi Mithra Executive Dashboard</h1>
        <p class="page-subtitle">Digital Farming Marketplace & Agricultural Services Platform Overview</p>
      </div>
      <div>
        <button class="btn btn-primary" onclick="openAddMachineModal()"><i class="fa-solid fa-plus"></i> + Add Machine</button>
      </div>
    </div>

    <!-- QUICK ACTIONS BAR -->
    <div class="quick-actions-bar">
      <div class="quick-actions-title"><i class="fa-solid fa-bolt"></i> Platform Quick Actions</div>
      <div class="action-buttons-group">
        <button class="btn btn-sm btn-primary" onclick="openAddMachineModal()"><i class="fa-solid fa-tractor"></i> + Add Machine</button>
        <button class="btn btn-sm btn-orange" onclick="openAddWorkerModal()"><i class="fa-solid fa-user-plus"></i> + Add Worker</button>
        <button class="btn btn-sm btn-secondary" onclick="switchView('provider-approvals')"><i class="fa-solid fa-user-check"></i> Provider Approvals (${pendingApps})</button>
        <button class="btn btn-sm btn-secondary" onclick="openAddProductModal()"><i class="fa-solid fa-box"></i> + Add Product</button>
        <button class="btn btn-sm btn-secondary" onclick="switchView('notifications')"><i class="fa-solid fa-paper-plane"></i> Send Notification</button>
      </div>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card" style="border-left: 4px solid var(--accent-orange);">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-user-clock"></i></div>
          <span class="stat-badge ${pendingApps > 0 ? 'down' : 'up'}">${pendingApps} Pending</span>
        </div>
        <div class="stat-value">${pendingApps}</div>
        <div class="stat-label">Pending Provider Applications</div>
      </div>

      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-users"></i></div>
          <span class="stat-badge up">+12.5%</span>
        </div>
        <div class="stat-value">12,450</div>
        <div class="stat-label">Total Registered Farmers</div>
      </div>

      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-tractor"></i></div>
          <span class="stat-badge up">+8.4%</span>
        </div>
        <div class="stat-value">${totalMachines > 0 ? totalMachines : 1284}</div>
        <div class="stat-label">Machines Listed (${availMachines} Available)</div>
      </div>

      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-key"></i></div>
          <span class="stat-badge up">326 Active</span>
        </div>
        <div class="stat-value">1,842</div>
        <div class="stat-label">Total Rentals & Bookings</div>
      </div>

      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon purple"><i class="fa-solid fa-user-ninja"></i></div>
          <span class="stat-badge up">${availWorkers} Available</span>
        </div>
        <div class="stat-value">${totalWorkers > 0 ? totalWorkers : 582}</div>
        <div class="stat-label">Verified Farm Workers & Drivers</div>
      </div>

      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-indian-rupee-sign"></i></div>
          <span class="stat-badge up">+15.2%</span>
        </div>
        <div class="stat-value">₹8,42,500</div>
        <div class="stat-label">Monthly Gross Platform Revenue</div>
      </div>
    </div>

    <!-- CHARTS GRID -->
    <div class="charts-grid">
      <div class="chart-card">
        <div class="chart-header">
          <h3 class="chart-title"><i class="fa-solid fa-chart-area" style="color:var(--primary);"></i> Machine Rentals Overview</h3>
        </div>
        <div class="chart-container">
          <canvas id="rentalsChart"></canvas>
        </div>
      </div>

      <div class="chart-card">
        <div class="chart-header">
          <h3 class="chart-title"><i class="fa-solid fa-chart-pie" style="color:var(--accent-orange);"></i> Machine Category Popularity</h3>
        </div>
        <div class="chart-container">
          <canvas id="categoryChart"></canvas>
        </div>
      </div>
    </div>

    <!-- PENDING PROVIDER APPROVALS & RECENT BOOKINGS -->
    <div class="charts-grid">
      <div class="card-table-wrapper">
        <div class="card-header-bar">
          <h3 class="chart-title"><i class="fa-solid fa-user-clock" style="color:var(--accent-orange);"></i> Pending Provider Applications (${pendingApps})</h3>
          <button class="btn btn-sm btn-secondary" onclick="switchView('provider-approvals')">View All</button>
        </div>
        <table class="custom-table">
          <thead>
            <tr>
              <th>App ID</th>
              <th>Applicant</th>
              <th>Service / Machine</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            ${renderPendingProviderRows()}
          </tbody>
        </table>
      </div>

      <div class="card-table-wrapper">
        <div class="card-header-bar">
          <h3 class="chart-title"><i class="fa-solid fa-list-check" style="color:var(--primary);"></i> Recent Rental Bookings</h3>
          <button class="btn btn-sm btn-secondary" onclick="switchView('bookings')">View All</button>
        </div>
        <table class="custom-table">
          <thead>
            <tr>
              <th>Booking ID</th>
              <th>Machine / Worker</th>
              <th>Customer</th>
              <th>Amount</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            ${renderRecentBookingsRows()}
          </tbody>
        </table>
      </div>
    </div>
  `;

  initDashboardCharts();
}

function renderPendingProviderRows() {
  const pendingApps = globalData.providerApplications.filter(a => a.status === 'PENDING');
  if (pendingApps.length === 0) {
    return '<tr><td colspan="4" style="text-align:center; padding:20px; color:var(--gray-text);">No pending applications! All providers reviewed.</td></tr>';
  }
  return pendingApps.map(a => `
    <tr>
      <td><strong>${a.applicationId || a.id}</strong></td>
      <td>
        <div class="cell-avatar-title">
          <img src="${a.profilePhoto || 'https://via.placeholder.com/40'}" class="table-avatar-round" alt="">
          <div>
            <div class="cell-title-main">${a.userName}</div>
            <div class="cell-subtitle">${a.userPhone}</div>
          </div>
        </div>
      </td>
      <td>
        <div class="cell-title-main">${a.machineName || a.category}</div>
        <div class="cell-subtitle">₹${a.rentalPricePerDay}/day • ${a.userLocation}</div>
      </td>
      <td>
        <button class="btn btn-sm btn-primary" onclick="viewProviderApplicationModal('${a.id}')">Review & Approve</button>
      </td>
    </tr>
  `).join('');
}

function renderRecentBookingsRows() {
  return globalData.bookings.map(b => `
    <tr>
      <td><strong>${b.id}</strong></td>
      <td>${b.targetTitle}</td>
      <td>${b.customerName}</td>
      <td><strong>₹${b.totalAmount}</strong></td>
      <td><span class="badge ${b.bookingStatus === 'Completed' ? 'badge-green' : 'badge-orange'}">${b.bookingStatus}</span></td>
    </tr>
  `).join('');
}

function initDashboardCharts() {
  const ctxRentals = document.getElementById('rentalsChart');
  if (ctxRentals) {
    new Chart(ctxRentals, {
      type: 'line',
      data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
        datasets: [{
          label: 'Machine Rentals',
          data: [120, 190, 300, 250, 420, 510, 480, 560, 620],
          borderColor: '#176B3A',
          backgroundColor: 'rgba(23, 107, 58, 0.1)',
          fill: true,
          tension: 0.3
        }]
      },
      options: { responsive: true, maintainAspectRatio: false }
    });
  }

  const ctxCategory = document.getElementById('categoryChart');
  if (ctxCategory) {
    new Chart(ctxCategory, {
      type: 'doughnut',
      data: {
        labels: ['Tractors', 'Harvesters', 'Power Tillers', 'Borewell Rig', 'Brush Cutters'],
        datasets: [{
          data: [42, 25, 15, 10, 8],
          backgroundColor: ['#176B3A', '#F59E0B', '#2563EB', '#7E22CE', '#EC4899']
        }]
      },
      options: { responsive: true, maintainAspectRatio: false }
    });
  }
}

function capitalizeTitle(str) {
  if (!str) return '';
  return str.replace(/\b\w/g, l => l.toUpperCase()).replace(/Di\b/g, 'DI').replace(/Hp\b/g, 'HP');
}

let providerFilterStatus = 'All';

function renderProviderApprovalsView() {
  const container = document.getElementById('content-area');
  const apps = globalData.providerApplications || [];
  const pendingCount = apps.filter(a => a.status === 'PENDING').length;
  const approvedCount = apps.filter(a => a.status === 'APPROVED').length;
  const rejectedCount = apps.filter(a => a.status === 'REJECTED').length;

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-user-check" style="color:var(--primary-dark);"></i> Join as Worker / Machine Owner Approval System</h1>
        <p class="page-subtitle">Review user applications to list agricultural machinery or register as farm workers</p>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="card-header-bar">
        <div class="table-filters">
          <button class="btn btn-sm ${providerFilterStatus === 'All' ? 'btn-primary' : 'btn-secondary'}" onclick="providerFilterStatus='All'; filterProviderApps('All')">All Applications (${apps.length})</button>
          <button class="btn btn-sm ${providerFilterStatus === 'PENDING' ? 'btn-orange' : 'btn-secondary'}" onclick="providerFilterStatus='PENDING'; filterProviderApps('PENDING')">🟡 Pending Review (${pendingCount})</button>
          <button class="btn btn-sm ${providerFilterStatus === 'APPROVED' ? 'btn-primary' : 'btn-secondary'}" onclick="providerFilterStatus='APPROVED'; filterProviderApps('APPROVED')">🟢 Approved (${approvedCount})</button>
          <button class="btn btn-sm ${providerFilterStatus === 'REJECTED' ? 'btn-danger' : 'btn-secondary'}" onclick="providerFilterStatus='REJECTED'; filterProviderApps('REJECTED')">🔴 Rejected (${rejectedCount})</button>
        </div>
      </div>

      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="width:140px;">Application ID</th>
              <th style="min-width:180px;">Applicant User</th>
              <th style="width:140px;">Service Offered</th>
              <th style="min-width:170px;">Machine / Skill</th>
              <th style="width:130px;">Category</th>
              <th style="width:130px;">Location</th>
              <th style="width:110px;">Rate</th>
              <th style="width:140px;">Submitted Date</th>
              <th style="width:120px;">Status</th>
              <th style="min-width:160px;">Actions</th>
            </tr>
          </thead>
          <tbody id="provider-apps-table-body">
            ${renderProviderAppsRows(providerFilterStatus === 'All' ? apps : apps.filter(a => a.status === providerFilterStatus))}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderProviderAppsRows(appsList) {
  if (!appsList || appsList.length === 0) {
    return '<tr><td colspan="10" style="text-align:center; padding:24px; color:var(--gray-text);">No provider applications found for this filter.</td></tr>';
  }
  return appsList.map(a => `
    <tr>
      <td><strong style="color:var(--dark-text);">${a.applicationId || a.id}</strong></td>
      <td>
        <div class="cell-avatar-title">
          <img src="${a.profilePhoto || 'https://via.placeholder.com/40'}" class="table-avatar-round" alt="">
          <div>
            <div class="cell-title-main">${capitalizeTitle(a.userName)}</div>
            <div class="cell-subtitle">${a.userPhone || ''}</div>
          </div>
        </div>
      </td>
      <td style="white-space:nowrap;"><span class="badge badge-blue">${a.serviceType || 'Service'}</span></td>
      <td style="min-width:160px;"><strong>${capitalizeTitle(a.machineName || a.category)}</strong></td>
      <td style="white-space:nowrap;"><span class="badge badge-orange">${a.category || 'Agri'}</span></td>
      <td style="white-space:nowrap;">${a.userLocation || a.district || 'Shivamogga, KA'}</td>
      <td style="white-space:nowrap;"><strong style="color:var(--primary-dark);">₹${a.rentalPricePerDay || a.dailyRate || 0}</strong><span style="font-size:11px; color:var(--gray-text);">/day</span></td>
      <td style="white-space:nowrap;"><span style="font-size:12px;">${a.submittedAt || ''}</span></td>
      <td style="white-space:nowrap;">
        <span class="badge ${a.status === 'APPROVED' ? 'badge-green' : (a.status === 'REJECTED' ? 'badge-red' : 'badge-orange')}">
          ${a.status === 'APPROVED' ? '🟢 APPROVED' : (a.status === 'REJECTED' ? '🔴 REJECTED' : '🟡 PENDING')}
        </span>
      </td>
      <td>
        <div class="table-actions">
          <button class="btn btn-sm btn-secondary" onclick="viewProviderApplicationModal('${a.id}')" title="Review Application Details"><i class="fa-solid fa-eye"></i> Details & Preview</button>
        </div>
      </td>
    </tr>
  `).join('');
}

function filterProviderApps(status) {
  providerFilterStatus = status;
  renderProviderApprovalsView();
}

// --- PROVIDER APPLICATION DETAIL & IN-APP PREVIEW MODAL ---
function viewProviderApplicationModal(id) {
  const app = globalData.providerApplications.find(a => a.id === id);
  if (!app) return;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const modalFooter = document.getElementById('modal-footer');

  modalTitle.innerText = `Provider Application Review (${app.applicationId || app.id})`;

  modalBody.innerHTML = `
    <div style="display:grid; grid-template-columns: 1fr 300px; gap:20px;">
      <!-- APPLICATION DETAILS -->
      <div>
        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:16px; margin-bottom:16px;">
          <h4 style="font-size:14px; font-weight:700; margin-bottom:8px; color:var(--primary-dark);">1. Personal Details</h4>
          <p><strong>Name:</strong> ${app.userName}</p>
          <p><strong>Phone:</strong> ${app.userPhone}</p>
          <p><strong>Location:</strong> ${app.village}, ${app.taluk}, ${app.district}, ${app.state}</p>
        </div>

        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:16px; margin-bottom:16px;">
          <h4 style="font-size:14px; font-weight:700; margin-bottom:8px; color:var(--primary-dark);">2. Machine / Service Specification</h4>
          <p><strong>Service Type:</strong> ${app.serviceType}</p>
          <p><strong>Title:</strong> ${app.machineName || app.category}</p>
          <p><strong>Category:</strong> ${app.category}</p>
          <p><strong>Brand / Model:</strong> ${app.brand || ''} ${app.model || ''} (${app.horsePower || ''})</p>
          <p><strong>Rental Price:</strong> ₹${app.rentalPricePerDay} (${app.rentalType}) | Deposit: ₹${app.securityDeposit || 1000}</p>
          <p><strong>Description:</strong> ${app.description}</p>
        </div>

        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:16px; margin-bottom:16px;">
          <h4 style="font-size:14px; font-weight:700; margin-bottom:8px; color:var(--primary-dark);">3. Verification Documents & Terms Agreement</h4>
          <p><strong>Agreement Accepted:</strong> ✓ Accepted on ${app.acceptedDate || app.submittedAt}</p>
          <p><strong>Documents Uploaded:</strong> ${(app.documents || []).map(d => d.name || 'RC Copy').join(', ')}</p>
          ${app.rejectionReason ? `<p style="color:var(--red-alert); margin-top:8px;"><strong>Rejection Reason:</strong> ${app.rejectionReason}</p>` : ''}
        </div>
      </div>

      <!-- IN-APP PREVIEW CARD -->
      <div>
        <h4 style="font-size:12px; font-weight:700; text-align:center; margin-bottom:8px; color:var(--gray-text);">Farmer Mobile App Preview</h4>
        <div style="border:2px solid var(--border-color); border-radius:16px; padding:12px; background:white; box-shadow:var(--shadow-md);">
          <img src="${(app.images && app.images[0]) || 'https://via.placeholder.com/200'}" style="width:100%; height:130px; object-fit:cover; border-radius:10px;" alt="">
          <div style="margin-top:10px;">
            <div style="font-weight:700; font-size:14px; color:var(--dark-text);">${app.machineName || app.category}</div>
            <div style="font-size:11px; color:var(--gray-text); margin-top:2px;">📍 2.4 km • ${app.userLocation || 'Shivamogga'}</div>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:8px;">
              <span style="font-weight:700; font-size:14px; color:var(--primary-dark);">₹${app.rentalPricePerDay}/day</span>
              <span class="badge badge-green">🟢 Available</span>
            </div>
            <div style="font-size:11px; margin-top:8px; background:#F1F8F3; padding:6px; border-radius:6px; color:var(--primary-dark);">
              <strong>Owner:</strong> ${app.userName} (✓ Verified)
            </div>
          </div>
        </div>
      </div>
    </div>
  `;

  modalFooter.innerHTML = `
    <button class="btn btn-secondary" onclick="closeModal()">Close</button>
    ${app.status === 'PENDING' ? `
      <button class="btn btn-danger" onclick="rejectProviderApplicationModal('${app.id}')">Reject Application</button>
      <button class="btn btn-primary" onclick="approveProviderApplication('${app.id}')">✓ Approve Application</button>
    ` : `<span class="badge ${app.status === 'APPROVED' ? 'badge-green' : 'badge-red'}">Status: ${app.status}</span>`}
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function approveProviderApplication(id) {
  if (confirm('Are you sure you want to approve this provider application? The machine/worker will immediately be added to the public mobile app catalog under its category.')) {
    const res = await apiPost(`/admin/provider-applications/${id}/approve`, {});
    if (res && res.success) {
      showToast('Application APPROVED! Machine is now live in the mobile app catalog.', 'success');
      closeModal();
      await loadAllData();
      renderProviderApprovalsView();
    }
  }
}

function rejectProviderApplicationModal(id) {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const modalFooter = document.getElementById('modal-footer');

  modalTitle.innerText = 'Reject Provider Application';

  modalBody.innerHTML = `
    <div class="form-group">
      <label class="form-label">Select Rejection Reason *</label>
      <select id="rej-reason-select" class="form-control" onchange="document.getElementById('rej-notes').value = this.value">
        <option value="Please upload clearer machine ownership / RC document.">Incomplete Document / Unclear RC Proof</option>
        <option value="Machine details incomplete. Please specify manufacturing year and HP.">Incomplete Machine Details</option>
        <option value="Profile details incomplete. Please upload profile photo.">Incomplete Profile Info</option>
        <option value="Rental price out of platform market range. Please adjust rate.">Invalid Price Rate</option>
      </select>
    </div>
    <div class="form-group">
      <label class="form-label">Custom Rejection Reason Notes for User *</label>
      <textarea id="rej-notes" class="form-control">Please upload clearer machine ownership / RC document.</textarea>
    </div>
  `;

  modalFooter.innerHTML = `
    <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
    <button class="btn btn-danger" onclick="submitRejectProviderApplication('${id}')">Confirm Rejection</button>
  `;
}

async function submitRejectProviderApplication(id) {
  const reason = document.getElementById('rej-notes').value;
  if (!reason) {
    showToast('Rejection reason required', 'error');
    return;
  }

  const res = await apiPost(`/admin/provider-applications/${id}/reject`, { rejectionReason: reason });
  if (res && res.success) {
    showToast('Application REJECTED with reason feedback sent to user.', 'error');
    closeModal();
    await loadAllData();
    renderProviderApprovalsView();
  }
}

// ====================================================
// 2. USERS MANAGEMENT
// ====================================================
function renderUsersView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-users" style="color:var(--primary);"></i> Users Management</h1>
        <p class="page-subtitle">Manage all farmers, machine owners, workers, drivers, buyers, sellers and admins</p>
      </div>
      <button class="btn btn-primary" onclick="openAddUserModal()"><i class="fa-solid fa-user-plus"></i> + Add User</button>
    </div>

    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table" id="users-table">
          <thead>
            <tr>
              <th style="width:110px;">User ID</th>
              <th style="min-width:180px;">Profile</th>
              <th style="width:130px;">Phone</th>
              <th style="min-width:180px;">Email</th>
              <th style="width:130px;">Role</th>
              <th style="width:140px;">Location</th>
              <th style="width:120px;">Joined Date</th>
              <th style="width:100px;">Status</th>
              <th style="min-width:160px;">Actions</th>
            </tr>
          </thead>
          <tbody>
            ${renderUsersRows(globalData.users)}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderUsersRows(usersList) {
  if (!usersList || usersList.length === 0) {
    return '<tr><td colspan="9" style="text-align:center; padding:20px;">No users found.</td></tr>';
  }
  return usersList.map(u => `
    <tr>
      <td><strong>${u.id}</strong></td>
      <td>
        <div class="cell-avatar-title">
          <img src="${u.profilePhoto || 'https://via.placeholder.com/40'}" class="table-avatar-round" alt="">
          <div>
            <div class="cell-title-main">${u.name}</div>
            <div class="cell-subtitle">${u.isVerified ? '✓ Verified User' : 'Pending Verification'}</div>
          </div>
        </div>
      </td>
      <td style="white-space:nowrap;">${u.phone}</td>
      <td>${u.email}</td>
      <td style="white-space:nowrap;"><span class="badge badge-blue">${u.role}</span></td>
      <td style="white-space:nowrap;">${u.location}</td>
      <td style="white-space:nowrap;">${u.joinedDate}</td>
      <td style="white-space:nowrap;"><span class="badge ${u.status === 'Active' ? 'badge-green' : 'badge-red'}">${u.status}</span></td>
      <td>
        <div class="table-actions">
          <button class="btn btn-sm btn-whatsapp" onclick="openWhatsAppModal('user', '${u.id}')" title="Send WhatsApp Message"><i class="fa-brands fa-whatsapp"></i></button>
          <button class="btn btn-sm btn-secondary" onclick="viewUserDetails('${u.id}')">View</button>
          <button class="btn btn-sm btn-danger" onclick="deleteUser('${u.id}')">Delete</button>
        </div>
      </td>
    </tr>
  `).join('');
}

// ====================================================
// 3. FARMERS MANAGEMENT
// ====================================================
function renderFarmersView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-tractor" style="color:var(--primary-dark);"></i> Farmers Directory</h1>
        <p class="page-subtitle">Manage verified farmers, land holdings, crops and rental histories</p>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="width:110px;">Farmer ID</th>
              <th style="min-width:180px;">Farmer Name</th>
              <th style="width:160px;">Village / Taluk</th>
              <th style="width:130px;">District</th>
              <th style="width:110px;">Farm Size</th>
              <th style="min-width:150px;">Crops Grown</th>
              <th style="width:120px;">Verification</th>
              <th style="min-width:160px;">Actions</th>
            </tr>
          </thead>
          <tbody>
            ${globalData.farmers.map(f => `
              <tr>
                <td><strong>${f.id}</strong></td>
                <td>
                  <div class="cell-avatar-title">
                    <img src="${f.profilePhoto || 'https://via.placeholder.com/40'}" class="table-avatar-round" alt="">
                    <div>
                      <div class="cell-title-main">${f.name}</div>
                      <div class="cell-subtitle">${f.phone}</div>
                    </div>
                  </div>
                </td>
                <td>${f.village}, ${f.taluk}</td>
                <td style="white-space:nowrap;">${f.district}</td>
                <td style="white-space:nowrap;"><strong>${f.farmSizeAcres} Acres</strong></td>
                <td>${f.cropTypes ? f.cropTypes.join(', ') : 'Paddy, Arecanut'}</td>
                <td style="white-space:nowrap;"><span class="badge badge-green">${f.verificationStatus}</span></td>
                <td>
                  <div class="table-actions">
                    <button class="btn btn-sm btn-whatsapp" onclick="openWhatsAppModal('farmer', '${f.id}')" title="Send WhatsApp Message"><i class="fa-brands fa-whatsapp"></i></button>
                    <button class="btn btn-sm btn-secondary" onclick="viewFarmerDetails('${f.id}')">View</button>
                    <button class="btn btn-sm btn-danger" onclick="deleteFarmer('${f.id}')">Delete</button>
                  </div>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function viewFarmerDetails(id) {
  const f = globalData.farmers.find(farmer => farmer.id === id);
  if (!f) {
    showToast('Farmer record not found', 'error');
    return;
  }

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-tractor" style="color:var(--primary);"></i> Farmer Details - ${f.name} (${f.id})`;

  modalBody.innerHTML = `
    <div style="display:grid; grid-template-columns: 100px 1fr; gap:20px; align-items:start;">
      <div style="text-align:center;">
        <img src="${f.profilePhoto || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}" style="width:90px; height:90px; border-radius:50%; object-fit:cover; border:3px solid var(--primary-light); box-shadow:var(--shadow-md);">
        <span class="badge ${f.verificationStatus === 'Verified' ? 'badge-green' : 'badge-orange'}" style="margin-top:10px; display:inline-block;">${f.verificationStatus || 'Verified'}</span>
      </div>
      <div>
        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:14px; margin-bottom:12px;">
          <h4 style="font-size:14px; font-weight:700; color:var(--primary-dark); margin-bottom:8px;"><i class="fa-solid fa-id-card"></i> Personal Information</h4>
          <p style="margin-bottom:4px;"><strong>Farmer ID:</strong> ${f.id}</p>
          <p style="margin-bottom:4px;"><strong>Full Name:</strong> ${f.name}</p>
          <p style="margin-bottom:4px;"><strong>Mobile Phone:</strong> <a href="tel:${f.phone}" style="color:var(--primary); font-weight:600;">${f.phone}</a></p>
          <p style="margin-bottom:4px;"><strong>Location:</strong> ${f.village || ''}, ${f.taluk || ''}, ${f.district || 'Shivamogga'}, ${f.state || 'Karnataka'}</p>
        </div>

        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:14px; margin-bottom:12px;">
          <h4 style="font-size:14px; font-weight:700; color:var(--primary-dark); margin-bottom:8px;"><i class="fa-solid fa-wheat-awn"></i> Land & Agricultural Profile</h4>
          <p style="margin-bottom:4px;"><strong>Farm Size:</strong> <span class="badge badge-green">${f.farmSizeAcres || '12.5'} Acres</span></p>
          <p style="margin-bottom:4px;"><strong>Crops Cultivated:</strong> ${f.cropTypes ? f.cropTypes.join(', ') : 'Arecanut, Paddy, Pepper'}</p>
          <p style="margin-bottom:4px;"><strong>Soil Type / Water Source:</strong> Red Loamy Soil / Borewell & Canal</p>
        </div>

        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:14px;">
          <h4 style="font-size:14px; font-weight:700; color:var(--primary-dark); margin-bottom:8px;"><i class="fa-solid fa-clock-rotate-left"></i> Platform Activity</h4>
          <p style="margin-bottom:4px;"><strong>Registered On:</strong> ${f.registeredDate || '2026-01-15'}</p>
          <p style="margin-bottom:4px;"><strong>Bookings Made:</strong> 4 Successful Rentals</p>
        </div>
      </div>
    </div>
  `;

  if (submitBtn) {
    submitBtn.innerHTML = `<i class="fa-brands fa-whatsapp"></i> Send WhatsApp Message`;
    submitBtn.className = 'btn btn-whatsapp';
    submitBtn.onclick = () => {
      closeModal();
      openWhatsAppModal('farmer', f.id);
    };
  }

  document.getElementById('modal-overlay').classList.add('active');
}

function viewUserDetails(id) {
  const u = globalData.users.find(user => user.id === id);
  if (!u) {
    showToast('User record not found', 'error');
    return;
  }

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-user" style="color:var(--primary);"></i> User Profile Details - ${u.name} (${u.id})`;

  modalBody.innerHTML = `
    <div style="display:grid; grid-template-columns: 100px 1fr; gap:20px; align-items:start;">
      <div style="text-align:center;">
        <img src="${u.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'}" style="width:90px; height:90px; border-radius:50%; object-fit:cover; border:3px solid var(--primary-light); box-shadow:var(--shadow-md);">
        <span class="badge ${u.status === 'Active' ? 'badge-green' : 'badge-red'}" style="margin-top:10px; display:inline-block;">${u.status || 'Active'}</span>
      </div>
      <div>
        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:14px; margin-bottom:12px;">
          <h4 style="font-size:14px; font-weight:700; color:var(--primary-dark); margin-bottom:8px;"><i class="fa-solid fa-id-card"></i> User Profile</h4>
          <p style="margin-bottom:4px;"><strong>User ID:</strong> ${u.id}</p>
          <p style="margin-bottom:4px;"><strong>Full Name:</strong> ${u.name}</p>
          <p style="margin-bottom:4px;"><strong>Phone:</strong> <a href="tel:${u.phone}" style="color:var(--primary); font-weight:600;">${u.phone}</a></p>
          <p style="margin-bottom:4px;"><strong>Email:</strong> ${u.email || 'N/A'}</p>
          <p style="margin-bottom:4px;"><strong>Platform Role:</strong> <span class="badge badge-blue">${u.role}</span></p>
          <p style="margin-bottom:4px;"><strong>Location:</strong> ${u.location || 'Shivamogga, KA'}</p>
          <p style="margin-bottom:4px;"><strong>Joined Date:</strong> ${u.joinedDate || '2026-01-10'}</p>
        </div>
      </div>
    </div>
  `;

  if (submitBtn) {
    submitBtn.innerHTML = `<i class="fa-brands fa-whatsapp"></i> Send WhatsApp Message`;
    submitBtn.className = 'btn btn-whatsapp';
    submitBtn.onclick = () => {
      closeModal();
      openWhatsAppModal('user', u.id);
    };
  }

  document.getElementById('modal-overlay').classList.add('active');
}

// ====================================================
// 4. MACHINES MANAGEMENT
// ====================================================
function renderMachinesView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-gear" style="color:var(--accent-orange);"></i> Machinery Management Center</h1>
        <p class="page-subtitle">Control tractor, harvester, power tiller listings, rental rates & real-time availability</p>
      </div>
      <button class="btn btn-primary" onclick="openAddMachineModal()"><i class="fa-solid fa-plus"></i> + Add Machine</button>
    </div>

    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="width:70px; text-align:center;">Image</th>
              <th style="min-width:200px;">Machine Name</th>
              <th style="width:140px;">Category</th>
              <th style="min-width:150px;">Owner</th>
              <th style="width:130px;">Location</th>
              <th style="width:120px;">Rental Price</th>
              <th style="width:130px;">Availability</th>
              <th style="width:100px;">Rating</th>
              <th style="width:120px;">Verification</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            ${renderMachinesRows(globalData.machines)}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function formatImageUrl(url, category) {
  if (!url || typeof url !== 'string' || url.startsWith('assets/')) {
    if (category === 'Harvesters') return 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800';
    if (category === 'Power Tillers') return 'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800';
    if (category === 'Brush Cutters') return 'https://images.unsplash.com/photo-1592417817098-8f3d6ef23a28?w=800';
    if (category === 'Borewell Machines') return 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800';
    return 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';
  }
  if (url.includes('mahindra') || url.includes('tractor')) return 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';
  if (url.includes('kubota') || url.includes('harvester')) return 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800';
  if (url.includes('tiller')) return 'https://images.unsplash.com/photo-1530267981608-bc7e96a40a58?w=800';
  return url;
}

function capitalizeMachineName(str) {
  if (!str) return 'Agricultural Machine';
  return str.replace(/\b\w/g, l => l.toUpperCase()).replace(/Di\b/g, 'DI').replace(/Hp\b/g, 'HP');
}

function renderMachinesRows(machinesList) {
  if (!machinesList || machinesList.length === 0) {
    return '<tr><td colspan="10" style="text-align:center; padding:20px;">No machines found.</td></tr>';
  }
  return machinesList.map(m => `
    <tr>
      <td style="text-align:center;"><img src="${formatImageUrl(m.images && m.images[0], m.category)}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';" class="table-avatar-card" style="cursor:pointer;" onclick="openEditMachineModal('${m.id}')" title="Click to edit photo & machine listing" alt=""></td>
      <td style="min-width: 180px;">
        <div class="cell-title-main" onclick="openEditMachineModal('${m.id}')" style="cursor:pointer; color:var(--dark-text);" title="Click to edit machine details">
          ${capitalizeMachineName(m.name)} <i class="fa-solid fa-pen-to-square" style="font-size:11px; color:var(--primary); margin-left:3px;"></i>
        </div>
        <div class="cell-subtitle">${m.brand || ''} ${m.model || ''} ${m.horsePower ? '• ' + m.horsePower : ''}</div>
      </td>
      <td style="white-space: nowrap;"><span class="badge badge-orange">${m.category || 'Tractors'}</span></td>
      <td style="white-space: nowrap;"><strong>${m.ownerName || 'Owner'}</strong><br><span class="cell-subtitle">${m.ownerPhone || ''}</span></td>
      <td style="white-space: nowrap;">${m.location || 'Shivamogga, KA'}</td>
      <td style="white-space: nowrap;"><strong style="color:var(--primary-dark);">₹${m.rentalPricePerDay || m.price || 0}</strong><span style="font-size:11px; color:var(--gray-text);">/${m.rentalType === 'Per Hour' ? 'hr' : 'day'}</span></td>
      <td style="white-space: nowrap;">
        <button class="btn btn-sm ${m.isAvailable ? 'btn-primary' : 'btn-secondary'}" onclick="toggleMachineAvailability('${m.id}', ${!m.isAvailable})">
          ${m.isAvailable ? '✓ Available' : '✖ Unavailable'}
        </button>
      </td>
      <td style="white-space: nowrap;">⭐ ${m.rating || 5.0} <span style="font-size:11px; color:var(--gray-text);">(${m.reviewCount || 0})</span></td>
      <td style="white-space: nowrap;"><span class="badge ${m.verificationStatus === 'Verified' ? 'badge-green' : 'badge-orange'}">${m.verificationStatus || 'Pending'}</span></td>
      <td>
        <div class="table-actions">
          <button class="btn btn-sm btn-whatsapp" onclick="openWhatsAppModal('machine', '${m.id}')" title="Send WhatsApp Message"><i class="fa-brands fa-whatsapp"></i></button>
          <button class="btn btn-sm btn-primary" onclick="openEditMachineModal('${m.id}')" title="Edit Machine Listing"><i class="fa-solid fa-pen-to-square"></i> Edit</button>
          <button class="btn btn-sm btn-secondary" onclick="openMachineDetailModal('${m.id}')" title="View Detail & Availability"><i class="fa-solid fa-calendar-days"></i> Detail</button>
          <button class="btn btn-sm btn-danger" onclick="deleteMachine('${m.id}')" title="Delete Listing"><i class="fa-solid fa-trash"></i></button>
        </div>
      </td>
    </tr>
  `).join('');
}

async function toggleMachineAvailability(id, newStatus) {
  const updated = await apiPut(`/machines/${id}/availability`, {
    isAvailable: newStatus,
    availabilityStatus: newStatus ? 'Available' : 'Unavailable'
  });
  if (updated) {
    showToast(`Machine availability updated to ${newStatus ? 'AVAILABLE' : 'UNAVAILABLE'} (Synced to Mobile App)`, 'success');
    await loadAllData();
    renderMachinesView();
  }
}

function openAddMachineModal() {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerText = '+ Add New Agricultural Machine';
  submitBtn.innerText = 'Save & List Machine';
  submitBtn.onclick = () => submitAddMachineForm();

  modalBody.innerHTML = `
    <form id="add-machine-form">
      <!-- Photo Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Machine Photo / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="m-add-img-preview" src="https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Machine Photo">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Photo Image URL</label>
            <input type="text" id="m-add-img" class="form-control" value="https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800" 
              placeholder="Paste photo URL (https://...)" 
              oninput="document.getElementById('m-add-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'm-add-img', 'm-add-img-preview')">🚜 Tractor</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800', 'm-add-img', 'm-add-img-preview')">🌾 Harvester</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1530267981608-bc7e96a40a58?w=800', 'm-add-img', 'm-add-img-preview')">⚙️ Tiller</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="m-add-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'm-add-img', 'm-add-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('m-add-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group full">
          <label class="form-label">Machine Name *</label>
          <input type="text" id="m-name" class="form-control" placeholder="e.g. Mahindra 575 DI Tractor (45 HP)" required>
        </div>
        <div class="form-group">
          <label class="form-label">Category *</label>
          <select id="m-category" class="form-control">
            <option value="Tractors">Tractors</option>
            <option value="Harvesters">Harvesters</option>
            <option value="Power Tillers">Power Tillers</option>
            <option value="Rotavators">Rotavators</option>
            <option value="Borewell Machines">Borewell Machines</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Rental Price (₹) *</label>
          <input type="number" id="m-price" class="form-control" placeholder="2200" required>
        </div>
        <div class="form-group">
          <label class="form-label">Owner Name *</label>
          <input type="text" id="m-owner" class="form-control" placeholder="Suresh Patil" required>
        </div>
        <div class="form-group">
          <label class="form-label">Owner Phone *</label>
          <input type="text" id="m-phone" class="form-control" placeholder="+91 8310856407" required>
        </div>
        <div class="form-group">
          <label class="form-label">Location</label>
          <input type="text" id="m-location" class="form-control" value="Shivamogga, KA">
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitAddMachineForm() {
  const name = document.getElementById('m-name').value;
  const price = parseFloat(document.getElementById('m-price').value);
  const owner = document.getElementById('m-owner').value;
  const phone = document.getElementById('m-phone').value;
  const photoUrl = document.getElementById('m-add-img').value;

  if (!name || !price || !owner || !phone) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  const newMachine = {
    name: name,
    category: document.getElementById('m-category').value,
    rentalPricePerDay: price,
    ownerName: owner,
    ownerPhone: phone,
    location: document.getElementById('m-location').value || 'Shivamogga, KA',
    images: photoUrl ? [photoUrl] : ['https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'],
    isAvailable: true,
    verificationStatus: 'Verified',
    status: 'Approved',
  };

  const res = await apiPost('/machines', newMachine);
  if (res) {
    showToast('Machine listed live in mobile catalog!', 'success');
    closeModal();
    await loadAllData();
    renderMachinesView();
  }
}

function setMachinePhotoPreset(url, inputId, previewId) {
  document.getElementById(inputId).value = url;
  document.getElementById(previewId).src = url;
}

function handleImageFileSelect(fileInput, inputId, previewId) {
  const file = fileInput.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      const img = new Image();
      img.onload = function () {
        const canvas = document.createElement('canvas');
        const maxW = 800;
        const maxH = 600;
        let w = img.width;
        let h = img.height;
        if (w > maxW || h > maxH) {
          if (w / h > maxW / maxH) {
            h = Math.round(h * (maxW / w));
            w = maxW;
          } else {
            w = Math.round(w * (maxH / h));
            h = maxH;
          }
        }
        canvas.width = w;
        canvas.height = h;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, w, h);
        const resizedDataUrl = canvas.toDataURL('image/jpeg', 0.82);

        document.getElementById(inputId).value = resizedDataUrl;
        document.getElementById(previewId).src = resizedDataUrl;
        showToast('Photo uploaded & optimized successfully!', 'success');
      };
      img.src = e.target.result;
    };
    reader.readAsDataURL(file);
  }
}

function openEditMachineModal(id) {
  const machine = globalData.machines.find(m => m.id === id);
  if (!machine) return;

  const currentImg = (machine.images && machine.images[0]) ? machine.images[0] : (machine.image || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800');

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Machine Listing`;
  submitBtn.innerText = 'Save Changes';
  submitBtn.onclick = () => submitEditMachineForm(id);

  modalBody.innerHTML = `
    <form id="edit-machine-form">
      <!-- Photo Editing Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Machine Photo / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="m-edit-img-preview" src="${currentImg}" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Machine Photo">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Photo Image URL</label>
            <input type="text" id="m-edit-img" class="form-control" value="${currentImg}" 
              placeholder="Paste photo URL (https://...)" 
              oninput="document.getElementById('m-edit-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'm-edit-img', 'm-edit-img-preview')">🚜 Tractor</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800', 'm-edit-img', 'm-edit-img-preview')">🌾 Harvester</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1589923188900-85dae523342b?w=800', 'm-edit-img', 'm-edit-img-preview')">⚙️ Tiller</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1617575521317-864339cd58a1?w=800', 'm-edit-img', 'm-edit-img-preview')">🌿 Bush Cutter</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=800', 'm-edit-img', 'm-edit-img-preview')">💧 Borewell Rig</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="m-edit-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'm-edit-img', 'm-edit-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('m-edit-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group full">
          <label class="form-label">Machine Name *</label>
          <input type="text" id="m-edit-name" class="form-control" value="${machine.name || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Category *</label>
          <select id="m-edit-category" class="form-control">
            <option value="Tractors" ${machine.category === 'Tractors' ? 'selected' : ''}>Tractors</option>
            <option value="Harvesters" ${machine.category === 'Harvesters' ? 'selected' : ''}>Harvesters</option>
            <option value="Power Tillers" ${machine.category === 'Power Tillers' ? 'selected' : ''}>Power Tillers</option>
            <option value="Bush Cutters" ${machine.category === 'Bush Cutters' ? 'selected' : ''}>Bush Cutters</option>
            <option value="Borewell Machines" ${machine.category === 'Borewell Machines' ? 'selected' : ''}>Borewell Machines</option>
            <option value="Rotavators" ${machine.category === 'Rotavators' ? 'selected' : ''}>Rotavators</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Rental Price (₹ / day) *</label>
          <input type="number" id="m-edit-price" class="form-control" value="${machine.rentalPricePerDay || 0}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Owner Name *</label>
          <input type="text" id="m-edit-owner" class="form-control" value="${machine.ownerName || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Owner Phone *</label>
          <input type="text" id="m-edit-phone" class="form-control" value="${machine.ownerPhone || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Location</label>
          <input type="text" id="m-edit-location" class="form-control" value="${machine.location || ''}">
        </div>
        <div class="form-group">
          <label class="form-label">Horsepower / Spec</label>
          <input type="text" id="m-edit-hp" class="form-control" value="${machine.horsePower || ''}">
        </div>
        <div class="form-group">
          <label class="form-label">Verification Status</label>
          <select id="m-edit-verification" class="form-control">
            <option value="Verified" ${machine.verificationStatus === 'Verified' ? 'selected' : ''}>Verified</option>
            <option value="Pending" ${machine.verificationStatus === 'Pending' ? 'selected' : ''}>Pending</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Availability Status</label>
          <select id="m-edit-available" class="form-control">
            <option value="true" ${machine.isAvailable ? 'selected' : ''}>Available</option>
            <option value="false" ${!machine.isAvailable ? 'selected' : ''}>Unavailable</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditMachineForm(id) {
  const name = document.getElementById('m-edit-name').value;
  const price = parseFloat(document.getElementById('m-edit-price').value);
  const owner = document.getElementById('m-edit-owner').value;
  const phone = document.getElementById('m-edit-phone').value;
  const photoUrl = document.getElementById('m-edit-img').value;

  if (!name || !price || !owner || !phone) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  const finalPhoto = photoUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';

  const updatedData = {
    name: name,
    category: document.getElementById('m-edit-category').value,
    rentalPricePerDay: price,
    ownerName: owner,
    ownerPhone: phone,
    location: document.getElementById('m-edit-location').value,
    horsePower: document.getElementById('m-edit-hp').value,
    verificationStatus: document.getElementById('m-edit-verification').value,
    isAvailable: document.getElementById('m-edit-available').value === 'true',
    availabilityStatus: document.getElementById('m-edit-available').value === 'true' ? 'Available' : 'Unavailable',
    image: finalPhoto,
    images: [finalPhoto],
  };

  const res = await apiPut(`/machines/${id}`, updatedData);
  if (res) {
    showToast('Machine details & photo updated successfully! (Synced to mobile app)', 'success');
    closeModal();
    await loadAllData();
    renderMachinesView();
  }
}

function openMachineDetailModal(id) {
  const machine = globalData.machines.find(m => m.id === id);
  if (!machine) return;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerText = `Machine Details & Availability Control`;
  submitBtn.innerText = 'Close';
  submitBtn.onclick = () => closeModal();

  modalBody.innerHTML = `
    <div style="display:flex; gap:20px; margin-bottom:20px; align-items:center;">
      <img src="${machine.images[0] || 'https://via.placeholder.com/100'}" style="width:110px; height:90px; object-fit:cover; border-radius:8px;" alt="">
      <div>
        <h2 style="font-size:18px; font-weight:700;">${machine.name}</h2>
        <p style="font-size:13px; color:var(--gray-text);">Owner: <strong>${machine.ownerName}</strong> (${machine.ownerPhone})</p>
        <p style="font-size:13px; color:var(--primary-dark); font-weight:700;">Price: ₹${machine.rentalPricePerDay}/day</p>
      </div>
    </div>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

// ====================================================
// 5. WORKERS & DRIVERS MANAGEMENT
// ====================================================
function renderWorkersView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-user-ninja" style="color:var(--primary);"></i> Workers & Drivers Management</h1>
        <p class="page-subtitle">Manage tractor drivers, combine operators, arecanut tree climbers & harvesting teams</p>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="min-width:180px;">Worker Profile</th>
              <th style="width:140px;">Category / Skill</th>
              <th style="width:110px;">Experience</th>
              <th style="width:110px;">Daily Rate</th>
              <th style="width:130px;">Location</th>
              <th style="width:110px;">Availability</th>
              <th style="width:110px;">Verification</th>
              <th style="min-width:180px;">Actions</th>
            </tr>
          </thead>
          <tbody>
            ${globalData.workers.map(w => `
              <tr>
                <td>
                  <div class="cell-avatar-title">
                    <img src="${w.profilePhoto || 'https://via.placeholder.com/40'}" class="table-avatar-round" alt="">
                    <div>
                      <div class="cell-title-main">${w.name}</div>
                      <div class="cell-subtitle">${w.phone}</div>
                    </div>
                  </div>
                </td>
                <td style="white-space:nowrap;"><span class="badge badge-blue">${w.category || w.skills[0]}</span></td>
                <td style="white-space:nowrap;">${w.experienceYears} Years</td>
                <td style="white-space:nowrap;"><strong style="color:var(--primary-dark);">₹${w.dailyRate}</strong>/day</td>
                <td style="white-space:nowrap;">${w.location}</td>
                <td style="white-space:nowrap;"><span class="badge ${w.isAvailable ? 'badge-green' : 'badge-red'}">${w.isAvailable ? 'Available' : 'Busy'}</span></td>
                <td style="white-space:nowrap;"><span class="badge badge-green">${w.isVerified ? '✓ Verified' : 'Pending'}</span></td>
                <td>
                  <div class="table-actions">
                    <button class="btn btn-sm btn-whatsapp" onclick="openWhatsAppModal('worker', '${w.id}')" title="Send WhatsApp Message"><i class="fa-brands fa-whatsapp"></i> WhatsApp</button>
                    <button class="btn btn-sm btn-primary" onclick="openEditWorkerModal('${w.id}')" title="Edit Worker Profile"><i class="fa-solid fa-pen-to-square"></i> Edit</button>
                    <button class="btn btn-sm btn-danger" onclick="deleteWorker('${w.id}')" title="Delete Record"><i class="fa-solid fa-trash"></i> Delete</button>
                  </div>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function openEditWorkerModal(id) {
  const worker = globalData.workers.find(w => w.id === id);
  if (!worker) return;

  const currentPhoto = worker.profilePhoto || 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400';

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Worker / Driver Profile`;
  submitBtn.innerText = 'Save Changes';
  submitBtn.onclick = () => submitEditWorkerForm(id);

  modalBody.innerHTML = `
    <form id="edit-worker-form">
      <!-- Photo Editing Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Worker Profile Photo Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="w-edit-img-preview" src="${currentPhoto}" 
              style="width:90px; height:90px; object-fit:cover; border-radius:50%; border:3px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Worker Photo">
            <span style="position:absolute; bottom:0; right:0; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Photo</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Profile Photo URL</label>
            <input type="text" id="w-edit-img" class="form-control" value="${currentPhoto}" 
              placeholder="Paste photo URL (https://...)" 
              oninput="document.getElementById('w-edit-img-preview').src = this.value || 'https://via.placeholder.com/90'">

            <div style="margin-top:10px;">
              <input type="file" id="w-edit-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'w-edit-img', 'w-edit-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('w-edit-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload New Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group full">
          <label class="form-label">Worker Name *</label>
          <input type="text" id="w-edit-name" class="form-control" value="${worker.name || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Phone *</label>
          <input type="text" id="w-edit-phone" class="form-control" value="${worker.phone || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Category / Skill *</label>
          <select id="w-edit-category" class="form-control">
            <option value="Tractor Driver" ${worker.category === 'Tractor Driver' ? 'selected' : ''}>Tractor Driver</option>
            <option value="Harvester Operator" ${worker.category === 'Harvester Operator' ? 'selected' : ''}>Harvester Operator</option>
            <option value="Tree Climber" ${worker.category === 'Tree Climber' ? 'selected' : ''}>Tree Climber</option>
            <option value="General Farm Worker" ${worker.category === 'General Farm Worker' ? 'selected' : ''}>General Farm Worker</option>
            <option value="Plantation Worker" ${worker.category === 'Plantation Worker' ? 'selected' : ''}>Plantation Worker</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Daily Rate (₹) *</label>
          <input type="number" id="w-edit-rate" class="form-control" value="${worker.dailyRate || 0}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Experience (Years)</label>
          <input type="number" id="w-edit-exp" class="form-control" value="${worker.experienceYears || 0}">
        </div>
        <div class="form-group">
          <label class="form-label">Location</label>
          <input type="text" id="w-edit-location" class="form-control" value="${worker.location || ''}">
        </div>
        <div class="form-group">
          <label class="form-label">Verification</label>
          <select id="w-edit-verified" class="form-control">
            <option value="true" ${worker.isVerified ? 'selected' : ''}>Verified</option>
            <option value="false" ${!worker.isVerified ? 'selected' : ''}>Pending</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Availability</label>
          <select id="w-edit-available" class="form-control">
            <option value="true" ${worker.isAvailable ? 'selected' : ''}>Available</option>
            <option value="false" ${!worker.isAvailable ? 'selected' : ''}>Busy / Unavailable</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditWorkerForm(id) {
  const name = document.getElementById('w-edit-name').value;
  const rate = parseFloat(document.getElementById('w-edit-rate').value);
  const phone = document.getElementById('w-edit-phone').value;
  const photoUrl = document.getElementById('w-edit-img').value;

  if (!name || !rate || !phone) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  const updatedData = {
    name: name,
    phone: phone,
    category: document.getElementById('w-edit-category').value,
    dailyRate: rate,
    experienceYears: parseInt(document.getElementById('w-edit-exp').value) || 0,
    location: document.getElementById('w-edit-location').value,
    isVerified: document.getElementById('w-edit-verified').value === 'true',
    isAvailable: document.getElementById('w-edit-available').value === 'true',
    availabilityStatus: document.getElementById('w-edit-available').value === 'true' ? 'Available' : 'Unavailable',
    profilePhoto: photoUrl || 'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=400',
  };

  const res = await apiPut(`/workers/${id}`, updatedData);
  if (res) {
    showToast('Worker profile & photo updated successfully!', 'success');
    closeModal();
    await loadAllData();
    renderWorkersView();
  }
}

// ====================================================
// 6. BOOKINGS MANAGEMENT
// ====================================================
let bookingStatusFilter = 'ALL';
let bookingSearchQuery = '';

function renderBookingsView() {
  const container = document.getElementById('content-area');
  const bookings = globalData.bookings || [];

  const totalBookings = bookings.length;
  const completed = bookings.filter(b => (b.bookingStatus || '').toLowerCase() === 'completed').length;
  const pending = bookings.filter(b => (b.bookingStatus || '').toLowerCase() === 'pending').length;
  const active = bookings.filter(b => ['confirmed', 'in progress', 'active'].includes((b.bookingStatus || '').toLowerCase())).length;
  const totalRevenue = bookings.reduce((acc, b) => acc + (Number(b.totalAmount) || 0), 0);

  const filteredBookings = bookings.filter(b => {
    const matchStatus = bookingStatusFilter === 'ALL' || (b.bookingStatus || '').toUpperCase() === bookingStatusFilter;
    const q = bookingSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (b.id && b.id.toLowerCase().includes(q)) ||
      (b.targetTitle && b.targetTitle.toLowerCase().includes(q)) ||
      (b.customerName && b.customerName.toLowerCase().includes(q)) ||
      (b.providerName && b.providerName.toLowerCase().includes(q)) ||
      (b.serviceLocation && b.serviceLocation.toLowerCase().includes(q));
    return matchStatus && matchSearch;
  });

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> Bookings & Rental Management</h1>
        <p class="page-subtitle">Track farm machinery rentals, worker hiring orders, and payment statuses</p>
      </div>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-calendar-day"></i></div>
          <span class="stat-badge up">Live</span>
        </div>
        <div class="stat-value">${totalBookings}</div>
        <div class="stat-label">Total Bookings</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-hourglass-half"></i></div>
          <span class="stat-badge ${pending > 0 ? 'down' : 'up'}">${pending} Pending</span>
        </div>
        <div class="stat-value">${pending}</div>
        <div class="stat-label">Awaiting Confirmation</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-person-digging"></i></div>
          <span class="stat-badge up">In Action</span>
        </div>
        <div class="stat-value">${active}</div>
        <div class="stat-label">Active / In Progress</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-indian-rupee-sign"></i></div>
          <span class="stat-badge up">GMV</span>
        </div>
        <div class="stat-value">₹${totalRevenue.toLocaleString()}</div>
        <div class="stat-label">Total Rental Value</div>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="card-header-bar">
        <div class="table-filters">
          <div class="filter-input-wrap">
            <i class="fa-solid fa-magnifying-glass filter-icon"></i>
            <input type="text" class="filter-input" placeholder="Search customer, equipment, booking ID..." value="${bookingSearchQuery}" oninput="bookingSearchQuery=this.value; renderBookingsRows();">
          </div>
          <select class="filter-select" onchange="bookingStatusFilter=this.value; renderBookingsView();">
            <option value="ALL" ${bookingStatusFilter === 'ALL' ? 'selected' : ''}>All Statuses</option>
            <option value="PENDING" ${bookingStatusFilter === 'PENDING' ? 'selected' : ''}>Pending</option>
            <option value="CONFIRMED" ${bookingStatusFilter === 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
            <option value="COMPLETED" ${bookingStatusFilter === 'COMPLETED' ? 'selected' : ''}>Completed</option>
            <option value="CANCELLED" ${bookingStatusFilter === 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
          </select>
        </div>
        <div class="table-info-counter">
          <span>Showing <strong>${filteredBookings.length}</strong> bookings</span>
        </div>
      </div>

      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="width:110px;">Booking ID</th>
              <th style="min-width:190px;">Equipment / Worker</th>
              <th style="width:110px;">Type</th>
              <th style="min-width:150px;">Customer</th>
              <th style="min-width:150px;">Provider</th>
              <th style="width:130px;">Dates</th>
              <th style="width:110px;">Amount</th>
              <th style="width:110px;">Status</th>
              <th style="min-width:170px;">Actions</th>
            </tr>
          </thead>
          <tbody id="bookings-tbody">
            ${renderBookingsTableRows(filteredBookings)}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderBookingsRows() {
  const bookings = globalData.bookings || [];
  const filtered = bookings.filter(b => {
    const matchStatus = bookingStatusFilter === 'ALL' || (b.bookingStatus || '').toUpperCase() === bookingStatusFilter;
    const q = bookingSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (b.id && b.id.toLowerCase().includes(q)) ||
      (b.targetTitle && b.targetTitle.toLowerCase().includes(q)) ||
      (b.customerName && b.customerName.toLowerCase().includes(q)) ||
      (b.providerName && b.providerName.toLowerCase().includes(q));
    return matchStatus && matchSearch;
  });
  const tbody = document.getElementById('bookings-tbody');
  if (tbody) tbody.innerHTML = renderBookingsTableRows(filtered);
}

function renderBookingsTableRows(list) {
  if (!list || list.length === 0) {
    return '<tr><td colspan="9" style="text-align:center; padding:30px; color:var(--gray-text);">No bookings found.</td></tr>';
  }
  return list.map(b => {
    const isMachine = (b.bookingType || '').toLowerCase() === 'machine';
    const statusClass = (b.bookingStatus || '').toLowerCase() === 'completed' ? 'badge-green' :
      (b.bookingStatus || '').toLowerCase() === 'pending' ? 'badge-orange' :
        (b.bookingStatus || '').toLowerCase() === 'cancelled' ? 'badge-red' : 'badge-blue';
    const defaultImg = isMachine ? 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800' : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400';
    return `
      <tr>
        <td><strong>${b.id}</strong><br><span class="cell-subtitle">${b.createdAt || ''}</span></td>
        <td>
          <div class="cell-avatar-title">
            <img src="${b.targetImageUrl || defaultImg}" onerror="this.src='${defaultImg}'" class="table-avatar-card" alt="">
            <div>
              <div class="cell-title-main">${b.targetTitle || 'Agri Service'}</div>
              <div class="cell-subtitle">${b.serviceLocation || ''}</div>
            </div>
          </div>
        </td>
        <td><span class="badge ${isMachine ? 'badge-orange' : 'badge-blue'}">${isMachine ? '🚜 Machine' : '👨‍🌾 Worker'}</span></td>
        <td><strong>${b.customerName}</strong><br><span class="cell-subtitle">${b.customerPhone || ''}</span></td>
        <td><strong>${b.providerName || 'N/A'}</strong><br><span class="cell-subtitle">${b.providerPhone || ''}</span></td>
        <td style="white-space:nowrap;"><span style="font-size:12px;">${b.startDate || ''}</span><br><span class="cell-subtitle">to ${b.endDate || ''}</span></td>
        <td>
          <strong style="color:var(--primary-dark);">₹${b.totalAmount}</strong><br>
          <span class="badge ${b.paymentStatus === 'Paid' ? 'badge-green' : 'badge-orange'}" style="font-size:10px; padding:1px 6px;">${b.paymentStatus || 'Pending'}</span>
        </td>
        <td><span class="badge ${statusClass}">${b.bookingStatus || 'Pending'}</span></td>
        <td>
          <div class="table-actions">
            <button class="btn btn-sm btn-secondary" onclick="openBookingDetailModal('${b.id}')" title="View Booking Details"><i class="fa-solid fa-eye"></i> Details</button>
            <button class="btn btn-sm btn-outline-primary" onclick="openEditBookingModal('${b.id}')" title="Edit Booking & Picture"><i class="fa-solid fa-pen"></i> Edit</button>
            <button class="btn btn-sm btn-primary" onclick="openUpdateBookingStatusModal('${b.id}')" title="Change Status"><i class="fa-solid fa-sliders"></i> Status</button>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

function openBookingDetailModal(id) {
  const b = globalData.bookings.find(item => item.id === id);
  if (!b) return;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> Booking Details - ${b.id}`;
  submitBtn.innerText = 'Change Status';
  submitBtn.onclick = () => { closeModal(); openUpdateBookingStatusModal(id); };

  const timelineHtml = (b.timeline || []).map(step => `
    <div class="timeline-step-item ${step.completed ? 'completed' : ''}">
      <div class="timeline-step-icon"><i class="fa-solid ${step.completed ? 'fa-check' : 'fa-circle'}"></i></div>
      <div>
        <div style="font-weight:600; font-size:13px; color:var(--dark-text);">${step.title}</div>
        <div style="font-size:11px; color:var(--gray-text);">${step.date || 'Pending'}</div>
      </div>
    </div>
  `).join('');

  modalBody.innerHTML = `
    <div style="display:flex; gap:16px; align-items:center; background:var(--light-gray); padding:14px; border-radius:10px; margin-bottom:18px;">
      <img src="${b.targetImageUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'}" style="width:80px; height:60px; object-fit:cover; border-radius:8px; border:1px solid var(--border-color);" alt="">
      <div style="flex:1;">
        <h4 style="margin:0; font-size:16px; color:var(--dark-text);">${b.targetTitle}</h4>
        <span class="badge ${b.bookingType === 'machine' ? 'badge-orange' : 'badge-blue'}" style="margin-top:4px;">${b.bookingType === 'machine' ? '🚜 Machine Rental' : '👨‍🌾 Farm Labor Hire'}</span>
        <span class="badge badge-green" style="margin-left:6px;">Status: ${b.bookingStatus}</span>
      </div>
      <button class="btn btn-sm btn-outline-primary" onclick="closeModal(); openEditBookingModal('${b.id}')" title="Edit Picture & Details">
        <i class="fa-solid fa-camera"></i> Edit Picture & Info
      </button>
    </div>

    <div class="form-grid" style="margin-bottom:18px;">
      <div>
        <div class="form-label">Customer Information</div>
        <div style="font-size:13px;"><strong>${b.customerName}</strong><br>Phone: ${b.customerPhone || 'N/A'}<br>Location: ${b.serviceLocation || 'N/A'}</div>
      </div>
      <div>
        <div class="form-label">Provider Information</div>
        <div style="font-size:13px;"><strong>${b.providerName || 'Direct'}</strong><br>Phone: ${b.providerPhone || 'N/A'}</div>
      </div>
    </div>

    <div class="form-grid" style="margin-bottom:18px; background:#F8FAFC; padding:12px; border-radius:8px;">
      <div>
        <span style="font-size:12px; color:var(--gray-text);">Rental Dates:</span><br>
        <strong>${b.startDate}</strong> to <strong>${b.endDate}</strong>
      </div>
      <div>
        <span style="font-size:12px; color:var(--gray-text);">Total Payment:</span><br>
        <strong style="color:var(--primary-dark); font-size:16px;">₹${b.totalAmount}</strong> (${b.paymentMethod || 'Cash on Delivery'}) - <span class="badge badge-green">${b.paymentStatus || 'Paid'}</span>
      </div>
    </div>

    <div>
      <div class="form-label" style="margin-bottom:12px;"><i class="fa-solid fa-clock-rotate-left"></i> Order Fulfillment Timeline</div>
      <div style="padding-left:6px;">
        ${timelineHtml || '<p style="color:var(--gray-text); font-size:13px;">Standard 5-step rental workflow in progress.</p>'}
      </div>
    </div>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

function openEditBookingModal(id) {
  const b = globalData.bookings.find(item => item.id === id);
  if (!b) return;

  const isMachine = (b.bookingType || '').toLowerCase() === 'machine';
  const defaultImg = isMachine ? 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800' : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400';
  const currentImg = b.targetImageUrl || defaultImg;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Booking & Picture - ${b.id}`;
  submitBtn.innerText = 'Save Changes';
  submitBtn.onclick = () => submitEditBookingForm(id);

  modalBody.innerHTML = `
    <form id="edit-booking-form">
      <!-- Photo Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Equipment / Worker Picture Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="edit-bk-img-preview" src="${currentImg}" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Booking Picture">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Picture Image URL</label>
            <input type="text" id="edit-bk-img" class="form-control" value="${currentImg}" 
              placeholder="Paste picture URL (https://...)" 
              oninput="document.getElementById('edit-bk-img-preview').src = this.value || '${defaultImg}'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Pictures:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'edit-bk-img', 'edit-bk-img-preview')">🚜 Tractor</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800', 'edit-bk-img', 'edit-bk-img-preview')">🌾 Harvester</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', 'edit-bk-img', 'edit-bk-img-preview')">👨‍🌾 Worker</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1530267981608-bc7e96a40a58?w=800', 'edit-bk-img', 'edit-bk-img-preview')">⚙️ Tiller</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="edit-bk-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'edit-bk-img', 'edit-bk-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('edit-bk-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Picture File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Equipment / Service Title *</label>
        <input type="text" id="edit-bk-title" class="form-control" value="${b.targetTitle || ''}" required>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Customer Name *</label>
          <input type="text" id="edit-bk-cname" class="form-control" value="${b.customerName || ''}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Customer Phone</label>
          <input type="text" id="edit-bk-cphone" class="form-control" value="${b.customerPhone || ''}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Provider Name</label>
          <input type="text" id="edit-bk-pname" class="form-control" value="${b.providerName || ''}">
        </div>
        <div class="form-group">
          <label class="form-label">Provider Phone</label>
          <input type="text" id="edit-bk-pphone" class="form-control" value="${b.providerPhone || ''}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Start Date</label>
          <input type="date" id="edit-bk-sdate" class="form-control" value="${b.startDate || ''}">
        </div>
        <div class="form-group">
          <label class="form-label">End Date</label>
          <input type="date" id="edit-bk-edate" class="form-control" value="${b.endDate || ''}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Total Amount (₹) *</label>
          <input type="number" id="edit-bk-amount" class="form-control" value="${b.totalAmount || 0}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Location / Taluk</label>
          <input type="text" id="edit-bk-location" class="form-control" value="${b.serviceLocation || ''}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Booking Status</label>
          <select id="edit-bk-status" class="form-control">
            <option value="Pending" ${b.bookingStatus === 'Pending' ? 'selected' : ''}>⏳ Pending</option>
            <option value="Confirmed" ${b.bookingStatus === 'Confirmed' ? 'selected' : ''}>✅ Confirmed</option>
            <option value="Rental Started" ${b.bookingStatus === 'Rental Started' ? 'selected' : ''}>🚜 Rental Started / In Progress</option>
            <option value="Completed" ${b.bookingStatus === 'Completed' ? 'selected' : ''}>🏁 Completed</option>
            <option value="Cancelled" ${b.bookingStatus === 'Cancelled' ? 'selected' : ''}>❌ Cancelled</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Payment Status</label>
          <select id="edit-bk-pay-status" class="form-control">
            <option value="Paid" ${b.paymentStatus === 'Paid' ? 'selected' : ''}>Paid</option>
            <option value="Pending" ${b.paymentStatus === 'Pending' ? 'selected' : ''}>Pending</option>
            <option value="Refunded" ${b.paymentStatus === 'Refunded' ? 'selected' : ''}>Refunded</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditBookingForm(id) {
  const targetTitle = document.getElementById('edit-bk-title').value;
  const targetImageUrl = document.getElementById('edit-bk-img').value;
  const customerName = document.getElementById('edit-bk-cname').value;
  const customerPhone = document.getElementById('edit-bk-cphone').value;
  const providerName = document.getElementById('edit-bk-pname').value;
  const providerPhone = document.getElementById('edit-bk-pphone').value;
  const startDate = document.getElementById('edit-bk-sdate').value;
  const endDate = document.getElementById('edit-bk-edate').value;
  const totalAmount = parseFloat(document.getElementById('edit-bk-amount').value) || 0;
  const serviceLocation = document.getElementById('edit-bk-location').value;
  const bookingStatus = document.getElementById('edit-bk-status').value;
  const paymentStatus = document.getElementById('edit-bk-pay-status').value;

  if (!targetTitle || !customerName) {
    showToast('Please fill in required fields (Title and Customer Name)', 'error');
    return;
  }

  const res = await apiPut(`/bookings/${id}`, {
    targetTitle,
    targetImageUrl,
    customerName,
    customerPhone,
    providerName,
    providerPhone,
    startDate,
    endDate,
    totalAmount,
    serviceLocation,
    bookingStatus,
    paymentStatus,
  });

  if (res) {
    showToast(`Booking ${id} details and picture updated!`, 'success');
    closeModal();
    await loadAllData();
    renderBookingsView();
  }
}

function openUpdateBookingStatusModal(id) {
  const b = globalData.bookings.find(item => item.id === id);
  if (!b) return;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Update Status - ${b.id}`;
  submitBtn.innerText = 'Save Status';
  submitBtn.onclick = () => submitBookingStatusUpdate(id);

  modalBody.innerHTML = `
    <div class="form-group">
      <label class="form-label">Current Booking Status</label>
      <select id="booking-new-status" class="form-control">
        <option value="Pending" ${b.bookingStatus === 'Pending' ? 'selected' : ''}>⏳ Pending</option>
        <option value="Confirmed" ${b.bookingStatus === 'Confirmed' ? 'selected' : ''}>✅ Confirmed</option>
        <option value="Rental Started" ${b.bookingStatus === 'Rental Started' ? 'selected' : ''}>🚜 Rental Started / In Progress</option>
        <option value="Completed" ${b.bookingStatus === 'Completed' ? 'selected' : ''}>🏁 Completed</option>
        <option value="Cancelled" ${b.bookingStatus === 'Cancelled' ? 'selected' : ''}>❌ Cancelled</option>
      </select>
    </div>
    <div class="form-group">
      <label class="form-label">Payment Status</label>
      <select id="booking-new-payment" class="form-control">
        <option value="Paid" ${b.paymentStatus === 'Paid' ? 'selected' : ''}>Paid</option>
        <option value="Pending" ${b.paymentStatus === 'Pending' ? 'selected' : ''}>Pending</option>
      </select>
    </div>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitBookingStatusUpdate(id) {
  const status = document.getElementById('booking-new-status').value;
  const payment = document.getElementById('booking-new-payment').value;

  const res = await apiPut(`/bookings/${id}`, {
    bookingStatus: status,
    paymentStatus: payment,
  });

  if (res) {
    showToast(`Booking ${id} status updated to ${status}`, 'success');
    closeModal();
    await loadAllData();
    renderBookingsView();
  }
}

// ====================================================
// 7. PRODUCE MARKETPLACE
// ====================================================
let marketplaceCategoryFilter = 'ALL';
let marketplaceSearchQuery = '';

function renderMarketplaceView() {
  const container = document.getElementById('content-area');
  const items = globalData.marketplace || [];

  const totalItems = items.length;
  const totalKg = items.reduce((acc, p) => acc + (Number(p.quantityAvailable) || 0), 0);

  const filtered = items.filter(p => {
    const matchCat = marketplaceCategoryFilter === 'ALL' || (p.category || '').toLowerCase() === marketplaceCategoryFilter.toLowerCase();
    const q = marketplaceSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (p.title && p.title.toLowerCase().includes(q)) ||
      (p.category && p.category.toLowerCase().includes(q)) ||
      (p.sellerName && p.sellerName.toLowerCase().includes(q)) ||
      (p.location && p.location.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-wheat-awn" style="color:var(--primary);"></i> Produce Marketplace</h1>
        <p class="page-subtitle">Direct farmer-to-buyer crop marketplace (Arecanut, Pepper, Paddy & Spices)</p>
      </div>
      <button class="btn btn-primary" onclick="openAddProduceModal()"><i class="fa-solid fa-plus"></i> + Add Produce Listing</button>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-seedling"></i></div>
          <span class="stat-badge up">Active</span>
        </div>
        <div class="stat-value">${totalItems}</div>
        <div class="stat-label">Listed Crop Lots</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-boxes-stacked"></i></div>
          <span class="stat-badge up">Stock</span>
        </div>
        <div class="stat-value">${totalKg.toLocaleString()} kg</div>
        <div class="stat-label">Total Produce Volume</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-tags"></i></div>
          <span class="stat-badge up">Crops</span>
        </div>
        <div class="stat-value">8+ Categories</div>
        <div class="stat-label">Arecanut, Pepper, Rice, etc.</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon purple"><i class="fa-solid fa-location-dot"></i></div>
          <span class="stat-badge up">Malnad</span>
        </div>
        <div class="stat-value">6 Districts</div>
        <div class="stat-label">Karnataka Agri Hubs</div>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="card-header-bar">
        <div class="table-filters">
          <div class="filter-input-wrap">
            <i class="fa-solid fa-magnifying-glass filter-icon"></i>
            <input type="text" class="filter-input" placeholder="Search crops, farmers, locations..." value="${marketplaceSearchQuery}" oninput="marketplaceSearchQuery=this.value; renderMarketplaceTableRowsDynamic();">
          </div>
          <select class="filter-select" onchange="marketplaceCategoryFilter=this.value; renderMarketplaceView();">
            <option value="ALL" ${marketplaceCategoryFilter === 'ALL' ? 'selected' : ''}>All Produce Categories</option>
            <option value="Arecanut" ${marketplaceCategoryFilter === 'Arecanut' ? 'selected' : ''}>Arecanut (ಅಡಿಕೆ)</option>
            <option value="Pepper" ${marketplaceCategoryFilter === 'Pepper' ? 'selected' : ''}>Black Pepper (ಕಾಳುಮೆಣಸು)</option>
            <option value="Rice" ${marketplaceCategoryFilter === 'Rice' ? 'selected' : ''}>Paddy & Rice (ಭತ್ತ)</option>
            <option value="Coconut" ${marketplaceCategoryFilter === 'Coconut' ? 'selected' : ''}>Coconut (ತೆಂಗಿನಕಾಯಿ)</option>
            <option value="Vegetables" ${marketplaceCategoryFilter === 'Vegetables' ? 'selected' : ''}>Vegetables</option>
            <option value="Fruits" ${marketplaceCategoryFilter === 'Fruits' ? 'selected' : ''}>Fruits</option>
          </select>
        </div>
        <div>
          <button class="btn btn-primary" onclick="openAddProduceModal()"><i class="fa-solid fa-plus"></i> Add Produce Listing</button>
        </div>
      </div>

      <table class="custom-table">
        <thead>
          <tr>
            <th>Image</th>
            <th>Crop Title</th>
            <th>Category</th>
            <th>Farmer / Seller</th>
            <th>Location</th>
            <th>Price</th>
            <th>Available Qty</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody id="marketplace-tbody">
          ${renderMarketplaceTableRows(filtered)}
        </tbody>
      </table>
    </div>
  `;
}

function renderMarketplaceTableRowsDynamic() {
  const items = globalData.marketplace || [];
  const filtered = items.filter(p => {
    const matchCat = marketplaceCategoryFilter === 'ALL' || (p.category || '').toLowerCase() === marketplaceCategoryFilter.toLowerCase();
    const q = marketplaceSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (p.title && p.title.toLowerCase().includes(q)) ||
      (p.sellerName && p.sellerName.toLowerCase().includes(q)) ||
      (p.location && p.location.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });
  const tbody = document.getElementById('marketplace-tbody');
  if (tbody) tbody.innerHTML = renderMarketplaceTableRows(filtered);
}

function renderMarketplaceTableRows(list) {
  if (!list || list.length === 0) {
    return '<tr><td colspan="9" style="text-align:center; padding:30px; color:var(--gray-text);">No produce listings found. Click "+ Add Produce Listing" to add one.</td></tr>';
  }
  return list.map(p => {
    const imgUrl = (p.images && p.images[0]) || 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800';
    return `
      <tr>
        <td><img src="${imgUrl}" onerror="this.src='https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800'" class="table-avatar-card" alt=""></td>
        <td>
          <div class="cell-title-main">${p.title}</div>
          <div class="cell-subtitle">${p.description ? p.description.substring(0, 55) + '...' : ''}</div>
        </td>
        <td><span class="badge badge-green">${p.category || 'Crop'}</span></td>
        <td><strong>${p.sellerName || 'Farmer'}</strong><br><span class="cell-subtitle">${p.sellerPhone || ''}</span></td>
        <td>${p.location || 'Karnataka'}</td>
        <td><strong style="color:var(--primary-dark); font-size:14px;">₹${p.price}</strong><span style="font-size:11px; color:var(--gray-text);">/${p.unit || 'kg'}</span></td>
        <td><strong>${p.quantityAvailable || 0}</strong> ${p.unit || 'kg'}</td>
        <td><span class="badge ${p.status === 'Approved' ? 'badge-green' : 'badge-orange'}">${p.status || 'Approved'}</span></td>
        <td>
          <div class="table-actions">
            <button class="btn btn-sm btn-whatsapp" onclick="openWhatsAppModal('product', '${p.id}')" title="Send WhatsApp Message"><i class="fa-brands fa-whatsapp"></i></button>
            <button class="btn btn-sm btn-primary" onclick="openEditProduceModal('${p.id}')" title="Edit Listing"><i class="fa-solid fa-pen-to-square"></i></button>
            <button class="btn btn-sm btn-danger" onclick="deleteProduceListing('${p.id}')" title="Delete Listing"><i class="fa-solid fa-trash"></i></button>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

function openAddProduceModal() {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-plus"></i> Add New Produce Listing`;
  submitBtn.innerText = 'Publish Produce';
  submitBtn.onclick = () => submitAddProduceForm();

  modalBody.innerHTML = `
    <form id="add-produce-form">
      <!-- Photo / Picture Settings Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Crop Picture / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="prod-add-img-preview" src="https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Crop Picture">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Picture Image URL</label>
            <input type="text" id="prod-img" class="form-control" value="https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800" 
              placeholder="Paste crop picture URL (https://...)" 
              oninput="document.getElementById('prod-add-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Crop Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800', 'prod-img', 'prod-add-img-preview')">🌴 Arecanut</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800', 'prod-img', 'prod-add-img-preview')">🌶️ Pepper</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800', 'prod-img', 'prod-add-img-preview')">☕ Coffee</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'prod-img', 'prod-add-img-preview')">🌾 Rice/Field</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="prod-add-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'prod-img', 'prod-add-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('prod-add-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Crop Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Crop Title *</label>
        <input type="text" id="prod-title" class="form-control" placeholder="e.g. Premium Sun-Dried Arecanut Rashi" required>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Category</label>
          <select id="prod-cat" class="form-control">
            <option value="Arecanut">Arecanut (ಅಡಿಕೆ)</option>
            <option value="Pepper">Black Pepper (ಕಾಳುಮೆಣಸು)</option>
            <option value="Rice">Paddy & Rice (ಭತ್ತ)</option>
            <option value="Coconut">Coconut (ತೆಂಗಿನಕಾಯಿ)</option>
            <option value="Vegetables">Vegetables (ತರಕಾರಿಗಳು)</option>
            <option value="Fruits">Fruits (ಹಣ್ಣುಗಳು)</option>
            <option value="Seeds">Seeds</option>
            <option value="Other Crops">Other Crops</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Unit of Measure</label>
          <select id="prod-unit" class="form-control">
            <option value="kg">kg (Kilogram)</option>
            <option value="quintal">quintal (100 kg)</option>
            <option value="bag">bag</option>
            <option value="box">box</option>
          </select>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Price per Unit (₹) *</label>
          <input type="number" id="prod-price" class="form-control" placeholder="480" required>
        </div>
        <div class="form-group">
          <label class="form-label">Quantity Available *</label>
          <input type="number" id="prod-qty" class="form-control" placeholder="500" required>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Farmer / Seller Name</label>
          <input type="text" id="prod-seller-name" class="form-control" placeholder="Narayana Hegde" value="Narayana Hegde" required>
        </div>
        <div class="form-group">
          <label class="form-label">Farmer Phone</label>
          <input type="text" id="prod-seller-phone" class="form-control" placeholder="+91 7892570830" value="+91 7892570830" required>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Location</label>
        <input type="text" id="prod-loc" class="form-control" placeholder="Shivamogga, KA" value="Shivamogga, KA" required>
      </div>

      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea id="prod-desc" class="form-control" rows="2" placeholder="Describe quality, drying process, and lot details."></textarea>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitAddProduceForm() {
  const title = document.getElementById('prod-title').value;
  const category = document.getElementById('prod-cat').value;
  const unit = document.getElementById('prod-unit').value;
  const price = parseFloat(document.getElementById('prod-price').value) || 0;
  const quantity = parseFloat(document.getElementById('prod-qty').value) || 0;
  const sellerName = document.getElementById('prod-seller-name').value;
  const sellerPhone = document.getElementById('prod-seller-phone').value;
  const location = document.getElementById('prod-loc').value;
  const img = document.getElementById('prod-img').value;
  const description = document.getElementById('prod-desc').value;

  if (!title) {
    showToast('Please enter crop title', 'error');
    return;
  }

  const payload = {
    title,
    category,
    unit,
    price,
    quantityAvailable: quantity,
    sellerName,
    sellerPhone,
    location,
    images: [img || 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800'],
    description,
    status: 'Approved',
    isAgroStoreItem: false,
    rating: 5.0,
  };

  const res = await apiPost('/marketplace', payload);
  if (res) {
    showToast('Produce item listed successfully on Marketplace!', 'success');
    closeModal();
    await loadAllData();
    renderMarketplaceView();
  }
}

function openEditProduceModal(id) {
  const p = globalData.marketplace.find(item => item.id === id);
  if (!p) return;

  const currentImg = (p.images && p.images[0]) || p.imageUrl || 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800';

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Produce & Picture - ${p.title}`;
  submitBtn.innerText = 'Save Updates';
  submitBtn.onclick = () => submitEditProduceForm(id);

  modalBody.innerHTML = `
    <form id="edit-produce-form">
      <!-- Photo Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Crop Picture / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="edit-prod-img-preview" src="${currentImg}" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Crop Picture">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Picture Image URL</label>
            <input type="text" id="edit-prod-img" class="form-control" value="${currentImg}" 
              placeholder="Paste crop picture URL (https://...)" 
              oninput="document.getElementById('edit-prod-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Crop Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800', 'edit-prod-img', 'edit-prod-img-preview')">🌴 Arecanut</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=800', 'edit-prod-img', 'edit-prod-img-preview')">🌶️ Pepper</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800', 'edit-prod-img', 'edit-prod-img-preview')">☕ Coffee</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'edit-prod-img', 'edit-prod-img-preview')">🌾 Rice/Field</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="edit-prod-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'edit-prod-img', 'edit-prod-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('edit-prod-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Crop Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Crop Title</label>
        <input type="text" id="edit-prod-title" class="form-control" value="${p.title}" required>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Price (₹ / unit)</label>
          <input type="number" id="edit-prod-price" class="form-control" value="${p.price}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Quantity Available</label>
          <input type="number" id="edit-prod-qty" class="form-control" value="${p.quantityAvailable}" required>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Category</label>
          <input type="text" id="edit-prod-cat" class="form-control" value="${p.category}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Status</label>
          <select id="edit-prod-status" class="form-control">
            <option value="Approved" ${p.status === 'Approved' ? 'selected' : ''}>Approved</option>
            <option value="Pending" ${p.status === 'Pending' ? 'selected' : ''}>Pending</option>
            <option value="Sold Out" ${p.status === 'Sold Out' ? 'selected' : ''}>Sold Out</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Location</label>
        <input type="text" id="edit-prod-loc" class="form-control" value="${p.location || ''}">
      </div>

      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea id="edit-prod-desc" class="form-control" rows="2">${p.description || ''}</textarea>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditProduceForm(id) {
  const title = document.getElementById('edit-prod-title').value;
  const price = parseFloat(document.getElementById('edit-prod-price').value) || 0;
  const qty = parseFloat(document.getElementById('edit-prod-qty').value) || 0;
  const cat = document.getElementById('edit-prod-cat').value;
  const status = document.getElementById('edit-prod-status').value;
  const loc = document.getElementById('edit-prod-loc').value;
  const img = document.getElementById('edit-prod-img').value;
  const desc = document.getElementById('edit-prod-desc') ? document.getElementById('edit-prod-desc').value : '';

  const res = await apiPut(`/marketplace/${id}`, {
    title,
    price,
    quantityAvailable: qty,
    category: cat,
    status,
    location: loc,
    images: [img || 'https://images.unsplash.com/photo-1546430498-05c7b929fb30?w=800'],
    description: desc,
  });

  if (res) {
    showToast('Produce listing and picture updated!', 'success');
    closeModal();
    await loadAllData();
    renderMarketplaceView();
  }
}

async function deleteProduceListing(id) {
  if (!confirm('Are you sure you want to remove this produce listing?')) return;
  const res = await apiDelete(`/marketplace/${id}`);
  if (res) {
    showToast('Produce listing removed.', 'success');
    await loadAllData();
    renderMarketplaceView();
  }
}

// ====================================================
// 8. AGRO STORE MANAGEMENT
// ====================================================
let storeCategoryFilter = 'ALL';
let storeSearchQuery = '';

function renderAgroStoreView() {
  const container = document.getElementById('content-area');
  const items = globalData.store || [];

  const totalProducts = items.length;
  const activeProducts = items.filter(s => (s.status || '').toLowerCase() === 'active').length;

  const filtered = items.filter(s => {
    const matchCat = storeCategoryFilter === 'ALL' || (s.category || '').toLowerCase() === storeCategoryFilter.toLowerCase();
    const q = storeSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (s.title && s.title.toLowerCase().includes(q)) ||
      (s.brand && s.brand.toLowerCase().includes(q)) ||
      (s.category && s.category.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-store" style="color:var(--primary);"></i> Krushi Mithra Official Agro Store</h1>
        <p class="page-subtitle">Supplies, Certified Seeds, Fertilizers, Bio-nutrients & Agricultural Tools</p>
      </div>
      <button class="btn btn-primary" onclick="openAddStoreProductModal()"><i class="fa-solid fa-plus"></i> + Add Store Product</button>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-box-open"></i></div>
          <span class="stat-badge up">Available</span>
        </div>
        <div class="stat-value">${totalProducts}</div>
        <div class="stat-label">Store Products</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-certificate"></i></div>
          <span class="stat-badge up">100% Verified</span>
        </div>
        <div class="stat-value">${activeProducts}</div>
        <div class="stat-label">Active Listings</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-percent"></i></div>
          <span class="stat-badge up">Deals</span>
        </div>
        <div class="stat-value">Up to 25% Off</div>
        <div class="stat-label">Farmer Discount Campaign</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon purple"><i class="fa-solid fa-truck-fast"></i></div>
          <span class="stat-badge up">Doorstep</span>
        </div>
        <div class="stat-value">24-48 Hours</div>
        <div class="stat-label">Delivery to Farm Gate</div>
      </div>
    </div>

    <div class="card-table-wrapper">
      <div class="card-header-bar">
        <div class="table-filters">
          <input type="text" class="filter-input" placeholder="Search product name, brand..." value="${storeSearchQuery}" oninput="storeSearchQuery=this.value; renderStoreTableRowsDynamic();">
          <select class="filter-select" onchange="storeCategoryFilter=this.value; renderAgroStoreView();">
            <option value="ALL" ${storeCategoryFilter === 'ALL' ? 'selected' : ''}>All Store Categories</option>
            <option value="Seeds" ${storeCategoryFilter === 'Seeds' ? 'selected' : ''}>Seeds (ಬೀಜಗಳು)</option>
            <option value="Fertilizers" ${storeCategoryFilter === 'Fertilizers' ? 'selected' : ''}>Fertilizers (ಗೊಬ್ಬರ)</option>
            <option value="Pesticides" ${storeCategoryFilter === 'Pesticides' ? 'selected' : ''}>Pesticides & Sprays</option>
            <option value="Tools" ${storeCategoryFilter === 'Tools' ? 'selected' : ''}>Tools & Equipment</option>
            <option value="Organic Products" ${storeCategoryFilter === 'Organic Products' ? 'selected' : ''}>Organic Products</option>
          </select>
        </div>
        <div>
          <button class="btn btn-sm btn-primary" onclick="openAddStoreProductModal()"><i class="fa-solid fa-plus"></i> Add Product</button>
        </div>
      </div>

      <table class="custom-table">
        <thead>
          <tr>
            <th>Image</th>
            <th>Product Name</th>
            <th>Category</th>
            <th>Brand</th>
            <th>Price</th>
            <th>Discount</th>
            <th>Stock</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody id="store-tbody">
          ${renderStoreTableRows(filtered)}
        </tbody>
      </table>
    </div>
  `;
}

function renderStoreTableRowsDynamic() {
  const items = globalData.store || [];
  const filtered = items.filter(s => {
    const matchCat = storeCategoryFilter === 'ALL' || (s.category || '').toLowerCase() === storeCategoryFilter.toLowerCase();
    const q = storeSearchQuery.toLowerCase();
    const matchSearch = !q ||
      (s.title && s.title.toLowerCase().includes(q)) ||
      (s.brand && s.brand.toLowerCase().includes(q));
    return matchCat && matchSearch;
  });
  const tbody = document.getElementById('store-tbody');
  if (tbody) tbody.innerHTML = renderStoreTableRows(filtered);
}

function renderStoreTableRows(list) {
  if (!list || list.length === 0) {
    return '<tr><td colspan="9" style="text-align:center; padding:30px; color:var(--gray-text);">No store products found. Click "+ Add Store Product" to create one.</td></tr>';
  }
  return list.map(s => {
    const imgUrl = (s.images && s.images[0]) || 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800';
    return `
      <tr>
        <td><img src="${imgUrl}" onerror="this.src='https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800'" class="table-avatar-card" alt=""></td>
        <td>
          <div class="cell-title-main">${s.title}</div>
          <div class="cell-subtitle">${s.description ? s.description.substring(0, 50) + '...' : ''}</div>
        </td>
        <td><span class="badge badge-green">${s.category || 'Supplies'}</span></td>
        <td><strong>${s.brand || 'Krushi Mithra'}</strong></td>
        <td><strong style="color:var(--primary-dark); font-size:14px;">₹${s.price}</strong><span style="font-size:11px; color:var(--gray-text);">/${s.unit || 'item'}</span></td>
        <td><span class="badge ${s.discount > 0 ? 'badge-orange' : 'badge-gray'}">${s.discount || 0}% OFF</span></td>
        <td><strong>${s.quantityAvailable || 0}</strong> in stock</td>
        <td><span class="badge ${s.status === 'Active' ? 'badge-green' : 'badge-red'}">${s.status || 'Active'}</span></td>
        <td>
          <div class="table-actions">
            <button class="btn btn-sm btn-primary" onclick="openEditStoreProductModal('${s.id}')" title="Edit Store Item"><i class="fa-solid fa-pen-to-square"></i></button>
            <button class="btn btn-sm btn-danger" onclick="deleteStoreProduct('${s.id}')" title="Delete Product"><i class="fa-solid fa-trash"></i></button>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

function openAddStoreProductModal() {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-plus"></i> Add New Agro Store Product`;
  submitBtn.innerText = 'Add to Store';
  submitBtn.onclick = () => submitAddStoreProductForm();

  modalBody.innerHTML = `
    <form id="add-store-form">
      <!-- Photo Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Product Picture / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="store-add-img-preview" src="https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Product Picture">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Picture Image URL</label>
            <input type="text" id="store-img" class="form-control" value="https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800" 
              placeholder="Paste picture URL (https://...)" 
              oninput="document.getElementById('store-add-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Pictures:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800', 'store-img', 'store-add-img-preview')">🌱 Seeds/Fertilizer</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'store-img', 'store-add-img-preview')">🛠️ Tools</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'store-img', 'store-add-img-preview')">🌾 Bio-Organic</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="store-add-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'store-img', 'store-add-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('store-add-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Picture File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Product Name</label>
        <input type="text" id="store-title" class="form-control" placeholder="e.g. Certified Jyothi High-Yield Paddy Seeds (10 kg)" required>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Category</label>
          <select id="store-cat" class="form-control">
            <option value="Seeds">Seeds (ಬೀಜಗಳು)</option>
            <option value="Fertilizers">Fertilizers (ಗೊಬ್ಬರ)</option>
            <option value="Pesticides">Pesticides (ಕೀಟನಾಶಕಗಳು)</option>
            <option value="Tools">Tools (ಕೃಷಿ ಉಪಕರಣಗಳು)</option>
            <option value="Farm Equipment">Farm Equipment</option>
            <option value="Organic Products">Organic Bio-Products</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Brand / Manufacturer</label>
          <input type="text" id="store-brand" class="form-control" placeholder="Krushi Mithra Certified" value="Krushi Mithra Certified">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Retail Price (₹)</label>
          <input type="number" id="store-price" class="form-control" placeholder="850" required>
        </div>
        <div class="form-group">
          <label class="form-label">Discount Percentage (%)</label>
          <input type="number" id="store-discount" class="form-control" placeholder="10" value="10">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Quantity / Stock Available</label>
          <input type="number" id="store-qty" class="form-control" placeholder="100" value="100" required>
        </div>
        <div class="form-group">
          <label class="form-label">Unit</label>
          <input type="text" id="store-unit" class="form-control" placeholder="bag / bottle / pack" value="bag">
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Product Description</label>
        <textarea id="store-desc" class="form-control" rows="2" placeholder="Describe usage instructions and benefits."></textarea>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitAddStoreProductForm() {
  const title = document.getElementById('store-title').value;
  const category = document.getElementById('store-cat').value;
  const brand = document.getElementById('store-brand').value;
  const price = parseFloat(document.getElementById('store-price').value) || 0;
  const discount = parseFloat(document.getElementById('store-discount').value) || 0;
  const qty = parseFloat(document.getElementById('store-qty').value) || 0;
  const unit = document.getElementById('store-unit').value;
  const img = document.getElementById('store-img').value;
  const desc = document.getElementById('store-desc').value;

  if (!title) {
    showToast('Please enter product title', 'error');
    return;
  }

  const payload = {
    title,
    category,
    brand,
    price,
    discount,
    quantityAvailable: qty,
    unit,
    images: [img || 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800'],
    description: desc,
    status: 'Active',
    rating: 4.9,
    isAgroStoreItem: true,
  };

  const res = await apiPost('/store', payload);
  if (res) {
    showToast('Product added to Agro Store!', 'success');
    closeModal();
    await loadAllData();
    renderAgroStoreView();
  }
}

function openEditStoreProductModal(id) {
  const s = globalData.store.find(item => item.id === id);
  if (!s) return;

  const currentImg = (s.images && s.images[0]) || s.imageUrl || 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800';

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Store Item - ${s.title}`;
  submitBtn.innerText = 'Save Changes';
  submitBtn.onclick = () => submitEditStoreProduct(id);

  modalBody.innerHTML = `
    <form id="edit-store-form">
      <!-- Photo Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Product Picture / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="edit-s-img-preview" src="${currentImg}" 
              style="width:120px; height:90px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Product Picture">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Picture Image URL</label>
            <input type="text" id="edit-s-img" class="form-control" value="${currentImg}" 
              placeholder="Paste picture URL (https://...)" 
              oninput="document.getElementById('edit-s-img-preview').src = this.value || 'https://via.placeholder.com/120x90'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Pictures:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800', 'edit-s-img', 'edit-s-img-preview')">🌱 Seeds/Fertilizer</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'edit-s-img', 'edit-s-img-preview')">🛠️ Tools</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'edit-s-img', 'edit-s-img-preview')">🌾 Bio-Organic</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="edit-s-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'edit-s-img', 'edit-s-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('edit-s-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Picture File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Product Name *</label>
        <input type="text" id="edit-s-title" class="form-control" value="${s.title}" required>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Category</label>
          <select id="edit-s-cat" class="form-control">
            <option value="Seeds" ${s.category === 'Seeds' ? 'selected' : ''}>Seeds (ಬೀಜಗಳು)</option>
            <option value="Fertilizers" ${s.category === 'Fertilizers' ? 'selected' : ''}>Fertilizers (ಗೊಬ್ಬರ)</option>
            <option value="Pesticides" ${s.category === 'Pesticides' ? 'selected' : ''}>Pesticides (ಕೀಟನಾಶಕಗಳು)</option>
            <option value="Tools" ${s.category === 'Tools' ? 'selected' : ''}>Tools (ಕೃಷಿ ಉಪಕರಣಗಳು)</option>
            <option value="Farm Equipment" ${s.category === 'Farm Equipment' ? 'selected' : ''}>Farm Equipment</option>
            <option value="Organic Products" ${s.category === 'Organic Products' ? 'selected' : ''}>Organic Bio-Products</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Brand / Manufacturer</label>
          <input type="text" id="edit-s-brand" class="form-control" value="${s.brand || 'Krushi Mithra Certified'}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Retail Price (₹) *</label>
          <input type="number" id="edit-s-price" class="form-control" value="${s.price}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Discount Percentage (%)</label>
          <input type="number" id="edit-s-discount" class="form-control" value="${s.discount || 0}">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Stock Quantity Available *</label>
          <input type="number" id="edit-s-qty" class="form-control" value="${s.quantityAvailable || 0}" required>
        </div>
        <div class="form-group">
          <label class="form-label">Unit</label>
          <input type="text" id="edit-s-unit" class="form-control" value="${s.unit || 'bag'}">
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Status</label>
        <select id="edit-s-status" class="form-control">
          <option value="Active" ${s.status === 'Active' ? 'selected' : ''}>Active</option>
          <option value="Out of Stock" ${s.status === 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
          <option value="Inactive" ${s.status === 'Inactive' ? 'selected' : ''}>Inactive</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Product Description</label>
        <textarea id="edit-s-desc" class="form-control" rows="2">${s.description || ''}</textarea>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditStoreProduct(id) {
  const title = document.getElementById('edit-s-title').value;
  const category = document.getElementById('edit-s-cat').value;
  const brand = document.getElementById('edit-s-brand').value;
  const price = parseFloat(document.getElementById('edit-s-price').value) || 0;
  const discount = parseFloat(document.getElementById('edit-s-discount').value) || 0;
  const qty = parseFloat(document.getElementById('edit-s-qty').value) || 0;
  const unit = document.getElementById('edit-s-unit').value;
  const status = document.getElementById('edit-s-status').value;
  const img = document.getElementById('edit-s-img').value;
  const desc = document.getElementById('edit-s-desc').value;

  if (!title) {
    showToast('Please enter product title', 'error');
    return;
  }

  const res = await apiPut(`/store/${id}`, {
    title,
    category,
    brand,
    price,
    discount,
    quantityAvailable: qty,
    unit,
    status,
    images: [img || 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800'],
    description: desc,
  });

  if (res) {
    showToast('Store product details and picture updated!', 'success');
    closeModal();
    await loadAllData();
    renderAgroStoreView();
  }
}



async function deleteStoreProduct(id) {
  if (!confirm('Are you sure you want to remove this product from the Agro Store?')) return;
  const res = await apiDelete(`/store/${id}`);
  if (res) {
    showToast('Store item deleted.', 'success');
    await loadAllData();
    renderAgroStoreView();
  }
}

// ====================================================
// 9. CATEGORIES MANAGEMENT
// ====================================================
let currentCategoryTab = 'machines';

function renderCategoriesView() {
  const container = document.getElementById('content-area');
  const cats = globalData.categories || {};
  const machineCats = cats.machineCategories || [];
  const workerCats = cats.workerCategories || [];
  const mpCats = cats.marketplaceCategories || [];
  const storeCats = cats.storeCategories || [];

  let activeList = [];
  if (currentCategoryTab === 'machines') activeList = machineCats;
  else if (currentCategoryTab === 'workers') activeList = workerCats;
  else if (currentCategoryTab === 'marketplace') activeList = mpCats;
  else if (currentCategoryTab === 'store') activeList = storeCats;

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-tags" style="color:var(--primary);"></i> Category Management Center</h1>
        <p class="page-subtitle">Configure agricultural machinery types, worker skills, produce lots & store classifications</p>
      </div>
    </div>

    <!-- TABS -->
    <div class="tab-navigation">
      <button class="tab-btn ${currentCategoryTab === 'machines' ? 'active' : ''}" onclick="currentCategoryTab='machines'; renderCategoriesView();">
        <i class="fa-solid fa-tractor"></i> Machinery Categories (${machineCats.length})
      </button>
      <button class="tab-btn ${currentCategoryTab === 'workers' ? 'active' : ''}" onclick="currentCategoryTab='workers'; renderCategoriesView();">
        <i class="fa-solid fa-person-digging"></i> Worker Skills (${workerCats.length})
      </button>
      <button class="tab-btn ${currentCategoryTab === 'marketplace' ? 'active' : ''}" onclick="currentCategoryTab='marketplace'; renderCategoriesView();">
        <i class="fa-solid fa-wheat-awn"></i> Produce Crops (${mpCats.length})
      </button>
      <button class="tab-btn ${currentCategoryTab === 'store' ? 'active' : ''}" onclick="currentCategoryTab='store'; renderCategoriesView();">
        <i class="fa-solid fa-store"></i> Agro Store Items (${storeCats.length})
      </button>
    </div>

    <div class="card-table-wrapper">
      <div class="card-header-bar">
        <div>
          <span style="font-weight:700; color:var(--dark-text); font-size:15px;">Active Category Catalog</span>
        </div>
      </div>

      <table class="custom-table">
        <thead>
          <tr>
            <th style="width:70px; text-align:center;">Icon</th>
            <th style="width:240px;">Category Name</th>
            <th>Description</th>
            <th style="width:120px;">Status</th>
          </tr>
        </thead>
        <tbody>
          ${activeList.map(c => `
            <tr>
              <td style="font-size:22px; width:70px; text-align:center;">${c.icon || '🌾'}</td>
              <td><strong style="color:var(--dark-text); font-size:14px;">${c.name}</strong></td>
              <td style="color:var(--gray-text);">${c.description || 'Standard agricultural category'}</td>
              <td><span class="badge badge-green">${c.status || 'Enabled'}</span></td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

// ====================================================
// 10. LOCATIONS & SERVICE HUBS
// ====================================================
let locationSearchQuery = '';

function renderLocationsView() {
  const container = document.getElementById('content-area');
  const locList = globalData.locations || [];
  const districts = (locList[0] && locList[0].districts) || [];

  const filteredDistricts = districts.filter(d => {
    const q = locationSearchQuery.toLowerCase();
    if (!q) return true;
    return d.name.toLowerCase().includes(q) || d.taluks.some(t => t.toLowerCase().includes(q));
  });

  const totalTaluks = districts.reduce((acc, d) => acc + (d.taluks ? d.taluks.length : 0), 0);

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-location-dot" style="color:var(--primary);"></i> Agricultural Regions & Service Hubs</h1>
        <p class="page-subtitle">Malnad & Karnataka district service hubs, taluk clusters & active machinery coverage zones</p>
      </div>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-map-location-dot"></i></div>
          <span class="stat-badge up">Karnataka</span>
        </div>
        <div class="stat-value">${districts.length} Districts</div>
        <div class="stat-label">Operational Hubs</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-cubes"></i></div>
          <span class="stat-badge up">Full Malnad</span>
        </div>
        <div class="stat-value">${totalTaluks} Taluks</div>
        <div class="stat-label">Service Clusters Covered</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon orange"><i class="fa-solid fa-route"></i></div>
          <span class="stat-badge up">50 KM</span>
        </div>
        <div class="stat-value">Instant Dispatch</div>
        <div class="stat-label">Machinery Delivery Radius</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon purple"><i class="fa-solid fa-circle-check"></i></div>
          <span class="stat-badge up">Active</span>
        </div>
        <div class="stat-value">100% Online</div>
        <div class="stat-label">Farmer Support Centers</div>
      </div>
    </div>

    <div class="card-table-wrapper" style="padding:20px;">
      <div class="card-header-bar" style="border-bottom:none; padding:0 0 20px 0;">
        <div class="table-filters">
          <input type="text" class="filter-input" style="min-width:280px;" placeholder="Search district or taluk (e.g. Sagara, Koppa)..." value="${locationSearchQuery}" oninput="locationSearchQuery=this.value; renderLocationsView();">
        </div>
      </div>

      <div class="locations-grid">
        ${filteredDistricts.map(d => `
          <div class="district-card">
            <div class="district-header">
              <div class="district-title">
                <i class="fa-solid fa-landmark" style="color:var(--primary);"></i> ${d.name}
              </div>
              <span class="badge badge-green">${d.taluks.length} Taluks</span>
            </div>
            <div class="taluks-chip-wrap">
              ${d.taluks.map(t => `
                <span class="taluk-chip"><i class="fa-solid fa-location-arrow" style="font-size:10px; color:var(--primary);"></i> ${t}</span>
              `).join('')}
            </div>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// ====================================================
// 11. MOBILE APP CONTENT & CMS MANAGER
// ====================================================
function renderMobileManagerView() {
  const container = document.getElementById('content-area');
  const appContent = (globalData.mobileContent && globalData.mobileContent.content) || {
    homeGreeting: 'Together we grow, together we prosper.',
    heroTitle: 'KRUSHI MITHRA',
    heroSubtitle: 'Digital Farming Marketplace & Agricultural Services Platform',
    machineSectionTitle: 'Available Machinery for Rent',
    workerSectionTitle: 'Hire Skilled Farm Workers & Drivers',
    marketplaceSectionTitle: 'Direct Farmer Produce Marketplace',
    agroStoreSectionTitle: 'Agro Store - Supplies & Fertilizers',
    safetyMessage: 'All machines and workers are verified by Krushi Mithra safety team.',
    supportMessage: 'Need assistance with your booking? Call our Helpline: +91 8000 999 000',
  };

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-mobile-screen-button" style="color:var(--primary);"></i> Mobile App Content Manager</h1>
        <p class="page-subtitle">Configure mobile app home banners, slogans, headlines & safety messages in real-time</p>
      </div>
      <button class="btn btn-primary" onclick="submitMobileContentChanges()"><i class="fa-solid fa-floppy-disk"></i> 💾 Save & Sync to Mobile App</button>
    </div>

    <div class="mobile-manager-grid">
      <!-- LIVE MOBILE PHONE FRAME -->
      <div>
        <div style="text-align:center; font-weight:700; font-size:13px; color:var(--gray-text); margin-bottom:10px;">
          <i class="fa-solid fa-eye"></i> Live Mobile Preview
        </div>
        <div class="mobile-preview-frame">
          <div class="mobile-status-bar">
            <span>9:41</span>
            <span><i class="fa-solid fa-signal"></i> 5G <i class="fa-solid fa-battery-full"></i></span>
          </div>
          <div class="mobile-app-header" id="prev-app-header">
            🌾 KRUSHI MITHRA
          </div>
          <div class="mobile-hero-banner">
            <div id="prev-hero-title" style="font-size:16px; font-weight:800;">${appContent.heroTitle || 'KRUSHI MITHRA'}</div>
            <div id="prev-greeting" style="font-size:11px; opacity:0.9; margin-top:3px;">"${appContent.homeGreeting}"</div>
          </div>
          <div style="padding:14px; background:#f8fafc; font-size:12px;">
            <div style="background:#fff; border:1px solid #e2e8f0; border-radius:10px; padding:10px; margin-bottom:10px; box-shadow:0 1px 3px rgba(0,0,0,0.05);">
              <div style="font-weight:700; color:var(--dark-text);" id="prev-m-title">${appContent.machineSectionTitle}</div>
              <div style="color:var(--gray-text); font-size:11px; margin-top:2px;">🚜 Rent tractors & harvesters</div>
            </div>
            <div style="background:#fff; border:1px solid #e2e8f0; border-radius:10px; padding:10px; margin-bottom:10px; box-shadow:0 1px 3px rgba(0,0,0,0.05);">
              <div style="font-weight:700; color:var(--dark-text);" id="prev-w-title">${appContent.workerSectionTitle}</div>
              <div style="color:var(--gray-text); font-size:11px; margin-top:2px;">👨‍🌾 Verified operators & climbers</div>
            </div>
            <div style="background:#fff; border:1px solid #e2e8f0; border-radius:10px; padding:10px; margin-bottom:10px; box-shadow:0 1px 3px rgba(0,0,0,0.05);">
              <div style="font-weight:700; color:var(--dark-text);" id="prev-mp-title">${appContent.marketplaceSectionTitle}</div>
              <div style="color:var(--gray-text); font-size:11px; margin-top:2px;">🌾 Direct arecanut, pepper, crops</div>
            </div>
            <div style="background:#FEF3C7; border:1px solid #FDE68A; border-radius:8px; padding:8px; font-size:10px; color:#92400E;" id="prev-safety">
              🛡️ ${appContent.safetyMessage}
            </div>
          </div>
        </div>
      </div>

      <!-- EDIT FORM -->
      <div class="mobile-content-card">
        <h3 style="margin-bottom:16px; font-size:16px; color:var(--dark-text);"><i class="fa-solid fa-pen-nib"></i> Mobile App Home Screen Text Configuration</h3>

        <div class="form-group">
          <label class="form-label">Farmer Welcome Slogan / Greeting</label>
          <input type="text" id="cms-greeting" class="form-control" value="${appContent.homeGreeting || ''}" oninput="document.getElementById('prev-greeting').innerText = '\"' + this.value + '\"';">
        </div>

        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Hero Banner Title</label>
            <input type="text" id="cms-hero-title" class="form-control" value="${appContent.heroTitle || ''}" oninput="document.getElementById('prev-hero-title').innerText = this.value;">
          </div>
          <div class="form-group">
            <label class="form-label">Hero Banner Subtitle</label>
            <input type="text" id="cms-hero-sub" class="form-control" value="${appContent.heroSubtitle || ''}">
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Machinery Section Title</label>
          <input type="text" id="cms-m-title" class="form-control" value="${appContent.machineSectionTitle || ''}" oninput="document.getElementById('prev-m-title').innerText = this.value;">
        </div>

        <div class="form-group">
          <label class="form-label">Farm Workers Section Title</label>
          <input type="text" id="cms-w-title" class="form-control" value="${appContent.workerSectionTitle || ''}" oninput="document.getElementById('prev-w-title').innerText = this.value;">
        </div>

        <div class="form-group">
          <label class="form-label">Marketplace Section Title</label>
          <input type="text" id="cms-mp-title" class="form-control" value="${appContent.marketplaceSectionTitle || ''}" oninput="document.getElementById('prev-mp-title').innerText = this.value;">
        </div>

        <div class="form-group">
          <label class="form-label">Safety & Verification Trust Message</label>
          <input type="text" id="cms-safety" class="form-control" value="${appContent.safetyMessage || ''}" oninput="document.getElementById('prev-safety').innerText = '🛡️ ' + this.value;">
        </div>

        <div class="form-group">
          <label class="form-label">Helpline Support Message</label>
          <input type="text" id="cms-support" class="form-control" value="${appContent.supportMessage || ''}">
        </div>

        <div style="margin-top:20px;">
          <button class="btn btn-primary" onclick="submitMobileContentChanges()"><i class="fa-solid fa-floppy-disk"></i> 💾 Save & Sync to Mobile App</button>
        </div>
      </div>
    </div>
  `;
}

async function submitMobileContentChanges() {
  const getVal = (id) => {
    const el = document.getElementById(id);
    return el ? el.value : '';
  };

  const payload = {
    content: {
      homeGreeting: getVal('cms-greeting'),
      heroTitle: getVal('cms-hero-title'),
      heroSubtitle: getVal('cms-hero-sub'),
      machineSectionTitle: getVal('cms-m-title'),
      workerSectionTitle: getVal('cms-w-title'),
      marketplaceSectionTitle: getVal('cms-mp-title'),
      agroStoreSectionTitle: 'Agro Store - Supplies & Fertilizers',
      safetyMessage: getVal('cms-safety'),
      supportMessage: getVal('cms-support'),
    }
  };

  try {
    const res = await apiPut('/mobile-content', payload);
    if (res) {
      showToast('Mobile App content updated and synced successfully!', 'success');
      await loadAllData();
      renderMobileManagerView();
    }
  } catch (e) {
    console.error('Error updating mobile content:', e);
    showToast('Failed to sync content with mobile app', 'error');
  }
}

// ====================================================
// 12. BANNERS & PROMOTIONS
// ====================================================
function renderBannersView() {
  const container = document.getElementById('content-area');
  const banners = globalData.banners || [];

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-image" style="color:var(--primary);"></i> Promotional Banners & In-App Ads</h1>
        <p class="page-subtitle">Manage high-impact marketing banners displayed in the Krushi Mithra mobile application</p>
      </div>
      <button class="btn btn-primary" onclick="openAddBannerModal()"><i class="fa-solid fa-plus"></i> + Create Promotional Banner</button>
    </div>

    <!-- STATS GRID -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon green"><i class="fa-solid fa-images"></i></div>
          <span class="stat-badge up">Live</span>
        </div>
        <div class="stat-value">${banners.length} Banners</div>
        <div class="stat-label">Total Mobile Banners</div>
      </div>
      <div class="stat-card">
        <div class="stat-top">
          <div class="stat-icon blue"><i class="fa-solid fa-bullhorn"></i></div>
          <span class="stat-badge up">100% CTR</span>
        </div>
        <div class="stat-value">High Engagement</div>
        <div class="stat-label">Machinery & Season Offers</div>
      </div>
    </div>

    <!-- BANNERS GRID -->
    <div class="banners-grid">
      ${banners.map(b => `
        <div class="banner-item-card">
          <div class="banner-img-wrap">
            <img src="${b.imageUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'}" alt="${b.title}">
            <div class="banner-badge-overlay">
              <span class="badge ${b.status === 'Active' ? 'badge-green' : 'badge-red'}">${b.status || 'Active'}</span>
            </div>
          </div>
          <div class="banner-info-body">
            <div>
              <div class="banner-title">${b.title}</div>
              <div class="banner-subtitle">${b.subtitle || ''}</div>
              <div style="font-size:12px; color:var(--primary-dark); font-weight:600;">
                <i class="fa-solid fa-arrow-up-right-from-square"></i> Target Screen: ${b.targetScreen || 'Home'}
              </div>
            </div>
            <div class="banner-footer">
              <span class="badge badge-orange">${b.buttonText || 'Explore Now'}</span>
              <div class="table-actions">
                <button class="btn btn-sm btn-secondary" onclick="openEditBannerModal('${b.id}')"><i class="fa-solid fa-pen-to-square"></i> Edit</button>
                <button class="btn btn-sm btn-danger" onclick="deleteBanner('${b.id}')"><i class="fa-solid fa-trash"></i></button>
              </div>
            </div>
          </div>
        </div>
      `).join('')}
    </div>
  `;
}

function openAddBannerModal() {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-plus"></i> Create Promotional Banner`;
  submitBtn.innerText = 'Publish Banner';
  submitBtn.onclick = () => submitAddBannerForm();

  modalBody.innerHTML = `
    <form id="add-banner-form">
      <!-- Photo / Image Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Banner Photo / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="ban-add-img-preview" src="https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800" 
              style="width:140px; height:80px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Banner Photo">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Photo Image URL</label>
            <input type="text" id="ban-img" class="form-control" value="https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800" 
              placeholder="Paste photo URL (https://...)" 
              oninput="document.getElementById('ban-add-img-preview').src = this.value || 'https://via.placeholder.com/140x80'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'ban-img', 'ban-add-img-preview')">🚜 Tractor</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800', 'ban-img', 'ban-add-img-preview')">🌾 Harvester</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'ban-img', 'ban-add-img-preview')">🌱 Agri Field</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800', 'ban-img', 'ban-add-img-preview')">🛍️ Store</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="ban-add-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'ban-img', 'ban-add-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('ban-add-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Banner Headline *</label>
        <input type="text" id="ban-title" class="form-control" placeholder="e.g. Monsoon Tractor & Harvester Rental Offers!" required>
      </div>

      <div class="form-group">
        <label class="form-label">Subtitle / Offer Description</label>
        <input type="text" id="ban-sub" class="form-control" placeholder="Rent heavy-duty machinery starting @ ₹600/day across Karnataka">
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Button CTA Text</label>
          <input type="text" id="ban-btn-text" class="form-control" value="Rent Machine Now">
        </div>
        <div class="form-group">
          <label class="form-label">Target Mobile Screen</label>
          <select id="ban-target" class="form-control">
            <option value="Machines">🚜 Machines & Rentals</option>
            <option value="Workers">👨‍🌾 Farm Workers</option>
            <option value="Marketplace">🌾 Produce Marketplace</option>
            <option value="Store">🛍️ Agro Store</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitAddBannerForm() {
  const title = document.getElementById('ban-title').value;
  const subtitle = document.getElementById('ban-sub').value;
  const buttonText = document.getElementById('ban-btn-text').value;
  const targetScreen = document.getElementById('ban-target').value;
  const imageUrl = document.getElementById('ban-img').value;

  if (!title) {
    showToast('Please enter banner title', 'error');
    return;
  }

  const payload = {
    title,
    subtitle,
    buttonText,
    targetScreen,
    imageUrl: imageUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
    status: 'Active',
    displayOrder: (globalData.banners.length || 0) + 1,
  };

  const res = await apiPost('/banners', payload);
  if (res) {
    showToast('Banner created and published!', 'success');
    closeModal();
    await loadAllData();
    renderBannersView();
  }
}

function openEditBannerModal(id) {
  const b = globalData.banners.find(item => item.id === id);
  if (!b) return;

  const currentImg = b.imageUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Banner - ${b.title}`;
  submitBtn.innerText = 'Save Banner';
  submitBtn.onclick = () => submitEditBannerForm(id);

  modalBody.innerHTML = `
    <form id="edit-banner-form">
      <!-- Photo / Image Upload Section -->
      <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:12px; padding:16px; margin-bottom:20px;">
        <label class="form-label" style="font-weight:700; color:var(--primary-dark); margin-bottom:10px; display:block;">
          <i class="fa-solid fa-camera" style="color:var(--primary);"></i> Banner Photo / Image Settings
        </label>
        <div style="display:flex; gap:16px; align-items:center; flex-wrap:wrap;">
          <div style="position:relative;">
            <img id="edit-ban-img-preview" src="${currentImg}" 
              style="width:140px; height:80px; object-fit:cover; border-radius:10px; border:2px solid var(--primary); box-shadow:0 3px 8px rgba(0,0,0,0.12);" alt="Banner Photo">
            <span style="position:absolute; bottom:-6px; right:-6px; background:var(--primary); color:#fff; font-size:10px; font-weight:700; padding:2px 6px; border-radius:10px;">Live Preview</span>
          </div>
          <div style="flex:1; min-width:240px;">
            <label class="form-label" style="font-size:12px; margin-bottom:4px;">Photo Image URL</label>
            <input type="text" id="edit-ban-img" class="form-control" value="${currentImg}" 
              placeholder="Paste photo URL (https://...)" 
              oninput="document.getElementById('edit-ban-img-preview').src = this.value || 'https://via.placeholder.com/140x80'">
            
            <div style="margin-top:8px; display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
              <span style="font-size:11px; color:#64748b; font-weight:600;">Sample Photos:</span>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800', 'edit-ban-img', 'edit-ban-img-preview')">🚜 Tractor</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=800', 'edit-ban-img', 'edit-ban-img-preview')">🌾 Harvester</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800', 'edit-ban-img', 'edit-ban-img-preview')">🌱 Agri Field</button>
              <button type="button" class="btn btn-sm btn-outline-primary" style="padding:2px 8px; font-size:11px;" 
                onclick="setMachinePhotoPreset('https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800', 'edit-ban-img', 'edit-ban-img-preview')">🛍️ Store</button>
            </div>

            <div style="margin-top:10px;">
              <input type="file" id="edit-ban-file" accept="image/*" style="display:none;" 
                onchange="handleImageFileSelect(this, 'edit-ban-img', 'edit-ban-img-preview')">
              <button type="button" class="btn btn-sm btn-secondary" style="padding:5px 12px; font-size:12px;" 
                onclick="document.getElementById('edit-ban-file').click()">
                <i class="fa-solid fa-cloud-arrow-up"></i> Upload Photo File...
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Banner Headline *</label>
        <input type="text" id="edit-ban-title" class="form-control" value="${b.title}" required>
      </div>

      <div class="form-group">
        <label class="form-label">Subtitle / Description</label>
        <input type="text" id="edit-ban-sub" class="form-control" value="${b.subtitle || ''}">
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Target Screen</label>
          <select id="edit-ban-target" class="form-control">
            <option value="Machines" ${b.targetScreen === 'Machines' ? 'selected' : ''}>Machines</option>
            <option value="Workers" ${b.targetScreen === 'Workers' ? 'selected' : ''}>Workers</option>
            <option value="Marketplace" ${b.targetScreen === 'Marketplace' ? 'selected' : ''}>Marketplace</option>
            <option value="Store" ${b.targetScreen === 'Store' ? 'selected' : ''}>Store</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Status</label>
          <select id="edit-ban-status" class="form-control">
            <option value="Active" ${b.status === 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${b.status === 'Inactive' ? 'selected' : ''}>Inactive</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditBannerForm(id) {
  const title = document.getElementById('edit-ban-title').value;
  const subtitle = document.getElementById('edit-ban-sub').value;
  const targetScreen = document.getElementById('edit-ban-target').value;
  const status = document.getElementById('edit-ban-status').value;
  const imageUrl = document.getElementById('edit-ban-img').value;

  const res = await apiPut(`/banners/${id}`, {
    title,
    subtitle,
    targetScreen,
    status,
    imageUrl: imageUrl || 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800',
  });

  if (res) {
    showToast('Banner photo and details updated!', 'success');
    closeModal();
    await loadAllData();
    renderBannersView();
  }
}

async function deleteBanner(id) {
  if (!confirm('Are you sure you want to delete this promotional banner?')) return;
  const res = await apiDelete(`/banners/${id}`);
  if (res) {
    showToast('Banner removed.', 'success');
    await loadAllData();
    renderBannersView();
  }
}

// ====================================================
// 13. REVIEWS & RATINGS MODERATION
// ====================================================
function renderReviewsView() {
  const container = document.getElementById('content-area');
  const reviews = globalData.reviews || [];

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-star" style="color:var(--accent-orange);"></i> Customer Reviews & Ratings</h1>
        <p class="page-subtitle">Farmer feedback on machines, operators, and agricultural produce</p>
      </div>
    </div>

    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead>
          <tr>
            <th>Reviewer</th>
            <th>Target Service</th>
            <th>Rating</th>
            <th>Feedback Comment</th>
            <th>Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          ${reviews.map(r => `
            <tr>
              <td><strong>${r.userName}</strong></td>
              <td><span class="badge badge-orange">${r.targetType || 'Machine'}</span> ${r.targetTitle || ''}</td>
              <td style="color:var(--accent-orange); font-weight:700;">⭐ ${r.rating} / 5</td>
              <td style="max-width:300px;">"${r.comment}"</td>
              <td>${r.date || ''}</td>
              <td><span class="badge badge-green">${r.status || 'Approved'}</span></td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

// ====================================================
// 14. PUSH NOTIFICATIONS
// ====================================================
function renderNotificationsView() {
  const container = document.getElementById('content-area');
  const notifs = globalData.notifications || [];

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-paper-plane" style="color:var(--primary);"></i> Push Notifications Broadcast</h1>
        <p class="page-subtitle">Send urgent notifications, weather alerts & seasonal discounts to farmer mobile apps</p>
      </div>
    </div>

    <div class="mobile-manager-grid">
      <!-- NOTIFICATION COMPOSER -->
      <div class="mobile-content-card">
        <h3 style="margin-bottom:16px; font-size:16px; color:var(--dark-text);"><i class="fa-solid fa-bullhorn"></i> Send Push Broadcast</h3>
        <div class="form-group">
          <label class="form-label">Notification Title</label>
          <input type="text" id="notif-title" class="form-control" placeholder="e.g. 15% Off Harvester Rentals This Week!" required>
        </div>
        <div class="form-group">
          <label class="form-label">Message Content</label>
          <textarea id="notif-msg" class="form-control" rows="3" placeholder="Enter notification message visible on lock screens..."></textarea>
        </div>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Target Audience</label>
            <select id="notif-target" class="form-control">
              <option value="All Users">All Registered Users</option>
              <option value="Farmers">Farmers Only</option>
              <option value="Machine Owners">Machinery Providers</option>
              <option value="Workers">Farm Workers & Drivers</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Notification Type</label>
            <select id="notif-type" class="form-control">
              <option value="Promotion">Promotion</option>
              <option value="Alert">Weather / Advisory Alert</option>
              <option value="System">System Update</option>
            </select>
          </div>
        </div>
        <button class="btn btn-primary" onclick="submitSendNotification()"><i class="fa-solid fa-paper-plane"></i> Send Notification Now</button>
      </div>

      <!-- SENT HISTORY -->
      <div class="card-table-wrapper">
        <div class="card-header-bar">
          <span style="font-weight:700; color:var(--dark-text);">Broadcast History</span>
        </div>
        <table class="custom-table">
          <thead>
            <tr>
              <th>Title</th>
              <th>Audience</th>
              <th>Status</th>
              <th>Sent At</th>
              <th style="text-align:right;">Actions</th>
            </tr>
          </thead>
          <tbody>
            ${notifs.map(n => `
              <tr>
                <td><strong>${n.title}</strong><br><span class="cell-subtitle">${n.message}</span></td>
                <td><span class="badge badge-blue">${n.targetAudience || 'All Users'}</span></td>
                <td><span class="badge badge-green">${n.status || 'Sent'}</span></td>
                <td style="white-space:nowrap; font-size:12px;">${n.sentAt || ''}</td>
                <td style="text-align:right; white-space:nowrap;">
                  <div style="display:flex; gap:6px; justify-content:flex-end;">
                    <button class="btn btn-sm btn-primary" onclick="resendNotification('${n.id}')" title="Send / Resend Push Broadcast to Mobile App"><i class="fa-solid fa-paper-plane"></i> Send</button>
                    <button class="btn btn-sm btn-danger" onclick="deleteNotification('${n.id}')" title="Delete Broadcast Record"><i class="fa-solid fa-trash"></i> Delete</button>
                  </div>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

async function submitSendNotification() {
  const title = document.getElementById('notif-title').value;
  const msg = document.getElementById('notif-msg').value;
  const target = document.getElementById('notif-target').value;
  const type = document.getElementById('notif-type').value;

  if (!title || !msg) {
    showToast('Please enter both title and message', 'error');
    return;
  }

  const res = await apiPost('/notifications', {
    title,
    message: msg,
    targetAudience: target,
    type,
    status: 'Sent',
  });

  if (res) {
    showToast('Push broadcast dispatched to mobile devices!', 'success');
    await loadAllData();
    renderNotificationsView();
  }
}

async function resendNotification(id) {
  const notif = globalData.notifications.find(n => n.id === id);
  if (!notif) return;

  if (!confirm(`Do you want to re-send broadcast notification "${notif.title}" to ${notif.targetAudience || 'All Users'}?`)) {
    return;
  }

  const res = await apiPost(`/notifications/${id}/resend`, {});
  if (res) {
    showToast(`Broadcast "${notif.title}" sent successfully to mobile devices!`, 'success');
  } else {
    // Fallback POST re-broadcast
    await apiPost('/notifications', {
      title: notif.title,
      message: notif.message,
      targetAudience: notif.targetAudience || 'All Users',
      type: notif.type || 'Promotion',
      status: 'Sent',
    });
    showToast(`Broadcast "${notif.title}" sent successfully!`, 'success');
  }
  await loadAllData();
  renderNotificationsView();
}

async function deleteNotification(id) {
  const notif = globalData.notifications.find(n => n.id === id);
  const title = notif ? notif.title : 'this broadcast';

  if (!confirm(`Are you sure you want to delete broadcast "${title}"?`)) {
    return;
  }

  const res = await apiDelete(`/notifications/${id}`);
  if (res) {
    showToast(`Notification broadcast "${title}" deleted successfully!`, 'success');
    await loadAllData();
    renderNotificationsView();
  }
}

// ====================================================
// 15. REPORTS, PAYMENTS, SUPPORT, LOGS & SETTINGS
// ====================================================
function renderReportsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-file-invoice" style="color:var(--primary);"></i> Krushi Mithra Analytics & Reports</h1>
        <p class="page-subtitle">Agricultural platform operational volume, GMV revenue & regional adoption metrics</p>
      </div>
    </div>
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-value">1,842</div>
        <div class="stat-label">Total Machinery Rentals Fulfilled</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">582</div>
        <div class="stat-label">Worker / Driver Bookings</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">₹8,42,500</div>
        <div class="stat-label">Gross Merchandise Value (GMV)</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">Tractors (42%)</div>
        <div class="stat-label">Most Rented Machinery Category</div>
      </div>
    </div>
  `;
}

function renderPaymentsView() {
  const container = document.getElementById('content-area');
  const payments = globalData.payments || [];
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-indian-rupee-sign" style="color:var(--primary);"></i> Payment Transactions & Escrow</h1>
        <p class="page-subtitle">Rental transactions, security deposits & provider payouts</p>
      </div>
    </div>
    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead>
          <tr>
            <th>Txn ID</th>
            <th>Customer</th>
            <th>Booking ID</th>
            <th>Amount</th>
            <th>Method</th>
            <th>Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          ${payments.map(p => `
            <tr>
              <td><strong>${p.id}</strong></td>
              <td>${p.user || 'Farmer'}</td>
              <td>${p.bookingId || 'b_1001'}</td>
              <td><strong style="color:var(--primary-dark);">₹${p.amount}</strong></td>
              <td>${p.method || 'Cash on Delivery'}</td>
              <td>${p.date || ''}</td>
              <td><span class="badge badge-green">${p.status || 'Success'}</span></td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderSupportView() {
  const container = document.getElementById('content-area');
  const tickets = globalData.support || [];
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-headset" style="color:var(--primary);"></i> Farmer Support Tickets</h1>
        <p class="page-subtitle">Customer care, machine breakdown reports & booking inquiries</p>
      </div>
    </div>
    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead>
          <tr>
            <th>Ticket ID</th>
            <th>Farmer</th>
            <th>Category</th>
            <th>Subject</th>
            <th>Priority</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          ${tickets.map(t => `
            <tr>
              <td><strong>${t.id}</strong></td>
              <td>${t.userName}<br><span class="cell-subtitle">${t.userPhone || ''}</span></td>
              <td><span class="badge badge-blue">${t.category || 'Inquiry'}</span></td>
              <td><strong>${t.subject}</strong><br><span class="cell-subtitle">${t.description || ''}</span></td>
              <td><span class="badge badge-orange">${t.priority || 'Medium'}</span></td>
              <td><span class="badge badge-green">${t.status || 'Resolved'}</span></td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderAdminUsersView() {
  const container = document.getElementById('content-area');
  const admins = globalData.adminUsers || [];
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-user-shield" style="color:var(--primary);"></i> Admin Users & Access Control</h1>
        <p class="page-subtitle">Authorized administrators managing the Krushi Mithra ecosystem</p>
      </div>
      <button class="btn btn-primary" onclick="openAddAdminUserModal()"><i class="fa-solid fa-user-plus"></i> + Add Admin User</button>
    </div>
    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="min-width:200px;">Admin Name & Email</th>
              <th style="width:160px;">Role</th>
              <th style="width:120px;">Status</th>
              <th style="width:180px;">Last Active</th>
              <th style="min-width:160px;">Actions</th>
            </tr>
          </thead>
          <tbody>
            ${admins.map(a => `
              <tr>
                <td><strong>${a.name}</strong><br><span class="cell-subtitle">${a.email}</span></td>
                <td style="white-space:nowrap;"><span class="badge ${a.role === 'Super Admin' ? 'badge-green' : 'badge-blue'}">${a.role}</span></td>
                <td style="white-space:nowrap;"><span class="badge ${a.status === 'Active' ? 'badge-green' : 'badge-red'}">${a.status}</span></td>
                <td style="white-space:nowrap;">${a.lastLogin || 'Recent'}</td>
                <td>
                  <div class="table-actions">
                    <button class="btn btn-sm btn-primary" onclick="openEditAdminUserModal('${a.id}')" title="Edit Admin Role & Access"><i class="fa-solid fa-pen-to-square"></i> Edit</button>
                    <button class="btn btn-sm btn-danger" onclick="deleteAdminUser('${a.id}')" title="Delete Admin User"><i class="fa-solid fa-trash"></i> Delete</button>
                  </div>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function openAddAdminUserModal() {
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-user-plus"></i> Add New Admin User`;
  submitBtn.innerText = 'Save & Authorize Admin';
  submitBtn.onclick = () => submitAddAdminUserForm();

  modalBody.innerHTML = `
    <form id="add-admin-user-form">
      <div class="form-group">
        <label class="form-label">Full Name *</label>
        <input type="text" id="adm-add-name" class="form-control" placeholder="e.g. Anand Kumar" required>
      </div>
      <div class="form-group">
        <label class="form-label">Admin Email *</label>
        <input type="email" id="adm-add-email" class="form-control" placeholder="anand.kumar@krushimithra.com" required>
      </div>
      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Administrative Role *</label>
          <select id="adm-add-role" class="form-control">
            <option value="Super Admin">Super Admin (Full Control)</option>
            <option value="Operations Manager">Operations Manager</option>
            <option value="Support Lead">Support Lead</option>
            <option value="Marketplace Admin">Marketplace Admin</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Account Status</label>
          <select id="adm-add-status" class="form-control">
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitAddAdminUserForm() {
  const name = document.getElementById('adm-add-name').value;
  const email = document.getElementById('adm-add-email').value;
  const role = document.getElementById('adm-add-role').value;
  const status = document.getElementById('adm-add-status').value;

  if (!name || !email) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  const payload = {
    name,
    email,
    role,
    status,
    lastLogin: new Date().toLocaleString(),
  };

  const res = await apiPost('/admin-users', payload);
  if (res) {
    showToast(`New admin user "${name}" added successfully!`, 'success');
    closeModal();
    await loadAllData();
    renderAdminUsersView();
  }
}

function openEditAdminUserModal(id) {
  const admin = (globalData.adminUsers || []).find(a => a.id === id);
  if (!admin) return;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-solid fa-pen-to-square"></i> Edit Admin User - ${admin.name}`;
  submitBtn.innerText = 'Save Changes';
  submitBtn.onclick = () => submitEditAdminUserForm(id);

  modalBody.innerHTML = `
    <form id="edit-admin-user-form">
      <div class="form-group">
        <label class="form-label">Full Name *</label>
        <input type="text" id="adm-edit-name" class="form-control" value="${admin.name || ''}" required>
      </div>
      <div class="form-group">
        <label class="form-label">Admin Email *</label>
        <input type="email" id="adm-edit-email" class="form-control" value="${admin.email || ''}" required>
      </div>
      <div class="form-grid">
        <div class="form-group">
          <label class="form-label">Administrative Role *</label>
          <select id="adm-edit-role" class="form-control">
            <option value="Super Admin" ${admin.role === 'Super Admin' ? 'selected' : ''}>Super Admin (Full Control)</option>
            <option value="Operations Manager" ${admin.role === 'Operations Manager' || admin.role === 'Manager' ? 'selected' : ''}>Operations Manager</option>
            <option value="Support Lead" ${admin.role === 'Support Lead' ? 'selected' : ''}>Support Lead</option>
            <option value="Marketplace Admin" ${admin.role === 'Marketplace Admin' ? 'selected' : ''}>Marketplace Admin</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Account Status</label>
          <select id="adm-edit-status" class="form-control">
            <option value="Active" ${admin.status === 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${admin.status === 'Inactive' ? 'selected' : ''}>Inactive</option>
          </select>
        </div>
      </div>
    </form>
  `;

  document.getElementById('modal-overlay').classList.add('active');
}

async function submitEditAdminUserForm(id) {
  const name = document.getElementById('adm-edit-name').value;
  const email = document.getElementById('adm-edit-email').value;
  const role = document.getElementById('adm-edit-role').value;
  const status = document.getElementById('adm-edit-status').value;

  if (!name || !email) {
    showToast('Please fill all required fields', 'error');
    return;
  }

  const res = await apiPut(`/admin-users/${id}`, { name, email, role, status });
  if (res) {
    showToast(`Admin user "${name}" updated successfully!`, 'success');
    closeModal();
    await loadAllData();
    renderAdminUsersView();
  }
}

async function deleteAdminUser(id) {
  const admin = (globalData.adminUsers || []).find(a => a.id === id);
  const name = admin ? admin.name : 'this admin user';

  if (!confirm(`Are you sure you want to remove admin access for ${name}?`)) {
    return;
  }

  const res = await apiDelete(`/admin-users/${id}`);
  if (res) {
    showToast(`Admin user ${name} removed.`, 'success');
    await loadAllData();
    renderAdminUsersView();
  }
}

function renderActivityLogsView() {
  const container = document.getElementById('content-area');
  const logs = globalData.activityLogs || [];
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-clock-rotate-left" style="color:var(--primary);"></i> Audit Trail & Activity Logs</h1>
        <p class="page-subtitle">Real-time record of admin actions, verification decisions & listing changes</p>
      </div>
    </div>
    <div class="card-table-wrapper">
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th style="width: 170px;">Admin</th>
              <th style="width: 160px;">Action</th>
              <th style="width: 140px;">Module</th>
              <th>Details</th>
              <th style="width: 170px; text-align: right;">Timestamp</th>
            </tr>
          </thead>
          <tbody>
            ${logs.map(l => `
              <tr>
                <td style="white-space: nowrap;"><strong>${l.admin}</strong></td>
                <td><span class="badge badge-blue">${l.action}</span></td>
                <td><span class="badge badge-orange">${l.module}</span></td>
                <td style="color: var(--dark-text);">${l.details}</td>
                <td style="white-space: nowrap; font-size: 12px; text-align: right; color: var(--gray-text);">${l.date || ''}</td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
}

function renderSettingsView() {
  const container = document.getElementById('content-area');
  const s = globalData.settings || {};

  const defaultSafetyTips = (s.whatsappSafetyTips && Array.isArray(s.whatsappSafetyTips))
    ? s.whatsappSafetyTips.join('\n')
    : `1. Never give money or product in advance.
2. Do not scan any QR code or send even ₹1 to anyone.
3. Never share your OTP or UPI PIN.
4. Be safe, take necessary precautions while meeting with buyers and sellers.
5. Krushi Mithra team is not responsible for any fraudulent activities.`;

  const defaultProdTpl = s.whatsappProductTemplate || "Hi {name},\n\nI'm interested in your {title} posted on Krushi Mithra.\n\nIs it available?";
  const defaultWorkerTpl = s.whatsappLabourTemplate || "Hi {name},\n\nI'm interested in hiring you for agricultural work ({category}) posted on Krushi Mithra.\n\nAre you available?";
  const defaultMachineTpl = s.whatsappMachineTemplate || "Hi {name},\n\nI'm interested in renting your {title} posted on Krushi Mithra.\n\nIs it available?";

  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-sliders" style="color:var(--primary);"></i> Settings & WhatsApp Templates</h1>
        <p class="page-subtitle">Manage global configuration, safety guidelines, and WhatsApp messaging patterns for products & labours</p>
      </div>
      <button class="btn btn-primary" onclick="submitSettingsChanges()"><i class="fa-solid fa-floppy-disk"></i> Save Settings & Templates</button>
    </div>

    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom:20px;">
      <!-- General Platform Settings Card -->
      <div class="mobile-content-card" style="margin-bottom:0;">
        <h3 style="font-size:16px; font-weight:700; margin-bottom:15px; border-bottom:1px solid #eee; padding-bottom:8px;">
          <i class="fa-solid fa-gear" style="color:var(--primary);"></i> General Platform Settings
        </h3>
        <div class="form-group">
          <label class="form-label">Platform Name</label>
          <input type="text" id="set-name" class="form-control" value="${s.appName || 'KRUSHI MITHRA'}">
        </div>
        <div class="form-group">
          <label class="form-label">Tagline</label>
          <input type="text" id="set-tagline" class="form-control" value="${s.tagline || 'Digital Farming Marketplace & Agricultural Services Platform'}">
        </div>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Customer Helpline</label>
            <input type="text" id="set-phone" class="form-control" value="${s.supportPhone || '+91 8000 999 000'}">
          </div>
          <div class="form-group">
            <label class="form-label">Support Email</label>
            <input type="text" id="set-email" class="form-control" value="${s.supportEmail || 'support@krushimithra.com'}">
          </div>
        </div>
        <div class="form-grid">
          <div class="form-group">
            <label class="form-label">Platform Commission (%)</label>
            <input type="number" id="set-comm" class="form-control" value="${s.commissionRate || 5}">
          </div>
          <div class="form-group">
            <label class="form-label">Currency</label>
            <input type="text" id="set-curr" class="form-control" value="INR (₹)" disabled>
          </div>
        </div>
      </div>

      <!-- WhatsApp Message Format & Safety Guidelines Editor Card -->
      <div class="mobile-content-card" style="margin-bottom:0;">
        <h3 style="font-size:16px; font-weight:700; margin-bottom:15px; border-bottom:1px solid #eee; padding-bottom:8px; color:#25D366;">
          <i class="fa-brands fa-whatsapp"></i> WhatsApp Message Templates & Safety Tips
        </h3>
        
        <div class="form-group">
          <label class="form-label">Safety Guidelines Header Title</label>
          <input type="text" id="set-wa-header" class="form-control" value="${s.whatsappSafetyHeader || 'Tips for a safe deal'}">
        </div>

        <div class="form-group">
          <label class="form-label">Safety Guidelines (5 Rules - 1 per line)</label>
          <textarea id="set-wa-tips" class="form-control" rows="5" style="font-size:13px; font-family:monospace;">${defaultSafetyTips}</textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Marketplace Crop / Produce WhatsApp Inquiry Body</label>
          <textarea id="set-wa-prod" class="form-control" rows="3" style="font-size:13px;">${defaultProdTpl}</textarea>
          <small style="color:var(--gray-text);">Available tags: {name}, {title}, {price}</small>
        </div>

        <div class="form-group">
          <label class="form-label">Labour / Worker WhatsApp Inquiry Body</label>
          <textarea id="set-wa-worker" class="form-control" rows="3" style="font-size:13px;">${defaultWorkerTpl}</textarea>
          <small style="color:var(--gray-text);">Available tags: {name}, {category}, {rate}</small>
        </div>

        <div class="form-group">
          <label class="form-label">Machinery Rental WhatsApp Inquiry Body</label>
          <textarea id="set-wa-machine" class="form-control" rows="3" style="font-size:13px;">${defaultMachineTpl}</textarea>
          <small style="color:var(--gray-text);">Available tags: {name}, {title}, {rate}</small>
        </div>
      </div>
    </div>
    <div style="text-align:right; margin-bottom:30px;">
      <button class="btn btn-primary btn-lg" onclick="submitSettingsChanges()"><i class="fa-solid fa-floppy-disk"></i> Save Settings & Templates</button>
    </div>
  `;
}

async function submitSettingsChanges() {
  const tipsRaw = document.getElementById('set-wa-tips').value;
  const tipsList = tipsRaw.split('\n').map(t => t.trim()).filter(t => t.length > 0);

  const payload = {
    appName: document.getElementById('set-name').value,
    tagline: document.getElementById('set-tagline').value,
    supportPhone: document.getElementById('set-phone').value,
    supportEmail: document.getElementById('set-email').value,
    commissionRate: parseFloat(document.getElementById('set-comm').value) || 5,
    whatsappSafetyHeader: document.getElementById('set-wa-header').value,
    whatsappSafetyTips: tipsList,
    whatsappProductTemplate: document.getElementById('set-wa-prod').value,
    whatsappLabourTemplate: document.getElementById('set-wa-worker').value,
    whatsappMachineTemplate: document.getElementById('set-wa-machine').value,
  };
  const res = await apiPut('/settings', payload);
  if (res) {
    showToast('Platform settings & WhatsApp templates saved successfully!', 'success');
    await loadAllData();
  }
}

function openWhatsAppModal(type, id) {
  let recipientPhone = '';
  let recipientName = '';
  let itemTitle = '';
  let categoryName = '';
  let itemUrl = '';

  const settings = globalData.settings || {};
  const safetyHeader = settings.whatsappSafetyHeader || 'Tips for a safe deal';
  const safetyTips = (settings.whatsappSafetyTips && Array.isArray(settings.whatsappSafetyTips) && settings.whatsappSafetyTips.length > 0)
    ? settings.whatsappSafetyTips
    : [
      '1. Never give money or product in advance.',
      '2. Do not scan any QR code or send even ₹1 to anyone.',
      '3. Never share your OTP or UPI PIN.',
      '4. Be safe, take necessary precautions while meeting with buyers and sellers.',
      '5. Krushi Mithra team is not responsible for any fraudulent activities.'
    ];

  if (type === 'product' || type === 'marketplace') {
    const item = (globalData.marketplace || []).find(p => p.id === id);
    if (!item) return;
    recipientName = item.sellerName || 'Farmer';
    recipientPhone = item.sellerPhone || '+91 8904089051';
    itemTitle = item.title || 'Produce Listing';
    categoryName = 'Produce Listing';
    itemUrl = `https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra&referrer=itemType%3Dmarketplace%26itemId%3D${item.id}`;
  } else if (type === 'worker') {
    const w = (globalData.workers || []).find(w => w.id === id);
    if (!w) return;
    recipientName = w.name || 'Farm Worker';
    recipientPhone = w.phone || '+91 8904089051';
    itemTitle = `${w.name} (${w.category || 'Worker'})`;
    categoryName = 'Farm Worker Profile';
    itemUrl = `https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra&referrer=itemType%3Dworkers%26itemId%3D${w.id}`;
  } else if (type === 'machine') {
    const m = (globalData.machines || []).find(m => m.id === id);
    if (!m) return;
    recipientName = m.ownerName || 'Machine Owner';
    recipientPhone = m.ownerPhone || '+91 8904089051';
    itemTitle = m.name || 'Tractor / Equipment';
    categoryName = 'Machinery Rental';
    itemUrl = `https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra&referrer=itemType%3Dmachines%26itemId%3D${m.id}`;
  } else if (type === 'user' || type === 'farmer') {
    const u = (globalData.users || []).find(u => u.id === id) || (globalData.farmers || []).find(f => f.id === id);
    if (!u) return;
    recipientName = u.name || 'User';
    recipientPhone = u.phone || '+91 8904089051';
    itemTitle = 'Krushi Mithra Account';
    categoryName = 'Krushi Mithra Account';
    itemUrl = `https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra&referrer=itemType%3Dusers%26itemId%3D${u.id}`;
  } else if (type === 'booking') {
    const b = (globalData.bookings || []).find(b => b.id === id);
    if (!b) return;
    recipientName = b.customerName || 'Customer';
    recipientPhone = b.customerPhone || b.phone || '+91 8904089051';
    itemTitle = b.targetTitle || 'Booking';
    categoryName = 'Service Booking';
    itemUrl = `https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra&referrer=itemType%3Dbookings%26itemId%3D${b.id}`;
  }

  const tipsBlock = safetyTips.join('\n');
  const playStoreLink = 'https://play.google.com/store/apps/details?id=com.krushimithra.krushi_mithra';
  const bodyText = `Hi ${recipientName},\n\nI'm interested in your ${itemTitle} posted on Krushi Mithra.\n\nIs it available?`;

  const fullWhatsAppMessage = `*${safetyHeader}*\n\n${tipsBlock}\n\nYour ${categoryName}: ${itemUrl}\n\n${bodyText}`;

  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const submitBtn = document.getElementById('modal-submit-btn');

  modalTitle.innerHTML = `<i class="fa-brands fa-whatsapp" style="color:#25D366;"></i> Send WhatsApp Message to ${recipientName}`;
  submitBtn.innerText = 'Launch WhatsApp Chat';
  submitBtn.className = 'btn btn-whatsapp';

  modalBody.innerHTML = `
    <div style="margin-bottom:15px;">
      <label style="font-weight:600; font-size:13px; color:var(--dark-text);">Recipient Phone Number:</label>
      <input type="text" id="wa-modal-phone" class="form-control" value="${recipientPhone}" placeholder="+91 9876543210" style="margin-top:4px;">
    </div>
    <div style="margin-bottom:15px;">
      <label style="font-weight:600; font-size:13px; color:var(--dark-text);">Pattern-Matched Structured Message (Editable):</label>
      <textarea id="wa-modal-text" class="form-control" rows="11" style="font-family:monospace; font-size:12px; line-height:1.4; background:#f9fbf8; border:1px solid #c8e6c9;">${fullWhatsAppMessage}</textarea>
    </div>
    <div style="background:#e8f5e9; padding:12px; border-radius:8px; font-size:12px; color:#2e7d32; display:flex; gap:8px; align-items:center;">
      <i class="fa-solid fa-shield-halved" style="font-size:16px; color:#25D366;"></i>
      <span>This WhatsApp message is formatted according to the safety deal guidelines and link pattern. You can edit the text before sending.</span>
    </div>
  `;

  submitBtn.onclick = () => {
    const phoneInput = document.getElementById('wa-modal-phone').value.replace(/[^\d+]/g, '');
    const cleanPhone = phoneInput.startsWith('+') ? phoneInput.replace('+', '') : `91${phoneInput}`;
    const text = document.getElementById('wa-modal-text').value;
    const url = `https://wa.me/${cleanPhone}?text=${encodeURIComponent(text)}`;
    window.open(url, '_blank');
    closeModal();
  };

  document.getElementById('modal-overlay').classList.add('active');
}

function closeModal() {
  document.getElementById('modal-overlay').classList.remove('active');
}

function showToast(message, type = 'success') {
  const toastContainer = document.getElementById('toast-container');
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `<span>${type === 'success' ? '✓' : '✖'}</span> <span>${message}</span>`;
  toastContainer.appendChild(toast);
  setTimeout(() => toast.remove(), 3500);
}

async function deleteMachine(id) {
  if (confirm('Delete machine listing?')) {
    await apiDelete(`/machines/${id}`);
    showToast('Machine deleted', 'success');
    await loadAllData();
    renderMachinesView();
  }
}

async function deleteWorker(id) {
  if (confirm('Delete worker record?')) {
    await apiDelete(`/workers/${id}`);
    showToast('Worker deleted', 'success');
    await loadAllData();
    renderWorkersView();
  }
}

function handleGlobalSearch(query) { }
