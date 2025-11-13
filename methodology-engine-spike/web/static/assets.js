// Assets Manager JavaScript

let allAssets = [];
let currentAsset = null;
let isEditMode = false;

// Property templates for different asset types
const propertyTemplates = {
    network_segment: {
        'cidr': { type: 'text', label: 'CIDR', placeholder: '10.0.0.0/24' },
        'vlan': { type: 'text', label: 'VLAN', placeholder: '100' },
        'nac_enabled': { type: 'boolean', label: 'NAC Enabled' },
        'nac_type': { type: 'text', label: 'NAC Type', placeholder: '802.1x, web_auth, mac_auth' },
        'access_level': { type: 'select', label: 'Access Level', options: ['blocked', 'limited', 'partial', 'full'] },
        'physical_access': { type: 'boolean', label: 'Physical Access' },
        'description': { type: 'text', label: 'Description' }
    },
    host: {
        'ip': { type: 'text', label: 'IP Address', placeholder: '192.168.1.10' },
        'hostname': { type: 'text', label: 'Hostname', placeholder: 'server-01' },
        'mac_address': { type: 'text', label: 'MAC Address', placeholder: '00:11:22:33:44:55' },
        'os': { type: 'text', label: 'Operating System', placeholder: 'Ubuntu 20.04' },
        'os_version': { type: 'text', label: 'OS Version' },
        'open_ports': { type: 'text', label: 'Open Ports', placeholder: '22,80,443' },
        'status': { type: 'select', label: 'Status', options: ['online', 'offline', 'unknown'] }
    },
    service: {
        'host': { type: 'text', label: 'Host', placeholder: '192.168.1.10' },
        'port': { type: 'number', label: 'Port', placeholder: '80' },
        'protocol': { type: 'select', label: 'Protocol', options: ['tcp', 'udp'] },
        'service_name': { type: 'text', label: 'Service Name', placeholder: 'http' },
        'version': { type: 'text', label: 'Version' },
        'url': { type: 'text', label: 'URL', placeholder: 'http://example.com' },
        'requires_auth': { type: 'boolean', label: 'Requires Authentication' }
    },
    credential: {
        'username': { type: 'text', label: 'Username', placeholder: 'admin' },
        'password': { type: 'text', label: 'Password', placeholder: 'password123' },
        'type': { type: 'select', label: 'Type', options: ['local', 'domain', 'database', 'service'] },
        'domain': { type: 'text', label: 'Domain' },
        'source': { type: 'text', label: 'Source', placeholder: 'credential_dump, social_engineering' },
        'tested': { type: 'boolean', label: 'Tested' },
        'valid': { type: 'boolean', label: 'Valid' }
    },
    web_application: {
        'url': { type: 'text', label: 'URL', placeholder: 'https://example.com' },
        'technology': { type: 'text', label: 'Technology', placeholder: 'WordPress, Django' },
        'version': { type: 'text', label: 'Version' },
        'authentication': { type: 'select', label: 'Authentication', options: ['none', 'basic', 'form', 'oauth', 'saml'] },
        'cms_detected': { type: 'boolean', label: 'CMS Detected' },
        'admin_panel_found': { type: 'boolean', label: 'Admin Panel Found' }
    }
};

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    refreshAssets();
});

// Fetch and display assets
async function refreshAssets() {
    try {
        const response = await fetch('/api/assets');
        allAssets = await response.json();
        filterAssets();
    } catch (error) {
        showNotification('Failed to load assets: ' + error.message, 'error');
    }
}

// Filter and display assets
function filterAssets() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();
    const typeFilter = document.getElementById('type-filter').value;

    const filtered = allAssets.filter(asset => {
        const matchesSearch = asset.name.toLowerCase().includes(searchTerm);
        const matchesType = !typeFilter || asset.type === typeFilter;
        return matchesSearch && matchesType;
    });

    displayAssets(filtered);
}

// Display assets in grid
function displayAssets(assets) {
    const grid = document.getElementById('assets-grid');

    if (assets.length === 0) {
        grid.innerHTML = `
            <div class="empty-state">
                <div class="empty-state-icon">🔍</div>
                <h2>No assets found</h2>
                <p>Try adjusting your filters</p>
            </div>
        `;
        return;
    }

    grid.innerHTML = assets.map(asset => createAssetCard(asset)).join('');
}

// Create asset card HTML
function createAssetCard(asset) {
    const properties = Object.entries(asset.properties)
        .slice(0, 4)
        .map(([key, value]) => `
            <div class="property-item">
                <span class="property-key">${formatKey(key)}</span>
                <span class="property-value">${formatValue(value)}</span>
            </div>
        `).join('');

    return `
        <div class="asset-card ${asset.type}" onclick="openEditModal('${asset.id}')">
            <div class="asset-header">
                <div class="asset-title">${asset.name}</div>
                <span class="asset-type-badge ${asset.type}">${asset.type}</span>
            </div>
            <div class="asset-properties">
                ${properties || '<div class="property-item"><span class="property-value">No properties</span></div>'}
            </div>
            <div class="asset-actions" onclick="event.stopPropagation()">
                <button onclick="openEditModal('${asset.id}')">✏️ Edit</button>
                <button class="danger" onclick="deleteAsset('${asset.id}')">🗑️ Delete</button>
            </div>
        </div>
    `;
}

