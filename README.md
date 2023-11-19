# Eksamen PGR301 2023

Denne besvarelsen krever at sensor legger til secrets i github secrets:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Sensor kan også endre variabler i workflow filen ecr-publish.yml. Foreløpige variabler peker til image og service name i terraform jeg selv har brukt:
* IMAGE: 244530008913.dkr.ecr.eu-west-1.amazonaws.com/kandidat2017:latest
* SERVICE_NAME: kandidat2017

## Oppgave 1A

## Oppgave 1B
Når jeg brukte kjellsimagebucket fikk jeg en feilmelding som sier "invalid image format", noe som Glenn har nevnt i en kunngjøring. I bucketen er det noen non-image filer som jeg ikke tørr å slette. La inn bilde i egen bucket og fikk riktig svar.
![oppgave 1b](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/oppgave1b.PNG)

## Oppgave 2A
"docker build -t ppe ." bygger følgende:
 ![oppgave 2a](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/build.PNG)

 "docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket ppe" kjører følgende:
 ![oppgave 2a](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/run.PNG)


## Oppgave 2B
https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/.github/workflows/ecr-publish.yml

I denne workflowen lagde jeg en short-sha, fordi sha er litt for lang. ECR_REPOSITORY brukt er kandidat2017. Den krever AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY for å kjøre. Workflowen gjør ikke annet enn å bygge med mindre workflowen ble startet fra main branchen.

## Oppgave 3A
Hardkoding av service_name ble byttet ut med en variabel som nå blir satt i workflow filen lenket til i oppgave 2B. De hardkodede variablene jeg valgte å bytte ut var service_name og image. Vurderte å bytte ut role og policy med variabler, men satte det heller til "${var.service_name}-role" og "${var.service_name}-policy". Vurderte å sette port til en variabel. Det kunne vært relevant på jobb, men på eksamen ser jeg ikke poenget. CPU og memory endret:

  instance_configuration {
    instance_role_arn = aws_iam_role.role_for_apprunner_service.arn
    cpu = 256
    memory = 1024
  }

## Oppgave 3B
La til terraform i samme workflow som lenket til i oppgave 2B. Terraform jobben har linjen "needs: build-and-push-docker", som gjør at den kun kjører etter build-and-push-docker jobben har kjørt og passert. Terraform provider og backend ligger i provider.tf.
Om sensor enda ikke har lagt til krecde secrets må det gjøres for å få kjørt workflowen. Her kan man også endre env: "IMAGE" og "SERVICE_NAME" om sensor skulle ønske. Jobben kjører kun hvis workflowen ble startet fra main branchen.

## Oppgave 4A

## Oppgave 4B

### Oppgave 5: Drøfteoppgaver
## Oppgave 5A

## Oppgave 5B

## Oppgave 5C