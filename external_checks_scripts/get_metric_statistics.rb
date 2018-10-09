#! /usr/bin/env ruby

require 'aws-sdk'

if ARGV.size < 6
  puts "Usage: #{$PROGRAM_NAME} [REGION] [NAMESPACE] [METRIC_NAME] [DIMENTION_NAME] [DIMENTION_VALUE] [STATISTICS_TYPE](Average) [DIFFERENCE_TIME(sec)](600) [PERIOD(sec)](300)"
  exit 1
end

region = ARGV[0]
namespace = ARGV[1]
metric_name = ARGV[2]
dime_name = ARGV[3]
dime_value = ARGV[4]
statistics_type = ARGV[5] || 'Average'
diff_time = ARGV[6] || '600'
period = ARGV[7] || '300'

cs = Aws::CloudWatch::Client.new(region: region)

cw.put_metric_data({
  namespace: namespace,
  metric_data: [{
    metric_name: metric_name,
    dimensions: [
      {
        name: dime_name,
	value: dime_value
      }
    ]
  }]
})

stats = metrics.get_statistics({
  start_time: Time.now - diff_time.to_i,
  end_time: Time.now,
  statistics: [statistics_type],
  period: period.to_i
})

last_stats = stats.datapoints.sort_by { |stat| stat[:timestamp] }.last
if last_stats.nil?
  puts 0
else
  puts last_stats[statistics_type.downcase.to_sym]
end
