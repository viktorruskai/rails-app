import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log(this.element.textContent.trim());

    this.parseNote(this.element.textContent.trim());
  }

  parseNote(note) {
    let time = this.extractTime(note);

    if (time === '-') {
      return;

    }

    let link = '<a class="video-link" href="#" data-time="' + time + '">' + time + '</a>';

    this.element.innerHTML = this.element.innerHTML.replace(time, link);
  }

  extractTime(note) {
    let time = note.match(/(\d{2}:)?(\d{2}):(\d{2})/);
    if (time === null) {
      return '-';
    }

    return time[0];
  }
}
