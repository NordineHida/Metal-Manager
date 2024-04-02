unit UnitGestionTempsLogic;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, unitGestionGroupeLogic, UnitMenuPrincipalLogic;

////////////////////////////////////////////////////////////////////
//----- TYPE -----
type
    typeMoisEnsemble = (Janvier,Fevrier,Mars,Avril,Mai,Juin,Juillet,Aout,Septembre,Octobre,Novembre,Decembre);


////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

//Permet de passer au mois suivant suite au choix du joueur
//Augmente tous les compteurs actifs (ecrire chanson, album, concert, maladie)
procedure passerMois();

//Renvoi l'année actuelle
function getAnneeActuel():integer;

//Renvoi le mois actuel
function getMoisActuel():typeMoisEnsemble;

//Initialisation en début de partie (date = janvier 2022)
procedure initialisationDebutPartieGestionTemps();

//////////////////////////////////////////////////////////////////////////////////////////////
implementation
 ////////////////////////////////////////////////////////////////////
//----- VARIABLES -----
var
   anneeActuel:integer;
   moisActuel: typeMoisEnsemble;
   moisInitial:typeMoisEnsemble;

//////////////////////////////////////////////////////////////////
//Permet d'initialiser l'année a 2022 au debut du jeu
procedure initialisationAnnee();
begin
  anneeActuel:=2022;
end;

//////////////////////////////////////////////////////////////////
//Initialisation du mois à Janvier
procedure initialisationMois();
begin
  MoisInitial := Janvier;
end;


//////////////////////////////////////////////////////////////////
//Permet de passer les mois (janvier --> fevrier,...,decembre --> janvier) augmente aussi les années
procedure moisSuivant(var MoisActuel: typeMoisEnsemble; var anneeActuel:integer);

   begin
     if MoisActuel = Decembre then      //Renvoie à Janvier (le mois initial si on passe le mois après décembre
     begin
       MoisActuel := MoisInitial;
       anneeActuel+=1;
     end
     else
         MoisActuel := succ(MoisActuel);
   end;



//////////////////////////////////////////////////////////////////////////////
//Initialisation en début de partie (date = janvier 2022)
procedure initialisationDebutPartieGestionTemps();
begin
initialisationAnnee(); // Initialisation de l'année à 2022
initialisationMois(); //Initialisation du mois a Janvier
end;

//////////////////////////////////////////////////////////////////////
//Permet de passer au mois suivant suite au choix du joueur
//Augmente tous les compteurs actifs(ecrire chanson, album, concert, maladie)
procedure passerMois();
begin
  //Salaire
  if MoisActuel=Decembre then ReiniSalaire();      //Chaque nouvelle année, on enlève de la cagnotte le salaire annuel du musicien : on l'a payé.
  salaireAnnuelMusicien();


  //Passe au mois suivant et à l'année suivante si on était en décembre
  moisSuivant(MoisActuel,anneeActuel);


  //on augmente ou non les compteurs (actifs ou non)
  gestionCompteurChanson();
  gestionCompteurConcert();
  gestionCompteurAlbum();


  //Verification que le joueur a encore de l'argent (sinon il a perdu)
  verificationPasPerdu();


  gestionEndurance();
  faitPromoDuGroupe();
  //Ajoute la renommée générée par la promo à la renommée total du groupe
  addRenommeeGeneree();


end;

//Fonctions get pour la gestion du temps dans le jeu
//Renvoi l'année actuelle
function getAnneeActuel():integer;
begin
  getAnneeActuel:=anneeActuel;
end;

//Renvoi le mois actuel
function getMoisActuel():typeMoisEnsemble;
begin
  getMoisActuel:=moisActuel;
end;

end.

