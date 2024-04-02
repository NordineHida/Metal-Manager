unit UnitTestUnitaireMusicienEtGroupe;
//Tests de l'unit UnitMusicienLogic
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils , TestUnitaire, UnitMusicienLogic, unitGestionGroupeLogic;

procedure test();

implementation

/////////////////////////////////////////////////////////////////////////////
//Test  de la génération d'entier de la fonction genererEntierAleatoire
procedure genererEntierAleatoire_test();
begin
     newTestsSeries('Génération d''entier aléatoire') ;

     newTest('Génération d''entier aléatoire','Création d''un entier entre un min et un max');
     testIsEqual((genererEntierAleatoire(1,3)>=1) and (genererEntierAleatoire(1,3)<=3 ));  //On prend 1 et 3 comme exemple

end;

/////////////////////////////////////////////////////////////////////////////
//Test des affectations de valeur de la function creationMusicien
procedure creationMusicien_test();
var
  musicienTest :typeMusicien;
begin
     newTestsSeries('Création d''un musicien') ;

     newTest('Création d''un musicien','Affectation d''une endurance aléatoire entre 50 et 200'); //Vérification que l'endurance du musicien
     musicienTest := creationMusicien();                                             //est comprise entre 50 et 200
     testIsEqual((musicienTest.endurance>=50) and (musicienTest.endurance<=200));

     newTest('Création d''un musicien','Affectation d''un salaire entre 1200 et 10 000');  //Vérification que le salaire du musicien
     musicienTest := creationMusicien();                                   //est compris entre 1200 et 10 000
     testIsEqual((musicienTest.salaire>=1200) and (musicienTest.salaire<=10000));

     newTest('Création d''un musicien','Affectation d''une instrument aléatoire');
     musicienTest := creationMusicien();
     testIsEqual((musicienTest.instrument=vocal) or (musicienTest.instrument=guitare)  //Vérification que l'instrument du musicien fait
     or (musicienTest.instrument=basse)or(musicienTest.instrument=batterie) or         //partie de la liste des instruments créée
     (musicienTest.instrument=violon) or (musicienTest.instrument=kazoo) or
     (musicienTest.instrument=synthetiseur));

     newTest('Création d''un musicien','Affectation d''un style aléatoire');
     musicienTest := creationMusicien();
     testIsEqual((musicienTest.style=heavyMetal) or (musicienTest.style=powerMetal)  //Vérification que le style du musicien fait
     or (musicienTest.style=symphonique) or (musicienTest.style=grooveMetal));       //partie de la liste des styles créée
end;

/////////////////////////////////////////////////////////////////////////////
//Test de création d'un groupe de musicien, de recrutement et de renvoi
procedure GroupeMusicien_test();
var
  tableauGroupeTest :typeGroupe;
  i :integer;
  valider:boolean;
  placeDispo:typeMusicien;
  ContientUnMusicien:boolean;
  NumeroMusicienRandom:integer;
  vocalExiste,batterieExiste:integer;
begin
     newTestsSeries('Création et manipulation d''un groupe de musicien') ;

     newTest('Création et manipulation d''un groupe de musicien','Création d''un tableau de musicien vide');
     placeDispo.nom:='';
     //Initialisation du groupe
     for i:=1 to 5 do
      begin
        tableauGroupeTest[i]:=placeDispo;
      end;
     //initialisation booleen de vérification
     valider:=true;
     i:=1;
     //Verification que tout les musiciens sont des musiciens sans nom (place dispo)
     while (i<6) and (valider=true) do
       begin
         if tableauGroupeTest[i].nom<>'' then valider:=false;
         i+=1;
       end;
     testIsEqual(valider);


     newTest ('Création et manipulation d''un groupe de musicien','Chercher une place libre');
     i:=1;
     while (i<6) and (not(tableauGroupeTest[i].nom = placeDispo.nom)) do i+=1;
     testIsEqual((i>=1) or (i<=5));

     newTest('Création et manipulation d''un groupe de musicien','Recruter un musicien');

     NumeroMusicienRandom:=genererEntierAleatoire(1,5);
     recruterMusicien(NumeroMusicienRandom);
     tableauGroupeTest:=getTableauGroupe();
     ContientUnMusicien:=true;
     //Boucle de vérification si le tableau contient un musicien après recrutement
     while (i<6) and (ContientUnMusicien=false) do
      begin
        if tableauGroupeTest[i].nom<>'' then ContientUnMusicien:=true;
        i+=1;
      end;
     testIsEqual(ContientUnMusicien);

     newTest('Création et manipulation d''un groupe de musicien','Renvoyer un musicien');
     renvoyerMusicien(NumeroMusicienRandom);
     valider:=true;
     //Verification que tout les musiciens sont des musiciens sans nom (donc que le musicien recruté est été renvoyé)
     while (i<6) and (valider=true) do
       begin
         if tableauGroupeTest[i].nom<>'' then valider:=false;
         i+=1;
       end;
     testIsEqual(valider);

     newTest('Création et manipulation d''un groupe de musicien','Récupérer le chanteur (vocal) du groupe');
     valider:=false;
     //On affecte un chanteur en position 3 pour être sûr qu'il y en ai un à récupérer
     tableauGroupeTest[3]:=creationMusicien();
     tableauGroupeTest[3].instrument:=vocal;
     //On verifie si on retrouve bien la position (3) du chanteur (procedure getMusicienVocal adapté pour le tableauGroupeTest)
     i:=1;
     while (i<6) and ( (tableauGroupeTest[i].instrument) <> (vocal) ) do i+=1;
     if tableauGroupeTest[i].instrument=vocal then valider:=true;
     testIsEqual(valider);

     newTest('Création et manipulation d''un groupe de musicien','Verification que le groupe soit valide');
     valider:=false;
     vocalExiste:=0;
     batterieExiste:=0;
     //Création d'un groupe non valide de test (car il manque un musicien)
     for i:=1 to 5 do
       begin
         tableauGroupeTest[i]:=creationMusicien();
         tableauGroupeTest[2].nom:='';
         tableauGroupeTest[1].instrument:=vocal;
         tableauGroupeTest[3].instrument:=batterie;
       end;

     for i:=1 to 5 do
          begin
            if tableauGroupeTest[i].instrument = vocal then vocalExiste+=1;
            if tableauGroupeTest[i].instrument = batterie then batterieExiste+=1;
          end;
     if (vocalExiste<>1) or (batterieExiste<1) //vérifie si il y a un nombre de musicien vocal autre que 1 (nécessaire) et moins d'un batteur (minimum nécessaire)
     or (tableauGroupeTest[1].nom='')
     or ( tableauGroupeTest[2].nom='')
     or ( tableauGroupeTest[3].nom='')
     or ( tableauGroupeTest[4].nom='')            //test si il manque un ou plusieurs musiciens au groupe
     or (tableauGroupeTest[5].nom='') then valider:=true;    //Si le programme detecte que le groupe n'est pas valide, alors le test est valide
     testIsEqual(valider);

end;



//Lance tous les tests
procedure test();
begin
     genererEntierAleatoire_test();
     creationMusicien_test();
     GroupeMusicien_test();

     Summary();
     readln;
end;


end.

