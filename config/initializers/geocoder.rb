geocoder_settings = {
  :lookup => :google,
  :api_key => Uke::Application::custom_config(:google_maps_api_key),
  :use_https => false,
  :timeout => 3,
  :units => :km
}

Geocoder.configure(geocoder_settings)