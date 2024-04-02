unit unitGestionGroupeLogic;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UnitMusicienLogic;

////////////////////////////////////////////////////////////////////
//----- TYPES -----
type
  typeGroupe=array [1..5] of typeMusicien;
  typeTableauRecrutement=array [1..7] of typeMusicien;
  typeMaxEndurance=array[1..5] of integer;


////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

//Permet de changer l'activité du chanteur en "Ecrit une chanson" et commence le compteur d'écriture
procedure ecrireChanson();

//Appelé quand l'écriture d'une chanson est terminée (compteur écriture chanson > durée écriture chanson)
//Ajoute une chanson au nombre total de chansons du groupe et modifie l'activité du chanteur en repos
procedure ecritureChansonTerminee();

// Permet au groupe d'enregistrer un album (nécessite 10 chansons non-utilisées), dure plusieurs mois (entre 3 et 4)
procedure enregistrerUnAlbum();

//Ajoute de la renommée générée pour chaque musicien qui fait la promo
procedure faitPromoDuGroupe ();


//Gestion de l'endurance des musiciens (la dimininue lors des activités) et gère la maladie des musiciens
procedure gestionEndurance();



///////////////////////////////////////////////////////////////////////////
//procédures argent

//argent rapporté chaque mois par les albums
procedure gainsAlbum();

// Rentrées d'argent dans la cagnotte après un concert
procedure gainsConcert();

//Paye des musiciens chaque année/////////////////////////////////////////////////////////////
procedure salaireAnnuelMusicien();

//réinitialisation de la paye
procedure ReiniSalaire();

///////////////////////////////////////////////////////////////////////////
//procédures tableau recrutement/groupe

//Renvoie une place disponible dans le tableau du groupe
function trouvePlaceDispo ():integer;

//Recrute le musicien avec son numéro
procedure recruterMusicien(choix:integer);

//Permet de récupérer un musicien avec son numéro
function getMusicienGroupe(numeroMusicien:integer):typeMusicien;

//Permet de modifier l'activité d'un musicien (saisir le musicien et sa nouvelle activité)
procedure changerActiviteMusicien(numMusicien:integer;nouvelleActivite:typeActivite);

//Renvoie un musicien
procedure renvoyerMusicien(choix:integer);

//Création du tableau de recrutement des musiciens
function creationTableauRecrutement():typeTableauRecrutement;

//Vérification que le groupe soit valide (1 chanteur + 1 batteur + nombre de musiciens = 5) (S'affiche si le groupe n'est pas valide)
procedure verificationGroupeValide();

///////////////////////////////////////////////////////////////////////////
//procédures concert

//Appelé quand le joueur lance un concert
procedure faitConcert();

//Appelé quand le compteur de concert depasse la duree du concert
procedure concertTerminee();



///////////////////////////////////////////////////////////////////////////
//procédures d'initialisation

//Initialisation en début de partie des variables de l'unité gestiongroupe
procedure initialisationDebutPartieGestionGroupe();

//Initialisation du tableauGroupe en le remplissant de placeDispo
procedure initialisationTableauGroupe();



///////////////////////////////////////////////////////////////////////////
//Gère le compteur (l'augmente s'il est actif + vérifie que les conditions de l'évènement soit respectées)
procedure gestionCompteurChanson();
procedure gestionCompteurConcert();
procedure gestionCompteurAlbum();

//Ensemble de fonctions "get" qui renvoient la variable associé

function getNombreChanson():integer;
function getNombreChansonUtilise():integer;
function getNombreAlbum():integer;
function getRenommee():integer;
function getCagnotte():integer;
function getCompteurMoisEcritureChanson ():integer;
function getCompteurMoisEnregistrementAlbum(): integer;
function getCompteurConcert():integer;
function getDureeEnregistrementAlbum():integer;
function getDureeEcritureChanson():integer;
function getPlaceDispo():typeMusicien;
function getTableauRecrutement():typeTableauRecrutement;
function getTableauGroupe():typeGroupe;
function getMusicienRecrutement():typeMusicien;
function getRenommeeGeneree():integer;
function getActifCompteurMoisEcrireChanson():boolean;
function getActifCompteurMoisEnregistrementAlbum():boolean;
function getActifCompteurMoisConcert():boolean;
function getArgentAlbum():integer;
function getArgentConcert():integer;
function getSalairePayeMusicien():integer;
function getEstGroupeValide():boolean;
function getNombreConcert():integer;
function getMusicienVocal():integer;
//Ensemble de fonction "add" qui ajoutent aux variables associées

