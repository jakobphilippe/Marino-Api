module MarinoApi

using Genie, Logging, LoggingExtras
using Logging
using LoggingExtras
using Mongoc
using PrettyPrint

locations = ["m-wr", "m-3", "m-g", "m-2", "m-tr", "sb-4"]

function main()
  Core.eval(Main, :(const UserApp = $(@__MODULE__)))

  Genie.genie(; context = @__MODULE__)

  Core.eval(Main, :(const Genie = UserApp.Genie))
  Core.eval(Main, :(using Genie))
end

function get_latest_data()
  suffix = "&tlsCAFile=" * ENV["CERT_LOC"]
  password = ENV["MONGO_PASSWORD"]
  
  @info suffix
  @info password 
 
  client = Mongoc.Client("mongodb+srv://root:$password@marinobase.vunm9.mongodb.net/umongo?retryWrites=true&w=majority" * suffix)
   
  database = client["Umongo"]
  @info "Succesfully connected to Umongo for API ;)"
  collection = database["GymData"]
  
  marino_data_dict = Dict()
  
  for name in locations
    bson_filter = Mongoc.BSON("""{ "name" : "$name" }""")
    bson_options = Mongoc.BSON("""{ "sort" : { "date_time" : -1 } }""")
    doc = Mongoc.find_one(collection, bson_filter, options=bson_options)
    
    marino_data_dict[name] = Dict(
                              "number" => doc["number"],
                              "percent" => doc["percent_full"],
                              "date_time" => doc["date_time"]
                              )
  end

  Mongoc.destroy!(client)
  
  return marino_data_dict
end

end
