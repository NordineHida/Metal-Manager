unit UnitMenuPrincipalLogic;

{$mode objfpc}{$H+}

interface
uses unitGestionGroupeLogic;
//Menu principal
procedure menuPrincipal(choix:integer);

//Menu de choix de recrutement
procedure menuRecrutement(choix:integer);

//Menu de choix dans les details des musiciens
procedure menuDetailsMusiciens(choix:integer);

//Menu du choix de planning des musiciens
procedure menuChoixPlanningMusiciens(choix:integer);

//Verifie que le joueur a toujours de l'argent, sinon  --> game over
procedure verificationPasPerdu();

implementation
uses
  UnitMenuPrincipalIHM, Classes, SysUtils, UnitMusicienLogic;

////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

//Affichage du menu principal une fois la partie lancée et choix pour relier les autres pages
procedure menuPrincipal(choix:integer);
begin
  readln(choix);
  if (choix=1) then
     begin
     affichageJeuRecrutement();
     end
  else if (choix = 2) then
     affichageJeuDetailsMusiciens()
  else if (choix= 3) then
     affichageJeuPlanningMusiciens()
  else if (choix= 4) and (getEstGroupeValide()=true)then
     affichageJeuBilan()
  else affichageJeu();
end;

//Menu de choix de recrutement
procedure menuRecrutement(choix:integer);
begin
  readln(choix);
  case (choix) of
       1:begin recruterMusicien(1);  affichageJeuRecrutement();end;
      2:begin recruterMusicien(2);  affichageJeuRecrutement();end;
      3:begin recruterMusicien(3);  affichageJeuRecrutement();end;
      4:begin recruterMusicien(4);  affichageJeuRecrutement();end;
      5:begin recruterMusicien(5);  affichageJeuRecrutement();end;
      6:begin recruterMusicien(6);  affichageJeuRecrutement();end;
      7:begin recruterMusicien(7);  affichageJeuRecrutement();end;
      9:affichageJeuRecrutement();
      0:affichageJeu();
      else affichageJeu();
    end;
end;
//Menu de choix dans les details des musiciens
procedure menuDetailsMusiciens(choix:integer);
begin
  readln(choix);
  case choix of
     0 : affichageJeu();

     1..5 : if (getTableauGroupe[choix].activite <> enregistreAlbum) AND
     (getTableauGroupe[choix].activite<>concert) AND (getTableauGroupe[choix].activite<>ecritChanson) then renvoyerMusicien(choix)
     else affichageJeuDetailsMusiciens();
  end;
  affichageJeuDetailsMusiciens();
end;

//Menu de choix dans les details des musiciens
procedure menuChoixPlanningMusiciens(choix:integer);
begin
  readln(choix);
  case (choix) of
  1:if getTableauGroupe[getMusicienVocal()].activite=repos then ecrireChanson()
  else affichageChoixPlanningMusiciens();
  2:if (getNombreChanson()>=10) then enregistrerUnAlbum()
  else affichageChoixPlanningMusiciens();
  3:if (getNombreAlbum()>=1) then faitConcert()
  else affichageChoixPlanningMusiciens();

  //Activités du musicien 1
  4:changerActiviteMusicien(1,repos);
  5:changerActiviteMusicien(1,entrainement);
  6:changerActiviteMusicien(1,promotion);

  //Activités du musicien 2
   7:changerActiviteMusicien(2,repos);
   8:changerActiviteMusicien(2,entrainement);
   9:changerActiviteMusicien(2,promotion);

    //Activités du musicien 3
  10:changerActiviteMusicien(3,repos);
  11:changerActiviteMusicien(3,entrainement);
  12:changerActiviteMusicien(3,promotion);

    //Activités du musicien 4
  13:changerActiviteMusicien(4,repos);
  14:changerActiviteMusicien(4,entrainement);
  15:changerActiviteMusicien(4,promotion);

    //Activités du musicien 5
  16:changerActiviteMusicien(5,repos);
  17:changerActiviteMusicien(5,entrainement);
  18:changerActiviteMusicien(5,promotion);

    //retour au menu
  0:affichageJeu();
  else affichageJeu();
  end;
  affichageJeuPlanningMusiciens();
end;

//Verifie que le joueur a toujours de l'argent, sinon  --> game over
procedure verificationPasPerdu();
var
  cagnotte:integer;
begin
  cagnotte:=getCagnotte();
 if cagnotte<=0 then affichageGameOver(20);    //si notre cagnotte est à 0 ou en négatif, le jeu s'arrête
end;



end.
