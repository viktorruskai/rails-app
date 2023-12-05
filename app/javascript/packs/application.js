// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


$(document).on('turbolinks:load', function () {
    $('.note').each(function () {
        // Extract time from the text content of the note
        let noteText = $(this).html();
        let time = extractTime(noteText);

        if (time === '-') {
            return;
        }

        // Skip if text already contains `video-link` class
        if (noteText.indexOf('video-link') !== -1) {
            return;
        }

        // Generate a link with the extracted time
        let link = '<a class="video-link" href="#" data-time="' + time + '">' + time + '</a>';

        // Replace the time in the note with a link
        noteText = noteText.replace(time, link);

        // Replace the text content of the note with the link
        $(this).html(noteText);
    });

    // Handle click event on the generated links
    $('.video-link').on('click', function (e) {
        e.preventDefault();
        // Get the time from the data-time attribute of the clicked link
        let time = $(this).data('time');
        // Split minutes and seconds
        let [minutes, seconds] = time.split(':');

        // Convert to seconds and set the current time of the video
        $('#video-player')[0].currentTime = parseInt(minutes) * 60 + parseInt(seconds);
    });

    // Function to extract time from note text
    function extractTime(text) {
        // Regular expression to match MM:SS format
        const regex = /(\d{2}):(\d{2})/;
        let match = text.match(regex);

        return match ? match[0] : '-';
    }
});
