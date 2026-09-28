<template>
  <main class="mx-auto max-w-6xl p-5 md:p-10">
    <header class="flex justify-between items-center border-b border-ink/20 pb-5 mb-10 gap-3">
      <div><div class="text-xs tracking-[.2em] uppercase text-accent font-bold">TK / PRIVATE WORKSPACE</div><h1 class="font-serif text-3xl mt-1">Portfolio Studio.</h1></div>
      <button v-if="session" class="secondary text-sm" @click="signOut">Sign out</button>
    </header>
    <div v-if="!configured" class="max-w-xl p-6 bg-white border border-ink/20">
      <h2 class="text-xl font-semibold">Configuration required</h2>
      <p class="mt-3">Create a Supabase project and set the three VITE_ variables in <code>studio/.env</code>. The Studio cannot authenticate until that is done.</p>
    </div>
    <section v-else-if="loading" class="text-sm">Checking session…</section>
    <section v-else-if="!session" class="max-w-md bg-white border border-ink/20 p-6 space-y-5">
      <h2 class="font-serif text-2xl">Administrator sign-in</h2>
      <form @submit.prevent="signIn" class="space-y-4">
        <div><label for="email">Email</label><input id="email" v-model="email" type="email" autocomplete="username" required /></div>
        <div><label for="password">Password</label><input id="password" v-model="password" type="password" autocomplete="current-password" required /></div>
        <button class="btn" :disabled="busy">Sign in</button>
      </form><p class="text-xs text-gray-500">Administrator accounts are provisioned privately; there is no public sign-up.</p>
    </section>
    <section v-else-if="!verified" class="max-w-lg bg-white border border-ink/20 p-6 space-y-5">
      <h2 class="font-serif text-2xl">Verify your identity</h2>
      <div v-if="enrollment">
        <p class="text-sm mb-3">Scan this QR code in your authenticator app, then enter the six-digit code to finish enrolling MFA.</p>
        <img :src="enrollment.totp.qr_code" alt="TOTP authenticator enrollment QR code" class="max-w-[220px] mb-4" />
      </div>
      <p v-else class="text-sm">Enter the code from your authenticator app. If this is your first sign-in, enrol a second factor first.</p>
      <button v-if="!enrollment && !factorId" class="secondary" :disabled="busy" @click="enroll">Set up authenticator</button>
      <form v-if="factorId" @submit.prevent="verifyMfa" class="space-y-4">
        <div><label for="otp">Six-digit verification code</label><input id="otp" v-model="otp" inputmode="numeric" autocomplete="one-time-code" maxlength="6" pattern="[0-9]{6}" required /></div>
        <button class="btn" :disabled="busy">Verify and continue</button>
      </form>
    </section>
    <section v-else class="space-y-8">
      <div class="grid sm:grid-cols-3 gap-4">
        <div class="bg-white border border-ink/20 p-5"><span class="text-xs uppercase tracking-widest text-gray-500">Projects</span><div class="text-3xl mt-2">{{ projects.length }}</div></div>
        <div class="bg-white border border-ink/20 p-5"><span class="text-xs uppercase tracking-widest text-gray-500">Posts</span><div class="text-3xl mt-2">{{ posts.length }}</div></div>
        <div class="bg-white border border-ink/20 p-5"><span class="text-xs uppercase tracking-widest text-gray-500">Access</span><div class="text-sm mt-3">Admin · MFA verified</div></div>
      </div>
      <nav class="flex flex-wrap gap-3 border-b border-ink/20 pb-4">
        <button :class="tab==='projects'?'btn':'secondary'" @click="tab='projects'">Projects</button>
        <button :class="tab==='posts'?'btn':'secondary'" @click="tab='posts'">Logbook posts</button>
      </nav>
      <div class="grid lg:grid-cols-[1fr_1fr] gap-8">
        <div class="bg-white border border-ink/20 p-5">
          <div class="flex justify-between items-center mb-5"><h2 class="font-serif text-2xl">{{ tab==='projects'?'Manage projects':'Manage posts' }}</h2><button class="secondary text-sm" @click="newItem">New</button></div>
          <div v-for="item in items" :key="item.id" class="flex justify-between gap-4 border-t border-ink/10 py-3">
            <div><strong>{{ item.title }}</strong><div class="text-xs text-gray-500">{{ item.status }} · /{{ item.slug }}</div></div>
            <div class="flex gap-2"><button class="text-sm underline" @click="selectItem(item)">Edit</button><button v-if="item.status!=='archived'" class="text-sm text-red-700 underline" @click="archiveItem(item)">Archive</button></div>
          </div>
          <p v-if="!items.length" class="text-sm text-gray-500">Nothing added yet. Create your first entry.</p>
        </div>
        <form class="bg-white border border-ink/20 p-5 space-y-4" @submit.prevent="save">
          <h2 class="font-serif text-2xl">{{ editing.id?'Edit':'New' }} {{ tab==='projects'?'project':'post' }}</h2>
          <div><label>Title</label><input v-model="editing.title" maxlength="180" required /></div>
          <div><label>Slug (lowercase and hyphens)</label><input v-model="editing.slug" :disabled="Boolean(editing.id)" pattern="[a-z0-9]+(-[a-z0-9]+)*" required /></div>
          <div><label>{{ tab==='projects'?'Summary':'Excerpt' }}</label><textarea v-model="editing[tab==='projects'?'summary':'excerpt']" rows="4" maxlength="1200"></textarea></div>
          <div><label>Category</label><input v-model="editing.category" maxlength="100" /></div>
          <template v-if="tab==='projects'">
            <div><label>GitHub URL (optional)</label><input v-model="editing.github_url" type="url" /></div>
            <div><label>Live URL (optional)</label><input v-model="editing.live_url" type="url" /></div>
            <div><label>Hero image path (optional)</label><input v-model="editing.hero_asset_path" placeholder="/images/project/hero.webp" /></div>
            <label class="flex items-center gap-2"><input type="checkbox" v-model="editing.featured" class="!w-auto" /> Featured project</label>
          </template>
          <div v-else><label>Cover image path (optional)</label><input v-model="editing.cover_asset_path" placeholder="/images/posts/cover.webp" /></div>
          <div><label>Publication status</label><select v-model="editing.status"><option value="draft">Draft</option><option value="published">Published</option><option value="archived">Archived</option></select></div>
          <p class="text-xs text-gray-500">This first editor manages metadata and publishing. Rich-text blocks and media uploads follow in the next milestone.</p>
          <button class="btn" :disabled="busy">Save {{ tab==='projects'?'project':'post' }}</button>
        </form>
      </div>
    </section>
    <p v-if="message" role="status" class="mt-6 border-l-4 border-accent bg-white p-4 text-sm">{{ message }}</p>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { configured, supabase, studioRequest } from './services.js'

