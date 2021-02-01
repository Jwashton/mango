// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    css: '/css',
    js: '/js',
    static: { url: '/', static: true }
  },
  plugins: [
    '@snowpack/plugin-sass'
  ],
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    out: '../priv/static'
  },
};
