$(function () {
    $(".datetimepicker").datetimepicker().each(function (index, elem) {
        var isoTime = $("#interview_" + elem.name + "_iso").val();
        if (isoTime == "") {
            $(elem).datetimepicker("setDate", new Date());
            $("#interview_" + this.name + "_iso").val(new Date(elem.value).toISOString());
        } else {
            $(elem).datetimepicker("setDate", new Date(isoTime));
        }
    }).change(function () {
        $("#interview_" + this.name + "_iso").val(new Date(this.value).toISOString());
    });

    $(".iso-time").each(function (index, elem) {
        elem.innerHTML = new Date(elem.innerHTML).toLocaleString();
    });

    function toggleModality(modality) {
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

    toggleModality(
        $("#interview_modality").change(function () {
            toggleModality(this.value);
        }).val()
    );

    // if it is on new/edit interview page
    if ($("#position select").length > 0) {
        function updateInterviewerList(openingId) {
            var url = "/openings/interviewers_select?opening_candidate_id=" + openingId;
            $("#interview_user_ids").load(url).attr('id', 'interview_user_ids')
                .attr('name', 'interview[user_ids]');
        }

        updateInterviewerList(
            $("#position select").change(function () {
                updateInterviewerList(this.value);
            }).val()
        );
        updateInterviewerList($("#position select")[0].value);
    }
});
