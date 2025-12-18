/* import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttJackpotService {
  static var logger = Logger();
  final client = MqttServerClient('wss://live.teleslot.net/mqtt', '');
  final StreamController<Map<String, dynamic>> jackpotStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get jackpotStream =>
      jackpotStreamController.stream;

  Future<int> main() async {
    client.useWebSocket = true;
    client.port = 443;

    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    String? jwtToken = await AuthService.getJwt();
    if (jwtToken == null) {
      jwtToken = await AuthService.loginAndSaveJwt();
      if (jwtToken == null) {
        throw Exception('Не удалось получить JWT токен');
      }
    }

    client.websocketHeader = {'Cookie': 'jwt_token=$jwtToken'};

    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 5;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    logger.i('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      logger.i('EXAMPLE::client exception - $e');
      client.disconnect();
      exit(-1);
    } on SocketException catch (e) {
      logger.i('EXAMPLE::socket exception - $e');
      client.disconnect();
      exit(-1);
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      logger.i('EXAMPLE::Mosquitto client connected');
    } else {
      logger.w(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}',
      );
      client.disconnect();
      exit(-1);
    }

    logger.i('EXAMPLE::Subscribing to the mystery/funds topic');
    const topic = 'mystery/#';
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      try {
        final json = jsonDecode(pt);
        logger.i('Получен JSON: $json');
        jackpotStreamController.add(json);
      } catch (e) {
        logger.i('Получено сообщение: $pt');
      }

      logger.i(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->',
      );
    });

    client.published!.listen((MqttPublishMessage message) {
      logger.i(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}',
      );
    });

    // Оставь только если нужно публиковать
    /*
    const pubTopic = 'Dart/Mqtt_client/testtopic';
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello from mqtt_client');
    client.subscribe(pubTopic, MqttQos.exactlyOnce);
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    */

    logger.i('EXAMPLE::Sleeping....');
    await MqttUtilities.asyncSleep(1000);

    logger.i('EXAMPLE::Unsubscribing');
    client.unsubscribe(topic);

    await MqttUtilities.asyncSleep(2);
    logger.i('EXAMPLE::Disconnecting');
    client.disconnect();
    return 0;
  }

  void onSubscribed(String topic) {
    logger.i('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    logger.i('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      logger.i(
        'EXAMPLE::OnDisconnected callback is solicited, this is correct',
      );
    }
  }

  void onConnected() {
    logger.i(
      'EXAMPLE::OnConnected client callback - Client connection was successful',
    );
  }

  void pong() {
    logger.i('EXAMPLE::Ping response client callback invoked');
  }
}
 */
