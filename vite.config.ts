import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import Components from "unplugin-vue-components/vite";
import {BootstrapVueNextResolver} from 'unplugin-vue-components/resolvers'
import AutoImport from 'unplugin-auto-import/vite'
import VueRouter from 'unplugin-vue-router/vite'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    VueRouter(),
    AutoImport({
      imports: ['vue', '@vueuse/core']
    }),
    Components({
      resolvers: [BootstrapVueNextResolver()],
    }),
    vue(),
  ],
  server: {
    host: true
  }
})
