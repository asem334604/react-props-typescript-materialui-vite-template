import {defineConfig} from "vite";
import reactRefresh from '@vitejs/plugin-react-refresh';

export default defineConfig({
    plugins: [reactRefresh()],
    server: {
        port: 3001,
        hmr: true,  // Enable Hot Module Replacement
        proxy: {
            '/': {
                target: 'http://localhost:3000', // The URL of your Express server
                changeOrigin: true,
                secure: false,
                rewrite: (path: string) => path.replace(/^\//, ''),
            },
        },
    },
});