procedure addCompteurMoisEcritureChanson(var compteurMoisEcritureChanson:integer);
procedure addRenommee (min,max,pas:integer;var renommee:integer);
procedure addCompteurConcert(var compteurConcert:integer);
procedure addNombreChanson(var nombreChanson:integer);
procedure addNombreAlbum(var nombreAlbum:integer);
procedure addCompteurMoisEnregistrementAlbum(var compteurMoisEnregistrementAlbum:integer);

//Ajoute la renommée générée par les musiciens a la renommée du groupe
procedure addRenommeeGeneree ();



implementation

uses UnitMenuPrincipalIHM;
////////////////////////////////////////////////////////////////////
//----- VARIABLES -----
var
  //Variable affichées dans le jeu
  nombreChanson:integer;             //nombre total de chansons du groupe
  nombreAlbum:integer;               //nombre d'albums du groupe
  nombreConcert:integer;             //nombre de concerts effectués
  renommee:integer;                   //renommée du groupe
  cagnotte:integer;                    //Cagnotte au début du jeu
  argentConcert:integer;               //Argent gagné a la fin du concert
  argentAlbum:integer;                 //Argent gagné chaque mois par la vente d'albums
  salairePayeMusicien : integer;       //salaire donné aux musiciens

  //Variables de travail

  nombreChansonUtilise:integer;      //nombre de chanson déjà utilisées dans un album

  compteurMoisEnregistrementAlbum:integer; //Compteur indiquant depuis combien de mois le groupe crée son album
  compteurMoisEcritureChanson:integer;     //Compteur indiquant depuis combien de mois le chanteur ecrit sa chanson

  actifCompteurMoisEnregistrementAlbum:boolean; //Indique si le compteur est actif (true) donc s'il faut l'augmenter de 1 a la fin du mois
  actifCompteurMoisEcrireChanson:boolean;      //Indique si le compteur est actif (true) donc s'il faut l'augmenter de 1 a la fin du mois
  actifCompteurMoisConcert:boolean;          //Indique si le compteur est actif (true) donc s'il faut l'augmenter de 1 a la fin du mois
  estGroupeValide : boolean;           // indique si le groupe est valide (1 chanteur et au moins un batteur et 5 personne dedans)

  compteurConcert:integer;                 //Compteur indiquant depuis combien de mois le groupe est en concert
  dureeEcritureChanson:integer;            //Durée de l'écriture d'une chanson générée aléatoirement entre 1 et 2 mois
  dureeEnregistrementAlbum:integer;        //Durée de l'enregistrement d'un album générée aléatoirement entre 3 et 4 mois

  placeDispo:typeMusicien;                 //Variable indiquant que la place dans le tableauGroupe est disponible
  tableauRecrutement:typeTableauRecrutement; //Tableau des 7 musiciens recrutables dans le menu recrutement
  tableauGroupe:typeGroupe;                //Tableau contenant les musiciens recrutés (et/ou les places Disponibles)
  musicienRecrutement:typeMusicien;        //Musicien recrutable
  renommeeGeneree : integer;               //Promotion générée ce mois


//////////////////////////////////////////////////////////////
//Ensemble de fonction "get" qui renvoient la variable associé

function getNombreChanson():integer;
begin
  getNombreChanson:=nombreChanson;
end;

function getNombreChansonUtilise():integer;
begin
  getNombreChansonUtilise:=nombreChansonUtilise;
end;

function getNombreAlbum():integer;
begin
  getNombreAlbum:=nombreAlbum;
end;

function getRenommee():integer;
begin
  getRenommee:=renommee;
