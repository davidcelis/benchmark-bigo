#!/usr/bin/env ruby

require 'benchmark/bigo'

report = Benchmark.bigo do |x|

  # increments is the total number of data points to collect
  x.config increments: 4

  # generator should construct a test object of the given size
  # example of an Array generator
  x.generator {|size| (0...size).to_a.shuffle }

  # specifies how the size of the object should grow
  #   options: linear, logarithmic
  x.logarithmic

  # report takes a label and a block.
  # block is passed in the generated object and the size of that object
  x.report("#<<") {|generated, size| generated.dup << rand(size) }
  x.report("#add") {|generated, size| g = generated.dup; g += [rand(size)] }
  x.report("#zip") {|generated, size| generated.zip(generated)}
  x.report("#zip-flatten") {|generated, size| generated.zip(generated).flatten  }

  # save results in JSON format
  x.data! 'chart_array_complex.json'

  # generate HTML chart using ChartKick
  x.chart! 'chart_array_complex.html'

  # for each report, create a comparison chart showing the report
  # and scaled series for O(log n), O(n), O(n log n), and O(n squared)
  x.compare!

end
