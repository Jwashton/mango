let currentMenu = null;

const findToggle = function findToggle(node) {
  return node?.getElementsByClassName('dropdown-toggle')[0];
};

const findOptions = function findOptions(node) {
  return node?.getElementsByClassName('dropdown-options')[0];
};

const hideMenu = function hideMenu() {
  const options = findOptions(currentMenu);

  if (options) {
    options
      .classList
      .remove('visible');
  }
  
  currentMenu = null;
};

const showMenu = function showMenu(node) {
  if (currentMenu) {
    hideMenu();
  }

  currentMenu = node;

  findOptions(node)
    .classList
    .toggle('visible');
};

const toggleMenu = function toggleMenu(node) {
  return (event) => {
    event.preventDefault();
    event.stopPropagation();

    if (currentMenu !== node) {
      showMenu(node);
    } else {
      hideMenu(node);
    }
  }
};

const Dropdown = {
  hydrate(node) {
    findToggle(node)
      ?.addEventListener('click', toggleMenu(node));

    document.addEventListener('click', () => { hideMenu() });
    window.addEventListener('keyup', event => {
      if (event.key === 'Esc' || event.key === 'Escape') {
        hideMenu();
      }
    })
  }
};

export default Dropdown;
