module ApplicationHelper
    def photo_uploadify
        # Putting the uploadify trigger script in the helper gives us
        # full access to the view and native rails objects without having
        # to set javascript variables.
        #
        # Uploadify is only a queue manager to hand carrierwave the files
        # one at a time. Carrierwave handles capturing, resizing and saving
        # all uploads. All limits set here (file types, size limit) are to
        # help the user pick the right files. Carrierwave is responsible
        # for enforcing the limits (white list file name, setting maximum file sizes)
        #
        # ScriptData:
        #   Sets the http headers to accept javascript plus adds
        #   the session key and authenticity token for XSS protection.
        #   The "FlashSessionCookieMiddleware" rack module deconstructs these 
        #   parameters into something Rails will actually use.
        
        session_key_name = Rails.application.config.session_options[:key]
        %Q{
            
            <script type='text/javascript'>
            $(document).ready(function() {
                              $('#photo_upload').uploadify({
                                                           script          : '#{store_item_photos_path(@item.store, @item)}',
                                                           fileDataName    : 'photo[image]',
                                                           uploader        : '/uploadify/uploadify.swf',
                                                           cancelImg       : '/uploadify/cancel.png',
                                                           fileDesc        : 'Images',
                                                           fileExt         : '*.png;*.jpg;*.gif',
                                                           sizeLimit       : #{10.megabytes},
                                                           queueSizeLimit  : 24,
                                                           multi           : true,
                                                           auto            : true,
                                                           buttonText      : 'ADD IMAGES',
                                                           scriptData      : {
                                                           '_http_accept': 'application/javascript',
                                                           '#{session_key_name}' : encodeURIComponent('#{u(cookies[session_key_name])}'),
                                                           'authenticity_token'  : encodeURIComponent('#{u(form_authenticity_token)}')
                                                           },
                                                           onComplete      : function(a, b, c, response){ eval(response) }
                                                           });
                              });
            </script>
            
        }.gsub(/[\n ]+/, ' ').strip.html_safe
    end
    
    def photo_sortable
        %Q{
            <script type="text/javascript">
            $(document).ready(function() {
                              $('#sortable').sortable( {
                                                      dropOnEmpty: false,
                                                      cursor: 'crosshair',
                                                      opacity: 0.75,
                                                      scroll: true,
                                                      update: function() {
                                                      $.ajax( {
                                                             type: 'post',
                                                             data: $('#sortable').sortable('serialize') + '&authenticity_token=#{u(form_authenticity_token)}',
                                                             dataType: 'script',
                                                             url: '#{sort_store_item_photos_path(@item.store, @item)}'})
                                                      }
                                                      });
                              });
            </script>
        }.gsub(/[\n ]+/, ' ').strip.html_safe
    end
    
    MAP_SIZE_IN_MAP_COORDINATES = 2147483648
    MAXIMUM_LATITUDE= 8505112;
    MINIMUM_LATITUDE = -8505112;
    MINIMUM_LONGITUDE = -18000000;
    MAXIMUM_LONGITUDE = 18000000;
    
    def geo_string_to_x_y ( pt )
    
    ps =  pt.split(/,/)
    lon = ps[0].to_f
    lat = ps[1].to_f
    
    clat = [lat,MINIMUM_LATITUDE].max
    clat = [clat, MAXIMUM_LATITUDE].min
    
    clon = [lon,MINIMUM_LONGITUDE].max
    clon = [clon, MAXIMUM_LONGITUDE].min
    
    realLatitude = clat 
    realLongitude = clon
    
    rx = ( realLongitude + 180.0 ) / 360.0
    sinLatitude = Math.sin (  ( realLatitude * Math::PI ) / 180.0 )
    subexpression =  (1.0 +  sinLatitude ) / (1.0 - sinLatitude)
    
    ry =  0.5 - ( Math.log(subexpression) / (4.0 * Math::PI ) )
    
    rx = [ (rx *  MAP_SIZE_IN_MAP_COORDINATES) , (MAP_SIZE_IN_MAP_COORDINATES - 1.0) ].min
    rx = [ rx, 0.0 ].max
    
    ry = [ ry *  MAP_SIZE_IN_MAP_COORDINATES , MAP_SIZE_IN_MAP_COORDINATES - 1.0 ].min
    ry = [ ry, 0.0 ].max
    
    return rx.to_int, ry.to_int
    
    
    end


end