end;

function getCagnotte():integer;
begin
  getCagnotte:=cagnotte;
end;

function getCompteurMoisEcritureChanson ():integer;
begin
  getCompteurMoisEcritureChanson:=compteurMoisEcritureChanson;
end;

function getCompteurMoisEnregistrementAlbum(): integer;
begin
  getCompteurMoisEnregistrementAlbum:=compteurMoisEnregistrementAlbum;
end;

function getCompteurConcert():integer;
begin
  getCompteurConcert:=compteurConcert;
end;

function getDureeEcritureChanson():integer;
begin
  getDureeEcritureChanson:=dureeEcritureChanson;
end;

function getDureeEnregistrementAlbum():integer;
begin
  getDureeEnregistrementAlbum:=dureeEnregistrementAlbum;
end;

function getPlaceDispo():typeMusicien;
begin
  getPlaceDispo:=placeDispo;
end;

function getTableauRecrutement():typeTableauRecrutement;
begin
  getTableauRecrutement:=tableauRecrutement;
end;

function getTableauGroupe():typeGroupe;
begin
  getTableauGroupe:=tableauGroupe;
end;

function getMusicienRecrutement():typeMusicien;
begin
  getMusicienRecrutement:=musicienRecrutement;
end;

function getRenommeeGeneree():integer;
begin
  getRenommeeGeneree:=renommeeGeneree;
end;

function getActifCompteurMoisEcrireChanson():boolean;
begin
  getActifCompteurMoisEcrireChanson:=actifCompteurMoisEcrireChanson;
end;

function getActifCompteurMoisEnregistrementAlbum():boolean;
begin
  getActifCompteurMoisEnregistrementAlbum:=actifCompteurMoisEnregistrementAlbum;
end;

function getActifCompteurMoisConcert():boolean;
begin
  getActifCompteurMoisConcert:=actifCompteurMoisConcert;
end;

function getArgentAlbum():integer;
begin
  getArgentAlbum:=argentAlbum;
end;

function getArgentConcert():integer;
begin
  getArgentConcert:=argentConcert;
end;

function getSalairePayeMusicien():integer;
begin
  getSalairePayeMusicien:=salairePayeMusicien;
end;

function getEstGroupeValide():boolean;
begin
  getEstGroupeValide:=estGroupeValide;
end;

function getNombreConcert():integer;
begin
  getNombreConcert:=nombreConcert;
end;

/////////////////////////////////////////////////////////////////////////////////////
//---------------- PROCEDURES ADD ------------------------

//Ajoute 1 au compteur du nombre d'album
procedure addCompteurMoisEnregistrementAlbum(var compteurMoisEnregistrementAlbum:integer);
begin
     compteurMoisEnregistrementAlbum+=1;
end;

//Ajoute un album au nombre d'album
procedure addNombreAlbum(var nombreAlbum:integer);
begin
     nombreAlbum+=1;
end;

//Ajoute un album au nombre d'album
procedure addNombreChanson(var nombreChanson:integer);
begin
     nombreChanson+=1;
end;

//////////////////////////////////////////////////////////////////////////////
//Initialise le musicien placeDispo en lui affectant un nom vide pour le distinguer des autres musiciens
procedure initialisationPlaceDispo();
begin
     placeDispo.nom:='';
end;

//////////////////////////////////////////////////////////////////////////////
//Initialisation du tableauGroupe en le remplissant de placeDispo
procedure initialisationTableauGroupe();
var
  i:integer; //Variable boucle
begin
  for i:=1 to 5 do
      begin
        tableauGroupe[i]:=placeDispo;
      end;
end;

//////////////////////////////////////////////////////////////////////////////
//Création du tableau de recrutement des musiciens
function creationTableauRecrutement():typeTableauRecrutement;
var
  i:integer; //Variable boucle
begin
  for i:=1 to 7 do
      begin
        musicienRecrutement:=creationMusicien();
        tableauRecrutement[i]:=musicienRecrutement;
      end;
  creationTableauRecrutement:=tableauRecrutement;
end;


