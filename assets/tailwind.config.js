// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  darkMode: 'class',
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      colors: {
        // Dark
        "dark-bgcolor": "hsl(235, 21%, 11%)",
        "dark-fg": "hsl(234, 39%, 85%)",
        "dark-bgtodo": "hsl(235, 24%, 19%)",
        // Light
        "bgcolor": "hsl(236, 33%, 92%)",
        "fg": "hsl(237, 14%, 26%)",
        "bgtodo": "hsl(0, 0%, 98%)",
      },
      gridTemplateColumns: {
        'auto': '10% auto'
      },
      screens: {
        'maxw': { 'raw': '(max-width: 640px)' },
        // => @media (min-height: 800px) { ... }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({ addVariant }) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({ addVariant }) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
