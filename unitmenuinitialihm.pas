unit UnitMenuInitialIHM;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
////////////////////////////////////////////////////////////////////
//----- FONCTION & PROCEDURE -----

{IHM du menu principal, renvoie le choix fait par l'utilisateur et affiche le titre du jeu et un dessin ASCII
1 -> nouvelle partie / 2 -> quitter}
procedure menuInitialIHM(var choix : String);

// Afficher une magnifique guitare en ascii à la hauteur défini en entrée
procedure asciiGuitareElectriqueY(hauteur:integer);

// Afficher le titre du jeu en ascii a la hauteur défini en entrée
procedure asciiMetalManagerY(hauteur:integer);

//Affichage la page quand on quitte le jeu
procedure quitterIHM();

//////////////////////////////////////////////////////////////////////////////////////////////
implementation
uses  Classes, SysUtils, GestionEcran ;

////////////////////////////////////////////////////////////////////////////////// ////////////
// Afficher une magnifique guitare en ascii à la hauteur défini en entrée
procedure asciiGuitareElectriqueY(hauteur:integer);
begin
     deplacerCurseurXY(0,hauteur);
     write('                                        _...',#10,'                                      .`   `',#10,'                                     /    .`',#10,'                                    /    .',#10,'                                   /    .',#10,'                                  /   `',#10,'                                 /   .`',#10,'                                 `.__|',#10,'                                  |  |',#10,'                                  |__|',#10,'                                  |  |',#10,'                                  |__|',#10,'                                  |  |',#10,'                                  |__|',#10,'                                  |  |',#10,'                                  |__|',#10,'                                  |. |',#10,'                                  |--|',#10,'                                  |__|',#10,'                                  |  |',#10,'                                  |--|',#10,'                                  |__|',#10,'                                  |__|        .-.',#10,'                                  |__|`     .`  /',#10,'                             _..-`     `._.` o / ',#10,'                            /     8888        /  ',#10,'                            |                /   ',#10,'                             1              /    ',#10,'                             `L   8888     /     ',#10,'                              |           /      ',#10,'                             /    ====    \      ',#10,'                            /     ____     \     ',#10,'                           /     (____)  o  \    ',#10,'                          /             o    \   ',#10,'                         /             o     .`  ',#10,'                        /               _..`^    ',#10,'                       /        __..-"~^         ',#10,'                      `....--~~^',#10);
end;

//////////////////////////////////////////////////////////////////////////////////////////////
// Afficher le titre du jeu en ascii a la hauteur défini en entree
procedure asciiMetalManagerY(hauteur:integer);
begin
     deplacerCurseurXY(0,hauteur);
     write('                                                   ____    ____  ________  _________     _       _____      ____    ____       _       ____  _____       _        ______  ________  _______',#10,'                                                  |_   \  /   _||_   __  ||  _   _  |   / \     |_   _|    |_   \  /   _|     / \     |_   \|_   _|     / \     .` ___  ||_   __  ||_   __ \',#10,'                                                    |   \/   |    | |_ \_||_/ | | \_|  / _ \      | |        |   \/   |      / _ \      |   \ | |      / _ \   / .`   \_|  | |_ \_|  | |__) |',#10,'                                                    | |\  /| |    |  _| _     | |     / ___ \     | |   _    | |\  /| |     / ___ \     | |\ \| |     / ___ \  | |   ____  |  _| _   |  __ /',#10,'                                                   _| |_\/_| |_  _| |__/ |   _| |_  _/ /   \ \_  _| |__/ |  _| |_\/_| |_  _/ /   \ \_  _| |_\   |_  _/ /   \ \_\ `.___]  |_| |__/ | _| |  \ \_',#10,'                                                  |_____||_____||________|  |_____||____| |____||________| |_____||_____||____| |____||_____|\____||____| |____|`._____.`|________||____| |___|',#10);
end;

/////////////////////////////////////////////////////////////////////////////
{IHM du menu Initial, renvoie le choix fait par l'utilisateur
1 -> nouvelle partie / 2 -> quitter}
procedure menuInitialIHM(var choix : String);
begin
     effacerEcran;  //Efface l'écran
  //Dessin ASCII
  couleurTexte(Cyan);
  asciiMetalManagerY(5);          //Dessine le titre du jeu en ASCII
  couleurTexte(Cyan);
  asciiGuitareElectriqueY(15);    //Dessine une guitare electrique en ASCII
 // dessin



  //Cadre de choix
  dessinerCadreXY(81,33,151,45,double,Magenta,Black);
  couleurTexte(White);
  deplacerCurseurXY(88,36);write('1 - Commencer une nouvelle partie');
  deplacerCurseurXY(88,38);write('2 - Quitter');
  couleurTexte(LightCyan);
  deplacerCurseurXY(88,43);write('Votre choix : ');
  couleurTexte(White);
  readln(choix);
end;


/////////////////////////////////////////////////////////////////////////////
//Affichage la page quand on quitte le jeu
procedure quitterIHM();
begin
     effacerEcran;
     dessinerCadreXY(49,16,182,23,double,Magenta,black);
     deplacerCurseurXY(110,20);write('A Bientôt ! <3');
     readln();

end;

end.

