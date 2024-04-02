unit UnitMenuPrincipalIHM;

{$mode objfpc}{$H+}
{$codepage utf8}

interface
uses
    GestionEcran,sysUtils, UnitMenuPrincipalLogic, unitGestionGroupeLogic, UnitMusicienLogic, UnitGestionTempsLogic;

////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

//Affiche le jeu
procedure affichageJeu();

//Affichage du résumé des chansons et des albums, concerts
procedure affichageResume();

//Affichage des choix d'action possible
procedure affichageChoixActionMenuPrincipal();

//Afficher le menu de recrutement dans le jeu
procedure affichageJeuRecrutement();

//Affiche le cadre contenant la liste des musiciens à recruter
procedure affichageJeuDetailsMusiciens();

//Afficher le menu du planning des musiciens
procedure affichageJeuPlanningMusiciens();

//Affiche le cadre avec la validation du groupe
procedure affichageCadreValide();

//Afficher le bilan de chaque mois
procedure affichageJeuBilan();

//procédure qui affiche les variables des musiciens dans le cadre (soit les choix du joueur)
procedure affichageInfoMusicienCadre();

//procédure qui affiche les variables des musiciens dans le cadre du recrutement
procedure affichageInfoMusicienRecrutement();

//renvoi l'activité du musicien en entrée sous forme de chaine de caratères
function affichageActiviteMusicien(musicien:typeMusicien) : string;

//Permet d'afficher toutes les caractéristiques d'un "musicien" (variable d'entrer)
procedure afficherMusicien (x, y: Integer; musicien:typeMusicien);

//Affiche un écran game over si le joueur a perdu la partie (0 d'argent)
procedure affichageGameOver(hauteur:integer);

//procédure qui affiche les variables des musiciens dans le cadre de la liste des details des musiciens
procedure affichageInfoMusicienDetails();

//Affiche le menu avec les différentes actions possibles sur le groupe de musicien dans le planning
procedure affichageChoixPlanningMusiciens();

implementation


uses UnitMenuInitialLogic;
////////////////////////////////////////////////////////////////////
//----- VARIABLES -----
var
  choix:integer;         //variables contenant le choix du joueur

////////////////////////////////////////////////////////Affichage des données////////////////////////////////////////////
//renvoi l'activité du musicien en entrée sous forme de chaine de caratères
function affichageActiviteMusicien (musicien:typeMusicien) : string;
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
     affichageActiviteMusicien:=activiteChaineCarateres;
end;

