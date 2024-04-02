unit UnitMenuInitialLogic;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----


//Menu Initial (lancement du jeu)
procedure menuInitial();


implementation

uses  Classes, SysUtils,GestionEcran, UnitMenuInitialIHM,UnitMenuPrincipalIHM, UnitGestionTempsLogic, unitGestionGroupeLogic;


/////////////////////////////////////////////////////////////////////
//renvoi a la page pour quitter le jeu
procedure quitter();
begin
   quitterIHM();
end;

//Initialisation en début de partie de toutes les variables
procedure initialisationDebutPartie();
begin
  initialisationDebutPartieGestionGroupe();
  initialisationDebutPartieGestionTemps();

end;

/////////////////////////////////////////////////////////////////////
//Menu Initial (lancement du jeu)
//Si l'user tape 1 : cela affiche le le menu principal du jeu
//Si il tape 2 : cela quitte le jeu
procedure menuInitial();
var
     choix : String;
begin
     changerTailleConsole(231,51);  //IHM EXEPTIONNEL pour changer la taille de la console pour le reste du jeu
     initialisationDebutPartie();

     choix :='';
     repeat
     menuInitialIHM(choix);
     until (choix='1') OR (choix='2');
     if (choix = '1') then affichageJeu()
     else quitter();

end;


end.

