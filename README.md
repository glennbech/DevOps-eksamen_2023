# Eksamen PGR301 2023

Denne besvarelsen krever at sensor legger til secrets i github secrets:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY

Sensor kan også endre variabler i workflow filen ecr-publish.yml. Foreløpige variabler peker til image og service name i terraform jeg selv har brukt:
* IMAGE: 244530008913.dkr.ecr.eu-west-1.amazonaws.com/kandidat2017:latest
* SERVICE_NAME: kandidat2017

Eventuelt også --stack-name i sam-deploy.yml som foreløpig er "kandidat2017new"

# Oppgave 1. Kjell's Python kode
## Oppgave 1A

## Oppgave 1B
Når jeg brukte kjellsimagebucket fikk jeg en feilmelding som sier "invalid image format", noe som Glenn har nevnt i en kunngjøring. I bucketen er det noen non-image filer som jeg ikke tørr å slette. La inn bilde i egen bucket og fikk riktig svar.
![oppgave 1b](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/oppgave1b.PNG)

# Oppgave 2. Overgang til Java og Spring boot
## Oppgave 2A
"docker build -t ppe ." bygger følgende:

 ![oppgave 2a](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/build.PNG)

 "docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=YYY -e BUCKET_NAME=kjellsimagebucket ppe" kjører følgende:
 ![oppgave 2a](https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/img/run.PNG)


## Oppgave 2B
https://github.com/aadnehm/DevOps-eksamen_2023/blob/main/.github/workflows/ecr-publish.yml

I denne workflowen lagde jeg en short-sha, fordi sha er litt for lang. ECR_REPOSITORY brukt er kandidat2017. Den krever AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY for å kjøre. Workflowen gjør ikke annet enn å bygge med mindre workflowen ble startet fra main branchen.

# Oppgave 3- Terraform, AWS Apprunner og Infrastruktur som kode
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

# Oppgave 4. Feedback
## Oppgave 4A

## Oppgave 4B

# Oppgave 5: Drøfteoppgaver
## Oppgave 5A: Kontinuerlig Integrering
### En definisjon av kontinuerlig integrasjon:
Kontinuerlig integrasjon (CI) er praksisen med å automatisere integreringen av kodeendringer fra flere bidragsytere i et enkelt prosjekt. Det er en "primary DevOps best practice", som lar utviklere ofte slå sammen kodeendringer i et sentralt repository, hvor bygging og tester deretter kjøres. Automatiserte verktøy brukes til å bekrefte den nye kodens korrekthet før integrering.

### Fordelene med å bruke CI i et utviklingsprosjekt - hvordan CI kan forbedre kodekvaliteten og effektivisere utviklingsprosessen:
CI har ufattelig mange fordeler, som er grunnen til at det blir brukt i så godt som alle prosjekter. Den aller største fordelen er automatisering. Mennesker er dumme på den måten at om vi skal gjøre det samme 1000 ganger vil det skje slurvefeil. Hvis man setter opp automatisk integrasjon vil man unngå disse slurvefeilene som mennesker, uten unntak, til slutt vil gjøre. Ved å sette opp automatiske tester vil man oppdage bugs og feil i koden mye tidligere. Ved å kontinuerlig integerere koden sin vil man også unngå "integration hell", der utviklere samler opp store endringer som tar lang tid å integrere. Om bugs og feil skulle skje, vil CI også hjelpe å lokalisere disse problemene ved hjelp av historie og logger, noe som blir mye enklere om integrasjoner er mindre og skjer oftere.

### Hvordan jobber vi med CI i GitHub rent praktisk? For eskempel i et utviklingsteam på fire/fem utivklere?:
Vi tar utgangspunk i 4-5 utviklere i kun ett repository, men én produkteier/repository admin. Som regel når et team jobber i ett repository vil man ha en branch - main - som alltid skal inneholde fungerende kode. Teammedlemmene som jobber på koden brancher ut, og når de vil ha koden sin i main vil de legge inn en pull request. Pull requesten må som oftest reviewes av én eller flere teammedlemmer, der den ene ofte må være admin. Hvis en pull request blir godkjent kan koden merges til main. Når koden merges til main vil ofte en github actions workflow kjøre. Denne workflowen vil bygge, teste og deploye koden til dev, test og prod. CI delen slutter vel på testing av kode da deployment går under CD (continuous deployment. CI og CD går hånd i hånd og blir referert til som CI/CD).

## Oppgave 5B: Sammenligning av Scrum/Smidig og DevOps fra et Utviklers Perspektiv
### Scrum/Smidig Metodikk:
Scrum er et verktøy for å effektivisere utviklingsprosessen. Et scrum team består som regel av en scrum master, en produkteier og et utviklingsteam. Dette teamet tar ofte i bruk backlogger for å holde oversikt over hva som gjenstår å utvikle. Det er vanlig å ha såkalte "sprints" som strekker seg over en fast tid, ofte 2-4 uker, men dette er noe som varierer veldig fra prosjekt til prosjekt. Man benytter seg ofte av daily standup for å dele fremgang og utfordringer. En viktig del av scrum er også sprint retrospective der man reflekterer over sprintene og hvilke endringer som bør gjøres.

