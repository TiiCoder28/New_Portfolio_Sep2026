// Editorial content: actual image files are provided separately under frontend/public/images.
// Add only verified public links and client-approved imagery.
export const projects = [
  {
    slug:'contentforge', number:'01', name:'ContentForge', category:'AI engineering · Content workflows', year:'2026',
    summary:'An AI content transformation studio designed around creating and editing reusable outputs from documents, links and prompts.',
    role:'Developer', stack:['JavaScript','AI integrations','Document workflows','Content editing'],
    image:'/images/contentforge/hero.webp', imageAlt:'ContentForge landing page showing its content transformation interface',
    gallery:[
      {src:'/images/contentforge/editor.webp',alt:'ContentForge slide editor with structured content controls and preview',caption:'A structured editing workspace with content, layout and media controls.'},
      {src:'/images/contentforge/media.webp',alt:'ContentForge image generation and replacement dialogue',caption:'A visual asset replacement workflow; the capture also shows a storage-quota error under investigation.'}
    ],
    problem:'Transforming source content into useful, editable formats can involve repetitive assembly and multiple tools.',
    approach:'Explore one workflow for starting from a file, notes, a link or a prompt and reviewing the resulting content in an editor.',
    implementation:'Developed an evolving JavaScript-based interface for content transformation, editing and media controls. The supplied captures show the landing page, structured slide editor and image replacement flow.',
    learnings:'Editing and exporting are as important as initial generation. Error states, including storage limits, need explicit handling.',
    featured:true
  },
  {
    slug:'betbetter', number:'02', name:'BetBetter', category:'Sports analytics · Data applications', year:'2026',
    summary:'A sports analytics interface presenting market information, probability estimates, revisions and uncertainty in one reviewable experience.',
    role:'Full-stack developer', stack:['FastAPI','PostgreSQL','AWS EC2','Data visualisation'],
    image:'/images/betbetter/hero.webp', imageAlt:'BetBetter Brazil versus Morocco fixture analysis dashboard',
    gallery:[
      {src:'/images/betbetter/markets.webp',alt:'BetBetter bookmaker markets including both-teams-to-score and match winner',caption:'Market tables distinguish quoted odds, raw implied probability and no-vig estimates.'},
      {src:'/images/betbetter/model-review.webp',alt:'BetBetter probability review showing confidence and risk indicators',caption:'Model review screen communicating evidence quality and uncertainty.'},
      {src:'/images/betbetter/odds-movement.webp',alt:'BetBetter graph of observed odds changes',caption:'Historical price movement by market and selection.'},
      {src:'/images/betbetter/history-empty.webp',alt:'Empty odds history state on a fixture page',caption:'The interface also accounts for unavailable data.'},
      {src:'/images/betbetter/privacy-memory.webp',alt:'Privacy request queue and candidate memory review',caption:'Operational review screens for privacy requests and proposed agent memories.'}
    ],
    problem:'Raw sports market information and changing prices can be difficult to interpret without transparent assumptions, history and uncertainty indicators.',
    approach:'Present market quotes alongside derived probability views, track revisions and distinguish missing data from meaningful results.',
    implementation:'Built a frontend and FastAPI backend with a PostgreSQL database and AWS EC2 deployment. The supplied captures demonstrate fixtures, market tables, price-history visualisations and review states.',
    learnings:'An analytical interface should communicate unavailable data, risk and uncertainty clearly instead of implying every model output is actionable.',
    featured:true
  },
  {
    slug:'spendsharp', number:'03', name:'SpendSharp', category:'Applied AI · Personal finance', year:'2026',
    summary:'An AI-assisted budgeting application built to help people understand spending patterns and make more informed decisions.',
    role:'Full-stack / AI developer',stack:['AI integration','Supabase','Vercel','Render'],
    problem:'Financial information can be difficult to interpret and act on when it is spread across transactions and disconnected views.',
    approach:'Design a focused product experience around structured financial information and accessible AI-generated guidance.',
    implementation:'Built and deployed frontend, backend services and structured-data workflows with AI-assisted guidance.',
    learnings:'Continual refinement of data handling and user-facing explanations is essential when applying AI to financial information.',
    featured:true
  },
  {
    slug:'minesafe-passport',number:'04',name:'MineSafe Passport',category:'Client delivery · Operational workflows',year:'2026',
    summary:'A client application supporting workforce medical-compliance operations and multi-role approval processes.',
    role:'Client application developer',stack:['Workflow design','Role-based access','Audit history','Migration planning'],
    problem:'Coordinating approvals, waitlists and medical sign-off across different operational stakeholders calls for clear, traceable workflows.',
    approach:'Map the needs of miners, HR teams, clinic administrators and approving practitioners to well-defined roles and process stages.',
    implementation:'Worked on approvals, waitlist management, transfers, OMP sign-off and audit history; advised on environment separation, rollback and controlled migration.',
    learnings:'Enterprise workflow design depends on role clarity, traceability and reliable transitions between stages.',
    featured:false,confidentiality:'Client project: only approved or anonymised visuals will be published.'
  }
]
export const getProject = slug => projects.find(p => p.slug === slug)
