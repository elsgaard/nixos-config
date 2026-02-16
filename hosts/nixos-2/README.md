
How to run java project

```bash
sudo git clone https://github.com/elsgaard/hellojetty.git /var/lib/hellojetty/app
cd /var/lib/hellojetty/app
sudo ./gradlew --no-daemon shadowJar
java -jar build/libs/HelloJetty-1.0-SNAPSHOT.jar
```
