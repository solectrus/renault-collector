require 'ruze'
require_relative 'flux_writer'

class RenaultLoop
  include FluxWriter

  def self.start
    new.start
  end

  def start
    puts "Starting Renault collector...\n\n"

    loop do
      push_to_influx(car_data)

      puts "Sleeping #{interval} seconds ..."
      sleep interval
    end
  end

  private

  attr_accessor :count

  def car_data
    self.count ||= 0
    self.count += 1

    puts "\n-------------------------------------------------------\n"
    print "##{count}: Getting data from Renault ..."
    car_data = Ruze::Car.new(email, password)
    puts "\n"
    puts "  battery level: #{car_data.battery['batteryLevel']} %"
    puts "  mileage: #{car_data.cockpit['totalMileage']} km"
    puts "\n"

    car_data
  end

  def push_to_influx(car_data)
    point = InfluxDB2::Point.new(name: influx_measurement)
              .add_field('battery_level', car_data.battery['batteryLevel'])
              .add_field('mileage',       car_data.cockpit['totalMileage'])
              .add_tag('model', model)

    print 'Pushing Renault data to InfluxDB ... '
    write_api.write(data: point, bucket: influx_bucket, org: influx_org)
    puts 'OK'
  end

  def influx_measurement
    'Car'
  end

  def interval
    @interval ||= ENV.fetch('RENAULT_INTERVAL', 7200).to_i
  end

  def email
    @email ||= ENV.fetch('RENAULT_EMAIL')
  end

  def password
    @password ||= ENV.fetch('RENAULT_PASSWORD')
  end

  def model
    @model ||= ENV.fetch('RENAULT_MODEL')
  end
end
