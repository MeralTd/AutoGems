require 'auto_record_system'
require 'yaml'


class AutoList
  attr_reader :items

  def initialize
    load
  end

  def add_item(name, model, plate, city)
    @items << Item.new(name, model, plate, city)
    save
    @items.last
  end

  def search(plate)
    plates = YAML.load(File.read('auto.yml'))
    city_plate = plates.select{ |p| p.plate == plate}
    if city_plate.any?
      puts city_plate.inspect
    else
      puts "#{plate} plate is not available in the vehicle system."
    end
  end

  def plate_number(plate)
    if File.exist?('auto.yml') && YAML.load(File.read('auto.yml'))
      plates = YAML.load(File.read('auto.yml'))
      city_plate = plates.select{ |p| p.plate == plate}
      if city_plate.any?
        puts "There is this plate car."
        exit false
      end
    end    
  end

  private

  def save
    File.open("auto.yml", "w") { |file| file.write(@items.to_yaml) }
  end

  def load
    if File.exist?('auto.yml') && YAML.load(File.read('auto.yml'))
      @items = YAML.load(File.read('auto.yml'))
    else
      @items = Array.new
    end

    @items
  end
end

class Item
  attr_accessor :name, :model, :plate, :city

  def initialize(name, model, plate, city)
    @name = name
    @model = model
    @plate = plate
    @city = city
  end
end

auto_list = AutoList.new
command = ARGV[0]

if command == '-s'
  item = auto_list.search(ARGV[1])
else
  puts 'Name: '
  name = gets.chomp

  puts 'Model: '
  model = gets.chomp
  AutoRecordSystem::Model.model_name(model)

  puts 'Plate:'
  plate = gets.chomp
  auto_list.plate_number(plate)
  plt = plate.split(" ")[0]
  AutoRecordSystem::Plate.plate_num(plt)

  citys = AutoRecordSystem::Plate.plate_num(plt)
  city_name = citys

  auto_list.add_item(name, model, plate, city_name)
end