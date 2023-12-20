// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"

Rails.start()
ActiveStorage.start()

window.Turbo.setProgressBarDelay(1);

$(document).on('turbo:before-fetch-response', function (event) {
    let t = $('#t').html();

    notes();

    if (typeof t === 'undefined') {
        return;
    }

    let id = event.target.id;

    let element = document.getElementById(id);

    if (element.getAttribute('data-video-note-id') === null) {
        return;
    }

    let frame = document.getElementById(element.getAttribute('data-video-note-id'));
    if (frame.complete) {
        notes();
    } else {
        frame.loaded.then(function () {
            notes();
            frame.reload();
        });
    }
});

$(document).on('turbo:load', function () {
    let $flash = $('#flash');

    if ($flash.is(':visible')) {
        $flash.delay(5000).fadeOut();
    }

    notes();
});

function notes() {
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
        let hours, minutes, seconds;

        e.preventDefault();
        // Get the time from the data-time attribute of the clicked link
        let time = $(this).data('time');
        // Split the time into parts
        let parts = time.split(':');

        // If the time is in MM:SS format, add 0 hours
        if (parts.length === 2) {
            hours = 0;
            minutes = parts[0];
            seconds = parts[1];
        } else if (parts.length === 3) {
            hours = parts[0];
            minutes = parts[1];
            seconds = parts[2];
        } else {
            return;
        }

        // Convert to seconds and set the current time of the video
        $('#video-player')[0].currentTime = parseInt(hours) * 3600 + parseInt(minutes) * 60 + parseInt(seconds);
    });
}

// Function to extract time from note text
function extractTime(text) {
    // Regular expression to match HH:MM:SS format, but HH is optional
    const regex = /(\d{2}:)?(\d{2}):(\d{2})/;
    let match = text.match(regex);

    return match ? match[0] : '-';
}