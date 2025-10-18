// video_stream_html.dart
String getVideoStreamHtml(String jwtToken, String roomId) {
  return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Video Stream</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/js-cookie@3.0.5/dist/js.cookie.min.js"></script>
    <script src="https://meet.jit.si/libs/lib-jitsi-meet.min.js"></script>
    <style>
        body {
            background: black;
            margin: 0;
            padding: 0;
            font-family: Arial;
            color: white;
            overflow: hidden;
        }
        #video-container {
            width: 100vw;
            height: 100vh;
            display: flex;
            align-items: top;
            justify-content: center;
            background: #000;
        }
        #video-element {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

    </style>
</head>
<body>
    <div id="video-container">
        <video autoplay playsinline disablepictureinpicture></video>
    </div>

    <script>
        // Room ID из параметра Flutter
        const ROOM_ID = '$roomId';
        const JWT_TOKEN = '$jwtToken';

        function createJitsiConnection() {
            const serviceUrl = 'wss://live.teleslot.net/xmpp-websocket';
            const connection = new JitsiMeetJS.JitsiConnection(null, null, {
                hosts: {
                    domain: 'meet.jitsi',
                    muc: 'muc.meet.jitsi',
                },
                serviceUrl: serviceUrl,
            });
            
            return connection;
        }

        function initJitsiConference(connection, roomId) {
            const room = connection.initJitsiConference(roomId, {
                p2p: {
                    enabled: false,
                    iceTransportPolicy: 'relay',
                },
                videoQuality: {
                    codecPreferenceOrder: ['VP8'],
                },
            });
            
            room.setDisplayName('player');
            room.setReceiverConstraints({
                assumedBandwidthBps: -1,
                constraints: {},
                defaultConstraints: { maxHeight: 2160 },
                lastN: -1,
            });
            
            return room;
        }

        function startJitsi() {
            
            // Инициализация Jitsi
            JitsiMeetJS.init({
                disableAudioLevels: true,
                disableThirdPartyRequests: true,
                enableAnalyticsLogging: false
            });

            const connection = createJitsiConnection();
            
            connection.addEventListener(JitsiMeetJS.events.connection.CONNECTION_ESTABLISHED, () => {
                console.log('JITSI: CONNECTION_ESTABLISHED');
                
                const room = initJitsiConference(connection, ROOM_ID);
                
                console.log('Room created:', room);

                room.on(JitsiMeetJS.events.conference.TRACK_ADDED, (track) => {
                    console.log('JITSI: TRACK_ADDED', track.getType());
                    if (track.getType() === 'video') {
                        track.attach(\$('video')[0]);
                        
                        // Уведомляем Flutter
                        if (window.VideoChannel) {
                            VideoChannel.postMessage('trackAdded');
                        }
                    }
                });
                
                room.on(JitsiMeetJS.events.conference.CONFERENCE_JOINED, () => {
                    console.log('JITSI: CONFERENCE_JOINED');

                    // Уведомляем Flutter
                    if (window.VideoChannel) {
                        VideoChannel.postMessage('connectionEstablished');
                    }
                });
                
                room.join();
            });

            connection.addEventListener(JitsiMeetJS.events.connection.CONNECTION_FAILED, (error) => {
                console.error('JITSI: CONNECTION_FAILED', error);
                
                // Уведомляем Flutter об ошибке
                if (window.VideoChannel) {
                    VideoChannel.postMessage('error:Ошибка подключения к Jitsi');
                }
            });

            connection.connect();
        }

         // Автоматический запуск при загрузке страницы
        \$(document).ready(function() {
            console.log('Auto-starting video stream...');
            console.log('JWT Token:', JWT_TOKEN ? 'Present' : 'Missing');
            console.log('Room ID:', ROOM_ID);
            
            // Сохраняем токен
            Cookies.set('jwt_token', JWT_TOKEN, { path: '/' });
            
            // Запускаем трансляцию с небольшой задержкой для инициализации DOM
            setTimeout(startJitsi, 10);
        });

        // Глобальные обработчики ошибок
        window.addEventListener('error', function(e) {
            console.error('Global error:', e.error);
            if (window.VideoChannel) {
                VideoChannel.postMessage('error:' + (e.error?.message || e.message));
            }
        });
    </script>
</body>
</html>
''';
}
