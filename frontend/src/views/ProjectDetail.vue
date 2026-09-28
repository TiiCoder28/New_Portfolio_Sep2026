<template>
  <div v-if="project" class="wrap case-study">
    <RouterLink to="/work" class="text-link">← All work</RouterLink>
    <div class="eyebrow case-eyebrow">CASE STUDY {{ project.number }} / {{ project.category }}</div>
    <img v-if="project.logo" :src="project.logo" :alt="project.logoAlt || (project.name + ' logo')" class="case-logo" loading="eager" />
    <h1 class="case-title">{{ project.name }}<span class="dot">.</span></h1>
    <p class="case-deck">{{ project.summary }}</p>
    <figure class="case-cover">
      <img v-if="project.image" :src="project.image" :alt="project.imageAlt || ('Screenshot of ' + project.name)" />
      <div v-else class="cover-placeholder"><span>VISUAL DOCUMENTATION</span><strong>{{ project.name }}</strong><small>Project imagery pending approval</small></div>
    </figure>
    <div class="case-meta">
      <div><span>YEAR</span><strong>{{ project.year }}</strong></div>
      <div><span>MY ROLE</span><strong>{{ project.role }}</strong></div>
      <div><span>TECHNOLOGIES / FOCUS</span><strong>{{ project.stack.join(' · ') }}</strong></div>
    </div>
    <div class="article">
      <section><span class="eyebrow">01 / CONTEXT</span><h2>The problem</h2><p>{{ project.problem }}</p></section>
      <section><span class="eyebrow">02 / PROCESS</span><h2>Design approach</h2><p>{{ project.approach }}</p></section>
      <section><span class="eyebrow">03 / ENGINEERING</span><h2>Implementation</h2><p>{{ project.implementation }}</p></section>
    </div>
    <section v-if="project.gallery?.length" class="case-gallery" aria-label="Application screenshots">
      <div class="eyebrow mb-6">APPLICATION GALLERY / REAL CAPTURES</div>
      <figure v-for="(asset,index) in project.gallery" :key="asset.src" class="case-gallery-item">
        <img :src="asset.src" :alt="asset.alt" loading="lazy" />
        <figcaption><span>{{ String(index + 1).padStart(2,'0') }} / {{ String(project.gallery.length).padStart(2,'0') }}</span>{{ asset.caption }}</figcaption>
      </figure>
    </section>
    <div class="article">
      <section><span class="eyebrow">04 / REFLECTION</span><h2>Lessons &amp; next steps</h2><p>{{ project.learnings }}</p></section>
      <p v-if="project.confidentiality" class="notice">{{ project.confidentiality }}</p>
      <div v-if="project.github || project.live" class="case-links">
        <a v-if="project.github" :href="project.github" target="_blank" rel="noopener noreferrer">GitHub ↗</a>
        <a v-if="project.live" :href="project.live" target="_blank" rel="noopener noreferrer">Live application ↗</a>
      </div>
    </div>
    <RouterLink class="next-case" :to="'/work/'+next.slug"><span>NEXT PROJECT ↗</span><strong>{{ next.name }}</strong></RouterLink>
  </div>
  <div v-else class="wrap page-top"><h1>Project not found.</h1><RouterLink to="/work" class="text-link">Return to work →</RouterLink></div>
</template>

<script setup>
import { computed } from 'vue'
import { getProject, projects } from '../data/projects.js'
const props = defineProps({ slug: { type: String, required: true } })
const project = computed(() => getProject(props.slug))
const next = computed(() => {
  const index = projects.findIndex(p => p.slug === props.slug)
  return projects[(index + 1) % projects.length]
})
</script>

<style scoped>
.case-logo { display:block; width:min(430px,100%); max-height:145px; object-fit:contain; object-position:left center; margin-top:2rem; }
.case-gallery { max-width: 960px; margin: 0 auto; padding: 2rem 0 4rem; }
.case-gallery-item { margin: 0 0 3rem; }
.case-gallery-item img { display: block; width: 100%; height: auto; background: #e8e5dc; border: 1px solid rgba(37,40,35,.12); }
.case-gallery-item figcaption { display: flex; gap: 1.25rem; padding: 1rem 0; font-size: .82rem; line-height: 1.6; color: #74786e; border-bottom: 1px solid rgba(37,40,35,.15); }
.case-gallery-item figcaption span { color: #252823; white-space: nowrap; font-weight: 600; letter-spacing: .1em; }
.case-cover img { object-fit: contain; }
</style>
