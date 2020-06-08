using FuzzyFinder
using Test

@testset "FuzzyFinder.jl" begin
	global const f = FuzzyFinder
	global const collections = ["migrations.jl",
            "random_migrations.jl",
            "random_admin_log.jl",
            "api_user.doc",
            "user_group.doc",
            "users.txt",
            "accounts.txt",
            "123.jl",
            "test123test.jl"
            ]
	global const cased_collections = ["MIGRATIONS.jl",
            "random_MiGRations.jl",
            "random_admin_log.jl",
            "migrations.doc",
            "user_group.doc",
            "users.txt",
            ]
	global const dict_collections =[
							  Dict("name"=> "migrations.jl"),
							  Dict("name"=> "random_migrations.jl"),
							  Dict("name"=> "random_admin_log.jl"),
							  Dict("name"=> "api_user.doc"),
							  Dict("name"=> "user_group.doc"),
							  Dict("name"=> "users.txt"),
							  Dict("name"=> "accounts.txt"),
							  ]
	result = f.fuzzyfinder("txt", collections)
	expected = ["users.txt", "accounts.txt"]
	@test collect(result) == expected

	result = f.fuzzyfinder("miGr", cased_collections)
	expected = ["MIGRATIONS.jl", "migrations.doc", "random_MiGRations.jl"]
	@test collect(result) == expected

	collection_arr = ["fuuz", "fuz", "fufuz"]
	result = f.fuzzyfinder("fuz", collection_arr)
	expected = ["fuz", "fuuz", "fufuz"]
	@test collect(result) == expected

	result = f.fuzzyfinder(".txt", collections)
	expected = ["users.txt", "accounts.txt"]
	@test collect(Set(result)) == expected

	result = f.fuzzyfinder("rami", collections)
	expected = ["random_migrations.jl", "random_admin_log.jl"]
	@test collect(result) == expected

	result = f.fuzzyfinder("mi", collections)
	expected = ["migrations.jl", "random_migrations.jl", "random_admin_log.jl"]
	@test collect(result) == expected

	result = f.fuzzyfinder("user", collections)
	expected = ["user_group.doc", "users.txt", "api_user.doc"]
	@test collect(result) == expected

	result = f.fuzzyfinder(123, collections)
	expected = ["123.jl", "test123test.jl"]
	@test collect(result) == expected

	result = f.fuzzyfinder("user", dict_collections, fetcher = x -> get(x, "name", ""))
	expected = [Dict("name"=> "user_group.doc"), Dict("name" => "users.txt"), Dict("name" => "api_user.doc")]
	@test collect(result) == expected

	collection = ["zzfuz", "nnfuz", "aafuz", "ttfuz", "wow!", "julia"]
	result = f.fuzzyfinder("fuz", collection, sorted=false)
	expected = ["zzfuz", "nnfuz", "aafuz", "ttfuz"]
	@test collect(result) == expected

end

