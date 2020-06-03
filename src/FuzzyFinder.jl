module FuzzyFinder

function regex_escape(s::AbstractString)
    res = replace(s, r"([()[\]{}?*+\-|^\$\\.&~#\s=!<>|:])" => s"\\\1")
    replace(res, "\0" => "\\0")
end

default = x -> x

function fuzzyfinder(input::String, iterable; fetcher::Function=default, sorted=true)
	recommendations = []
	input = if !isa(input, String)
		string(input)
	else
		input
	end
	pattern = join(regex_escape(input), ".?")
	pattern = "(?=($pattern))"
	for item in iterable
		matches = collect(eachmatch(Regex(pattern), fetcher(item)))
		println(matches)
		if !isempty(matches)
			best = length(matches)
			for m in matches
				best = min(best, length(m.captures[1]))
				println(best)
				push!(recommendations, (length(matches[best].captures[1]), matches[best].offset, fetcher(item), item))
			end
		end
	end
	if sorted
		return (res[end] for res in sort(recommendations))
	else
		return (res[end] for res in sort(recommendations, by=x->x[:3]))
	end
end

end
