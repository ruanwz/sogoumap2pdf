require 'rubygems'
require 'pdf/writer'
require 'net/http'
require 'uri'
require 'RMagick'
include Magick

module Sogoumap2pdf
  class ImageToPdf
    def initialize(link_end,page_width,page_height)
      #@page_width=600
      @page_width=page_width.to_i
      #@page_width=800
      #@page_height=768
      @page_height=page_height.to_i
      #@page_height=480
      @page_overlap=50
      @text_height=15
      @pdf=PDF::Writer.new(:paper=>[0,0,@page_width,@page_height])
      @pdf.margins_pt(0,0,0,0)
      # initialize icons
      @icon_size=20
      @link_end=link_end
    end
    def big_img_crop(x,y,w,h)
      g=@g
      nx0=x/256
      ny0=y/256
      nxn=(x+w)/256+1
      nyn=(y+h)/256+1
      delta_x=x-nx0*256
      delta_y=y-ny0*256
      # p "x #{x}"
      # p "y #{y}"
      # p "delta_x #{delta_x}"
      # p "delta_y #{delta_y}"
      ci=ImageList.new # image list to hold results
      page=Rectangle.new( 0, 0, 0, 0)
  
      for i in nx0..nxn
        for j in ny0..nyn
          #p "big_img_crop #{i},#{j}"
          picture_file_name="~/.sogoumap/0/"+ [g.resource_type,g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+g.link_end
          picture_file_name=File.expand_path(picture_file_name)
          if File.exist?(picture_file_name) && File.size(picture_file_name)!= 0 then
            tumb=ImageList.new.read(picture_file_name)[0] # image list to hold results
            path_file_name="~/.sogoumap/0/"+ ["179",g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+".PNG"
            path_file_name=File.expand_path(path_file_name)
  
            if g.satellite_path && File.exist?(path_file_name) && File.size(path_file_name)!=0 then
  
              path_tumb=ImageList.new.read(path_file_name)[0] # image list to hold results
              tumb.composite!(path_tumb, 0, 0, OverCompositeOp)
            end
  
            #append tumb
            ci << tumb
            #update page
            page.x=(i-nx0)*256
            page.y=(nyn-j)*256
            ci.page=page
          else
          end
        end
      end
      if ci.length==0 then
        resimg=ImageList.new.read("NULL:white") { self.size = "#{g.npx*@tumb_x}x#{g.npy*@tumb_y}"}
      else
        resimg=ci.mosaic
      end
      return resimg.crop(SouthWestGravity,delta_x,delta_y,w,h,true)
    end
  
    def perfect_fit(w,h,r,c)
      @page_width=w
      @page_height=h
      @row=r
      @column=c
      @tumb_x=@page_width*256/(c*@page_width-(c-1)*@page_overlap)
      @tumb_y=@page_height*256/(r*@page_height-(r-1)*@page_overlap)
      @big_img_width,@big_img_height=c*@page_width-(c-1)*@page_overlap, r*@page_height-(r-1)*@page_overlap
      return c*@page_width-(c-1)*@page_overlap, r*@page_height-(r-1)*@page_overlap
    end
    def create_pages(g)
      # get the size of the image
      size_x=@big_img_width
      size_y=@big_img_height
  
      # calculate the number of requred rows and columns
      cols=(size_x-@page_overlap)/(@page_width-@page_overlap)
      rows=(size_y-@page_overlap)/(@page_height-@page_overlap)
      # create pdf
      for i in 0...rows
        for j in 0...cols
          p "creating page #{i} #{j}"
          p Time.now
          @pdf.new_page
          @pdf.add_destination("map part #{i},#{j}", "Fit")
          pgimg=big_img_crop(j*(@page_width-@page_overlap),
                               (rows-1-i)*(@page_height-@page_overlap),@page_width,@page_height)
  
          # pgimg=big_image.crop(j*(@page_width-@page_overlap),
          #                      i*(@page_height-@page_overlap),@page_width,@page_height,true)
          pgimg.write("itptmp#{@link_end}") { self.quality = 100 }
          @pdf.add_image_from_file("itptmp#{@link_end}",0,0)
          ss = PDF::Writer::StrokeStyle.new(4,:cap=>:round)
          @pdf.stroke_style ss
          if j>0 then
            @pdf.add_internal_link("map part #{i},#{j-1}",0,@page_height/2,
                                   @icon_size,@page_height/2+@icon_size)
            @pdf.line(@icon_size,@page_height/2,0,@page_height/2+@icon_size/2).stroke
            @pdf.line(0,@page_height/2+@icon_size/2,@icon_size,@page_height/2+@icon_size).stroke
          end
          if j<cols-1 then
            @pdf.add_internal_link("map part #{i},#{j+1}",
                                   @page_width-@icon_size,@page_height/2,
                                   @page_width,@page_height/2+@icon_size)
            @pdf.line(@page_width-@icon_size,@page_height/2,
                      @page_width,@page_height/2+@icon_size/2).stroke
            @pdf.line(@page_width,@page_height/2+@icon_size/2,
                      @page_width-@icon_size,@page_height/2+@icon_size).stroke
          end
          if i>0 then
            @pdf.add_internal_link("map part #{i-1},#{j}",@page_width/2,@page_height,
                                   @page_width/2+@icon_size,@page_height-@icon_size)
            @pdf.line(@page_width/2,@page_height-@icon_size,
                      @page_width/2+@icon_size/2,@page_height).stroke
            @pdf.line(@page_width/2+@icon_size/2,@page_height,
                      @page_width/2+@icon_size,@page_height-@icon_size).stroke
          end
          if i<rows-1 then
            @pdf.add_internal_link("map part #{i+1},#{j}",@page_width/2,0,
                                    @page_width/2+@icon_size,@icon_size)
            @pdf.line(@page_width/2,@icon_size,
                      @page_width/2+@icon_size/2,0).stroke
            @pdf.line(@page_width/2+@icon_size/2,0,
                      @page_width/2+@icon_size,@icon_size).stroke
          end
  #        @pdf.restore_state          
        end
      end
    end
    def front_page(g)
      size_x=@big_img_width
      size_y=@big_img_height
      # calculate the number of requred rows and columns
      cols=(size_x-@page_overlap)/(@page_width-@page_overlap)
      rows=(size_y-@page_overlap)/(@page_height-@page_overlap)
  
      ci=ImageList.new # image list to hold results
      page=Rectangle.new( 0, 0, 0, 0)
      @g=g
      for i in 0... g.npx
        p "resizing #{i} j"
        for j in 0...g.npy
          picture_file_name="~/.sogoumap/0/"+ [g.resource_type,g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+g.link_end
          picture_file_name=File.expand_path(picture_file_name)
          if File.exist?(picture_file_name) && File.size(picture_file_name)!= 0 then
            tumb=ImageList.new.read(picture_file_name)[0] # image list to hold results
  
            path_file_name="~/.sogoumap/0/"+ ["179",g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+".PNG"
            path_file_name=File.expand_path(path_file_name)
            if g.satellite_path && File.exist?(path_file_name) && File.size(path_file_name)!=0 then
              path_tumb=ImageList.new.read(path_file_name)[0] # image list to hold results
              tumb.composite!(path_tumb, 0, 0, OverCompositeOp)
            end
            #resize each to tumb
            tumb.resize!(@tumb_x,@tumb_y)
            #append tumb
            ci << tumb
            #update page
            page.x=i*@tumb_x
            page.y=(g.npy-1-j)*@tumb_y
            ci.page=page
          else
          end
        end
      end
      #mosaic
      if ci.length==0 then
        p "@tumb_x,@tumb_y"
        p @tumb_x
        p @tumb_y
        p "g.npx,g.npy"
        p g.npx
        p g.npy
        p "#{g.npx*@tumb_x}x#{g.npy*@tumb_y}"
        ## can't work
        resimg=ImageList.new.read("null:white") { self.size = "#{g.npx.to_i*@tumb_x.to_i}x#{g.npy.to_i*@tumb_y.to_i}"}
      else
        resimg=ci.mosaic
      end
      #crop
      #map2pdf.rb:339:in `crop!': bignum too big to convert into `long' (RangeError)
      resx=@tumb_x*g.npx
      resy=@tumb_y*g.npy

      p "front_page size"
      p resx
      p resy
      resx=@page_width if resx>@page_width
      resy=@page_height if resy>@page_height
      resimg.crop!(SouthWestGravity,resx,resy)
      resimg.write("itptmp#{@link_end}"){ self.quality = 100 }
      @pdf.add_image_from_file("itptmp#{@link_end}",0,0)
      ss = PDF::Writer::StrokeStyle.new(2)
      @pdf.stroke_style ss
      for i in 1...cols
        @pdf.line(i*@page_width/cols,0,
                  i*@page_width/cols,@page_height).stroke
      end
      for i in 1...rows
        @pdf.line(0,i*@page_height/rows,
                  @page_width,i*@page_height/rows).stroke
      end
      for i in 0...rows
        for j in 0...cols
         p "adding #{i} #{j} link in front page"
         p Time.now
         @pdf.add_internal_link("map part #{i},#{j}",
                                j*@page_width/cols, @page_height-i*@page_height/rows,
                                (j+1)*@page_width/cols, @page_height-(i+1)*@page_height/rows)
       end
      end
    end
    def front_page_only(g)
      size_x=@big_img_width
      size_y=@big_img_height
      # calculate the number of requred rows and columns
      cols=(size_x-@page_overlap)/(@page_width-@page_overlap)
      rows=(size_y-@page_overlap)/(@page_height-@page_overlap)
  
      ci=ImageList.new # image list to hold results
      page=Rectangle.new( 0, 0, 0, 0)
      @g=g
      for i in 0... g.npx
        p "resizing #{i} j"
        for j in 0...g.npy
          picture_file_name="~/.sogoumap/0/"+ [g.resource_type,g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+g.link_end
          picture_file_name=File.expand_path(picture_file_name)
          if File.exist?(picture_file_name) && File.size(picture_file_name)!= 0 then
            tumb=ImageList.new.read(picture_file_name)[0] # image list to hold results
  
            path_file_name="~/.sogoumap/0/"+ ["179",g.resource_level,((g.start_link_x+i)/200).to_s,((g.start_link_y+j)/200).to_s].join("/")+"/"+(g.start_link_x+i).to_s+"_"+(g.start_link_y+j).to_s+".PNG"
            path_file_name=File.expand_path(path_file_name)
            if g.satellite_path && File.exist?(path_file_name) && File.size(path_file_name)!=0 then
              path_tumb=ImageList.new.read(path_file_name)[0] # image list to hold results
              tumb.composite!(path_tumb, 0, 0, OverCompositeOp)
            end
            #resize each to tumb
            tumb.resize!(@tumb_x,@tumb_y)
            #append tumb
            ci << tumb
            #update page
            page.x=i*@tumb_x
            page.y=(g.npy-1-j)*@tumb_y
            ci.page=page
          else
          end
        end
      end
      #mosaic
      if ci.length==0 then
        p "@tumb_x,@tumb_y"
        p @tumb_x
        p @tumb_y
        p "g.npx,g.npy"
        p g.npx
        p g.npy
        p "#{g.npx*@tumb_x}x#{g.npy*@tumb_y}"
        ## can't work
        resimg=ImageList.new.read("null:white") { self.size = "#{g.npx.to_i*@tumb_x.to_i}x#{g.npy.to_i*@tumb_y.to_i}"}
      else
        resimg=ci.mosaic
      end
      #crop
      #map2pdf.rb:339:in `crop!': bignum too big to convert into `long' (RangeError)
      resx=@tumb_x*g.npx
      resy=@tumb_y*g.npy
      p "front_page size"
      p resx
      p resy
      resx=@page_width if resx>@page_width
      resy=@page_height if resy>@page_height
      resimg.crop!(SouthWestGravity,resx,resy)
      resimg.write("itptmp#{@link_end}"){ self.quality = 100 }
      @pdf.add_image_from_file("itptmp#{@link_end}",0,0)
      ss = PDF::Writer::StrokeStyle.new(2)
      @pdf.stroke_style ss
      for i in 1...cols
        @pdf.line(i*@page_width/cols,0,
                  i*@page_width/cols,@page_height).stroke
      end
      for i in 1...rows
        @pdf.line(0,i*@page_height/rows,
                  @page_width,i*@page_height/rows).stroke
      end
      # for i in 0...rows
      #   for j in 0...cols
      #    p "adding #{i} #{j} link in front page"
      #    p Time.now
      #    @pdf.add_internal_link("map part #{i},#{j}",
      #                           j*@page_width/cols, @page_height-i*@page_height/rows,
      #                           (j+1)*@page_width/cols, @page_height-(i+1)*@page_height/rows)
      #   end
      # end
    end

    def save(save_file)
      @pdf.save_as(save_file)
    end
  end
end