//////////////////////////////////////////////////////////////////////////////
//Initialisation en début de partie des variables de l'unité gestiongroupe
procedure initialisationDebutPartieGestionGroupe();
begin
nombreChanson:=0;    //nombre de chanson du groupe
nombreChansonUtilise:=0; // nombre de chanson utilise dans un album
nombreAlbum:=0;      //nombre d'album du groupe
nombreConcert:=0;    //nombre de concert effectué
renommee:=0;          //renommée du groupe
cagnotte:= 1000000;  //Cagnotte au début du jeu
actifCompteurMoisEcrireChanson:=false; //Aucune écriture de chanson au debut du jeu
actifCompteurMoisEnregistrementAlbum:=false;   //Aucun enregistrement d'album au debut du jeu
compteurMoisEcritureChanson:=0; //Aucun musicien écrit de chanson au début du jeu
compteurMoisEnregistrementAlbum:=0; //Personne n'enregistre d'album au début du jeu
compteurConcert:=0; // Le compteur de concert est à 0
initialisationTableauGroupe(); //Initialisation du tableauGroupe en le remplissant de placeDispo
initialisationPlaceDispo(); //Initialisation des placeDispo en leur supprimant leur nom pour les reconnaitre
argentAlbum:=0;  //argent obtenu grâce au albums vendus (initialement à 0)
argentConcert:=0;   //argent obtenu grâce aux concerts (initialement à 0)
salairePayeMusicien:=0;  //argent que chaaque musicien perçoit grâce à son salaire (initialement à 0)
estGroupeValide:=false; //De base le groupe n'est pas valide car pas complet
end;

///////////////////////////////////////////////////////////////////////////////////////
//Permet de modifier l'activite d'un musicien (saisir le musicien et sa nouvelle activité)
procedure changerActiviteMusicien(numMusicien:integer;nouvelleActivite:typeActivite);
begin
  tableauGroupe[numMusicien].activite := nouvelleActivite;
end;

///////////////////////////////////////////////////////////////////////////////////////
//Renvoie une place disponible dans le tableau du groupe
function trouvePlaceDispo ():integer;
var
  i:integer; //Variable boucle
begin
  i:=1;
  while (i<6) and (not(tableauGroupe[i].nom = placeDispo.nom)) do   //Tant que nous somme dans le tableau (<6) et que la place n'est pas dispo (<> place dispo)
        i+=1;   // on passe à la prochaine case du tableau
  trouvePlaceDispo:=i;  //Renvoi la premiere place dispo trouvée
end;

//////////////////////////////////////////////////////////////////////////////
//Recrute le musicien avec son numéro dans le tableau de recrutement
procedure recruterMusicien(choix:integer);
var
  positionPlaceDispo:integer;
begin
  positionPlaceDispo:=trouvePlaceDispo();
  if positionPlaceDispo>=6 then
  else  tableauGroupe[positionPlaceDispo]:= tableauRecrutement[choix];      //Affecte un musicien depuis le tableaurecrutement au tableau du groupe dans une case dispon
end;

//////////////////////////////////////////////////////////////////////////////
//Renvoie un musicien
procedure renvoyerMusicien(choix:integer);
begin
  //Si le musicien fait une tache longue( enregistre album, chanson, ou concert) alors il ne peut pas être renvoyé
  tableauGroupe[choix]:=placeDispo;
end;

//////////////////////////////////////////////////////////////////////////////
//Permet de récupérer un musicien avec son numéro
function getMusicienGroupe(numeroMusicien:integer):typeMusicien;
begin
  getMusicienGroupe:=tableauGroupe[numeroMusicien];
end;

///////////////////////////////////////////////////////////////////////////////
//Permet de récupérer un chanteur avec son numéro
function getMusicienVocal():integer;
var
  i:integer;
begin
  i:=1;
  while (i<6) and ( (tableauGroupe[i].instrument) <> (vocal) ) do i+=1;
  if tableauGroupe[i].instrument=vocal then getMusicienVocal:=i;     //renvoie la case du tableau dans laquelle est le chanteur
