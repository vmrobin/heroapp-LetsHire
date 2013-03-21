# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

/*  Coffee script version
$ ->
  $('select#opening_country').change (event) ->
    select_wrapper = $('#opening_state_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country_code = $(this).val()

    url = "/addresses/subregion_options?country_code=#{country_code}"
    select_wrapper.load(url)
*/


(function() {
    $(function() {
        return $('select#opening_country').change(function(event) {
            var country_code, select_wrapper, url;
            select_wrapper = $('#opening_state_wrapper');
            $('select', select_wrapper).attr('disabled', true);
            country_code = $(this).val();
            url = "/addresses/subregion_options?country_code=" + country_code;
            return select_wrapper.load(url);
        });
    });
}).call(this);