//Permet d'afficher toutes les caractéristiques d'un "musicien" (variable d'entrer)
procedure afficherMusicien (x,y : integer ; musicien:typeMusicien);
begin
     if(musicien.nom <> '') then
           begin
           deplacerCurseurXY(x, y);
           write('Prénom Nom  : ',musicien.nom, #10);
           deplacerCurseurXY(x, y+1);
           write('Instrument  : ',musicien.instrument, #10);
           deplacerCurseurXY(x, y+2);
           write('Endurance   : ',musicien.endurance,'/',musicien.maxEndurance,#10);
           deplacerCurseurXY(x, y+4);
           write('Activité    : ',affichageActiviteMusicien(musicien),#10);
           end;
end;
////////////////////////////////////////////////////////////Cadre principal///////////////////////////////////////////////
//Affiche le cadre avec la date, l'argent, et la renommée
procedure affichageCadreStat();
begin
     dessinerCadreXY(150,0,230,4, double, White, Black);
     deplacerCurseurXY(159,2);
     write(getMoisActuel(),'    ',getAnneeActuel());
     deplacerCurseurXY(181,2);
     write('ARGENT : ',getCagnotte());
     deplacerCurseurXY(207,2);
     write('RENOMMEE : ', getRenommee());
end;

//Affiche les choix d'actions dans le menu principal du jeu (navigation entre pages)
procedure affichageChoixActionMenuPrincipal();
begin
     couleurTexte(Cyan);
     deplacerCurseurXY(85,2);
     write('-- ECRAN PRINCIPAL --');
     couleurTexte(White);
     deplacerCurseurXY(58,35);
     write('1 - Recruter un nouveau musicien ');
     deplacerCurseurXY(58,36);
     write('2 - Info détaillées sur les musiciens du groupe');
     deplacerCurseurXY(58,37);
     write('3 - Définir le planning des musiciens pour ce mois');
     deplacerCurseurXY(58,39);
     write('4 - Finir le mois');
     couleurTexte(LightCyan);
     deplacerCurseurXY(58,43);
     write('Choix : ');
     couleurTexte(White);
end;

//Affiche le resumé des chansons, albums, concerts... présent sur l'écran principal du jeu
procedure affichageResume();
begin
     deplacerCurseurXY(61,15);
     write('Nombres de chansons non publiées : ',getNombreChanson());
     deplacerCurseurXY(70,17);
     write('Nombres d''albums sortis : ',getNombreAlbum());
     deplacerCurseurXY(67,19);
     write('Nombres de concerts donnés : ',getNombreConcert());
end;

////////////////////////////////////////////////////////////Cadre liste des musiciens recruté///////////////////////////////
//Affiche le cadre avec la liste des musiciens vierge
procedure affichageCadreListeMusiciens();
begin
     //grand cadre
     dessinerCadreXY(0,0,40,50, double, White, Black);
     //cadre pour musicien
     dessinerCadreXY(0,4,40,14, simple, White, Black);
     dessinerCadreXY(0,14,40,23, simple, White, Black);
     dessinerCadreXY(0,23,40,32, simple, White, Black);
     dessinerCadreXY(0,32,40,41, simple, White, Black);
     dessinerCadreXY(0,41,40,50, simple, White, Black);
     //cadre de titre
     dessinerCadreXY(0,0,40,5, double, White, Black);
     //sous cadre de présentation
     dessinerCadreXY(0,4,7,5, double, White, Black);
     //Titre de liste
     dessinerCadreXY(34,4,40,5, double, White, Black);
     deplacerCurseurXY(11,2);
     write('LISTE DES MUSICIENS');
     //Correction des pixel manquant sur les colonnes
     deplacerCurseurXY(40,14);
     write(chr(180));
     deplacerCurseurXY(40,23);
     write(chr(180));
     deplacerCurseurXY(40,32);
     write(chr(180));
     deplacerCurseurXY(40,41);
     write(chr(180));
     deplacerCurseurXY(0,14);
     write(chr(195));
     deplacerCurseurXY(0,23);
     write(chr(195));
     deplacerCurseurXY(0,32);
     write(chr(195));
     deplacerCurseurXY(0,41);
     write(chr(195));
     couleurTexte(White);

     //Affichage des informations contenue dans le tableau crée
     affichageInfoMusicienCadre();
end;

//procédure qui affiche les variables des musiciens dans le cadre (soit les choix du joueur)
procedure affichageInfoMusicienCadre();
var
  i:integer; //variable boucle
begin
     for i:=1 to 5 do
     begin
       afficherMusicien(3, 7+((i-1)*9),getTableauGroupe()[i]);
     end;
end;

///////////////////////////////////////////////////////////////Cadre recrutement//////////////////////////////////
//Affiche le cadre contenant la liste des musiciens à recruter vierge
procedure affichageRecrutement();
begin
     couleurTexte(Cyan);
     deplacerCurseurXY(85,2);
     write('-- RECRUTEMENT DES MUSICIENS --');
     couleurTexte(White);
     //Cadre lignes
     dessinerCadreXY(58,11,212,15, simple, Magenta, Black);
     dessinerCadreXY(58,15,212,19, simple, Magenta, Black);
     dessinerCadreXY(58,19,212,23, simple, Magenta, Black);
     dessinerCadreXY(58,23,212,27, simple, Magenta, Black);
     dessinerCadreXY(58,27,212,31, simple, Magenta, Black);
     dessinerCadreXY(58,31,212,35, simple, Magenta, Black);
     dessinerCadreXY(58,35,212,39, simple, Magenta, Black);
     //Cadre colonnes
     dessinerCadreXY(62,7,109,39, simple, Magenta, Black);
     dessinerCadreXY(109,7,124,39, simple, Magenta, Black);
     dessinerCadreXY(124,7,138,39, simple, Magenta, Black);
     dessinerCadreXY(138,7,155,39, simple, Magenta, Black);
     dessinerCadreXY(155,7,172,39, simple, Magenta, Black);
     dessinerCadreXY(172,7,188,39, simple, Magenta, Black);
     dessinerCadreXY(188,7,200,39, simple, Magenta, Black);
     dessinerCadreXY(200,7,212,39, simple, Magenta, Black);
     //Retracer les lignes entières
     dessinerCadreXY(58,11,212,11, simple, Magenta, Black);
     dessinerCadreXY(58,15,212,15, simple, Magenta, Black);
     dessinerCadreXY(58,19,212,19, simple, Magenta, Black);
     dessinerCadreXY(58,23,212,23, simple, Magenta, Black);
     dessinerCadreXY(58,27,212,27, simple, Magenta, Black);
     dessinerCadreXY(58,31,212,31, simple, Magenta, Black);
     dessinerCadreXY(58,35,212,35, simple, Magenta, Black);
     //retrace les bordure de lignes droite
     couleurTexte(Magenta);
     deplacerCurseurXY(58,11);
     write(chr(218));
     deplacerCurseurXY(58,15);
     write(chr(195));
     deplacerCurseurXY(58,19);
     write(chr(195));
     deplacerCurseurXY(58,23);
     write(chr(195));
     deplacerCurseurXY(58,27);
     write(chr(195));
     deplacerCurseurXY(58,31);
     write(chr(195));
     deplacerCurseurXY(58,35);
     write(chr(195));
     deplacerCurseurXY(62,11);
     write(chr(193));
     //Retrace les lignes de bordure
     deplacerCurseurXY(109,7);
     write(chr(194));
     deplacerCurseurXY(124,7);
     write(chr(194));
     deplacerCurseurXY(138,7);
     write(chr(194));
     deplacerCurseurXY(155,7);
     write(chr(194));
     deplacerCurseurXY(172,7);
     write(chr(194));
     deplacerCurseurXY(188,7);
     write(chr(194));
     deplacerCurseurXY(200,7);
     write(chr(194));
     //Retrace les lignes de bordure du bas
     deplacerCurseurXY(62,39);
     write(chr(193));
     deplacerCurseurXY(109,39);
     write(chr(193));
     deplacerCurseurXY(124,39);
     write(chr(193));
     deplacerCurseurXY(138,39);
     write(chr(193));
     deplacerCurseurXY(155,39);
     write(chr(193));
     deplacerCurseurXY(172,39);
     write(chr(193));
     deplacerCurseurXY(188,39);
     write(chr(193));
     deplacerCurseurXY(200,39);
     write(chr(193));
     deplacerCurseurXY(212,39);
     write(chr(217));
     //Retrace les lignes de bordure du bas
     deplacerCurseurXY(212,11);
     write(chr(180));
     deplacerCurseurXY(212,15);
     write(chr(180));
     deplacerCurseurXY(212,19);
     write(chr(180));
     deplacerCurseurXY(212,23);
     write(chr(180));
     deplacerCurseurXY(212,27);
     write(chr(180));
     deplacerCurseurXY(212,35);
     write(chr(180));
     couleurTexte(White);
     //Titre de colonne
     deplacerCurseurXY(79,9);
     write('PRENOM NOM');
     deplacerCurseurXY(112,9);
     write('INSTRUMENT');
     deplacerCurseurXY(129,9);
     write('STYLE');
     deplacerCurseurXY(142,9);
     write('NIV INSTRU');
     deplacerCurseurXY(159,9);
     write('NIV STUDIO');
     deplacerCurseurXY(175,9);
     write('NIV CONCERT');
     deplacerCurseurXY(190,9);
     write('ENDURANCE');
     deplacerCurseurXY(203,9);
     write('SALAIRE');
     //Titre des lignes
     deplacerCurseurXY(60,13);
     write('1');
     deplacerCurseurXY(60,17);
     write('2');
     deplacerCurseurXY(60,21);
     write('3');
     deplacerCurseurXY(60,25);
     write('4');
     deplacerCurseurXY(60,29);
     write('5');
     deplacerCurseurXY(60,33);
     write('6');
     deplacerCurseurXY(60,37);
     write('7');
     //Texte de choix
     deplacerCurseurXY(58,42);
     write('X - Recruter le musicien');
     deplacerCurseurXY(58,44);
     write('0 - Revenir au menu principal');
     deplacerCurseurXY(90,42);
     write('9 - Actualiser les musiciens');
     couleurTexte(LightCyan);
     deplacerCurseurXY(58,48);
     write('Choix : ');
     couleurTexte(White);
end;

//procédure qui affiche les variables des musiciens dans le cadre de la liste des musiciens
procedure affichageInfoMusicienRecrutement();
var
  i,x:integer; //variable boucle
  tableauRecrutement:typeTableauRecrutement;
begin
     tableauRecrutement:=creationTableauRecrutement();
     x:=9;
     for i:=1 to 7 do
         begin
         deplacerCurseurXY(75,x+(i*4));
         write(tableauRecrutement[i].nom);
         changerColonneCurseur(113);
         write(InstrumentMusicien(tableauRecrutement[i]));
         changerColonneCurseur(126);
         write(StyleMusicien(tableauRecrutement[i]));
         changerColonneCurseur(146) ;
         write(tableauRecrutement[i].nivInstrument);
         changerColonneCurseur(163);
         write(tableauRecrutement[i].nivStudio);
         changerColonneCurseur(180);
         write(tableauRecrutement[i].nivConcert);
         changerColonneCurseur(192);
         write(tableauRecrutement[i].endurance);
         changerColonneCurseur(203);
         write(tableauRecrutement[i].salaire);
         end;
     deplacerCurseurXY(66,48);
end;

///////////////////////////////////////////////////////////////////////Cadre infos détaillées//////////////////////////////
//Affiche le cadre contenant la liste des musiciens recruté en détails
procedure affichageDetailsMusiciens();
begin
     couleurTexte(Cyan);
     deplacerCurseurXY(85,2);
     write('-- DETAILS SUR LES MUSICIENS --');
     couleurTexte(White);
     //Cadre lignes de base
     dessinerCadreXY(58,11,212,15, simple, Magenta, Black);
     dessinerCadreXY(58,15,212,19, simple, Magenta, Black);
     dessinerCadreXY(58,19,212,23, simple, Magenta, Black);
     dessinerCadreXY(58,23,212,27, simple, Magenta, Black);
     dessinerCadreXY(58,27,212,31, simple, Magenta, Black);
     //Cadre colonnes par dessus les lignes
     dessinerCadreXY(62,7,109,31, simple, Magenta, Black);
     dessinerCadreXY(109,7,124,31, simple, Magenta, Black);
     dessinerCadreXY(124,7,138,31, simple, Magenta, Black);
     dessinerCadreXY(138,7,155,31, simple, Magenta, Black);
     dessinerCadreXY(155,7,172,31, simple, Magenta, Black);
     dessinerCadreXY(172,7,188,31, simple, Magenta, Black);
     dessinerCadreXY(188,7,200,31, simple, Magenta, Black);
     dessinerCadreXY(200,7,212,31, simple, Magenta, Black);
     //Retracer les lignes entières
     dessinerCadreXY(58,11,212,11, simple, Magenta, Black);
     dessinerCadreXY(58,15,212,15, simple, Magenta, Black);
     dessinerCadreXY(58,19,212,19, simple, Magenta, Black);
     dessinerCadreXY(58,23,212,23, simple, Magenta, Black);
     dessinerCadreXY(58,27,212,27, simple, Magenta, Black);
     dessinerCadreXY(58,31,212,31, simple, Magenta, Black);
     //retrace les bordure de lignes droite
     couleurTexte(Magenta);
     deplacerCurseurXY(58,11);
     write(chr(218));
     deplacerCurseurXY(58,15);
     write(chr(195));
     deplacerCurseurXY(58,19);
     write(chr(195));
     deplacerCurseurXY(58,23);
     write(chr(195));
     deplacerCurseurXY(58,27);
     write(chr(195));
     deplacerCurseurXY(58,31);
     write(chr(192));
     //Retrace les lignes de bordure
     deplacerCurseurXY(109,7);
     write(chr(194));
     deplacerCurseurXY(124,7);
     write(chr(194));
     deplacerCurseurXY(138,7);
     write(chr(194));
     deplacerCurseurXY(155,7);
     write(chr(194));
     deplacerCurseurXY(172,7);
     write(chr(194));
     deplacerCurseurXY(188,7);
     write(chr(194));
     deplacerCurseurXY(200,7);
     write(chr(194));
     //Retrace les lignes de bordure du bas
     deplacerCurseurXY(62,31);
     write(chr(193));
     deplacerCurseurXY(109,31);
     write(chr(193));
     deplacerCurseurXY(124,31);
     write(chr(193));
     deplacerCurseurXY(138,31);
     write(chr(193));
     deplacerCurseurXY(155,31);
     write(chr(193));
     deplacerCurseurXY(172,31);
     write(chr(193));
     deplacerCurseurXY(188,31);
     write(chr(193));
     deplacerCurseurXY(200,31);
     write(chr(193));
     deplacerCurseurXY(212,31);
     write(chr(217));
     //Retrace les lignes de bordure du bas
     deplacerCurseurXY(212,11);
     write(chr(180));
     deplacerCurseurXY(212,15);
     write(chr(180));
     deplacerCurseurXY(212,19);
     write(chr(180));
     deplacerCurseurXY(212,23);
     write(chr(180));
     deplacerCurseurXY(212,27);
     write(chr(180));
     couleurTexte(White);
     //Titre de colonne
     deplacerCurseurXY(79,9);
     write('PRENOM NOM');
     deplacerCurseurXY(112,9);
     write('INSTRUMENT');
     deplacerCurseurXY(129,9);
     write('STYLE');
     deplacerCurseurXY(142,9);
     write('NIV INSTRU');
     deplacerCurseurXY(159,9);
     write('NIV STUDIO');
     deplacerCurseurXY(175,9);
     write('NIV CONCERT');
     deplacerCurseurXY(190,9);
     write('ENDURANCE');
     deplacerCurseurXY(203,9);
     write('SALAIRE');
     //Titre des lignes
     deplacerCurseurXY(60,13);
     write('1');
     deplacerCurseurXY(60,17);
     write('2');
     deplacerCurseurXY(60,21);
     write('3');
     deplacerCurseurXY(60,25);
     write('4');
     deplacerCurseurXY(60,29);
     write('5');
     //Texte de choix
     deplacerCurseurXY(58,42);
     write('X - Renvoyer le musicien');
     deplacerCurseurXY(58,44);
     write('0 - Revenir au menu principal');
     couleurTexte(LightCyan);
     deplacerCurseurXY(58,48);
     write('Choix : ');
     couleurTexte(White);
end;

//procédure qui affiche les variables des musiciens du groupe dans le cadre de la liste des details des musiciens
procedure affichageInfoMusicienDetails();
var
  i,x:integer; //variable boucle
  tableauGroupe:typeGroupe;
begin
     tableauGroupe:=getTableauGroupe();
     x:=9;
     for i:=1 to 5 do
         begin
         if(tableauGroupe[i].nom <> '') then
           begin
           deplacerCurseurXY(75,x+(i*4));
           write(tableauGroupe[i].nom);
           changerColonneCurseur(113);
           write(InstrumentMusicien(tableauGroupe[i]));
           changerColonneCurseur(126);
           write(StyleMusicien(tableauGroupe[i]));
           changerColonneCurseur(146) ;
           write(tableauGroupe[i].nivInstrument);
           changerColonneCurseur(163);
           write(tableauGroupe[i].nivStudio);
           changerColonneCurseur(180);
           write(tableauGroupe[i].nivConcert);
           changerColonneCurseur(192);
           write(tableauGroupe[i].endurance);
           changerColonneCurseur(203);
           write(tableauGroupe[i].salaire);
           end;
         end;
     deplacerCurseurXY(66,48);
end;

//////////////////////////////////////////////////////////////Cadre planning des musiciens///////////////////////////////////
//Affiche le menu avec les différentes actions possibles sur le groupe de musicien dans le planning
procedure affichageChoixPlanningMusiciens();
var
  tableauGroupe:typeGroupe;
begin
     tableauGroupe:=getTableauGroupe();
     couleurTexte(Cyan);
     deplacerCurseurXY(85,2);
     write('-- PLANNING DES MUSICIENS --');
     couleurTexte(White);
     //PLanifier une action pour le groupe
     couleurTexte(Cyan);
     deplacerCurseurXY(54,9);
     write('PLANIFIER UNE ACTION POUR LE GROUPE');
     couleurTexte(White);
     deplacerCurseurXY(57,10);
     write('1 - Ecrire une nouvelle chanson');
     deplacerCurseurXY(57,11);
     write('2 - Enregistrer un album');
     deplacerCurseurXY(57,12);
     write('3 - Partir en concert');
     //Planifier une action pour le premier musicien
     couleurTexte(Cyan);
     deplacerCurseurXY(54,19);
     write('PLANIFIER UNE ACTION POUR ',tableauGroupe[1].nom);
     couleurTexte(White);
     deplacerCurseurXY(57,20);
     write('4 - Se reposer');
     deplacerCurseurXY(57,21);
     write('5 - S''entrainer');
     deplacerCurseurXY(57,22);
     write('6 - Faire la promotion du groupe');
     //Planifier une action pour le deuxième musicien
     couleurTexte(Cyan);
     deplacerCurseurXY(54,27);
     write('PLANIFIER UNE ACTION POUR ', tableauGroupe[2].nom);
     couleurTexte(White);
     deplacerCurseurXY(57,29);
     write('7 - Se reposer');
     deplacerCurseurXY(57,30);
     write('8 - S''entrainer');
     deplacerCurseurXY(57,31);
     write('9 - Faire la promotion du groupe');
     //Planifier une action pour le troisième musicien
     couleurTexte(Cyan);
     deplacerCurseurXY(54,35);
     write('PLANIFIER UNE ACTION POUR ', tableauGroupe[3].nom);
     couleurTexte(White);
     deplacerCurseurXY(57,36);
     write('10 - Se reposer');
     deplacerCurseurXY(57,37);
     write('11 - S''entrainer');
     deplacerCurseurXY(57,38);
     write('12 - Faire la promotion du groupe');
     //Planifier une action pour le quatrième musicien
     couleurTexte(Cyan);
     deplacerCurseurXY(154,19);
     write('PLANIFIER UNE ACTION POUR ', tableauGroupe[4].nom);
     couleurTexte(White);
     deplacerCurseurXY(157,20);
     write('13 - Se reposer');
     deplacerCurseurXY(157,21);
     write('14 - S''entrainer');
     deplacerCurseurXY(157,22);
     write('15 - Faire la promotion du groupe');
     //Planifier une action pour le cinquième musicien
     couleurTexte(Cyan);
     deplacerCurseurXY(154,27);
     write('PLANIFIER UNE ACTION POUR ', tableauGroupe[5].nom);
     couleurTexte(White);
     deplacerCurseurXY(157,28);
     write('16 - Se reposer');
     deplacerCurseurXY(157,29);
     write('17 - S''entrainer');
     deplacerCurseurXY(157,30);
     write('18 - Faire la promotion du groupe');
     //Affichage global de choix
     deplacerCurseurXY(54,42);
     write('0 - Retour à lécran principal');
     couleurTexte(LightCyan);
     deplacerCurseurXY(61,47);
     write('Choix : ');
     couleurTexte(White);
end;

/////////////////////////////////////////////////////////////////Bilan du mois///////////////////////////////////////////////
//IHM du bilan (que les infos relatives au bilan)
procedure affichageBilan();
var
  i,y: integer;
begin
     //Affichage du bilan du mois/année actuel
     couleurTexte(Cyan);
     deplacerCurseurXY(82,3);
     write('-- BILAN DE ',getMoisActuel,' ',getAnneeActuel,' --');
     couleurTexte(White);

     //Affichage du bilan des musiciens, leurs activités effectués et les gains de renommée
     dessinerCadreXY(51,13,219,25,simple,Magenta,black);
     couleurTexte(Cyan);
     deplacerCurseurXY(57,13);
     write(' BILAN DES MUSICIENS : ');
     couleurTexte(White);
     deplacerCurseurXY(61,15);
     y:=15;
     //Boucle qui affiche le musicien puis son activité et passe au suivant
     for i:=1 to 5 do
         begin
              if(getTableauGroupe()[i].nom<>'')then
               begin
                    case (getTableauGroupe()[i].activite) of
                       repos: write(getTableauGroupe()[i].nom,' s''est bien reposé(e) et est maintenant en pleine forme');
                       entrainement : write(getTableauGroupe()[i].nom,' s''est entrainé');
                       promotion : write(getTableauGroupe()[i].nom,' a fait la promo');
                       ecritChanson: write(getTableauGroupe()[i].nom,' écrit le nouveau tube de l''année');
                       enregistreAlbum: write(getTableauGroupe()[i].nom,' a participé à la réalisation d''un superbe album');
                       concert : write(getTableauGroupe()[i].nom,' donne tout sur scène');
                       malade : write(getTableauGroupe()[i].nom,' vomit ses tripes, il devrait aller voir l''infirmière Joelle');
                    end;
               y+=2;
               deplacerCurseurXY(61,y);
               end;

         end;

     //Affichage du bilan financier
     dessinerCadreXY(51,31,219,39,simple,Magenta,black);
     couleurTexte(Cyan);
     deplacerCurseurXY(57,31);
     write(' BILAN FINANCIER : ');
     couleurTexte(White);
     deplacerCurseurXY(59,33);
     write('La vente des albums a rapporté ',getArgentAlbum(),' $ ce mois-ci');
     deplacerCurseurXY(59,35);
     write('Les concerts vous ont rapporté ', getArgentConcert(),' $');
     if (getMoisActuel())=Decembre then
       begin
     deplacerCurseurXY(59,37);
     write('Le salaire des membres du groupe est de ',getSalairePayeMusicien(),' $');
       end;

     //Affichage de passage au mois suivant
     couleurTexte(LightCyan);
     deplacerCurseurXY(109,47);
     write('<< Appuyez sur [entrée] pour passer au mois suivant! >>');
     couleurTexte(White);
end;

///////////////////////////////////////////////////////Messages d'erreurs///////////////////////////////////////////////////////////
//Affiche le cadre avec la validation du groupe (s'affiche si le groupe n'est PAS valide)
procedure affichageCadreValide();
begin
     dessinerCadreXY(149,33,227,41, simple, Magenta, Black);
     deplacerCurseurXY(177,35);
     write('-- Groupe non-valide --');
     deplacerCurseurXY(170,37);
     write('Le groupe doit comporter 5 membres !');
     deplacerCurseurXY(164,38);
     write('Le groupe doit comporter exactement un chanteur !');
     deplacerCurseurXY(165,39);
     write('Le groupe doit comporter au moins un batteur !');
end;

/////////////////////////////////////////////////////////Affichages globaux dans le jeux/////////////////////////////////////////////
//Afficher le jeu (écran principal)
procedure affichageJeu();
begin
     //Affichage du cadre principal
     effacerEcran();
     affichageCadreStat();
     verificationGroupeValide();
     affichageCadreListeMusiciens();
     //Affichage du menu principal du jeu
     affichageResume();
     affichageChoixActionMenuPrincipal();
     menuPrincipal(choix);
     readln(choix);

end;
//Afficher le menu de recrutement dans le jeu
procedure affichageJeuRecrutement();

begin
     //Affichage du cadre principal
     effacerEcran();
     affichageCadreStat();
     affichageCadreListeMusiciens();
     //Affichage du menu de recrutement
     affichageRecrutement();
     affichageInfoMusicienRecrutement();
     menuRecrutement(choix);
     readln(choix);
end;
//Afficher le menu de details des musiciens du groupe
procedure affichageJeuDetailsMusiciens();
begin
     //Affichage du cadre principal
     effacerEcran();
     affichageCadreStat();
     affichageCadreListeMusiciens();
     //Affichage du menu des détails des musiciens
     affichageDetailsMusiciens();
     affichageInfoMusicienDetails();
     menuDetailsMusiciens(choix);
end;

//Afficher le menu du planning des musiciens
procedure affichageJeuPlanningMusiciens();
begin
     //Affichage du cadre principal
     effacerEcran();
     affichageCadreStat();
     affichageCadreListeMusiciens();
     //Affichage du menu de planning des musiciens
     affichageChoixPlanningMusiciens();
     menuChoixPlanningMusiciens(choix);
     readln(choix);
end;

//Afficher le bilan de chaque mois
procedure affichageJeuBilan();
begin
     effacerEcran();
     affichageCadreStat();
     affichageCadreListeMusiciens();

     //Affichage du bilan et passage au mois suivant
     affichageBilan();

     passerMois();
     readln;
     affichageJeu();
end;

//Affiche un écran game over si le joueur a perdu la partie (0 d'argent) et renvoi au menu initial
procedure affichageGameOver(hauteur:integer);
begin
     effacerEcran;
     deplacerCurseurXY(0,hauteur);
     write('                                                                                         ____    _    __  __ _____    _____     _______ ____',#10,'                                                                                        / ___|  / \  |  \/  | ____|  / _ \ \   / / ____|  _ \',#10,'                                                                                       | |  _  / _ \ | |\/| |  _|   | | | \ \ / /|  _| | |_) |',#10,'                                                                                       | |_| |/ ___ \| |  | | |___  | |_| |\ V / | |___|  _ <',#10,'                                                                                        \____/_/   \_\_|  |_|_____|  \___/  \_/  |_____|_| \_\',#10);
     readln();
     menuInitial();
end;

end.
