$(function () {
    $(".datetimepicker").datetimepicker().each(function (index, elem) {
        var isoTime = $("#interview_" + elem.name + "_iso").val();
        $(elem).datetimepicker("setDate", new Date(isoTime));
    }).change(function () {
        $("#interview_" + this.name + "_iso").val(new Date(this.value).toISOString());
    });

    $(".iso-time").each(function (index, elem) {
        elem.innerHTML = new Date(elem.innerHTML).toLocaleString();
    });

    function toggle_modality(modality) {
        if (typeof(modality) == "string") {
            if (modality.indexOf("phone") >= 0) {
                $(".toggle-location").hide();
                $(".toggle-phone").show();
            } else if (modality.indexOf("onsite") >= 0) {
                $(".toggle-location").show();
                $(".toggle-phone").hide();
            }
        }
    }

    toggle_modality(
        $("#interview_modality").change(function () {
            toggle_modality(this.value);
        }).val()
    );
});