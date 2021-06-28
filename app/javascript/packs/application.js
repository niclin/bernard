// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'bootstrap/dist/js/bootstrap'
import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'leaflet'
import Swal from 'sweetalert2/dist/sweetalert2.js'
import './src/applications.scss'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

$(document).on('turbolinks:load', function () {
  // after turbolinks:load
  // becuase turbolinks will let link_to not trigger reload js
  // custome js in here ...

  $(document).on('click','.showPopup', function () {
    var iconSytle = $(this).data('icon') == 'successed' ? 'success' : 'error';
    Swal.fire({
      icon: iconSytle,
      html: $(this).data('response'),
    })
  })

  if ($('#map').length > 0) {
    var map = L.map('map');
    var mkr = L.marker([0, 0]);
    var lat = document.getElementById('punch_setting_geo_latitude').value == '0.0' ? '25.046273' : document.getElementById('punch_setting_geo_latitude').value
    var lng = document.getElementById('punch_setting_geo_longitude').value == '0.0' ? '121.517498' : document.getElementById('punch_setting_geo_longitude').value
    mkr.bindPopup('0,0');
    mkr.addTo(map);
    L.tileLayer('https://www.google.com/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i345013117!3m8!2szh-TW!3scn!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0', {
      attribution: ' &copy; <a href="https://maps.google.com/">Google</a>',
      maxZoom: 18,
    }).addTo(map);

    L.Control.Watermark = L.Control.extend({
      onAdd: function (map) {
        var img = L.DomUtil.create('img');
        img.src = 'https://maps.gstatic.com/mapfiles/api-3/images/google3_hdpi.png';
        img.style.width = '70px';
        return img;
      },
    });
    L.control.watermark = function (opts) {
      return new L.Control.Watermark(opts);
    }
    L.control.watermark({
      position: 'bottomleft'
    }).addTo(map);

    map.on('click', onMapClick);
    sm(lat, lng, 18)
  }

  function onMapClick(e) {
    mkr.setLatLng(e.latlng);
    setui(e.latlng.lat, e.latlng.lng, map.getZoom());
  }

  function sm(lt, ln, zm) {
    setui(lt, ln, zm);
    mkr.setLatLng(L.latLng(lt, ln));
    map.setView([lt, ln], zm);
  }

  function setui(lt, ln, zm) {
    lt = Number(lt).toFixed(6);
    ln = Number(ln).toFixed(6);
    mkr.setPopupContent(lt + ',' + ln).openPopup();
    document.getElementById('punch_setting_geo_latitude').value = lt;
    document.getElementById('punch_setting_geo_longitude').value = ln;
  }
});