end;


////////////////////////////////////////////////////////////////////////////////////
//Genere de la renommée pour chaque musicien qui fait la promo
procedure faitPromoDuGroupe ();
var
  i:integer;
begin
for i:=1 to 5 do
    begin
     if tableauGroupe[i].activite=promotion then          //si un musicien parmi les 5 fait de la promotion alors la renommée augmente d'un nombre aléatoire entre 50 et 100
     renommeeGeneree+=genererEntierAleatoire(50,100);
    end;

end;

//Appelé quand l'écriture d'une chanson est terminé (compteur ecriture chanson > duree ecriture chanson)
//Ajoute une chanson au nombre total de chanson du groupe et modifie l'activite du chanteur en repos
procedure ecritureChansonTerminee();
begin

  nombreChanson+=1;
  tableauGroupe[getMusicienVocal()].activite:=repos;
  actifCompteurMoisEcrireChanson:=false;

end;

//////////////////////////////////////////////////////////////////////////////////
//Permet de changer l'activité du chanteur en "Ecrit une chanson"
procedure ecrireChanson();

begin
    begin
      changerActiviteMusicien(getMusicienVocal(),ecritChanson);
      dureeEcritureChanson:= genererEntierAleatoire(1,2);        //l'écriture d'une chanson dure entre 1 et deux mois
      actifCompteurMoisEcrireChanson:=true;
    end
end;

//////////////////////////////////////////////////////////////////////////////////
// Permet au groupe d'enregistrer un album (nécessite 10 chansons non-utilisées)
procedure enregistrerUnAlbum();
var
  i:integer; //Variable de boucle de 1 a 5 (taille du tableau du groupe)
begin
    for i:=1 to 5 do
        begin
          if (tableauGroupe[i].activite=repos) and (nombreChanson-nombreChansonUtilise>=10) then
          nombreChansonUtilise+=10;
          changerActiviteMusicien(i,enregistreAlbum);
          dureeEnregistrementAlbum:= genererEntierAleatoire(3,4);        //dure plusieurs mois (entre 3 et 4)
          actifCompteurMoisEnregistrementAlbum:=True;
        end
end;

/////////////////////////////////////////////////////////////////////////////////////
//Ajoute 1 au compteur du concert
procedure addCompteurConcert(var compteurConcert:integer);
begin
  compteurConcert+=1;
end;

/////////////////////////////////////////////////////////////////////////////////////
//Ajoute de la renommee (Exemple: (1,2,10 = nombre aléatoire entre 10 et 20)
procedure addRenommee (min,max,pas:integer;var renommee:integer);
begin
  renommee+=genererEntierAleatoire(min,max)*pas;
end;
/////////////////////////////////////////////////////////////////////////////////////
//Ajoute 1 au compteur du nombre d'album
procedure addCompteurMoisEcritureChanson(var compteurMoisEcritureChanson:integer);
begin
     compteurMoisEcritureChanson+=1;
end;



/////////////////////////////////////////////////////////////////////////////////////
//Appelé quand l'enregistrement d'un album est terminé
//Ajoute un album au nombre total d'album du groupe et modifie l'activite des musiciens en repos
procedure enregistrementAlbumTerminee();
var
  i:integer; //Variable de boucle de 1 a 5 (taille du tableau du groupe)
begin

  for i:=1 to 5 do tableauGroupe[i].activite:=repos;
  nombreAlbum+=1;
end;

//////////////////////////////////////////////////////////////////////
//Gestion de l'endurance des musiciens (la dimininue lors des activités) et gère la maladie des musiciens
procedure gestionEndurance();
var
  i : integer;  //variable de boucle
  tabMaxEndurance:typeMaxEndurance; //Tableau de l'endurance maximal de chaque musicien
