// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can also rename this file to openings.js.coffee, and only keep the coffee script
// below : http://jashkenas.github.com/coffee-script/
$(function() {
    $("select#opening_country").change(function(event) {
        //$(this).parent().find('span').remove();
        var country_code, state_select_wrapper, url;
        state_select_wrapper = $("#opening_state_wrapper");
        $("select", state_select_wrapper).attr("disabled", true);
        country_code = $(this).val();
        url = "/addresses/subregion_options?country_code=" + country_code;
        return state_select_wrapper.load(url);
    });

    var reload_role_func = function(department_id, role) {
        if (department_id.length <= 0) {
            department_id = '0'
        }

        var role_id = $( '#opening_' + role + '_id');
        $('select', role_id).attr('disabled', true);

        var url = "/departments/" + department_id + "/user_select?selected=" + role_id.data('value') + "&role=" + role;
        return role_id.load(url).attr('id', 'opening_' + role + '_id')
                                .attr('name', 'opening[' + role + '_id]');
    };

    $('select#opening_department_id').change(function(event) {
        var department_id = $(this).val();
        return reload_role_func(department_id, 'hiring_manager');
    });
    if ($('#opening_hiring_manager_id').length > 0) {
        reload_role_func($('#opening_department_id')[0].value, 'hiring_manager');
    }
});
