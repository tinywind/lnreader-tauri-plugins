import fs from 'fs';
import path from 'path';

const compiledPluginDirectory = path.join('.js', 'plugins');
fs.rmSync(compiledPluginDirectory, { force: true, recursive: true });