Ett av målene - og fordelene - med scrum metodikk er at man får et mye klarere bilde av hva som skal gjøres og hvor lang tid det vil ta. Dette hjelper utviklere med å jobbe mer effektivt, og gir produkteier og "stakeholders" bedre innsikt i utviklingsprosessen. Siden man itererer over så korte perioder blir det også lettere å få kontinuerlig feedback fra produkteier og stakeholders, og dermed lettere å korrigere retningen i prosjektet. 
Noen ulemper med scrum er at det ikke passer for alle prosjekter. Et personlig problem jeg har med scrum er at det blir veldig mange møter som kan hindre fremgang. I prosjekter jeg har deltatt i blir det ikke brukt sprints. Grunnen til dette er at å utvikle funksjonaliteter innenfor et satt tidsrom ikke gir like stor mulighet for utforsking og kreative løsninger.

### DevOps Metodikk:
Grunnleggende prinsipper:
DevOps er et sett med praksiser som tar sikte på å forbedre samarbeid og produktivitet. DevOps skal sørge for kontinuerlig kommunikasjon og samarbeid mellom utviklere, IT-driftspersonell og andre interessenter i organisasjonen. DevOps innebærer også automasjon, som ble nevnt i oppgave 5a. CI/CD Automatiserer integrerings- og distribusjonsprosessen for å sikre hyppige og pålitelige kodeutgivelser. DevOps kan også håndtere og tilrettelegge infrastruktur gjennom kode i stedet for manuelle prosesser. automatiseringen inkluderer også automatiserte enhets-, integrasjons-, og systemtester for å sikre kodekvalitet. Kontinuerlig overvåking og tilbakemelding av applikasjoner og infrastrukturprestasjoner for raskt å identifisere problemer. Alt dette er basert på å gjøre små, hyppige og håndterbare endringer heller enn store, sjeldne oppdateringer.

Styrker ved bruk av DevOps:
Forbedret samarbeid og moral. DevOps bryter ned veggene mellom team fører til bedre samarbeid, forståelse og jobbtilfredshet. Økt effektivitet og produktivitet. Automatisering reduserer manuelt arbeid, noe som fører til mer effektive prosesser og høyere produktivitet. Raskere løsning av problemer. Kontinuerlig overvåking og rask tilbakemelding tillater raskere identifisering og løsning av problemer. Forbedret kundetilfredshet. Raskere levering av funksjoner og rettelser fører til høyere kundetilfredshet.

Utfordringer:
Å flette DevOps inn i hverdagen krever kulturendring. Å skifte til en DevOps-kultur krever betydelige endringer i tankegang og praksiser, noe som kan være utfordrende for noen organisasjoner. DevOps krever også et bredt spekter av ferdigheter, inkludert koding, infrastrukturhåndtering og mer. Opplæring av eksisterende personell eller ansettelse av nytt personell med disse ferdighetene kan være en utfordring. Implementering og vedlikehold av de ulike verktøyene som kreves for automatisering, overvåking og samarbeid kan også være komplekst. DevOps kommer også med sikkerhetsbekymringer. Raske utviklingssykluser kan potensielt føre til sikkerhetshull hvis de ikke nøye håndteres.

### Sammenligning og Kontrast:
Scrum og DevOps, som begge har som formål å øke produktivitet og kodekvalitet blir ofte brukt sammen. På alle prosjekter jeg har værten del av (utenfor skolesammenheng) er begge deler blitt brukt. Hvordan disse verktøyene blir brukt varierer fra prosjekt til prosjekt. I noen prosjekter er det mer gunstig å legge masse fokus på DevOps, og ikke bruke sprints i det hele tatt. I andre prosjekter har det ingenting for seg å ha continuous deployment, og da vil det ofte være mer relevant å ha sprints. Så basert på prosjektets natur vil man velge og plukke fra scrum og DevOps for å gjøre arbeidsflyten best mulig.

Scrum fokuserer mer på iterativ utvikling, der kontinuerlig feedback er nødvendig for å drive prosjektet framover. Programvarekvaliteten er derfor basert på feedback og testing. Leveransetempoet er basert på sprints. Sprints er ofte delt inn i 2-4 uker utvikling, og på slutten skal man ha utviklet noe man kan vise. Noe man "kan ta tak i".

DevOps øker programvarekvalitet ved hjelp av automatisering av tester og integrasjon. Dette hjelper også leveransetempoet, som også økes ved bruk av CD.

Hvis jeg skulle valgt selv ville jeg lagt mer fokus på scrum i starten av et prosjekt. Om man starter fra scratch kan et prosjekt virke overveldende, og det viktigste er å ha god oversikt over hva som skal gjøres og å ha konstant fremgang. Når man har nådd et minimun viable product, eller MVP, ville jeg lagt mer fokus på DevOps. Grunnen til dette er at når man har et MVP gjenstår som regel de mest komplekse tingene. I min erfaring er det ingen idé å drive med sprints om hver person jobber med én funksjonalitet over hele sprinten. Da vil jeg heller beholde dailys, boards og reviews, men la utviklere jobbe med funksjonalitet og oppgaver uten deadlinen av en sprint i bakhodet. Som tidligere nevnt føler jeg at en sprint hemmer kreativitet og utforsking av et prosjekt, noe som jeg mener er viktig når man jobber med mer komplekse ting. I tilfeller der prosjektet allerede ligger i produksjon (om det er prosjektets natur), vil jeg kaste bort det meste fra scum med unntak av daily standup frem til flere funksjonaliteter skal utvikles. Men fremdeles på dette punket ville jeg ikke tatt tilbake sprints med mindre det skal utvikles noe veldig stort som krever et mer overordnet overblikk.

## Oppgave 5C: Det Andre Prinsippet - Feedback