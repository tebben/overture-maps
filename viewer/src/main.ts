import './style.css'
import 'maplibre-gl/dist/maplibre-gl.css';
import maplibregl from 'maplibre-gl';
import * as pmtiles from 'pmtiles'


let protocol = new pmtiles.Protocol();
maplibregl.addProtocol("pmtiles", protocol.tile);

let hostname = location.hostname;
console.log(hostname);

const map = new maplibregl.Map({
    container: 'map',
    hash: true,
    style: {
        version: 8,
        glyphs: "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf",
        sources: {
            "overture": {
                "type": "vector",
                "url": location.hostname.includes("github.io") ? "pmtiles://https://storage.googleapis.com/ahp-research/overture/pmtiles/overture.pmtiles" : "pmtiles://dist/overture.pmtiles",
                "attribution": "© OpenStreetMap, Overture Maps Foundation, Barry"
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
            /* {
                "id": 'buldings',
                "type": 'fill',
                "source": 'overture',
                "source-layer": 'buildings',
                "paint": {
                    'fill-color': '#1C1C1C'
                }
            }, */
            {
                "id": 'buldings-extruded',
                "type": 'fill-extrusion',
                "source": 'overture',
                "source-layer": 'buildings',
                "paint": {
                    'fill-extrusion-color': '#1C1C1C',
                    "fill-extrusion-height": [
                        "case",
                        ["==", ["get", "height"], -1],
                        0,
                        ["get", "height"]  // Otherwise, use the actual height value
                    ],
                    'fill-extrusion-opacity': 0.9
                }
            },
            {
                "id": 'roads',
                "type": 'line',
                "source": 'overture',
                "source-layer": 'roads',
                "paint": {
                    'line-color':
                        ['case',
                            ['==', ['get', 'class'], 'motorway'], '#717171',
                            ['==', ['get', 'class'], 'primary'], '#717171',
                            ['==', ['get', 'class'], 'secondary'], '#717171',
                            ['==', ['get', 'class'], 'tertiary'], '#717171',
                            ['==', ['get', 'class'], 'residential'], '#464646',
                            ['==', ['get', 'class'], 'livingStreet'], '#464646',
                            ['==', ['get', 'class'], 'trunk'], '#5A5A5A',
                            ['==', ['get', 'class'], 'unclassified'], '#5A5A5A',
                            ['==', ['get', 'class'], 'parkingAisle'], '#323232',
                            ['==', ['get', 'class'], 'driveway'], '#1C1C1C',
                            ['==', ['get', 'class'], 'pedestrian'], '#232323',
                            ['==', ['get', 'class'], 'footway'], '#1C1C1C',
                            ['==', ['get', 'class'], 'steps'], '#1C1C1C',
                            ['==', ['get', 'class'], 'track'], '#1C1C1C',
                            ['==', ['get', 'class'], 'cycleway'], '#1C1C1C',
                            ['==', ['get', 'class'], 'unknown'], '#1C1C1C',
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
                            ['==', ['get', 'class'], 'pedestrian'], 3,
                            ['==', ['get', 'class'], 'footway'], 3,
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
                "id": 'roads-labels',
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
                    "circle-color": "#4EDAD8",
                    "circle-radius": 5,
                    "circle-blur": 0.3,
                    "circle-opacity": 0.8
                }
            },
            {
                "id": 'places-labels',
                "type": 'symbol',
                "source": 'overture',
                "source-layer": 'places',
                "layout": {
                    'icon-allow-overlap': false,
                    'text-allow-overlap': false,
                    'text-anchor': "bottom",
                    'text-radial-offset': 1,
                    'symbol-placement': "point",
                    'text-field': ['get', 'name'],
                    'text-size': 10,
                },
                "paint": {
                    'text-color': "#4EDAD8",
                    'text-halo-color': "black",
                    'text-halo-width': 3,
                    'text-halo-blur': 2
                }
            },
        ],
    },
    center: [4.91431, 52.34304],
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

/* map.addControl(
    new maplibregl.NavigationControl({
        visualizePitch: true,
    })
); */
