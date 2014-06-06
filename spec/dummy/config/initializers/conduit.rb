Conduit.configure do |c|
  if Rails.env.test?
    c.driver_paths << Rails.root.join('lib', 'conduit', 'drivers')
  end
end