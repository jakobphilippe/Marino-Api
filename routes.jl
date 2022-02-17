using Genie.Router, Genie.Renderer.Json
using Mongoc
include("src/MarinoApi.jl")

route("/") do
  serve_static_file("welcome.html")
end

route("/get_latest_data") do
  try
    json(get_latest_data())
  catch e
    @error e
  end
end