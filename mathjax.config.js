// mathjax.config.js
window.MathJax = {
  tex2jax: {
    inlineMath:  [ ['\\(','\\)'], ['$', '$'] ],
    displayMath: [ ['\\[','\\]'], ['$$', '$$'] ],
    processEscapes: true
  },
  TeX: {
    equationNumbers: { autoNumber: "AMS" },
    extensions: ["autoload-all.js"]
  }
};
