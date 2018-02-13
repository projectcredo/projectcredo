class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.queued_for_write[:original]

    dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
    width = options[:width]
    height = options[:height]

    puts attribute, dimensions, width, height

    if width and dimensions.width < width then
      record.errors[attribute] << "dimensions are too small. For a good quality #{attribute} upload a larger image. Minimum width: #{width}px."
    end

    if height and dimensions.height < height then
      record.errors[attribute] << "dimensions are too small. For a good quality #{attribute} upload a larger image. Minimum height: #{height}px."
    end
  end
end
