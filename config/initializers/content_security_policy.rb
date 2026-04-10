Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https

    policy.script_src :self, :https, :unsafe_inline, "https://www.google.com", "https://www.gstatic.com"

    policy.frame_src :self, "https://www.google.com"

    policy.img_src :self, :https, :data

    policy.style_src :self, :https, :unsafe_inline
  end
end
