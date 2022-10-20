export default {
  mounted() {
    // let root = document.getElementById("root")

    // if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    //   root.classList.add('dark')
    // } else {
    //   root.classList.remove('dark')
    // }

    this.el.addEventListener("click", e => {
      window.toggleTheme()
      // if (localStorage.theme !== 'dark') {
      //   root.classList.add('dark')
      //   localStorage.setItem('theme', 'dark')
      // } else {
      //   root.classList.remove('dark')
      //   localStorage.setItem('theme', 'light')
      // }
    })
  }
}