begin
   //Permet d'affecter les endurances maximales de chaques musiciens dans le tableau
   for i:=1 to 5 do
       begin
         tabMaxEndurance[i]:=tableauGroupe[i].maxEndurance;
       end;

      //Si le musicien n'est pas malade il peut alors effectuer des activités
      for i:=1 to 5 do
          begin
            if tableauGroupe[i].activite <> malade  then
             begin
              //Chaque acitivité fait perdre une certaine quantité d'endurance
              //L'activité "repos" met l'endurance au maximum
               case (tableauGroupe[i].activite) of
                 entrainement: tableauGroupe[i].endurance -= 20;      //L'entrainement fait perdre 20 d'endurance
                 promotion: tableauGroupe[i].endurance -= 10;         //Faire la promotion du groupe fait perdre 10 d'endurance
                 ecritChanson: tableauGroupe[i].endurance -= 15;      //Ecrire une chanson fait perdre 15 d'endurance
                 enregistreAlbum: tableauGroupe[i].endurance -= 20;  //Enregistrer un album fait perdre 20 d'endurance
                 concert: tableauGroupe[i].endurance -= 25;           //Faire un concert fait perdre 25 d'endurance
                 repos: tableauGroupe[i].endurance :=tabMaxEndurance[i];    //Se reposer met l'endurance au maximum (recupere l'endurance max dans le tableau créer précédément)
               end;
             end

          //Si le musicien est malade
          //La durée de la maladie perd 1 à chaque tour durant lequel le musicien est malade
            else if tableauGroupe[i].activite=malade then //Si la durée atteint 0 la maladie est considéré finit il est au repos
              begin
                tableauGroupe[i].dureeMaladie-=1;
                if tableauGroupe[i].dureeMaladie=0 then
                   begin
                     tableauGroupe[i].activite:=repos;
                     tableauGroupe[i].endurance:=tabMaxEndurance[i];
                   end;
              end;

      //Si l'endurance du musicien est inférieur ou égale à 0 et qu'il n'étais pas déjà malade alors celui devient malade
            if (tableauGroupe[i].endurance<=0) and ((tableauGroupe[i].activite)<>(malade)) then
               begin
                 tableauGroupe[i].activite:=malade; //Le musicien devient malade
                 tableauGroupe[i].dureeMaladie:=genererEntierAleatoire(2,4);  // on genere une durée de maladie entre 2 et 4 mois
               end;
            end;
end;

//////////////////////////////////////////////////////
//Appelé quand le joueur lance un concert
procedure faitConcert();
var
  i:integer; //variable de boucle
begin                                                    //gère tout le foctionnement des concerts (La durée, le changement d'activité et le gain de renommée et d'argent
       for i:=1 to 5 do                                  //change l'activité de chacun des membres du groupe
          begin
               tableauGroupe[i].activite:=concert;
          end;
       actifCompteurMoisConcert:=true;
end;

//////////////////////////////////////////////////////////////////////////
//Appelé quand le compteur de concert depasse la duree du concert
procedure concertTerminee();
 var
  i:integer; //variable de boucle
 begin
  for i:=1 to 5 do
      begin
           tableauGroupe[i].activite:=repos;
      end;

  renommee+=genererEntierAleatoire(1,4)*100;       //rajoute à la renommée un nombre aléatoire entre 100 et 400
  gainsConcert();                                  //renvoie vers une fonction qui gère les gains d'argent générés par le concert
  argentConcert:=0;
  nombreConcert+=1;

 end;

///////////////////////////////////////////////////////////////////////////
//Gère le compteur (l'augmente s'il est actif, verifie que les conditions de l'événement soit respectées)
procedure gestionCompteurChanson();
begin
    //Si une ecriture de chanson est en cours alors augmente le compteur
  if actifCompteurMoisEcrireChanson=true then
     begin
       compteurMoisEcritureChanson+=1;
       //Si le compteur dépasse la durée d'écriture de la chanson, alors execute la procedure de fin d'écriture
       if compteurMoisEcritureChanson> dureeEcritureChanson then
          begin
             actifCompteurMoisEcrireChanson:=false;
             ecritureChansonTerminee();
          end;
     end;
end;



