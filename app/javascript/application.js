import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "bootstrap"
import "./controllers"

ActiveStorage.start();

window.Turbo.setProgressBarDelay(1);