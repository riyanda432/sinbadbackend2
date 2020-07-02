defmodule MyAppWeb.ErrorHelpers do
 
  def translate_error({msg, opts}) do

    if count = opts[:count] do
      Gettext.dngettext(MyAppWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(MyAppWeb.Gettext, "errors", msg, opts)
    end
  end
end
