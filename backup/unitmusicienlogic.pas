unit UnitMusicienLogic;
//Unit contenant les fonctions et les procédures concernant la création de
//musiciens et de leurs caractéristiques + récuperer ces mêmes caractéristiques
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils;

////////////////////////////////////////////////////////////////////
//----- TYPE -----
type
  //type des différents instruments
  typeInstrument=(vocal,guitare,basse,batterie,violon,kazoo,synthetiseur);

  //type des différents styles de musique
  typeStyle=(heavyMetal,powerMetal,symphonique,grooveMetal);

  //type des différents  des activités des musiciens
  typeActivite=(repos,entrainement,promotion,ecritChanson,enregistreAlbum,concert,malade);

  //type des musiciens comprennant toutes leurs caractéristiques
  typeMusicien = record
       nom:string;
       instrument:typeInstrument;
       style:typeStyle;
       nivInstrument:integer;
       nivStudio:integer;
       nivConcert:integer;
       endurance:integer;     //Endurance actuel du musicien
       maxEndurance:integer;  //Endurance maximal du musicien
       salaire:integer;
       activite:typeActivite;

       nombreEntrainement:integer; //Nombre d'entrainements
       dureeMaladie:integer;  //Indique depuis combien de temps le musicien est malade (par défaut 0)
  end;

////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

//Permet de créer un musicien avec des stats aléatoires en indiquant sont nom et prénom en entrée
function creationMusicien():typeMusicien;

//renvoi l'instrument du musicien en entrée sous forme de chaine de caratères
function InstrumentMusicien(musicien:typeMusicien) : string;

//renvoi l'activité du musicien en entrée sous forme de chaine de caratères
function ActiviteMusicien(musicien:typeMusicien) : string;

//renvoi le style du musicien en entrée sous forme de chaine de caratères
function StyleMusicien(musicien : typeMusicien) : string;

//Permet d'afficher toutes les caractéristiques d'un "musicien" (variable d'entrer)
procedure afficherMusicien (musicien:typeMusicien);

//Permet de generer un entier aléatoire entre 2 valeur (min et max) en entrée
function genererEntierAleatoire (min,max : integer) :integer;


////////////////////////////////////////////////////////////////////////////////////////////////////////////
implementation

////////////////////////////////////////////////////////////////////////
//renvoi l'instrument du musicien en entrée sous forme de chaine de caratères
function InstrumentMusicien(musicien:typeMusicien) : string;
var
   instrumentChaineCarateres: string;
begin
     case (musicien.instrument) of
          vocal : instrumentChaineCarateres :='Vocal';
          guitare : instrumentChaineCarateres :='Guitare';
          basse : instrumentChaineCarateres :='Basse';
          batterie : instrumentChaineCarateres :='Batterie';
          violon : instrumentChaineCarateres :='Violon';
          kazoo : instrumentChaineCarateres :='Kazoo';
          synthetiseur:instrumentChaineCarateres :='Synthétiseur';
     end;
     InstrumentMusicien:=instrumentChaineCarateres;
end;


////////////////////////////////////////////////////////////////////////
//renvoi le style du musicien en entrée sous forme de chaine de caratères
function StyleMusicien(musicien : typeMusicien) : string;
var
   styleChaineCarateres :string;
begin
     case (musicien.style) of
          heavyMetal : styleChaineCarateres := 'Heavy Metal';
          powerMetal : styleChaineCarateres := 'Power Metal';
          symphonique : styleChaineCarateres := 'Symphonique';
          grooveMetal : styleChaineCarateres := 'Groove Metal';
     end;
     StyleMusicien:=styleChaineCarateres;
end;

////////////////////////////////////////////////////////////////////////
//renvoi l'activité du musicien en entrée sous forme de chaine de caratères
function ActiviteMusicien (musicien:typeMusicien) : string;
var
   activiteChaineCarateres:string;
begin
     case (musicien.activite) of
          repos : activiteChaineCarateres := 'Se repose';
          entrainement : activiteChaineCarateres := 's''entraine';
          promotion : activiteChaineCarateres := 'Fait la promo du groupe';
          ecritChanson : activiteChaineCarateres := 'Ecrit une chanson';
          enregistreAlbum : activiteChaineCarateres := 'Enregistre un album';
          concert : activiteChaineCarateres := 'Est en concert';
          malade : activiteChaineCarateres:='Est malade';
     end;
     ActiviteMusicien:=activiteChaineCarateres;
end;
//////////////////////////////////////////////////////////////////////////
//Renvoi un instrument (chaine de caratères) à partir d'un entier
function choixInstrument(entierAleatoire : integer) : typeInstrument;
var
   instrument : typeInstrument;
begin
     case (entierAleatoire) of
          1 : instrument := vocal  ;        //dans le cas ou entierAleatoire=1, cela renvoi vocal
          2 : instrument := guitare  ;      //dans le cas ou entierAleatoire=2, cela renvoi guitare
          3 : instrument := basse  ;        //dans le cas ou entierAleatoire=3, cela renvoi basse
          4 : instrument := batterie  ;     //dans le cas ou entierAleatoire=4, cela renvoi batterie
          5 : instrument := violon  ;       //dans le cas ou entierAleatoire=5, cela renvoi violon
          6 : instrument := kazoo;          //dans le cas ou entierAleatoire=6, cela renvoi kazoo
          7 : instrument := synthetiseur;   //dans le cas ou entierAleatoire=7, cela renvoi synthetiseur
     end;
     choixInstrument := instrument;
