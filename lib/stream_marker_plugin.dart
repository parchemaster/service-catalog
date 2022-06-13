import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';


class StreamMarkerPlugin<T> extends MapPlugin {
  @override
  Widget createLayer(LayerOptions options, MapState mapState, Stream<void>? stream) {
    StreamMarkerLayerOptions<T> layerOptions =
    options as StreamMarkerLayerOptions<T>;
    
    return StreamBuilder<Iterable<T>>(
        stream: layerOptions._stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: 0.0,
              height: 0.0,
            );
          }
          
          List<Marker> markers = [];
          for (T provider in snapshot.data!) {
            markers.add(layerOptions._creator(provider));
          }

          MarkerLayerOptions markerOpts = MarkerLayerOptions(markers: markers);

          return MarkerLayer(markerOpts, mapState, stream);
        });
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is StreamMarkerLayerOptions<T>;
  }
}

class StreamMarkerLayerOptions<T> extends LayerOptions {
  final Stream<Iterable<T>> _stream;
  final Marker Function(T object) _creator;

  StreamMarkerLayerOptions({
    required Stream<Iterable<T>> stream,
    required Marker Function(T object) markerCreator
  }) : _stream = stream, _creator = markerCreator;
}
