#
docker build  -t "bitrix-dev" .

docker run -d -p 80:80 --name="bitrix" bitrix-dev

http://localhost/bitrixsetup.php
