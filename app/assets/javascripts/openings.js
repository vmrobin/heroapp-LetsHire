// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can also rename this file to openings.js.coffee, and only keep the coffee script
// below : http://jashkenas.github.com/coffee-script/
/*
$ ->
  $("select#opening_country").change (event) ->
    select_wrapper = $("#opening_state_wrapper")

    $("select", select_wrapper).attr("disabled", true)

    country_code = $(this).val()

    url = "/addresses/subregion_options?country_code=#{country_code}"
    select_wrapper.load(url)
*/
$(function() {
    $("select#opening_country").change(function(event) {
        var country_code, select_wrapper, url;
        select_wrapper = $("#opening_state_wrapper");
        $("select", select_wrapper).attr("disabled", true);
        country_code = $(this).val();
        url = "/addresses/subregion_options?country_code=" + country_code;
        return select_wrapper.load(url);
    });
});
