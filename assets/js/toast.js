function makeToastContainer() {
  const container = document.createElement('div');

  container.id = 'toastContainer';

  document.body.appendChild(container);

  return container;
}

function getToastContainer() {
  return document.querySelector('#toastContainer') ?? makeToastContainer();
}

let numToasts = 0;

function displayToast(message, type) {
  const toast = document.createElement('div');

  toast.classList.add('toast', type);
  toast.textContent = message;

  numToasts++;
  getToastContainer().appendChild(toast);

  setTimeout(() => {
    numToasts--;
    toast.remove();

    if (numToasts === 0) {
      getToastContainer().remove();
    }
  }, 5000);
}

export default displayToast;
