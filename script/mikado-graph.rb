#!/usr/bin/env ruby

require "octokit"
require "yaml"
require "pp"
require "tsort"

# should debugging output be enabled?
def debugging?
  ENV['DEBUG'] && ENV['DEBUG'] != ''
end

def exit_with_usage!
  STDERR.puts "Usage:"
  STDERR.puts "  #{$0} <owner/repository> "
  exit 1
end

def client
  @client ||= Octokit::Client.new :access_token => access_token
  puts "Current octokit rate limit: #{@client.rate_limit.inspect}" if debugging?
  @client
end

# retrieve GitHub API token
def access_token
  return @access_token if @access_token
  creds = YAML.load(File.read(File.expand_path('~/.github.yml')))
  @access_token = creds["token"]
end

def issue_text(repo)
  results = {}
  client.list_issues(repo).each do |issue|
    text = [ issue["body"] ]
    if issue["comments"] > 0
      text += client.issue_comments(repo, issue["number"]).map do |comment|
        comment["body"]
      end
    end
    results[issue["number"]] = text.join("\n").gsub(/\r\n/, "\n")
  end
  results
end

def normalize_as_issue_url(repo, reference)
  words, ref = reference.strip.split(/:\s+/)
  result = convert_ref_to_url(repo, ref)
  puts "reference:[#{reference}], words:[#{words}], ref:[#{ref}], result:[#{result}]" if debugging?
  result
end

def convert_ref_to_url(repo, ref)
  # See: https://help.github.com/en/github/writing-on-github/autolinked-references-and-urls#issues-and-pull-requests
  case ref
  when Integer
    "https://github.com/#{repo}/issues/#{ref}"
  when %r{^#\d+$}
    number = ref.sub(%r{^#}, '')
    "https://github.com/#{repo}/issues/#{number}"
  when %r{^GH-\d+$}
    number = ref.sub(%r{^GH-}, '')
    "https://github.com/#{repo}/issues/#{number}"
  when %r{^[^/#]+/[^/]+#\d+$}
    number = ref.sub(%r{^[^/#]+/[^/]+#(\d+)$}, '\1')
    "https://github.com/#{repo}/issues/#{number}"
  when %r{^https://github.com/[^/]+/[^/]+/issues/\d+$}
    ref
  else
    nil
  end
end

def process_matches(repo, matches)
  if matches.size > 0
    result = matches.map {|match| normalize_as_issue_url(repo, match) }.compact
    result.size > 0 ? result : nil
  else
    nil
  end
end

def text_dependencies(repo, text)
  matches = text.scan(%r{\bdepends(?:\s+|-)on:\s+[^\s]+(?:\s|\z)}i)
  process_matches(repo, matches)
end

def text_blocks(repo, text)
  matches = text.scan(%r{\bblocks:\s+[^\s]+(?:\s|\z)}i)
  process_matches(repo, matches)
end

def find_references(repo, issue_map)
  results = {}
  issue_map.each_pair do |number, text|
    url_for_number = convert_ref_to_url(repo, number)
    results[url_for_number] ||= []

    if deps = text_dependencies(repo, text)
      results[url_for_number] += deps
    end

    if blocked = text_blocks(repo, text)
      blocked.each do |blocker|
        results[blocker] ||= []
        results[blocker] += [ url_for_number ]
      end
    end
  end
  results
end

# Augment Hash to support topological sorting
class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

# gather command-line parameters
repo = ARGV.shift
exit_with_usage! unless repo

edges = find_references(repo, issue_text(repo))

# edges.each_pair do |source, destinations|
#   puts "#{source}:"
#   destinations.each do |destination|
#     puts "\t#{destination}"
#   end
#   puts
# end

edges.tsort.each do |node|
  puts "#{node}:"
  edges[node].each do |destination|
    puts "\t#{destination}"
  end
  puts
end
