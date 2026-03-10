#!/usr/bin/env node
// U-Claw config migration script
// Runs on every startup to ensure config compatibility

const fs = require('fs');
const path = require('path');

const dataDir = process.argv[2] || path.join(__dirname, '..', 'data');
const configPath = path.join(dataDir, 'config.json');

if (!fs.existsSync(configPath)) process.exit(0);

try {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

    // Ensure gateway section exists
    if (!config.gateway) {
        config.gateway = { mode: 'local', auth: { token: 'uclaw' } };
    }

    // Ensure auth token exists
    if (!config.gateway.auth || !config.gateway.auth.token) {
        config.gateway.auth = { token: 'uclaw' };
    }

    // Future migrations go here:
    // if (!config._version) { config._version = '1.1'; ... }

    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
} catch (e) {
    // Don't crash on migration errors
    console.error('Migration warning:', e.message);
}
