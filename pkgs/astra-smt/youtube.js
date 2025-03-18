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
            "https://www.youtube.com/embed/" + this.dataset.id,
        );
        iframe.setAttribute("frameborder", "0");
        iframe.setAttribute("allowfullscreen", "1");
        this.parentNode.replaceChild(iframe, this);
    }

    function loadCSS() {
        var head = document.getElementsByTagName("head")[0];
        var link = document.createElement("link");
        link.rel = "stylesheet";
        link.type = "text/css";
        // TODO: Don't hard-code this link location
        link.href = "/wp-content/themes/astra-smt/youtube.css";
        link.media = "all";
        head.appendChild(link);
    }

    document.addEventListener("DOMContentLoaded", function () {
        var players = document.getElementsByClassName("youtube-player");
        if (players.length === 0) {
            return;
        }
        loadCSS();
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
