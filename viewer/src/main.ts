import './style.css'
import 'maplibre-gl/dist/maplibre-gl.css';
import maplibregl from 'maplibre-gl';
import * as pmtiles from 'pmtiles'


let protocol = new pmtiles.Protocol();
maplibregl.addProtocol("pmtiles", protocol.tile);

const map = new maplibregl.Map({
    container: 'map',
    hash: true,
    style: {
        version: 8,
        glyphs: "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf",
        sources: {
            "overture": {
                "type": "vector",
                "url": "pmtiles://dist/overture.pmtiles",
            }
        },
        layers: [
            {
                "id": 'admins',
                "type": 'fill',
                "source": 'overture',
                "source-layer": 'admins',
                "paint": {
                    'fill-color': "#000"
                }
            },
            {
                "id": 'admins-outline',
                "type": 'line',
                "source": 'overture',
                "source-layer": 'admins',
                "paint": {
                    'line-color': '#6a6a6a',
                    'line-width': 1
                }
            },
            {
                "id": 'buldings',
                "type": 'fill',
                "source": 'overture',
                "source-layer": 'buildings',
                "paint": {
                    'fill-color': '#353535'
                }
            },
            /*   {
                  "id": 'buldings-extruded',
                  "type": 'fill-extrusion',
                  "source": 'overture',
                  "source-layer": 'buildings',
                  "paint": {
                      'fill-extrusion-color': '#353535',
                      'fill-extrusion-height': ['get', 'height'],
                  }
              }, */
            {
                "id": 'roads',
                "type": 'line',
                "source": 'overture',
                "source-layer": 'roads',
                /*  'filter': [
                     ">=", ["zoom"],
                     ["match", ["get", "class"],
                         ["motorway", "primary", "secondary"],
                         10,
                         ["tertiary", "residential"],
                         13,
                         14
                     ]
                 ], */
                "paint": {
                    'line-color':
                        ['case',
                            ['==', ['get', 'class'], 'motorway'], '#717171',
                            ['==', ['get', 'class'], 'primary'], '#717171',
                            ['==', ['get', 'class'], 'secondary'], '#717171',
                            ['==', ['get', 'class'], 'tertiary'], '#717171',
                            ['==', ['get', 'class'], 'residential'], '#717171',
                            ['==', ['get', 'class'], 'livingStreet'], '#717171',
                            ['==', ['get', 'class'], 'trunk'], '#5A5A5A',
                            ['==', ['get', 'class'], 'unclassified'], '#5A5A5A',
                            ['==', ['get', 'class'], 'parkingAisle'], '#5A5A5A',
                            ['==', ['get', 'class'], 'driveway'], '#5A5A5A',
                            ['==', ['get', 'class'], 'pedestrian'], '#5A5A5A',
                            ['==', ['get', 'class'], 'footway'], '#6a6a6a',
                            ['==', ['get', 'class'], 'steps'], '#6a6a6a',
                            ['==', ['get', 'class'], 'track'], '#6a6a6a',
                            ['==', ['get', 'class'], 'cycleway'], '#6a6a6a',
                            ['==', ['get', 'class'], 'unknown'], '#6a6a6a',
                            '#5A5A5A'
                        ],
                    'line-width':
                        ['case',
                            ['==', ['get', 'class'], 'motorway'], 6,
                            ['==', ['get', 'class'], 'primary'], 5,
                            ['==', ['get', 'class'], 'secondary'], 4,
                            ['==', ['get', 'class'], 'tertiary'], 3,
                            ['==', ['get', 'class'], 'residential'], 3,
                            ['==', ['get', 'class'], 'livingStreet'], 3,
                            ['==', ['get', 'class'], 'trunk'], 2,
                            ['==', ['get', 'class'], 'unclassified'], 2,
                            ['==', ['get', 'class'], 'parkingAisle'], 2,
                            ['==', ['get', 'class'], 'driveway'], 2,
                            ['==', ['get', 'class'], 'pedestrian'], 2,
                            ['==', ['get', 'class'], 'footway'], 2,
                            ['==', ['get', 'class'], 'steps'], 2,
                            ['==', ['get', 'class'], 'track'], 2,
                            ['==', ['get', 'class'], 'cycleway'], 2,
                            ['==', ['get', 'class'], 'unknown'], 2,
                            2
                        ],

                },
                "layout": {
                    "line-cap": "round"
                }
            },
            {
                "id": 'road-names',
                "type": 'symbol',
                "source": 'overture',
                "source-layer": 'roads',
                "layout": {
                    'icon-allow-overlap': false,
                    'symbol-placement': "line",
                    'text-field': ['get', 'roadName'],
                    'text-radial-offset': 0.5,
                    'text-size': 12,
                },
                "paint": {
                    'text-color': "#E2E2E2",
                    'text-halo-color': "#000",
                    'text-halo-width': 3,
                    'text-halo-blur': 2
                }
            },
            {
                "id": 'places',
                "type": 'circle',
                "source": 'overture',
                "source-layer": 'places',
                "paint": {
                    "circle-color": "#fff",
                    "circle-radius": 10
                }
            },
        ],
    },
    center: [5.300171258675078, 51.69073045148227],
    zoom: 14,
});

map.on('click', function (e) {
    var visibleLayers = map.getStyle().layers;

    for (var i = 0; i < visibleLayers.length; i++) {
        var layerId = visibleLayers[i].id;
        var features = map.queryRenderedFeatures(e.point, { layers: [layerId] });

        if (features.length) {
            var feature = features[0];

            // Create an HTML table to display key-value pairs from feature properties
            var tableHTML = '<h1>' + layerId + '</h1><table>';
            for (var property in feature.properties) {
                if (feature.properties.hasOwnProperty(property)) {
                    tableHTML += '<tr><td>' + property + '</td><td>' + feature.properties[property] + '</td></tr>';
                }
            }
            tableHTML += '</table>';

            new maplibregl.Popup()
                .setLngLat(e.lngLat)
                .setHTML(tableHTML)
                .addTo(map);
        }
    }
});

map.addControl(
    new maplibregl.NavigationControl({
        visualizePitch: true,
    })
);
