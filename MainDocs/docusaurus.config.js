import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export default {
    title: 'My Static Site',
    tagline: 'Static sites made easy',
    url: 'https://example.com', // Update to a generic URL
    baseUrl: '/', // Ensure this is correct for your hosting setup
    onBrokenLinks: 'warn',
    onBrokenMarkdownLinks: 'warn',
    favicon: 'img/favicon.ico', // Use relative path
    organizationName: 'your-org', // Usually your GitHub org/user name.
    projectName: 'your-project', // Usually your repo name.
    themeConfig: {
        navbar: {
            title: 'My Static Site',
            logo: {
                alt: 'Site Logo',
                src: 'img/logo.svg', // Use relative path
            },
            items: [
                {
                    to: 'docs/', // Use relative path
                    activeBasePath: 'docs/', // Use relative path
                    label: 'Docs',
                    position: 'left',
                },
                {
                    href: 'https://github.com/your-org/your-project',
                    label: 'GitHub',
                    position: 'right',
                },
            ],
        },
        footer: {
            style: 'dark',
            links: [
                {
                    title: 'Docs',
                    items: [
                        {
                            label: 'Getting Started',
                            to: 'docs/', // Use relative path
                        },
                    ],
                },
            ],
            copyright: `Copyright © ${new Date().getFullYear()} Your Project, Inc. Built with Docusaurus.`,
        },
    },
    presets: [
        [
            '@docusaurus/preset-classic',
            {
                docs: {
                    path: path.resolve(__dirname, 'docs'), // Keep absolute path
                    sidebarPath: path.resolve(__dirname, 'sidebar.js'), // Keep absolute path
                    editUrl: 'https://github.com/your-org/your-project/edit/main/website/',
                },
                theme: {
                    customCss: path.resolve(__dirname, 'src/css/custom.css'), // Keep absolute path
                },
            },
        ],
    ],
};