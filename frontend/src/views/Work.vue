<template>
<div class="wrap page-top"><div class="eyebrow">INDEX / 01</div><h1 class="page-title">Selected work<span class="dot">.</span></h1><p class="page-intro">A collection of applications, client engagements and ongoing engineering experiments. Each case study explores the problem, approach and decisions behind the build.</p><div class="project-grid work-grid"><ProjectTile v-for="project in projects" :key="project.slug" :project="project"/></div></div>
</template>

<script setup>
import { projects } from '../data/projects.js'
import ProjectTile from '../components/ProjectTile.vue'
</script>

<style scoped>
/* Component-specific styles live here; shared design tokens and utilities are in Tailwind. */
</style>
