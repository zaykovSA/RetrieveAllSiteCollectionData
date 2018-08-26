$(document).ready(function () {
    $(".searchInput").each((numb, elem) => {
        if ($(elem).val())
            $(elem).parent().addClass("focused");
    });

    $(".resultTable th:contains('Title')").text("Название");
    $(".resultTable th:contains('Announcement')").text("Описание");
    $(".resultTable th:contains('PagesCount')").text("Количество страниц");

    $(".searchInput").on("focus", function () {
        $(this).parent().addClass("focused");
    });

    $(".searchInput").on("blur", function () {
        if (!$(this).val())
            $(this).parent().removeClass("focused");
    });
});