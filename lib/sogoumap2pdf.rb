$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

dir = File.dirname(__FILE__)
SOGOUMAP2PDF_ROOT = File.join(dir, 'sogoumap2pdf')
require File.join(SOGOUMAP2PDF_ROOT, "version")
require File.join(SOGOUMAP2PDF_ROOT, "sogou_map_image")
require File.join(SOGOUMAP2PDF_ROOT, "image_to_pdf")

module Sogoumap2pdf
  
end
