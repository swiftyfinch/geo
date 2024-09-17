BUMP_TYPE = ARGV[0]
unless /^(major|minor|patch)$/.match?(BUMP_TYPE)
	abort("Please, pass one of these major/minor/patch bump type.")
end

VERSION_PROVIDER_PATH = 'Sources/Geo/geo.swift'
CONTENT = File.read(VERSION_PROVIDER_PATH)
VERSION = CONTENT.match(/version\s=\s"([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2})"/).captures.first.chomp
VERSION_PARTS = VERSION.split(".").map(&:to_i)

if BUMP_TYPE == "major"
	VERSION_PARTS[0] += 1
	VERSION_PARTS[1] = 0
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "minor"
	VERSION_PARTS[1] += 1
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "patch"
	VERSION_PARTS[2] += 1
end
NEW_VERSION = VERSION_PARTS.join(".")

# Update version in Rugby.swift for ArgumentParser
%x[sed -i '' 's/#{VERSION}/#{NEW_VERSION}/g' #{VERSION_PROVIDER_PATH}]
# Add bump commit
%x[git commit -i #{VERSION_PROVIDER_PATH} -m "[skip ci] Bump version #{NEW_VERSION}"]

puts NEW_VERSION
