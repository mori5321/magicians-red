App.router.config do
  get  "hello", to: "sample#index"
  post "hello", to: "sample#create"
end