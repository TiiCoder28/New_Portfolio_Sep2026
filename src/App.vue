<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>
<template><div class="site-shell"><header class="header wrap"><RouterLink to="/" class="brand">TK<span class="dot">.</span></RouterLink><nav aria-label="Main navigation"><RouterLink to="/work">Work</RouterLink><RouterLink to="/about">About</RouterLink><RouterLink to="/logbook">Logbook</RouterLink><RouterLink to="/contact">Contact</RouterLink></nav></header><main><RouterView /></main><footer class="footer wrap"><span>© {{ new Date().getFullYear() }} Tiisetso Khumalo</span><span>Built thoughtfully, one iteration at a time.</span></footer></div></template>
