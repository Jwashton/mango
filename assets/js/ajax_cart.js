import displayToast from './toast';

function ajaxHandler(e) {
  e.preventDefault();

  const post_url = e.target.action;
  const form_data = new FormData(e.target);
  const request_options = {
    method: 'POST',
    body: form_data
  };

  fetch(post_url, request_options)
    .then(response => response.json())
    .then(blurb => {
      displayToast(blurb.message, 'success');

      document
        .querySelectorAll('.cart-count')
        .forEach(elem => { elem.textContent = blurb.cart_count; })
    });
}

const ajaxCart = {
  init() {
    document
      .querySelectorAll('.cart-form')
      .forEach(form => form.addEventListener('submit', ajaxHandler));
  }
};

export default ajaxCart;