///////////////////////////////////////////////////////////////////////////
//Gère le compteur (l'augmente s'il est actif, verifie que les conditions de l'événement soit respectées)
procedure gestionCompteurAlbum();
begin
 //Si un enregistrement d'album est en cours alors augmente le compteur
  if actifCompteurMoisEnregistrementAlbum=true then
     begin
       compteurMoisEnregistrementAlbum+=1;
       //Si le compteur dépasse la durée d'enregistrement d'album, alors execute la procedure de fin d'album
       if compteurMoisEnregistrementAlbum > dureeEnregistrementAlbum then
          begin
             actifCompteurMoisEnregistrementAlbum:=false;
             enregistrementAlbumTerminee;
          end;
     end;
end;


///////////////////////////////////////////////////////////////////////////
//Gère le compteur (l'augmente s'il est actif, verifie que les conditions de l'événement soit respectées)
procedure gestionCompteurConcert();
begin
    // Si un concert un en cours = augmente le compteur
  if actifCompteurMoisConcert=true then
     begin
       compteurConcert+=1;
       if compteurConcert > 3 then      //Si le compteur dépasse la durée de du concert alors execute la procedure de fin du concert
          begin
             actifCompteurMoisConcert:=false;
             concertTerminee();
          end;
     end;
end;
///////////////////////////////////////////////////////
// Rentrées d'argent dans la cagnotte grâce aux albums
procedure gainsAlbum();
begin
    if renommee<600 then argentAlbum:= (random(250)+750)*nombreAlbum          //Si la renomee est inférieure à 600, les gains rapportés par les albums seront un nombre aléatoire entre 750 et 1000$ fois le nombre d'albums sortis
    else if (renommee>=600) AND (renommee<1000) then argentAlbum:= genererEntierAleatoire(800,1100)*nombreAlbum          //Si la renomee est entre 600 et 1000, les gains rapportés par les albums seront un nombre aléatoire entre 800 et 1100 fois le nombre d'albums sortis
    else if (renommee>=1000) AND (renommee<2000) then argentAlbum:=genererEntierAleatoire(1000,1500)*nombreAlbum        //etc....
    else if (renommee>=2000) AND (renommee<3000) then argentAlbum:= genererEntierAleatoire(1400,2100)*nombreAlbum
    else if (renommee>=3000) AND (renommee<4000) then argentAlbum:=genererEntierAleatoire(1800,2700)*nombreAlbum
    else if (renommee>=4000) AND (renommee<5000) then argentAlbum:= genererEntierAleatoire(2200,3300)*nombreAlbum
    else if (renommee>=5000) AND (renommee<6000) then argentAlbum:= genererEntierAleatoire(2600,3900)*nombreAlbum
    else if (renommee>=6000) then argentAlbum:= genererEntierAleatoire(3000,4500)*nombreAlbum;
    cagnotte:=cagnotte+argentAlbum;
 end;// argentAlbum à remmettre à zéro chaque mois

///////////////////////////////////////////////////////
// Rentrées d'argent dans la cagnotte après un concert
procedure gainsConcert();
begin
   if renommee<600 then argentConcert:= (genererEntierAleatoire(750,1000))               //Si la renomee est inférieure à 600, les gains rapportés par les concert seront un nombre aléatoire entre 750 et 1000$
    else if (renommee>=600) AND (renommee<1000) then argentConcert:=(genererEntierAleatoire(1000,1250))    //Si la renomee est entre 600 et 1000, les gains rapportés par les albums seront un nombre aléatoire entre 1000 et 1250$
    else if (renommee>=1000) AND (renommee<2000) then argentConcert:=(genererEntierAleatoire(2000,2450))
    else if (renommee>=2000) AND (renommee<3000) then argentConcert:=(genererEntierAleatoire(5000,5720))     //etc...
    else if (renommee>=3000) AND (renommee<4000) then argentConcert:=(genererEntierAleatoire(10000,11800))
    else if (renommee>=4000) AND (renommee<5000) then argentConcert:=(genererEntierAleatoire(20000,203100))
    else if (renommee>=5000) AND (renommee<6000) then argentConcert:=(genererEntierAleatoire(26000,26520))
    else if (renommee>=6000) then argentConcert:= genererEntierAleatoire(30000,7000);
    cagnotte+=argentConcert;
