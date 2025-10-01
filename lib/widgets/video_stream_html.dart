// video_stream_html.dart
String getVideoStreamHtml(String jwtToken, String roomId) {
  return r'''
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
            align-items: center;
            justify-content: center;
            background: #000;
        }
        #video-element {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .status {
            position: fixed;
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.8);
            padding: 10px;
            border-radius: 5px;
            z-index: 1000;
        }
        .close-btn {
            position: fixed;
            top: 10px;
            right: 10px;
            background: red;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            z-index: 1000;
        }
        #spinner {
            position: fixed;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        #spinner img {
            width: 50px;
            height: 50px;
            display: none;
        }
    </style>
</head>
<body>
    <div id="spinner">
        <p>Click me</p>
        <img src="data:image/png;base64, тут длинный base64 код
" alt="Spinner" />
    </div>
    <div class="status" id="status">Подготовка...</div>
    <button class="close-btn" onclick="closeVideo()">×</button>
    <div id="video-container">
        <video autoplay playsinline disablepictureinpicture></video>
    </div>

    <script>
        // Room ID из параметра Flutter
        // const ROOM_ID = '${roomId}';

        const ROOM_ID = 'a1360da3-09ea-4dde-b0e7-1f23bcc592e1';

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
            document.getElementById('status').textContent = 'Инициализация Jitsi...';
            
            // Инициализация Jitsi
            JitsiMeetJS.init({
                disableAudioLevels: true,
                disableThirdPartyRequests: true,
                enableAnalyticsLogging: false
            });

            const connection = createJitsiConnection();
            
            connection.addEventListener(JitsiMeetJS.events.connection.CONNECTION_ESTABLISHED, () => {
                console.log('JITSI: CONNECTION_ESTABLISHED');
                document.getElementById('status').textContent = 'Подключение установлено';
                
                const room = initJitsiConference(connection, ROOM_ID);
                
                console.log('Room created:', room);

                room.on(JitsiMeetJS.events.conference.TRACK_ADDED, (track) => {
                    console.log('JITSI: TRACK_ADDED', track.getType());
                    if (track.getType() === 'video') {
                        track.attach($('video')[0]);
                        $('#spinner').hide();
                        
                        // Уведомляем Flutter
                        if (window.VideoChannel) {
                            VideoChannel.postMessage('trackAdded');
                        }
                    }
                });
                
                room.on(JitsiMeetJS.events.conference.CONFERENCE_JOINED, () => {
                    console.log('JITSI: CONFERENCE_JOINED');
                    document.getElementById('status').textContent = 'Вход в комнату выполнен';
                    
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

        $('body').click(() => {
            $('body').off('click');
            $('#spinner img').show();
            $('#spinner p').hide();
            const username = 'cvetan';
            const password = '123qweXX';
            const payload = {username, password};
            const options = { headers: {'Content-Type': 'application/x-www-form-urlencoded' }};
            $.post('https://live.teleslot.net/login', payload, options).done((data) => {
                console.log('Login successful:', data);
                Cookies.set('jwt_token', data, { path: '/' });
                startJitsi();
            }).fail((err) => {
                console.error('Login failed:', err);
                $('#spinner img').hide();
            });
        });

        function closeVideo() {
            if (window.VideoChannel) {
                VideoChannel.postMessage('videoClosed');
            }
        }

        // Автоматически запускаем если токен уже есть
        /* $(document).ready(function() {
            const jwtToken = Cookies.get('jwt_token');
            if (jwtToken) {
                console.log('JWT token present, auto-starting...');
                $('#spinner p').text('Подключаемся...');
                setTimeout(startJitsi, 1000);
            }
        }); */

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
