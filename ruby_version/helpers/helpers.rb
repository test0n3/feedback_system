# frozen_string_literal: true

module ViewHelpers
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end
end