end;

///////////////////////////////////////////////////////////////
//ajoute un entrainement au compteur si le musicien s'est entrainé
procedure addNombreEntrainements(var tableauGroupe:typeGroupe);
var
 i:integer;
  begin
   for i:=1 to 5 do
    if tableauGroupe[i].activite=entrainement then tableauGroupe[i].nombreEntrainement+=1;
  end;


///////////////////////////////////////////////////////////////
//Gère l'évolution du niveau d'instrument des musiciens
procedure evolutionNivInstrument(var tableauGroupe:typeGroupe);
var
 i:integer;
begin
  for i:=1 to 5 do
  begin
    case tableauGroupe[i].nivInstrument of
      1..2 : if (tableauGroupe[i].nombreEntrainement)=4 then        //si un musicien de niveau 1 ou 2 a fait 4 entrainements, il gagne un point de niveau
      begin
        tableauGroupe[i].nivInstrument+=1;
        tableauGroupe[i].nombreEntrainement:=0
      end;
      3 : if tableauGroupe[i].nombreEntrainement=6 then           //si un musicien de niveau 3 a fait 6 entrainements, il gagne un point de niveau
       begin
        tableauGroupe[i].nivInstrument+=1;
        tableauGroupe[i].nombreEntrainement:=0
       end;
      4 : if tableauGroupe[i].nombreEntrainement=8 then          //si un musicien de niveau 4 a fait 8 entrainements, il gagne un point de niveau
        begin
          tableauGroupe[i].nivInstrument+=1;
          tableauGroupe[i].nombreEntrainement:=0
        end;
      end;
  end;
end;

///////////////////////////////////////////////////////////////
//Paye des musiciens chaque année
procedure salaireAnnuelMusicien();
var
   i:integer;
begin
    for i:=1 to 5 do  salairePayeMusicien:=salairePayeMusicien+tableaugroupe[i].salaire;  //Tous les mois, on ajoute le salaire mensuel du musicien au nombre d'argent que l'on doit lui payer en fin d'année

end;

///////////////////////////////////////////////////////////////
//réinitialisation de la paye à 0
procedure ReiniSalaire();
begin
  cagnotte:=cagnotte-salairePayeMusicien;
  salairePayeMusicien:=0;
end;

///////////////////////////////////////////////////////////////
//Ajoute la renomme générée par les musiciens a la renommée du groupe
procedure addRenommeeGeneree ();
begin
  renommee+=renommeeGeneree;
  renommeeGeneree:=0;
end;

///////////////////////////////////////////////////////////////
//Verification que le groupe soit valide (1 chanteur + 1 batteur + nombre de musiciens = 5) (S'affiche si le groupe n'est pas valide)
procedure verificationGroupeValide();
var
  i:integer;
  vocalExiste,batterieExiste:integer;
begin
//initialisation
 vocalExiste:=0;
 batterieExiste:=0;
 tableauGroupe:=getTableauGroupe();

 ///////////////////////////////////////////////////////////////
 //si le programme trouve un batteur ou un chanteur alors le compteur augmente d'1
 for i:=1 to 5 do
     begin
       if tableauGroupe[i].instrument = vocal then vocalExiste+=1;
       if tableauGroupe[i].instrument = batterie then batterieExiste+=1;
     end;

 if (vocalExiste<>1) or (batterieExiste<1) //vérifie si il y a un nombre de musicien vocal autre que 1 (nécessaire) et moins d'un batteur (minimum nécessaire)
 or (tableauGroupe[1].nom='')
 or ( tableauGroupe[2].nom='')
 or ( tableauGroupe[3].nom='')
 or ( tableauGroupe[4].nom='')            //test si il manque un ou plusieurs musiciens au groupe
 or (tableauGroupe[5].nom='') then
 begin
   estGroupeValide:=false;
   affichageCadreValide();  //dans le cas où un des test précédents est vrai alors on renvoie le cadre de groupe invalide
 end

 else estGroupeValide:=true;
end;

end.

