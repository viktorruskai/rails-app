import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["link"];
  connect() {
    this.parseNote(this.element.textContent.trim());
  }

  parseNote(note) {
    let time = this.extractTime(note);

    if (time === '-') {
      return;

    }

    let link = '<a data-notes-target="link" data-action="click->notes#handleClick" href="#" data-time="' + time + '">' + time + '</a>';

    this.element.innerHTML = this.element.innerHTML.replace(time, link);
  }

  extractTime(note) {
    let time = note.match(/(\d{2}:)?(\d{2}):(\d{2})/);
    if (time === null) {
      return '-';
    }

    return time[0];
  }

  handleClick(event) {
    event.preventDefault();

    let hours, minutes, seconds;
    let time = this.linkTarget.dataset.time;
    let parts = time.split(':');

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

    let videoPlayer = document.getElementById('video-player');
    videoPlayer.currentTime = parseInt(hours) * 3600 + parseInt(minutes) * 60 + parseInt(seconds);
  }
}
