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

document.addEventListener('DOMContentLoaded', () => {
  initSidebar();
  loadAllData().then(() => {
    switchView('dashboard');
  });
});

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
    return await res.json();
  } catch (e) {
    showToast('Failed to save data to backend server', 'error');
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
    return await res.json();
  } catch (e) {
    showToast('Failed to update data', 'error');
    return null;
  }
}

async function apiDelete(endpoint) {
  try {
    const res = await fetch(`${API_BASE}${endpoint}`, { method: 'DELETE' });
    return await res.json();
  } catch (e) {
    showToast('Failed to delete item', 'error');
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

// ====================================================
// PROVIDER APPROVAL SYSTEM MODULE (CRITICAL REQUIREMENT)
// ====================================================
function renderProviderApprovalsView() {
  const container = document.getElementById('content-area');
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
          <button class="btn btn-sm btn-primary" onclick="filterProviderApps('All')">All Applications</button>
          <button class="btn btn-sm btn-orange" onclick="filterProviderApps('PENDING')">🟡 Pending Review</button>
          <button class="btn btn-sm btn-secondary" onclick="filterProviderApps('APPROVED')">🟢 Approved</button>
          <button class="btn btn-sm btn-danger" onclick="filterProviderApps('REJECTED')">🔴 Rejected</button>
        </div>
      </div>

      <table class="custom-table">
        <thead>
          <tr>
            <th>Application ID</th>
            <th>Applicant User</th>
            <th>Service Offered</th>
            <th>Machine / Skill</th>
            <th>Category</th>
            <th>Location</th>
            <th>Rate</th>
            <th>Submitted Date</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody id="provider-apps-table-body">
          ${renderProviderAppsRows(globalData.providerApplications)}
        </tbody>
      </table>
    </div>
  `;
}

function renderProviderAppsRows(appsList) {
  if (!appsList || appsList.length === 0) {
    return '<tr><td colspan="10" style="text-align:center; padding:20px;">No provider applications found.</td></tr>';
  }
  return appsList.map(a => `
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
      <td><span class="badge badge-blue">${a.serviceType}</span></td>
      <td><strong>${a.machineName || a.category}</strong></td>
      <td><span class="badge badge-orange">${a.category}</span></td>
      <td>${a.userLocation || a.district}</td>
      <td><strong style="color:var(--primary-dark);">₹${a.rentalPricePerDay}</strong>/day</td>
      <td>${a.submittedAt}</td>
      <td>
        <span class="badge ${a.status === 'APPROVED' ? 'badge-green' : (a.status === 'REJECTED' ? 'badge-red' : 'badge-orange')}">
          ${a.status === 'APPROVED' ? '🟢 APPROVED' : (a.status === 'REJECTED' ? '🔴 REJECTED' : '🟡 PENDING')}
        </span>
      </td>
      <td>
        <button class="btn btn-sm btn-secondary" onclick="viewProviderApplicationModal('${a.id}')">View Details & Preview</button>
      </td>
    </tr>
  `).join('');
}

function filterProviderApps(status) {
  if (status === 'All') {
    document.getElementById('provider-apps-table-body').innerHTML = renderProviderAppsRows(globalData.providerApplications);
  } else {
    const filtered = globalData.providerApplications.filter(a => a.status === status);
    document.getElementById('provider-apps-table-body').innerHTML = renderProviderAppsRows(filtered);
  }
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
      <table class="custom-table" id="users-table">
        <thead>
          <tr>
            <th>User ID</th>
            <th>Profile</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Role</th>
            <th>Location</th>
            <th>Joined Date</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          ${renderUsersRows(globalData.users)}
        </tbody>
      </table>
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
      <td>${u.phone}</td>
      <td>${u.email}</td>
      <td><span class="badge badge-blue">${u.role}</span></td>
      <td>${u.location}</td>
      <td>${u.joinedDate}</td>
      <td><span class="badge ${u.status === 'Active' ? 'badge-green' : 'badge-red'}">${u.status}</span></td>
      <td>
        <button class="btn btn-sm btn-secondary" onclick="viewUserDetails('${u.id}')">View</button>
        <button class="btn btn-sm btn-danger" onclick="deleteUser('${u.id}')">Delete</button>
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
      <table class="custom-table">
        <thead>
          <tr>
            <th>Farmer ID</th>
            <th>Farmer Name</th>
            <th>Village / Taluk</th>
            <th>District</th>
            <th>Farm Size</th>
            <th>Crops Grown</th>
            <th>Verification</th>
            <th>Actions</th>
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
              <td>${f.district}</td>
              <td><strong>${f.farmSizeAcres} Acres</strong></td>
              <td>${f.cropTypes ? f.cropTypes.join(', ') : 'Paddy, Arecanut'}</td>
              <td><span class="badge badge-green">${f.verificationStatus}</span></td>
              <td>
                <button class="btn btn-sm btn-secondary" onclick="viewFarmerDetails('${f.id}')">View</button>
                <button class="btn btn-sm btn-danger" onclick="deleteFarmer('${f.id}')">Delete</button>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
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
      <table class="custom-table">
        <thead>
          <tr>
            <th>Image</th>
            <th>Machine Name</th>
            <th>Category</th>
            <th>Owner</th>
            <th>Location</th>
            <th>Price</th>
            <th>Availability</th>
            <th>Rating</th>
            <th>Verification</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          ${renderMachinesRows(globalData.machines)}
        </tbody>
      </table>
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

function renderMachinesRows(machinesList) {
  if (!machinesList || machinesList.length === 0) {
    return '<tr><td colspan="10" style="text-align:center; padding:20px;">No machines found.</td></tr>';
  }
  return machinesList.map(m => `
    <tr>
      <td><img src="${formatImageUrl(m.images && m.images[0], m.category)}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800';" class="table-avatar-card" style="cursor:pointer;" onclick="openEditMachineModal('${m.id}')" title="Click to edit photo & machine listing" alt=""></td>
      <td style="min-width: 160px;">
        <div class="cell-title-main" onclick="openEditMachineModal('${m.id}')" style="cursor:pointer; color:var(--dark-text);" title="Click to edit machine details">
          ${m.name} <i class="fa-solid fa-pen-to-square" style="font-size:11px; color:var(--primary); margin-left:3px;"></i>
        </div>
        <div class="cell-subtitle">${m.brand || ''} ${m.model || ''} ${m.horsePower ? '• ' + m.horsePower : ''}</div>
      </td>
      <td style="white-space: nowrap;"><span class="badge badge-orange">${m.category}</span></td>
      <td style="white-space: nowrap;"><strong>${m.ownerName}</strong><br><span class="cell-subtitle">${m.ownerPhone}</span></td>
      <td style="white-space: nowrap;">${m.location}</td>
      <td style="white-space: nowrap;"><strong style="color:var(--primary-dark);">₹${m.rentalPricePerDay}</strong><span style="font-size:11px; color:var(--gray-text);">/day</span></td>
      <td style="white-space: nowrap;">
        <button class="btn btn-sm ${m.isAvailable ? 'btn-primary' : 'btn-secondary'}" onclick="toggleMachineAvailability('${m.id}', ${!m.isAvailable})">
          ${m.isAvailable ? '✓ Available' : '✖ Unavailable'}
        </button>
      </td>
      <td style="white-space: nowrap;">⭐ ${m.rating} <span style="font-size:11px; color:var(--gray-text);">(${m.reviewCount})</span></td>
      <td style="white-space: nowrap;"><span class="badge ${m.verificationStatus === 'Verified' ? 'badge-green' : 'badge-orange'}">${m.verificationStatus}</span></td>
      <td>
        <div class="table-actions">
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
    reader.onload = function(e) {
      const img = new Image();
      img.onload = function() {
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
      <table class="custom-table">
        <thead>
          <tr>
            <th>Worker Profile</th>
            <th>Category / Skill</th>
            <th>Experience</th>
            <th>Daily Rate</th>
            <th>Location</th>
            <th>Availability</th>
            <th>Verification</th>
            <th>Actions</th>
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
              <td><span class="badge badge-blue">${w.category || w.skills[0]}</span></td>
              <td>${w.experienceYears} Years</td>
              <td><strong style="color:var(--primary-dark);">₹${w.dailyRate}</strong>/day</td>
              <td>${w.location}</td>
              <td><span class="badge ${w.isAvailable ? 'badge-green' : 'badge-red'}">${w.isAvailable ? 'Available' : 'Busy'}</span></td>
              <td><span class="badge badge-green">${w.isVerified ? '✓ Verified' : 'Pending'}</span></td>
              <td>
                <div class="table-actions">
                  <button class="btn btn-sm btn-primary" onclick="openEditWorkerModal('${w.id}')" title="Edit Worker Profile"><i class="fa-solid fa-pen-to-square"></i> Edit</button>
                  <button class="btn btn-sm btn-danger" onclick="deleteWorker('${w.id}')" title="Delete Record"><i class="fa-solid fa-trash"></i> Delete</button>
                </div>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
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
// 6. BOOKINGS, MARKETPLACE, STORE, CONTENT, SETTINGS & UTILS
// ====================================================
function renderBookingsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-calendar-check" style="color:var(--primary);"></i> Bookings & Rental Management</h1>
      </div>
    </div>
    <div class="card-table-wrapper">
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
          ${globalData.bookings.map(b => `
            <tr>
              <td><strong>${b.id}</strong></td>
              <td>${b.targetTitle}</td>
              <td>${b.customerName}</td>
              <td><strong>₹${b.totalAmount}</strong></td>
              <td><span class="badge badge-green">${b.bookingStatus}</span></td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderMarketplaceView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div>
        <h1 class="page-title"><i class="fa-solid fa-wheat-awn"></i> Produce Marketplace</h1>
      </div>
    </div>
    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead>
          <tr><th>Title</th><th>Category</th><th>Price</th><th>Location</th></tr>
        </thead>
        <tbody>
          ${globalData.marketplace.map(p => `<tr><td>${p.title}</td><td>${p.category}</td><td>₹${p.price}</td><td>${p.location}</td></tr>`).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderAgroStoreView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `
    <div class="page-header">
      <div><h1 class="page-title"><i class="fa-solid fa-store"></i> Agro Store</h1></div>
    </div>
    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead><tr><th>Product</th><th>Category</th><th>Price</th></tr></thead>
        <tbody>
          ${globalData.store.map(s => `<tr><td>${s.title}</td><td>${s.category}</td><td>₹${s.price}</td></tr>`).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderCategoriesView() {
  const container = document.getElementById('content-area');
  const machineCats = globalData.categories.machineCategories || [];
  container.innerHTML = `
    <div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-tags"></i> Categories</h1></div></div>
    <div class="card-table-wrapper">
      <table class="custom-table">
        <thead><tr><th>Icon</th><th>Category</th><th>Description</th></tr></thead>
        <tbody>
          ${machineCats.map(c => `<tr><td>${c.icon}</td><td>${c.name}</td><td>${c.description}</td></tr>`).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderLocationsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-location-dot"></i> Locations</h1></div></div><p>Shivamogga, Chikamagaluru, Hassan, Mandya, Udupi, Davanagere</p>`;
}

function renderReviewsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-star"></i> Reviews</h1></div></div>`;
}

function renderNotificationsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-paper-plane"></i> Notifications</h1></div></div>`;
}

function renderBannersView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-image"></i> Banners</h1></div></div>`;
}

function renderMobileManagerView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-mobile-screen-button"></i> Mobile App Manager</h1></div></div>`;
}

function renderReportsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-file-invoice"></i> Reports</h1></div></div>`;
}

function renderPaymentsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-indian-rupee-sign"></i> Payments</h1></div></div>`;
}

function renderSupportView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-headset"></i> Support</h1></div></div>`;
}

function renderAdminUsersView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-user-shield"></i> Admin Users</h1></div></div>`;
}

function renderActivityLogsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-clock-rotate-left"></i> Activity Logs</h1></div></div>`;
}

function renderSettingsView() {
  const container = document.getElementById('content-area');
  container.innerHTML = `<div class="page-header"><div><h1 class="page-title"><i class="fa-solid fa-sliders"></i> Settings</h1></div></div>`;
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

function handleGlobalSearch(query) {}
