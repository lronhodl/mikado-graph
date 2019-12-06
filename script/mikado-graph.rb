#!/usr/bin/env ruby

require "octokit"
require "yaml"
require "pp"

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

# gather command-line parameters
repo = ARGV.shift
if repo
  client.list_issues(repo).each do |issue|
    puts "Issue: #{issue["number"]}, #{issue["html_url"]}, state: #{issue["state"]}"
    puts "\tbody: #{issue["body"]}"
    client.issue_comments(repo, issue["number"]).each do |comment|
      puts "\tcomment: #{comment["body"]}"
    end
    puts
    break
  end
else
  exit_with_usage!
end