// Format property key for display
function formatKey(key) {
    return key.split('_').map(word =>
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
}

// Format property value for display
function formatValue(value) {
    if (typeof value === 'boolean') {
        return value ? '✓ Yes' : '✗ No';
    }
    if (Array.isArray(value)) {
        return value.join(', ') || 'None';
    }
    if (typeof value === 'object') {
        return JSON.stringify(value);
    }
    return value || 'N/A';
}

// Open create modal
function openCreateModal() {
    isEditMode = false;
    currentAsset = null;
    document.getElementById('modal-title').textContent = 'Create Asset';
    document.getElementById('asset-form').reset();
    document.getElementById('asset-type').disabled = false;
    updatePropertyTemplate();
    document.getElementById('asset-modal').classList.add('active');
}

// Open edit modal
async function openEditModal(assetId) {
    isEditMode = true;
    currentAsset = allAssets.find(a => a.id === assetId);

    if (!currentAsset) {
        showNotification('Asset not found', 'error');
        return;
    }

    document.getElementById('modal-title').textContent = 'Edit Asset';
    document.getElementById('asset-type').value = currentAsset.type;
    document.getElementById('asset-type').disabled = true;
    document.getElementById('asset-name').value = currentAsset.name;
    document.getElementById('asset-confidence').value = currentAsset.confidence;

    updatePropertyTemplate(currentAsset.properties);
    document.getElementById('asset-modal').classList.add('active');
}

// Close modal
function closeModal() {
    document.getElementById('asset-modal').classList.remove('active');
    currentAsset = null;
    isEditMode = false;
}

// Update property template based on asset type
function updatePropertyTemplate(existingProperties = {}) {
    const assetType = document.getElementById('asset-type').value;
    const editor = document.getElementById('property-editor');
    const template = propertyTemplates[assetType] || {};

    editor.innerHTML = Object.entries(template).map(([key, config]) => {
        const value = existingProperties[key] || '';
        return createPropertyField(key, config, value);
    }).join('');
}

// Create property field HTML
function createPropertyField(key, config, value) {
    const id = `prop-${key}`;

    if (config.type === 'boolean') {
        return `
            <div class="form-group">
                <label>
                    <input type="checkbox" id="${id}" ${value ? 'checked' : ''}>
                    ${config.label}
                </label>
            </div>
        `;
    }

    if (config.type === 'select') {
        return `
            <div class="form-group">
                <label>${config.label}</label>
                <select id="${id}">
                    <option value="">Select...</option>
                    ${config.options.map(opt =>
                        `<option value="${opt}" ${value === opt ? 'selected' : ''}>${opt}</option>`
                    ).join('')}
                </select>
            </div>
        `;
    }

    return `
        <div class="form-group">
            <label>${config.label}</label>
            <input type="${config.type}" id="${id}" value="${value}" placeholder="${config.placeholder || ''}">
        </div>
    `;
}

// Save asset
async function saveAsset(event) {
    event.preventDefault();

    const assetType = document.getElementById('asset-type').value;
    const assetName = document.getElementById('asset-name').value;
    const confidence = parseFloat(document.getElementById('asset-confidence').value);

    // Collect properties
    const template = propertyTemplates[assetType] || {};
    const properties = {};

    Object.keys(template).forEach(key => {
        const id = `prop-${key}`;
        const element = document.getElementById(id);

        if (element) {
            if (element.type === 'checkbox') {
                properties[key] = element.checked;
            } else if (element.type === 'number') {
                properties[key] = element.value ? parseInt(element.value) : null;
            } else {
                properties[key] = element.value;
            }
        }
    });

    const assetData = {
        type: assetType,
        name: assetName,
        properties: properties,
        confidence: confidence
    };

    try {
        let response;
        if (isEditMode && currentAsset) {
            response = await fetch(`/api/assets/${currentAsset.id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(assetData)
            });
        } else {
            response = await fetch('/api/assets', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(assetData)
            });
        }

        if (response.ok) {
            showNotification(`Asset ${isEditMode ? 'updated' : 'created'} successfully!`);
            closeModal();
            refreshAssets();
        } else {
            const error = await response.json();
            showNotification(`Error: ${error.detail}`, 'error');
        }
    } catch (error) {
        showNotification(`Failed to save asset: ${error.message}`, 'error');
    }
}

// Delete asset
async function deleteAsset(assetId) {
    if (!confirm('Are you sure you want to delete this asset?')) {
        return;
    }

    try {
        const response = await fetch(`/api/assets/${assetId}`, {
            method: 'DELETE'
        });

        if (response.ok) {
            showNotification('Asset deleted successfully!');
            refreshAssets();
        } else {
            const error = await response.json();
            showNotification(`Error: ${error.detail}`, 'error');
        }
    } catch (error) {
        showNotification(`Failed to delete asset: ${error.message}`, 'error');
    }
}

// Show notification
function showNotification(message, type = 'success') {
    const notification = document.getElementById('notification');
    notification.textContent = message;
    notification.className = type;
    notification.style.display = 'block';

    setTimeout(() => {
        notification.style.display = 'none';
    }, 3000);
}

// Close modal on escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        closeModal();
    }
});
