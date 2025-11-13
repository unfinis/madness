// API base URL
const API_BASE = '';

// State
let autoRefresh = true;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    refreshAll();
    // Auto-refresh every 3 seconds
    setInterval(() => {
        if (autoRefresh) {
            refreshAll();
        }
    }, 3000);
});

// Refresh all data
async function refreshAll() {
    await Promise.all([
        loadStats(),
        loadAssets(),
        loadMethodologies(),
        loadTriggerMatches(),
        loadBatchCommands()
    ]);
}

// Load statistics
async function loadStats() {
    try {
        const response = await fetch(`${API_BASE}/api/stats`);
        const stats = await response.json();

        document.getElementById('stat-assets').textContent = stats.total_assets;
        document.getElementById('stat-methodologies').textContent = stats.total_methodologies;
        document.getElementById('stat-triggers').textContent = stats.total_trigger_matches;
        document.getElementById('stat-commands').textContent = stats.total_batch_commands;
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

// Load assets
async function loadAssets() {
    try {
        const response = await fetch(`${API_BASE}/api/assets`);
        const assets = await response.json();

        const container = document.getElementById('assets');

        if (assets.length === 0) {
            container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">📦</div><p>No assets yet. Add one or run a demo scenario!</p></div>';
            return;
        }

        container.innerHTML = assets.map(asset => `
            <div class="item-card">
                <div class="item-header">
                    <div class="item-title">${escapeHtml(asset.name)}</div>
                    <span class="badge info">${asset.type}</span>
                </div>
                <div class="item-meta">
                    ID: ${asset.id}<br>
                    Confidence: ${(asset.confidence * 100).toFixed(0)}%<br>
                    Discovered: ${new Date(asset.discovered_at).toLocaleString()}
                </div>
                ${Object.keys(asset.properties).length > 0 ? `
                    <div class="command-box">
                        ${Object.entries(asset.properties).map(([k, v]) => `${k}: ${v}`).join('<br>')}
                    </div>
                ` : ''}
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading assets:', error);
    }
}

// Load methodologies
async function loadMethodologies() {
    try {
        const response = await fetch(`${API_BASE}/api/methodologies`);
        const methodologies = await response.json();

        const container = document.getElementById('methodologies');

        if (methodologies.length === 0) {
            container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">📚</div><p>No methodologies loaded.</p></div>';
            return;
        }

        container.innerHTML = methodologies.map(m => `
            <div class="methodology-card">
                <div class="item-header">
                    <div class="item-title">${escapeHtml(m.name)}</div>
                    <div>
                        <span class="badge ${m.risk_level}">${m.risk_level.toUpperCase()}</span>
                        ${m.batch_compatible ? '<span class="badge success">BATCH</span>' : ''}
                    </div>
                </div>
                <div class="item-meta">
                    Category: ${m.category} | Triggers: ${m.trigger_count} | Steps: ${m.step_count}<br>
                    ${escapeHtml(m.description)}
                </div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading methodologies:', error);
    }
}

// Load trigger matches
async function loadTriggerMatches() {
    try {
        const response = await fetch(`${API_BASE}/api/trigger-matches`);
        const matches = await response.json();

        const container = document.getElementById('trigger-matches');

        if (matches.length === 0) {
            container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">🎯</div><p>No triggers fired yet. Add assets to trigger methodologies!</p></div>';
            return;
        }

        container.innerHTML = matches.map(match => `
            <div class="item-card triggered">
                <div class="item-header">
                    <div class="item-title">${escapeHtml(match.methodology_name)}</div>
                    <div>
                        <span class="badge ${match.priority <= 2 ? 'high' : match.priority <= 4 ? 'medium' : 'low'}">
                            Priority ${match.priority}
                        </span>
                        ${match.executed ? '<span class="badge success">EXECUTED</span>' : ''}
                    </div>
                </div>
                <div class="item-meta">
                    Confidence: ${(match.confidence * 100).toFixed(0)}% |
                    Matched Assets: ${match.matched_assets.length} |
                    ${new Date(match.matched_at).toLocaleString()}
                </div>
                <div style="margin-top: 10px; color: #94a3b8;">
                    <strong>Matched Assets:</strong><br>
                    ${match.matched_assets.map(a => `• ${escapeHtml(a.name)} (${a.type})`).join('<br>')}
                </div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading trigger matches:', error);
    }
}

// Load batch commands
async function loadBatchCommands() {
    try {
        const response = await fetch(`${API_BASE}/api/batch-commands`);
        const commands = await response.json();

        const container = document.getElementById('batch-commands');

        if (commands.length === 0) {
            container.innerHTML = '<div class="empty-state"><div class="empty-state-icon">⚡</div><p>No commands generated yet.</p></div>';
            return;
        }

        container.innerHTML = commands.map(cmd => `
            <div class="item-card ${cmd.batched ? 'batched' : ''}">
                <div class="item-header">
                    <div class="item-title">${escapeHtml(cmd.methodology_name)}</div>
                    <div>
                        ${cmd.batched ? '<span class="badge success">BATCHED</span>' : '<span class="badge info">SINGLE</span>'}
                        <span class="badge info">${cmd.target_count} target${cmd.target_count > 1 ? 's' : ''}</span>
                    </div>
                </div>
                <div class="item-meta">
                    ${new Date(cmd.created_at).toLocaleString()}
                    ${cmd.batched ? ` | ⚡ Batched ${cmd.target_count} targets into single command!` : ''}
                </div>
                <div class="command-box">${escapeHtml(cmd.command)}</div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading batch commands:', error);
    }
}

// Add asset
async function addAsset(event) {
    event.preventDefault();

    const type = document.getElementById('asset-type').value;
    const name = document.getElementById('asset-name').value;
    const propertiesText = document.getElementById('asset-properties').value;

    let properties = {};
    if (propertiesText.trim()) {
        try {
            properties = JSON.parse(propertiesText);
        } catch (e) {
            showNotification('Invalid JSON in properties field', 'error');
            return;
        }
    }

    try {
        const response = await fetch(`${API_BASE}/api/assets`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                type: type,
                name: name,
                properties: properties
            })
        });

        const result = await response.json();

        showNotification(`Asset created! Triggered ${result.triggered_matches} matches, generated ${result.generated_commands} commands.`);

        // Clear form
        document.getElementById('asset-form').reset();
        toggleAssetForm();

        // Refresh data
        refreshAll();
    } catch (error) {
        console.error('Error adding asset:', error);
        showNotification('Error creating asset: ' + error.message, 'error');
    }
}

// Run demo scenario
async function runScenario(scenarioName) {
    try {
        showNotification(`Running ${scenarioName} scenario...`, 'info');

        const response = await fetch(`${API_BASE}/api/demo/scenario/${scenarioName}`, {
            method: 'POST'
        });

        const result = await response.json();

        showNotification(`${scenarioName} completed! Check out the generated batch commands.`);

        // Refresh data
        setTimeout(() => refreshAll(), 500);
    } catch (error) {
        console.error('Error running scenario:', error);
        showNotification('Error running scenario: ' + error.message, 'error');
    }
}

// Reset engine
async function resetEngine() {
    if (!confirm('Are you sure you want to reset the engine? This will clear all assets, triggers, and commands.')) {
        return;
    }

    try {
        await fetch(`${API_BASE}/api/reset`, { method: 'POST' });
        showNotification('Engine reset successfully');
        refreshAll();
    } catch (error) {
        console.error('Error resetting engine:', error);
        showNotification('Error resetting engine: ' + error.message, 'error');
    }
}

// Toggle asset form
function toggleAssetForm() {
    const section = document.getElementById('asset-form-section');
    section.style.display = section.style.display === 'none' ? 'block' : 'none';
}

// Update property fields based on asset type
function updatePropertyFields() {
    const type = document.getElementById('asset-type').value;
    const propertiesField = document.getElementById('asset-properties');

    const templates = {
        network_segment: '{"cidr": "10.0.0.0/24", "vlan": "100"}',
        host: '{"ip": "10.0.0.1", "hostname": "server01", "os": "Linux"}',
        service: '{"host": "10.0.0.1", "port": 80, "protocol": "http", "url": "http://10.0.0.1"}',
        credential: '{"username": "admin", "password": "password123", "type": "domain"}',
        web_application: '{"url": "http://example.com", "technology": "PHP"}'
    };

    propertiesField.placeholder = templates[type] || '{"key": "value"}';
}

// Show notification
function showNotification(message, type = 'success') {
    const notification = document.getElementById('notification');
    notification.textContent = message;
    notification.style.display = 'block';
    notification.style.background = type === 'error' ? '#ef4444' : type === 'info' ? '#3b82f6' : '#10b981';

    setTimeout(() => {
        notification.style.display = 'none';
    }, 3000);
}

// Escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
