defmodule MangoWeb.RegistrationView do
  use MangoWeb, :view

  def text_control(f, name) do
    form_control(f, :text, name)
  end

  def password_control(f, name) do
    form_control(f, :password, name)
  end

  def form_control(f, type, name) do
    ~E"""
    <div class="form-group">
      <%= label f, name, class: "control-label" %>
      <%=
        case type do
          :text ->
            text_input f, name, class: "form-control"
          :password ->
            password_input f, name, placeholder: "Password", class: "form-control"
        end
      %>
      <%= error_tag f, name %>
    </div>
    """
  end
end
