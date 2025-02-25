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
    onBrokenLinks: 'throw',
    onBrokenMarkdownLinks: 'warn',
    favicon: 'img/favicon.ico',
    organizationName: 'your-org', // Usually your GitHub org/user name.
    projectName: 'your-project', // Usually your repo name.
    themeConfig: {
        navbar: {
            title: 'My Static Site',
            logo: {
                alt: 'Site Logo',
                src: 'img/logo.svg',
            },
            items: [
                {
                    to: path.resolve(__dirname, 'MainDocs/sidebars.js'),
                    activeBasePath: path.resolve(__dirname, 'MainDocs/docs'),
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
                            to: path.resolve(__dirname, 'MainDocs/docs/'),
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
                    sidebarPath: path.resolve(__dirname, 'MainDocs/sidebars.js'),
                    editUrl:
                        'https://github.com/your-org/your-project/edit/main/website/',
                },
                theme: {
                    customCss: path.resolve(__dirname, 'MainDocs/src/css/custom.css'),
                },
            },
        ],
    ],
};
