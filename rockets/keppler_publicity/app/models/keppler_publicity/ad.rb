# frozen_string_literal: true

module KepplerPublicity
  # Ad Model
  class Ad < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
    include Searchable
    mount_uploader :image, AttachmentUploader
    acts_as_list
    acts_as_paranoid
    validate  :check_dimensions, :on => [:create, :update]
    validate  :validate_url
    validates_presence_of :image, :type_ad, :location, :url

    def validate_url
      url = URI.parse(self.url)
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = true
        if !url.host.nil?
          res = req.request_head('/')
          if !res.code.eql?('200')
            errors.add(:url, "La URL introducida no es válida")
          end
        else
          errors.add(:url, "La URL introducida no es válida")
        end
    end

    def self.have_actives(ad)
      where(
        type_ad: ad.type_ad, 
        location: ad.location, 
        active: true
      )
    end

    def self.update_active(ad)
      actives = have_actives(ad)
      return if actives.blank?

      actives.update(active: false)
    end

    def check_dimensions_type(width, height)
      if (image.width < width) || ( image.height < height)
          errors.add :image, "Dimensión incorrecta <br/> El tamaño de la imágen cargada es de: #{image.width}x#{image.height}px y no cumple con las dimensiones recomendadas: #{width}x#{height}".html_safe
      end
    end

    def check_dimensions
      return if image_cache.nil?
      if type_ad.eql?('banner')
        check_dimensions_type(1080, 700)
      elsif type_ad.eql?('half-banner')
        check_dimensions_type(900, 550)
      elsif type_ad.eql?('steal-page')
        check_dimensions_type(300, 550)
      end
    end

    def self.index_attributes
      %i[image type_ad location]
    end
  end
end