const loading=ref(Boolean(configured)), busy=ref(false), session=ref(null), verified=ref(false)
const email=ref(''),password=ref(''),otp=ref(''),factorId=ref(''),enrollment=ref(null),message=ref('')
const projects=ref([]),posts=ref([]),tab=ref('projects'),editing=ref({})
const items=computed(()=>tab.value==='projects'?projects.value:posts.value)
function newItem(){editing.value=tab.value==='projects'?{title:'',slug:'',summary:'',category:'',featured:false,status:'draft',github_url:null,live_url:null,hero_asset_path:null}:{title:'',slug:'',excerpt:'',category:'',status:'draft',cover_asset_path:null}}
function selectItem(item){editing.value={...item}}
function showError(error){message.value=error?.message||'An unexpected error occurred.'}
async function refresh(){
  projects.value=await studioRequest('projects')
  posts.value=await studioRequest('posts')
}
async function checkAssurance(){
  const {data,error}=await supabase.auth.mfa.getAuthenticatorAssuranceLevel()
  if(error)throw error
  if(data.currentLevel!=='aal2'){
    verified.value=false
    const factors=await supabase.auth.mfa.listFactors()
    if(factors.error)throw factors.error
    factorId.value=factors.data.totp.find(f=>f.status==='verified')?.id||''
    return
  }
  await studioRequest('session')
  verified.value=true
  await refresh()
  newItem()
}
async function signIn(){
  busy.value=true; message.value=''
  try{const {data,error}=await supabase.auth.signInWithPassword({email:email.value,password:password.value});if(error)throw error;session.value=data.session;password.value='';await checkAssurance()}catch(e){showError(e)}finally{busy.value=false}
}
async function enroll(){
  busy.value=true;message.value=''
  try{const {data,error}=await supabase.auth.mfa.enroll({factorType:'totp',friendlyName:'Portfolio Studio'});if(error)throw error;enrollment.value=data;factorId.value=data.id}catch(e){showError(e)}finally{busy.value=false}
}
async function verifyMfa(){
  busy.value=true;message.value=''
  try{
    const {data:challenge,error:challengeError}=await supabase.auth.mfa.challenge({factorId:factorId.value});if(challengeError)throw challengeError
    const {error}=await supabase.auth.mfa.verify({factorId:factorId.value,challengeId:challenge.id,code:otp.value});if(error)throw error
    otp.value='';enrollment.value=null;await checkAssurance()
  }catch(e){showError(e)}finally{busy.value=false}
}
async function save(){
  busy.value=true;message.value=''
  try{
    const kind=tab.value
    const original=editing.value
    const fields=kind==='projects'?['title','summary','category','hero_asset_path','github_url','live_url','featured','sort_order','status']:['title','excerpt','category','cover_asset_path','status']
    const payload=Object.fromEntries(fields.filter(k=>Object.prototype.hasOwnProperty.call(original,k)).map(k=>[k,original[k] ?? null]))
    if(kind==='projects'){payload.featured=Boolean(original.featured);payload.summary=original.summary||'';payload.category=original.category||''}
    else payload.excerpt=original.excerpt||''
    if(!original.id){payload.slug=original.slug;await studioRequest(kind,{method:'POST',body:JSON.stringify(payload)})}
    else await studioRequest(kind+'/'+original.id,{method:'PATCH',body:JSON.stringify(payload)})
    await refresh();newItem();message.value='Saved successfully.'
  }catch(e){showError(e)}finally{busy.value=false}
}
async function archiveItem(item){
  if(!confirm('Archive "'+item.title+'"? It will no longer be public.'))return
  busy.value=true;message.value=''
  try{await studioRequest(tab.value+'/'+item.id,{method:'DELETE'});await refresh();message.value='Archived.'}catch(e){showError(e)}finally{busy.value=false}
}
async function signOut(){await supabase.auth.signOut();session.value=null;verified.value=false;factorId.value='';enrollment.value=null}
onMounted(async()=>{
  newItem()
  if(!configured)return
  try{const {data,error}=await supabase.auth.getSession();if(error)throw error;session.value=data.session;if(session.value)await checkAssurance()}catch(e){showError(e)}finally{loading.value=false}
})
</script>

<style scoped>
main{min-height:100vh}
</style>
