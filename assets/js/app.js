// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html';

const toggleUserMenu = function toggleUserMenu(event) {
  event.preventDefault();
  event.stopPropagation();

  document
    .getElementById('user-nav-options')
    .classList
    .toggle('visible');
};

const hideUserMenu = function hideUserMenu() {
  document
    .getElementById('user-nav-options')
    .classList
    .remove('visible');
}

document
  .getElementById('user-nav-toggle')
  .addEventListener('click', toggleUserMenu);

document.addEventListener('click', hideUserMenu);
