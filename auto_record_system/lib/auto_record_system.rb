require "auto_record_system/version"
require 'json'

module AutoRecordSystem
  class Plate
    attr_accessor :city_name
    def self.plate_num(plate)
      plates = JSON.parse(File.read('../auto_record_system/lib/cities.json'))
      auto_plate = plates.select{ |p| p == plate}
      if auto_plate.any?
        city_name = auto_plate.first[1]
      else
        puts 'The plate format is not suitable. (Enter between 01-81)'
        exit false 
      end
    end
  end

  class Model
    attr_accessor :mname
    def self.model_name(model)
      models = JSON.parse(File.read('../auto_record_system/lib/models.json'))
      auto_plate = models.select{ |p| p['name'] == model}
      if auto_plate.any?
        mname = auto_plate
      else
        puts 'Vehicle model not available.'
        exit false 
      end
    end
  end
end
