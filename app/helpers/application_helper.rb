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

end
