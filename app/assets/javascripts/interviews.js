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
    if ($("#interviewers-list").length > 0) {
        var allInterviewers = JSON.parse($("#interviewers-list").text());
        var selectedInterviewers = JSON.parse($("#interviewers-data").text());

        function interviewersSelected() {
            var interviewers = [];
            var hiddenFields = [];
            $("#interviewer-select div").each(function (index, elem) {
                var checkBox = $(elem).find("input")[0];
                if (checkBox.checked) {
                    interviewers.push($(elem).find("span.name").text());
                    hiddenFields.push("<input type='hidden' name='interview[interviewer_ids][]' value='" + checkBox.value + "' />");
                }
            });
            $("#interviewers-text").val(interviewers.join(", "));
            $("#interviewers-data").html(hiddenFields.join(""));
        }

        function updateInterviewerList(openingId) {
            $("#interviewer-select").html(
                (allInterviewers[openingId] || []).map(function (interviewer) {
                    return "<div class='interviewer-line'><span><input type='checkbox' value='" + interviewer.id + "' "
                            + (selectedInterviewers.indexOf(interviewer.id) >= 0 ? 'checked' : '')
                            + "/><span class='name'>"
                            + interviewer.name + "</span><span class='email'>"
                            + interviewer.email + "</span></span></div>";
                }).join("")
            );
            $("#interviewer-select input").click(function () {
                interviewersSelected();
            });
            interviewersSelected();
        }

        updateInterviewerList(
            $("#position select").change(function () {
                updateInterviewerList(this.value);
            }).val()
        );

        $("#interviewers-text").click(function () {
            $("#interviewer-select").toggleClass("hide");
        });
    }
});
