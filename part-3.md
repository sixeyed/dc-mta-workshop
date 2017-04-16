

## Part 1 - async save

In SignUp.aspx.cs:

from 

```
            //v1.0:
            using (var context = new ProductLaunchContext())
            {
                //reload child objects:
                prospect.Country = context.Countries.Single(x => x.CountryCode == prospect.Country.CountryCode);
                prospect.Role = context.Roles.Single(x => x.RoleCode == prospect.Role.RoleCode);

                context.Prospects.Add(prospect);
                context.SaveChanges();
            }

            //v1.3:
            /*
            var eventMessage = new ProspectSignedUpEvent
            {
                Prospect = prospect,
                SignedUpAt = DateTime.UtcNow
            };

            MessageQueue.Publish(eventMessage);
            */
```

to 

```
            var eventMessage = new ProspectSignedUpEvent
            {
                Prospect = prospect,
                SignedUpAt = DateTime.UtcNow
            };

            MessageQueue.Publish(eventMessage);

```


x


```
cd C:\scm\github\sixeyed\dc-mta-workshop

docker build -t $DockerID/mta-app:1.3 -f part-3\v1.3\web\Dockerfile .

docker build -t $DockerID/mta-save-handler -f part-3\v1.3\save-handler\Dockerfile .

```

x


```
C:\scm\github\sixeyed\dc-mta-workshop\app

docker-compose -f .\docker-compose-1.3.yml up -d
```

check:

```
docker exec app_mta-db_1 powershell "Invoke-SqlCmd -Query 'SELECT * FROM Prospects' -Database ProductLaunch"

docker logs app_mta-save-handler_1
```

# 2 - Add self-service analytics

```
cd C:\scm\github\sixeyed\dc-mta-workshop

docker build -t $DockerID/mta-index-handler -f part-3\v1.4\index-handler\Dockerfile .

```


```
C:\scm\github\sixeyed\dc-mta-workshop\app

docker-compose -f .\docker-compose-1.4.yml up -d
```


test a couple of submits

```
docker logs app_mta-save-handler_1

docker exec app_mta-db_1 powershell "Invoke-SqlCmd -Query 'SELECT * FROM Prospects' -Database ProductLaunch"

docker logs app_mta-index-handler_1
```

check on kibana - pie chart

```
docker inspect app_kibana_1
```

http://$kibana-ip:5601


# 3 - Replace homepage

```
cd C:\scm\github\sixeyed\dc-mta-workshop\part-3\v1.5\homepage

docker build -t $DockerID/mta-homepage .

```


```
cd C:\scm\github\sixeyed\dc-mta-workshop\app

docker-compose -f .\docker-compose-1.5.yml up -d
```


new ip - test

```
docker inspect app_mta-app_1
```