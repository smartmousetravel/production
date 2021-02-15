(function () {
    function thumbHTML(id) {
        return (
            '<img src="https://i.ytimg.com/vi/' +
            id +
            '/hqdefault.jpg">' +
            '<div class="play"></div>'
        );
    }

    function swapIFrame() {
        var iframe = document.createElement("iframe");
        iframe.setAttribute(
            "src",
            "https://www.youtube.com/embed/" + this.dataset.id
        );
        iframe.setAttribute("frameborder", "0");
        iframe.setAttribute("allowfullscreen", "1");
        this.parentNode.replaceChild(iframe, this);
    }

    document.addEventListener("DOMContentLoaded", function () {
        var players = document.getElementsByClassName("youtube-player");
        for (var i = 0; i < players.length; i++) {
            var player = players[i];
            var div = document.createElement("div");
            div.setAttribute("data-id", player.dataset.id);
            div.innerHTML = thumbHTML(player.dataset.id);
            div.addEventListener("click", swapIFrame);
            player.appendChild(div);
        }
    });
})();
