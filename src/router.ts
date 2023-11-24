import { RouteRecordRaw, createRouter, createWebHistory } from 'vue-router/auto';
import Index from './pages/index.vue';
import AlbumPage from './pages/AlbumPage.vue'; 


const routes = [
    {
      path: '/',
      component: Index,
    },
    {
        path: '/AlbumPage',
        name: 'AlbumPage',
        component: AlbumPage,
        props: true, 
    },
    // ...other routes
  ];

export const router = createRouter({
  history: createWebHistory(),
  routes,
});
