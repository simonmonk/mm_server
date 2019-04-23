// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks

//= require bootstrap-datepicker

//= require vue

//= require Chart.bundle
//= require chartkick

//= require jquery3
//= require popper
//= require bootstrap
//= require_tree .

Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
}

Number.prototype.to_gbp = function() {
    var formatter = new Intl.NumberFormat('en-UK', { style: 'currency', currency: 'GBP', minimumFractionDigits: 2 });
    return formatter.format(this.valueOf())
}

String.prototype.to_gbp = function() {
    var formatter = new Intl.NumberFormat('en-UK', { style: 'currency', currency: 'GBP', minimumFractionDigits: 2 });
    return formatter.format(parseFloat(this.valueOf()))
}


Number.prototype.to_usd = function() {
    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 2 });
    return formatter.format(this.valueOf())
}

String.prototype.to_usd = function() {
    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 2 });
    return formatter.format(parseFloat(this.valueOf()))
}


Number.prototype.to_currency = function(currency) {
    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: currency, minimumFractionDigits: 2 });
    return formatter.format(this.valueOf())
}


String.prototype.to_currency = function(currency) {
    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: currency, minimumFractionDigits: 2 });
    return formatter.format(parseFloat(this.valueOf()))
}