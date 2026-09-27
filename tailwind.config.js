/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js}'],
  theme: {
    extend: {
      colors: { paper: '#f6f3ed', ink: '#252823', muted: '#74786e', accent: '#787e58' },
      fontFamily: { sans: ['Inter', 'Arial', 'sans-serif'], serif: ['Georgia', 'Times New Roman', 'serif'] }
    }
  },
  plugins: []
}
