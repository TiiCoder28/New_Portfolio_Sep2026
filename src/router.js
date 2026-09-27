import { createRouter, createWebHistory } from 'vue-router'
import Home from './views/Home.vue'
import Work from './views/Work.vue'
import ProjectDetail from './views/ProjectDetail.vue'
import About from './views/About.vue'
import Logbook from './views/Logbook.vue'
import Contact from './views/Contact.vue'
export const router = createRouter({ history:createWebHistory(), routes:[
 {path:'/',component:Home}, {path:'/work',component:Work}, {path:'/work/:slug',component:ProjectDetail,props:true}, {path:'/about',component:About}, {path:'/logbook',component:Logbook}, {path:'/contact',component:Contact}, {path:'/:pathMatch(.*)*',redirect:'/'}
],scrollBehavior:()=>({top:0}) })
