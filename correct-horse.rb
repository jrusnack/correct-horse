#!/usr/bin/env ruby

# Copyright (C) 2014 Jan Rusnacko
#
# This copyrighted material is made available to anyone wishing to use,
# modify, copy, or redistribute it subject to the terms and conditions of the
# MIT license.
require 'optparse'

STRENGTH = [:weak, :medium, :strong]
MIN_ENTROPY = { weak: 40, medium: 60, strong: 80 }

def random_word(wordlist)
  wordlist[rand(wordlist.size)].clone
end

def read_wordlist(filename)
  wordlist = []
  File.readlines(filename).each do |word|
    wordlist << word.strip.downcase if word.size > 3 && word.size < 12
  end
  return wordlist.uniq
end

# Choosing a random value from array can be modelled as a value of a random
# variable. This function returns entropy of a random variable ASSUMING choice
# of value from array is random (probability distribution of values of random
# variable is uniform).
def entropy(array)
  Math.log2(array.size)
end

def seconds_to_human(interval)
  sec = interval % 60
  interval /= 60

  min = interval % 60
  interval /= 60

  hours = interval % 24
  interval /= 24

  days = interval % 365
  interval /= 365

  years = interval

  if years > 0
    return "~#{years} years"
  elsif days > 0
    return "~#{days} days"
  elsif hours > 0
    return "~#{hours} hours"
  elsif min > 0
    return "~#{min} minutes"
  else
    return "~#{sec} seconds"
  end
end

# Given entropy of password, returns expected time to crack the password for:
# * online attack - attacker guesses online, number of guesses not limited
# * offline - attacker has reasonable amount of money to buy large cluster to
#       crack the password.
# * offline NSA - attacker has no financial or technological restrictions
def speed_of_cracking(entropy)
  speed_seconds = {}

  # 10 000 guesses per second (cause network is fast nowadays)
  speed_seconds[:online] = (2**entropy) / 10_000

  # 350 000 000 000 per second (based on
  #  http://arstechnica.com/security/2012/12/25-gpu-cluster-cracks-every-
  #  standard-windows-password-in-6-hours/ )
  speed_seconds[:offline] = (2**entropy) / 350_000_000_000

  # 100 000 000 000 000 000 per second (current Bitcoin hash rate).
  # Does NSA have power comparable with whole bitcoin network ? Maybe once it
  # will, so let`s be on the safe side.
  speed_seconds[:offline_nsa] = (2**entropy) / 100_000_000_000_000_000

  speed_seconds.values.map { |t| seconds_to_human(t) }
end

# Returns random easy to remember password along with estimated entropy.
# Most probably imprecise.
#
# Strength parameter should be one of: :weak, :medium, :strong
def password(wordlist, strength, camelcase = false)
  repetitions = MIN_ENTROPY[strength].fdiv(entropy(wordlist)).ceil
  password_parts = []

  repetitions.times do
    password_parts << random_word(wordlist)
  end

  if camelcase
    password = password_parts.map(&:capitalize).join
  else
    password = password_parts.join('-')
  end

  entropy = entropy(wordlist) * repetitions
  [password, entropy.floor]
end

def formatted_output(wordlist, options)
  output = "\n"
  output_ary = [['Entropy', 'Online', 'Offline', 'Offline NSA', 'Password']]

  # One password of each strength
  STRENGTH.each do |strength|
    password, entropy = password(wordlist, strength, options[:camelcase])

    # contruct array line containing entropy, times to crack and password
    line = [entropy]
    line.concat speed_of_cracking(entropy)
    line << password
    output_ary << line
  end

  # comput column sizes - maximum size of words in each column
  cs = output_ary.transpose.map { |c| c.group_by(&:size).max.first }
  line_len = cs.reduce(&:+) + 8

  fmtstr = "%-#{cs[0]}s %-#{cs[1]}s  %-#{cs[2]}s  %-#{cs[3]}s   %-#{cs[4]}s\n"

  # Header with separator
  output << format(fmtstr, *output_ary[0])
  output << '-' * line_len + "\n"

  # lines with passwords
  output_ary[1..-1].each do |line|
    output << format(fmtstr, *line)
  end

  output
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: correct-horse [options] wordlist'

  opts.on('-c', '--camelcase', 'Separate words using CamelCase') do
    options[:camelcase] = true
  end
end.parse!

fail 'Password list file as argument. Consider using /usr/share/dict/words.' \
  unless ARGV[0] && File.exist?(ARGV[0])

# words longer than 12 chars are probably too tedious to type, so dump those
wordlist = read_wordlist(ARGV[0])

puts formatted_output(wordlist, options)