end;
//////////////////////////////////////////////////////////////////////////
//Renvoi le style (chaine de caratère) à partir d'un entier
function choixStyle(entierAleatoire : integer) : typeStyle;
var
   style : typeStyle;
begin
     case (entierAleatoire) of
          1 : style := heavyMetal  ;     //dans le cas ou entierAleatoire=1, cela renvoi heavyMetal
          2 : style := powerMetal  ;     //dans le cas ou entierAleatoire=2, cela renvoi powerMetal
          3 : style := symphonique  ;    //dans le cas ou entierAleatoire=3, cela renvoi symphonique
          4 : style := grooveMetal  ;    //dans le cas ou entierAleatoire=4, cela renvoi grooveMetal

     end;
     choixStyle := style;
end;

//////////////////////////////////////////////////////////////////////////
//Renvoi un Nom (prenom + nom de famille)(chaine de caratère) à partir d'un entier aléatoire
function choixNom(entierAleatoire : integer) :string;
var
   nom : string;
begin
     case (entierAleatoire) of
            1 : nom := 'Elodie Bidon';     //dans le cas ou entierAleatoire=1, cela renvoi Joris Bouteille
            2 : nom := 'Matthieu Simonet';     //dans le cas ou entierAleatoire=2, cela renvoi Franck Franck
            3 : nom := 'N''Golo Kanté';
            4 : nom := 'Nordine Banane';    // ETC ...
            5: nom := 'Hugh Jasse';
            6: nom := 'Pascal Lazarus';
            7: nom := 'Stéphane Auquinne';
            8 : nom := 'Jéreme Mouille';
            9 : nom := 'Franck Frankk';
            10: nom := 'Joris Bouteille';
            11: nom := 'Mike Oxlong';
            12: nom := 'Olivier Sykes';
            13: nom := 'Gérard Wouais';
            14: nom := 'Keurt Kobain';
            15: nom := 'Katarina Bérant';
            16: nom := 'Tatiana Schmayluk';
            17: nom := 'Marc Iniosse';
            18:nom := 'Angelo Ladébrouille';
            19: nom := 'Karine Serier';
            20: nom := 'Franck Marzani';
            21 : nom :='Elio Perlmangay';
            22: nom :='Bigflo é''Oli';
            23:nom:='Nicolas Sarkozy';
            24:nom:='Nicolas Raisin';
            25:nom:='Tom Egerie';
            26:nom:='Andre Matos';
            27: nom :='Asser Deces';
            28: nom :='Brigitte Macron ';
            29: nom :='Jean Bonbeurre';
            30: nom :='Charles Attends';
     end;
     choixNom := nom;
end;
////////////////////////////////////////////////////////////////////////
//Permet de generer un entier aléatoire entre 2 valeur (min et max) en entrée
function genererEntierAleatoire (min,max : integer) :integer;

begin
     genererEntierAleatoire := (random(max-min+1)+min);
end;

////////////////////////////////////////////////////////////////////////
//Permet de créer un musicien avec des stats aléatoires en indiquant sont nom et prénom en entrée
function creationMusicien():typeMusicien;
var
   musicien :typeMusicien;    // variable de travaille contenant le musicien à renvoyer au programme appelant
begin


  musicien.nom:=choixNom(genererEntierAleatoire(1,30)); //Generation d'un nom aléatoire parmis la liste créée dans choixNom
  musicien.instrument:= choixInstrument(genererEntierAleatoire(1,7)); //Generation d'un instrument aléatoire parmis l'énumération des instruments
  musicien.style:= choixStyle(genererEntierAleatoire(1,4)); //Generation d'un style de musique aléatoire parmis l'énumération des styles
  musicien.nivInstrument:= genererEntierAleatoire(1,5); //Generation d'un niveau d'instrument aléatoire entre 1 et 5
  musicien.nivStudio:=genererEntierAleatoire(1,5); //Generation d'un niveau au studio aléatoire entre 1 et 5
  musicien.nivConcert:= genererEntierAleatoire(1,5); //Generation d'un niveau pendant les concert aléatoire entre 1 et 5
  musicien.maxEndurance:= genererEntierAleatoire(8,20)*10; //Generation aléatoire de l'endurance  maximal entre 50 et 200
  musicien.endurance:=musicien.maxEndurance; //initialisation de l'endurance actuel du musicien à son maximum
  musicien.salaire:=genererEntierAleatoire(12,100)*100; //Generation d'un niveau d'instrument aléatoire entre 1200 et 10000
  musicien.activite := repos;  //affectation de l'activité par défaut (Repos)
  musicien.nombreEntrainement:=0; //Initialisation du nombre d'entrainement à 0

  creationMusicien := musicien;

end;
////////////////////////////////////////////////////////////////////////
//Permet d'afficher toutes les caractéristiques d'un "musicien" (variable d'entrer)
procedure afficherMusicien (musicien:typeMusicien);
begin
  writeln(
  'Nom : ',musicien.nom,#10,
  'Instrument : ',musicien.instrument,#10,
  'Niveau Studio : ',musicien.nivStudio,#10,
  'Niveau Concert : ',musicien.nivConcert,#10,
  'Endurance : ',musicien.endurance,'/',musicien.maxEndurance,#10,
  'Salaire : ',musicien.salaire,#10,
  'Activité : ',musicien.activite,#10);
end;

end.


