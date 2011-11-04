class Zipcode 
  include Mongoid::Document
  include ApplicationHelper
  
  field :name, type: String, unique: true  
  field :state
  field :city
  field :county
    
  field :polygon, type: String  
  field :coordinate, type: String
  field :location, type: Array, default: []
  index [[ :location, Mongo::GEO2D ]] 
  index :name
    
  before_save :generate_x_y  
  def self.find_by_location ( ipt )
    
    ips =  ApplicationHelper::geo_string_to_x_y(ipt)
    
    p = ipt.split(/,/)    
    query = Zipcode.near(location:  [ p[0].to_f, p[1].to_f ]).limit(32)
    
    query.each do | zip |
      
      if ( zip.inside?(ipt)) 
        return zip
      end

    end      
    nil
  end
  
  def inside? ( ipt )
     
    ips =  ApplicationHelper::geo_string_to_x_y(ipt)
    tx = ips[0]
    ty = ips[1]
    
    j = 0
    c = false
    
    zpoints =  self.polygon.split(/\s/)
        
    j = zpoints.length-1  
    for i in (0..zpoints.length-1)
      
      ipt = ApplicationHelper::geo_string_to_x_y(zpoints[i])
      ix =  ipt[0]
      iy =  ipt[1]
      
      jpt = ApplicationHelper::geo_string_to_x_y(zpoints[j])
      jx =  jpt[0]
      jy =  jpt[1]
      
      if (   (  ( iy > ty ) != ( jy > ty ) ) &&
             (  tx < ( jx - ix ) * (ty - iy ) / ( jy - iy ) + ix ) )
            c = !c
      end
      
      j = i
          
    end
    
    c  
  end
      
  private 
    def generate_x_y
    
      # save coordinate into location index
      p = self.coordinate.split(/,/)
      self.location = [ p[0].to_f, p[1].to_f ]
    end 
  
end
  
 
class MyDocument < Nokogiri::XML::SAX::Document
  
  def start_document
     @depth = 0
     @save_count = 0
     @fcount = 0
      @in_zip = false
     puts "the document has started"
   end
  
  def end_document
    puts "the document has ended"
  end

    #<Folder>
    #<name>AK</name>
    #<Folder>
    #<name>Aleutians East County</name>
    #<Folder>
    #<name>Akutan</name>
    #<Placemark>

  def start_element name, attributes = []
    @depth = @depth + 1

    #puts "#{@depth} #{name} started"
    if ( name == "Folder" )
        @fcount = @fcount + 1
    end
    if ( name == "Placemark") 
      @in_zip = true
      @cord = ""
    end
        
    if ( @in_zip == false ) 
        if ( name == "name" && @fcount == 1 ) 
            puts "in State"
            @in_statename = true
        end
        if ( name == "name" && @fcount == 2 ) 
            @in_countyname = true
        end
        if ( name == "name" && @fcount == 3 ) 
            @in_cityname = true
        end

    end

            
        
    if ( @in_zip == true && name == "name") 
      @in_zipname = true
    end
    if  @in_zip == true && name == "Point"
      @in_zippoint = true
    end
    if  @in_zippoint == true && name == "coordinates"
      @in_zippointcoord = true
    end
    if  @in_zip == true && name == "outerBoundaryIs"
      @in_zipboundary = true
    end
    if  @in_zipboundary == true && name == "coordinates"
       @in_zipboundarycoord = true
    end
    
  end
  
  def end_element name
      #puts "#{@depth} #{name} ended"
      if ( name == "Folder" )
          @fcount = @fcount - 1
      end

      @depth -= 1
      if ( @in_zip == true && name == "Placemark")
        @in_zip = false
        save_zip
      end
      if ( @in_statename == true && name == "name")
        @in_statename = false
      end
      if ( @in_cityname == true && name == "name")
          @in_cityname = false
      end
      if ( @in_countyname == true && name == "name")
          @in_countyname = false
      end

      if ( @in_zipname == true && name == "name")
        @in_zipname = false
      end
      if  @in_zippoint == true && name == "Point"
        @in_zippoint = false
      end
      if  @in_zippointcoord == true && name == "coordinates"
         @in_zippointcoord = false
       end
       if  @in_zipboundary == true && name == "outerBoundaryIs"
         @in_zipboundary = false
       end
       if  @in_zipboundarycoord == true && name == "coordinates"
         @in_zipboundarycoord = false
       end
      
  end
  
  def characters str
    if ( @in_statename == true )
          @state_name = str
          puts "State = #{str}"
    end
      if ( @in_cityname == true )
          @city_name = str
          #puts "City = #{str}"
      end
      if ( @in_countyname == true )
          @county_name = str
          #puts "County = #{str}"
      end

    if ( @in_zipname == true )
      @zip_name = str
     #puts "zipcode = #{str}"
   end
   if ( @in_zippointcoord == true )
     @zip_point = str
     #puts "zip point = #{str}"
   end
   if ( @in_zipboundarycoord == true )
     #puts "zip boundary = #{str}"
     @cord  += str
   end
   
   def save_zip
     if ( !@cord.empty? )
       zc = Zipcode.new
       zc.name = @zip_name
       zc.state = @state_name
       zc.city = @city_name
       zc.county = @county_name
       p = @zip_point.split(/,/)
       zc.coordinate = p[1].to_s + ',' + p[0].to_s
       cc  = ""
       # reverse lon,lat to lat,lon
       zpoints =  @cord.split(/\s/)
       zpoints.each do | zp | 
         p = zp.split(/,/)
         cc += p[1].to_s + ',' + p[0].to_s + ' '
       end
      
       zc.polygon = cc
       zc.save
         #puts "#{@save_count}"
       @save_count += 1
     end
     
   end
   
        
  end
  
end

