<template>
<RouterLink class="project-tile" :to="'/work/'+project.slug"><div class="tile-image"><img v-if="project.image" :src="project.image" :alt="'Screenshot of '+project.name"/><span v-else class="image-awaiting">PROJECT / {{ project.number }}<small>Visual case study</small></span><span class="tile-arrow" aria-hidden="true">↗</span></div><div class="tile-meta"><span>{{ project.category }}</span><span>{{ project.year }}</span></div><h3>{{ project.name }}</h3><p>{{ project.summary }}</p></RouterLink>
</template>

<script setup>
import { RouterLink } from 'vue-router'
defineProps({ project: { type:Object, required:true } })
</script>

<style scoped>
/* Component-specific styles live here; shared design tokens and utilities are in Tailwind. */
</style>
