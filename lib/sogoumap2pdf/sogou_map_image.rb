#!/usr/bin/ruby
require 'rubygems'
require 'pdf/writer'
require 'net/http'
require 'uri'
require 'RMagick'
include Magick

# provides an access to sogou map 
# emulates it as an image
#
# must be initialised by a link to an image from map.sogou.com
# 
# command syntax:
# guangzhou: sogoumap2pdf http://hbpic3.go2map.com/seamless/0/180/792/504/105/100899_21033.JPG 1024x768 3x3 guangzhou.pdf sp
module Sogoumap2pdf
  class SogouMapImage
    attr_reader   :link_end, :satellite_path, :start_link_x, :start_link_y, :picture_directory_name, :path_directory_name, :npx, :npy, :area_width, :area_height,:resource_type,:resource_level,:resource_extension
    def initialize(sogou_link,option)
      @link_beginning, @link_end = sogou_link.split(/\d+_\d+/)
      @sogou_link=sogou_link
      resource_head,resource_parameters= sogou_link.split(/\/0\//)
      @resource_head = resource_head+"/0/"
      @resource_type,@resource_level,@resource_x200,@resource_y200,@resource_x,@resource_y,@resource_extension=resource_parameters.split(/\/|_|\./)
      @link_x=@resource_x.to_i
      @link_y=@resource_y.to_i
  
      @satellite_only=true if option=="s"
      @satellite_path=true if option=="sp"
      @map=true if option=="m"
      @patch_size_x=256
      @patch_size_y=256
      #for sogou map
      #@link_beginning="http://hbpic2.go2map.com/seamless/0/180/792/504/105/"
      #@link_end=".JPG"
      #@link_x=100960
      #@link_y=21035
    end
    # get a patch of map from google maps
    # the initial link is the patch 0,0
    def get_or_read_picture(link_name,dir_name,file_name)
      file_name=File.expand_path(file_name)
      if File.exist? file_name then
        #if File.size(file_name) !=0 then
        #  picture_block=File.read file_name
        #else
        #  picture_block = File.read("empty.jpg") if link_name =~ /(JPG|GIF)$/
        #  picture_block = File.read("empty.png") if link_name =~ /PNG$/
        #end
      else
        picture_data=Net::HTTP.get_response(URI.parse(link_name))
        p picture_data.code
        if picture_data.code == "200" then
          picture_block = picture_data.body
          unless File.exist? dir_name then
            #Dir.mkdir dir_name
            `mkdir -p #{dir_name}`
          end
          tmp_file=File.new(file_name,"w")
                tmp_file.binmode
          tmp_file.write(picture_data.body)
          tmp_file.close
        else
          unless File.exist? dir_name then
            #Dir.mkdir dir_name
            `mkdir -p #{dir_name}`
          end
          `touch #{file_name}`
          #temp_blob = ImageList.new.read("NULL:white") { self.size = "256x256"}
          #picture_block = temp_blob.to_blob
          #picture_block = File.read("empty.jpg") if link_name =~ /(JPG|GIF)$/
          #picture_block = File.read("empty.png") if link_name =~ /PNG$/
        end
      end
      return picture_block
    end
    def only_save_image(x,y)
      http_get_picture = false
      http_get_path = false
      @resource_x200=((@link_x+x)/200).to_s
      @resource_y200=((@link_y+y)/200).to_s
      picture_link=@resource_head+[@resource_type,@resource_level,@resource_x200,@resource_y200].join("/")+"/"+(@link_x+x).to_s+"_"+(@link_y+y).to_s+"."+@resource_extension
      p "getting #{x-@spx}/#{@npx-1}, #{y-@spy}/#{@npy-1} #{picture_link}"
      picture_directory_name = "~/.sogoumap/0/"+ [@resource_type,@resource_level,@resource_x200,@resource_y200].join("/") 
      picture_file_name = picture_directory_name +"/"+ (@link_x+x).to_s+"_"+(@link_y+y).to_s+"."+@resource_extension 
      get_or_read_picture(picture_link,picture_directory_name,picture_file_name)
      if @satellite_path then
        path_link=@resource_head+["179",@resource_level,@resource_x200,@resource_y200].join("/")+"/"+(@link_x+x).to_s+"_"+(@link_y+y).to_s+"."+"PNG"
        p "getting #{x-@spx}/#{@npx-1}, #{y-@spy}/#{@npy-1} #{path_link}"
        path_data=Net::HTTP.get_response(URI.parse(path_link))
        path_directory_name = "~/.sogoumap/0/"+ ["179",@resource_level,@resource_x200,@resource_y200].join("/") 
        path_file_name = path_directory_name + "/" +(@link_x+x).to_s+"_"+(@link_y+y).to_s+".PNG" 
        get_or_read_picture(path_link,path_directory_name, path_file_name)
      end
    end
    # creates map of given size (in pixels), returns Image object
    def fill_map(rx,ry)
      @npx=npx=rx/@patch_size_x+1
      @npy=npy=ry/@patch_size_y+1
      @spacex=spacex=npx*@patch_size_x-rx
      @spacey=spacey=npy*@patch_size_y-ry
      # starting patch
      @spx=spx=-(npx/2)
      @spy=spy=-(npy/2)
      @start_link_x=spx+@link_x
      @start_link_y=spy+@link_y
      @area_height=npy*@patch_size_y
      @area_width=npx*@patch_size_x
      # end patch
      # epx=npx+spx-1
      # epy=npy+spy-1
      # for i in 0...npx
      #   for j in 0...npy
      #     self.only_save_image(i+spx,j+spy)
      #   end
      # end
    end
    def fill_map2
      for i in 0...@npx
        for j in 0...@npy
          self.only_save_image(i+@spx,j+@spy)
        end
      end
    end

  end
end
