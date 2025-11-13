// Methodology Engine - Tabbed Interface
// Handles Assets, Attack Queue, and Playbook Library tabs

const API_BASE = '';
let currentTab = 'assets';
let allAssets = [];
let allMethodologies = [];
let allTriggers = [];
let allCommands = [];

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    refreshAll();
    setInterval(() => refreshAll(), 3000); // Auto-refresh every 3s
});

// Main refresh function
async function refreshAll() {
    try {
        await Promise.all([
            loadStats(),
            loadAssets(),
            loadMethodologies(),
            loadTriggerMatches(),
            loadBatchCommands()
        ]);
        renderCurrentTab();
    } catch (error) {
        console.error('Error refreshing:', error);
    }
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

        // Update queue badge
        document.getElementById('queue-badge').textContent = stats.total_batch_commands;
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

// Load all data
async function loadAssets() {
    const response = await fetch(`${API_BASE}/api/assets`);
    allAssets = await response.json();
}

async function loadMethodologies() {
    const response = await fetch(`${API_BASE}/api/methodologies`);
    allMethodologies = await response.json();
}

async function loadTriggerMatches() {
    const response = await fetch(`${API_BASE}/api/trigger-matches`);
    allTriggers = await response.json();
}

async function loadBatchCommands() {
    const response = await fetch(`${API_BASE}/api/batch-commands`);
    allCommands = await response.json();
}

// Tab switching
function switchTab(tabName) {
    currentTab = tabName;

    // Update tab buttons
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');

    // Update tab content
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    document.getElementById(`tab-${tabName}`).classList.add('active');

    renderCurrentTab();
}

// Render current tab content
function renderCurrentTab() {
    switch (currentTab) {
        case 'assets':
            renderAssetsTab();
            break;
        case 'queue':
            renderAttackQueueTab();
            break;
        case 'library':
            renderPlaybookLibraryTab();
            break;
    }
}

// ============================================================================
// ASSETS TAB
// ============================================================================
function renderAssetsTab() {
    const container = document.getElementById('tab-assets');

    if (allAssets.length === 0) {
        container.innerHTML = `
            <div class="section">
                <div class="empty-state">
                    <div class="empty-state-icon">📦</div>
                    <h2>No Assets Yet</h2>
                    <p>Assets represent discovered network elements, hosts, services, and credentials.</p>
                    <p style="margin-top: 15px;">Run a demo scenario to see assets in action!</p>
                </div>
            </div>
        `;
        return;
    }

    // Group assets by type
    const assetsByType = {};
    allAssets.forEach(asset => {
        if (!assetsByType[asset.type]) {
            assetsByType[asset.type] = [];
        }
        assetsByType[asset.type].push(asset);
    });

    let html = '';

    Object.entries(assetsByType).forEach(([type, assets]) => {
        const typeColor = getAssetTypeColor(type);

        html += `
            <div class="section">
                <div class="section-header">
                    <div class="section-title">${getAssetTypeIcon(type)} ${formatAssetType(type)} (${assets.length})</div>
                </div>
                <div class="card-grid">
                    ${assets.map(asset => createAssetCard(asset, typeColor)).join('')}
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

function createAssetCard(asset, colorClass) {
    const mainProps = getMainProperties(asset);

    return `
        <div class="card ${colorClass}">
            <div class="card-header">
                <div class="card-title">${escapeHtml(asset.name)}</div>
                <span class="card-badge" style="background: rgba(56, 189, 248, 0.2); color: #38bdf8;">
                    ${(asset.confidence * 100).toFixed(0)}%
                </span>
            </div>
            <div class="card-body">
                ${mainProps.length > 0 ? `
                    <div class="property-list">
                        ${mainProps.map(([key, value]) => `
                            <div class="property-item">
                                <span class="property-key">${formatKey(key)}</span>
                                <span class="property-value">${formatValue(value)}</span>
                            </div>
                        `).join('')}
                    </div>
                ` : '<div style="color: #64748b; font-style: italic;">No properties</div>'}
            </div>
            <div style="color: #64748b; font-size: 0.85em; margin-top: 10px;">
                Added: ${new Date(asset.discovered_at).toLocaleString()}
            </div>
        </div>
    `;
}

// ============================================================================
// ATTACK QUEUE TAB
// ============================================================================
function renderAttackQueueTab() {
    const container = document.getElementById('tab-queue');

    if (allCommands.length === 0) {
        container.innerHTML = `
            <div class="section">
                <div class="empty-state">
                    <div class="empty-state-icon">⚡</div>
                    <h2>No Commands in Queue</h2>
                    <p>When asset properties match methodology triggers, commands appear here ready to execute.</p>
                    <p style="margin-top: 15px;">Add assets or run demo scenarios to populate the queue!</p>
                </div>
            </div>
        `;
        return;
    }

    // Sort by methodology
    const commandsByMethodology = {};
    allCommands.forEach(cmd => {
        if (!commandsByMethodology[cmd.methodology_name]) {
            commandsByMethodology[cmd.methodology_name] = [];
        }
        commandsByMethodology[cmd.methodology_name].push(cmd);
    });

    let html = '';

    Object.entries(commandsByMethodology).forEach(([methodName, commands]) => {
        html += `
            <div class="section">
                <div class="section-header">
                    <div class="section-title">⚡ ${methodName}</div>
                    <span class="card-badge priority-high">${commands.length} ${commands.length === 1 ? 'command' : 'commands'}</span>
                </div>
                <div>
                    ${commands.map(cmd => createCommandCard(cmd)).join('')}
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

function createCommandCard(cmd) {
    return `
        <div class="list-item" style="border-left-color: ${cmd.batched ? '#10b981' : '#f59e0b'};">
            <div class="list-item-header">
                <div class="list-item-title">${escapeHtml(cmd.methodology_name)}</div>
                <div style="display: flex; gap: 10px;">
                    ${cmd.batched ? '<span class="card-badge" style="background: #10b981; color: white;">BATCHED</span>' : ''}
                    <span class="card-badge priority-medium">${cmd.target_count} ${cmd.target_count === 1 ? 'target' : 'targets'}</span>
                </div>
            </div>
            <div class="command-box">${escapeHtml(cmd.command)}</div>
            <div class="list-item-meta">
                Generated: ${new Date(cmd.created_at).toLocaleString()}
                ${cmd.batched ? ' • Intelligently batched for parallel execution' : ''}
            </div>
        </div>
    `;
}

// ============================================================================
// PLAYBOOK LIBRARY TAB
// ============================================================================
function renderPlaybookLibraryTab() {
    const container = document.getElementById('tab-library');

    if (allMethodologies.length === 0) {
        container.innerHTML = `
            <div class="section">
                <div class="empty-state">
                    <div class="empty-state-icon">📚</div>
                    <h2>No Playbooks Loaded</h2>
                    <p>Playbooks (methodologies) contain trigger conditions and execution steps.</p>
                </div>
            </div>
        `;
        return;
    }

    // Group by category
    const methodsByCategory = {};
    allMethodologies.forEach(m => {
        const category = m.category || 'uncategorized';
        if (!methodsByCategory[category]) {
            methodsByCategory[category] = [];
        }
        methodsByCategory[category].push(m);
    });

    let html = '';

    Object.entries(methodsByCategory).forEach(([category, methods]) => {
        html += `
            <div class="section">
                <div class="section-header">
                    <div class="section-title">${getCategoryIcon(category)} ${formatCategory(category)}</div>
                    <span class="card-badge" style="background: rgba(56, 189, 248, 0.2); color: #38bdf8;">
                        ${methods.length} ${methods.length === 1 ? 'playbook' : 'playbooks'}
                    </span>
                </div>
                <div class="card-grid">
                    ${methods.map(m => createMethodologyCard(m)).join('')}
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
}

function createMethodologyCard(methodology) {
    const riskColors = {
        critical: '#ef4444',
        high: '#f59e0b',
        medium: '#3b82f6',
        low: '#10b981'
    };

    return `
        <div class="card" onclick="showMethodologyDetail('${methodology.id}')">
            <div class="card-header">
                <div class="card-title">${escapeHtml(methodology.name)}</div>
                <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                    <span class="card-badge" style="background: ${riskColors[methodology.risk_level]}; color: white;">
                        ${methodology.risk_level.toUpperCase()}
                    </span>
                    ${methodology.batch_compatible ? '<span class="card-badge" style="background: #10b981; color: white;">BATCH</span>' : ''}
                </div>
            </div>
            <div class="card-body">
                ${methodology.description ? `<p style="margin-bottom: 15px;">${escapeHtml(methodology.description)}</p>` : ''}
                <div class="property-list">
                    <div class="property-item">
                        <span class="property-key">Triggers</span>
                        <span class="property-value">${methodology.trigger_count}</span>
                    </div>
                    <div class="property-item">
                        <span class="property-key">Steps</span>
                        <span class="property-value">${methodology.step_count}</span>
                    </div>
                    <div class="property-item">
                        <span class="property-key">Category</span>
                        <span class="property-value">${formatCategory(methodology.category)}</span>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 15px; color: #38bdf8; font-size: 0.9em;">
                    Click to view details →
                </div>
            </div>
        </div>
    `;
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================
function getAssetTypeIcon(type) {
    const icons = {
        network_segment: '🌐',
        host: '💻',
        service: '⚙️',
        credential: '🔑',
        web_application: '🌍'
    };
    return icons[type] || '📦';
}

function getAssetTypeColor(type) {
    const colors = {
        network_segment: 'asset-network',
        host: 'asset-host',
        service: 'asset-service',
        credential: 'asset-credential',
        web_application: 'asset-web'
    };
    return colors[type] || '';
}

function getCategoryIcon(category) {
    const icons = {
        recon: '🔍',
        reconnaissance: '🔍',
        enumeration: '📋',
        exploitation: '💥',
        post_exploitation: '🎯',
        lateral_movement: '↔️'
    };
    return icons[category] || '📚';
}

function formatAssetType(type) {
    return type.split('_').map(word =>
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
}

function formatCategory(category) {
    return category.split('_').map(word =>
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
}

function formatKey(key) {
    return key.split('_').map(word =>
        word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
}

function formatValue(value) {
    if (typeof value === 'boolean') {
        return value ? '✓ Yes' : '✗ No';
    }
    if (Array.isArray(value)) {
        return value.length > 0 ? value.join(', ') : 'None';
    }
    if (typeof value === 'object') {
        return JSON.stringify(value);
    }
    return value || 'N/A';
}

function getMainProperties(asset) {
    const props = Object.entries(asset.properties);

    // Prioritize certain properties based on asset type
    const priorities = {
        network_segment: ['cidr', 'vlan', 'nac_enabled', 'access_level'],
        host: ['ip', 'hostname', 'os', 'status'],
        service: ['host', 'port', 'protocol', 'url'],
        credential: ['username', 'type', 'domain', 'valid'],
        web_application: ['url', 'technology', 'version']
    };

    const priorityKeys = priorities[asset.type] || [];
    const priorityProps = props.filter(([key]) => priorityKeys.includes(key));
    const otherProps = props.filter(([key]) => !priorityKeys.includes(key));

    return [...priorityProps, ...otherProps].slice(0, 5);
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ============================================================================
// DEMO SCENARIOS
// ============================================================================
async function runScenario(scenarioName) {
    try {
        showNotification(`Running ${scenarioName} scenario...`);
        const response = await fetch(`${API_BASE}/api/demo/scenario/${scenarioName}`, {
            method: 'POST'
        });

        if (response.ok) {
            const result = await response.json();
            showNotification(`✓ Scenario completed! ${result.stats.total_assets} assets, ${result.stats.total_trigger_matches} triggers`);
            await refreshAll();
        } else {
            showNotification('Failed to run scenario', 'error');
        }
    } catch (error) {
        console.error('Error running scenario:', error);
        showNotification('Error running scenario', 'error');
    }
}

async function resetEngine() {
    if (!confirm('Are you sure you want to reset the engine? All data will be cleared.')) {
        return;
    }

    try {
        const response = await fetch(`${API_BASE}/api/reset`, { method: 'POST' });
        if (response.ok) {
            showNotification('✓ Engine reset successfully');
            await refreshAll();
        } else {
            showNotification('Failed to reset engine', 'error');
        }
    } catch (error) {
        console.error('Error resetting engine:', error);
        showNotification('Error resetting engine', 'error');
    }
}

function showNotification(message, type = 'success') {
    const notification = document.getElementById('notification');
    notification.textContent = message;
    notification.className = type;
    notification.style.display = 'block';

    setTimeout(() => {
        notification.style.display = 'none';
    }, 3000);
}

// For old functionality (Quick Add Asset)
function toggleAssetForm() {
    // This can be removed or integrated into Assets tab in future
    showNotification('Use the Assets tab to manage assets!');
}

// ============================================================================
// METHODOLOGY DETAIL MODAL
// ============================================================================
async function showMethodologyDetail(methodologyId) {
    try {
        const response = await fetch(`${API_BASE}/api/methodologies/${methodologyId}`);
        if (!response.ok) {
            showNotification('Failed to load methodology details', 'error');
            return;
        }

        const methodology = await response.json();

        // Update modal title
        document.getElementById('modal-methodology-name').textContent = methodology.name;

        // Build modal body content
        const modalBody = document.getElementById('modal-methodology-body');
        modalBody.innerHTML = renderMethodologyDetail(methodology);

        // Show modal
        document.getElementById('methodology-modal').classList.add('active');
    } catch (error) {
        console.error('Error loading methodology:', error);
        showNotification('Error loading methodology details', 'error');
    }
}

function renderMethodologyDetail(m) {
    const riskColors = {
        critical: '#ef4444',
        high: '#f59e0b',
        medium: '#3b82f6',
        low: '#10b981'
    };

    let html = '';

    // Overview Section
    html += `
        <div class="modal-section">
            <div style="display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap;">
                <span class="card-badge" style="background: ${riskColors[m.risk_level]}; color: white;">
                    ${m.risk_level.toUpperCase()} RISK
                </span>
                <span class="card-badge" style="background: rgba(56, 189, 248, 0.2); color: #38bdf8;">
                    ${formatCategory(m.category)}
                </span>
                ${m.batch_compatible ? '<span class="card-badge" style="background: #10b981; color: white;">BATCH COMPATIBLE</span>' : ''}
            </div>
            <p style="color: #94a3b8; line-height: 1.8;">${escapeHtml(m.description || 'No description available')}</p>
        </div>
    `;

    // Risk Warning
    if (m.metadata.risk_warning) {
        html += `
            <div class="modal-section">
                <div class="warning-box">
                    <strong>⚠️ Risk Warning:</strong><br>
                    ${escapeHtml(m.metadata.risk_warning)}
                </div>
            </div>
        `;
    }

    // Tools Required
    if (m.metadata.tools && m.metadata.tools.length > 0) {
        html += `
            <div class="modal-section">
                <div class="modal-section-title">🔧 Required Tools</div>
                <div>
                    ${m.metadata.tools.map(tool => `<span class="tool-tag">${escapeHtml(tool)}</span>`).join('')}
                </div>
            </div>
        `;
    }

    // Trigger Conditions
    if (m.triggers && m.triggers.length > 0) {
        html += `
            <div class="modal-section">
                <div class="modal-section-title">🎯 Trigger Conditions</div>
                <p style="color: #94a3b8; margin-bottom: 15px;">
                    This methodology will automatically trigger when the following conditions are met:
                </p>
                ${m.triggers.map((trigger, idx) => `
                    <div class="trigger-item">
                        <div class="item-title-row">
                            <div class="item-title-text">Trigger ${idx + 1}: ${escapeHtml(trigger.description || trigger.id)}</div>
                            <span class="card-badge priority-${trigger.priority === 1 ? 'critical' : trigger.priority === 2 ? 'high' : 'medium'}">
                                Priority ${trigger.priority}
                            </span>
                        </div>
                        <div style="margin-top: 10px;">
                            <div style="color: #94a3b8; margin-bottom: 8px;">
                                <strong>Type:</strong> ${escapeHtml(trigger.type)}
                                ${trigger.asset_type ? ` | <strong>Asset Type:</strong> ${formatAssetType(trigger.asset_type)}` : ''}
                                | <strong>Required Assets:</strong> ${trigger.required_count}
                            </div>
                            ${Object.keys(trigger.required_properties || {}).length > 0 ? `
                                <div style="margin-top: 10px;">
                                    <strong style="color: #e2e8f0;">Required Properties:</strong>
                                    <div class="requirement-grid">
                                        ${Object.entries(trigger.required_properties).map(([key, value]) => `
                                            <div class="requirement-item">
                                                <div style="color: #94a3b8; font-size: 0.85em;">${formatKey(key)}</div>
                                                <div style="color: #e2e8f0; font-weight: 500;">${formatValue(value)}</div>
                                            </div>
                                        `).join('')}
                                    </div>
                                </div>
                            ` : ''}
                            ${trigger.deduplication.enabled ? `
                                <div class="info-box" style="margin-top: 10px;">
                                    <strong>Deduplication:</strong> ${escapeHtml(trigger.deduplication.strategy || 'enabled')}
                                    ${trigger.deduplication.cooldown_seconds ? ` • Cooldown: ${trigger.deduplication.cooldown_seconds}s` : ''}
                                </div>
                            ` : ''}
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    }

    // Execution Steps
    if (m.steps && m.steps.length > 0) {
        html += `
            <div class="modal-section">
                <div class="modal-section-title">📝 Execution Steps</div>
                <p style="color: #94a3b8; margin-bottom: 15px;">
                    ${m.steps.length} step${m.steps.length > 1 ? 's' : ''} will be executed in order:
                </p>
                ${m.steps.map((step, idx) => `
                    <div class="step-item">
                        <div class="item-title-row">
                            <div class="item-title-text">Step ${step.order}: ${escapeHtml(step.name)}</div>
                            <span class="card-badge" style="background: rgba(16, 185, 129, 0.2); color: #6ee7b7;">
                                ${step.timeout_seconds}s timeout
                            </span>
                        </div>
                        <p style="color: #94a3b8; margin: 10px 0;">${escapeHtml(step.description)}</p>

                        ${step.commands && step.commands.length > 0 ? `
                            <div style="margin-top: 15px;">
                                <div style="color: #e2e8f0; font-weight: 600; margin-bottom: 10px; font-size: 0.9em;">
                                    🔧 Command Alternatives:
                                </div>
                                ${step.commands.map((cmd, cmdIdx) => `
                                    <div style="margin-bottom: 12px; border-left: 3px solid ${cmd.preferred ? '#10b981' : '#475569'}; padding-left: 12px;">
                                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; flex-wrap: wrap;">
                                            <span class="tool-tag" style="background: ${cmd.preferred ? 'rgba(16, 185, 129, 0.2)' : 'rgba(71, 85, 105, 0.2)'}; color: ${cmd.preferred ? '#6ee7b7' : '#94a3b8'};">
                                                ${cmd.preferred ? '⭐ ' : ''}${escapeHtml(cmd.tool)}
                                            </span>
                                            ${cmd.platforms.map(platform => `
                                                <span class="card-badge" style="background: rgba(56, 189, 248, 0.1); color: #38bdf8; font-size: 0.75em;">
                                                    ${escapeHtml(platform)}
                                                </span>
                                            `).join('')}
                                            ${cmd.requires_elevation ? `
                                                <span class="card-badge" style="background: rgba(239, 68, 68, 0.2); color: #f87171; font-size: 0.75em;">
                                                    🔒 REQUIRES ELEVATION
                                                </span>
                                            ` : ''}
                                        </div>
                                        <div class="command-box" style="margin: 8px 0;">
                                            ${escapeHtml(cmd.command)}
                                        </div>
                                        ${cmd.notes ? `
                                            <div style="color: #94a3b8; font-size: 0.85em; font-style: italic;">
                                                💡 ${escapeHtml(cmd.notes)}
                                            </div>
                                        ` : ''}
                                    </div>
                                `).join('')}
                            </div>
                        ` : step.command ? `
                            <div class="command-box" style="margin-top: 10px;">
                                ${escapeHtml(step.command)}
                            </div>
                        ` : ''}

                        ${step.requires_confirmation ? `
                            <div class="warning-box" style="margin-top: 10px;">
                                ⚠️ This step requires manual confirmation before execution
                            </div>
                        ` : ''}
                    </div>
                `).join('')}
            </div>
        `;
    }

    // Batch Strategy
    if (m.metadata.batch_strategy) {
        html += `
            <div class="modal-section">
                <div class="info-box">
                    <strong>💡 Batch Strategy:</strong><br>
                    ${escapeHtml(m.metadata.batch_strategy).replace(/\n/g, '<br>')}
                </div>
            </div>
        `;
    }

    // Expected Outcomes
    if (m.metadata.expected_outcomes && m.metadata.expected_outcomes.length > 0) {
        html += `
            <div class="modal-section">
                <div class="modal-section-title">✓ Expected Outcomes</div>
                <ul style="color: #94a3b8; line-height: 2;">
                    ${m.metadata.expected_outcomes.map(outcome => `
                        <li>${escapeHtml(outcome)}</li>
                    `).join('')}
                </ul>
            </div>
        `;
    }

    // Common Issues & Troubleshooting
    if ((m.metadata.common_issues && m.metadata.common_issues.length > 0) ||
        (m.metadata.troubleshooting && Object.keys(m.metadata.troubleshooting).length > 0)) {
        html += `
            <div class="modal-section">
                <div class="modal-section-title">⚠️ Common Issues & Troubleshooting</div>
        `;

        if (m.metadata.common_issues && m.metadata.common_issues.length > 0) {
            html += m.metadata.common_issues.map(issue => `
                <div class="issue-item">
                    <div class="item-title-text">${escapeHtml(issue.issue || issue)}</div>
                    ${issue.solution ? `
                        <div style="color: #94a3b8; margin-top: 10px;">
                            <strong style="color: #6ee7b7;">Solution:</strong> ${escapeHtml(issue.solution)}
                        </div>
                    ` : ''}
                </div>
            `).join('');
        }

        if (m.metadata.troubleshooting && Object.keys(m.metadata.troubleshooting).length > 0) {
            html += `<div style="margin-top: 15px;">`;
            Object.entries(m.metadata.troubleshooting).forEach(([problem, solution]) => {
                html += `
                    <div class="issue-item">
                        <div class="item-title-text">${escapeHtml(problem)}</div>
                        <div style="color: #94a3b8; margin-top: 10px;">
                            <strong style="color: #6ee7b7;">Solution:</strong> ${escapeHtml(solution)}
                        </div>
                    </div>
                `;
            });
            html += `</div>`;
        }

        html += `</div>`;
    }

    return html;
}

function closeMethodologyModal() {
    document.getElementById('methodology-modal').classList.remove('active');
}

// Close modal on escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        closeMethodologyModal();
    }
});

// Close modal when clicking outside
document.getElementById('methodology-modal').addEventListener('click', (e) => {
    if (e.target.id === 'methodology-modal') {
        closeMethodologyModal();
    }
});
