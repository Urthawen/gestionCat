-------------PS CREATION PRODUIT
CREATE OR REPLACE PROCEDURE nouveauProduit (p_nomProduit IN Produit.nomProduit%TYPE, p_prixHT IN Produit.prixHT%TYPE, p_quantite IN Produit.quantite%TYPE, p_catalogue IN produit.catalogue%TYPE) IS

BEGIN
	INSERT INTO Produit (idProduit, nomProduit, prixHT, quantite,catalogue)
	VALUES (idProduit_produit_seq.NEXTVAL, p_nomProduit,p_prixHT,p_quantite,p_catalogue);
END;



------------PS AJOUTER QUANTITE
CREATE OR REPLACE PROCEDURE ajouterQuantite (p_nomProduit IN Produit.nomProduit%TYPE, p_quantite IN PRODUIT.quantite%TYPE, p_catalogue IN produit.catalogue%TYPE) IS

BEGIN
	UPDATE Produit set quantite = quantite + p_quantite
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
END;

------------PS ENLEVER QUANTITE
CREATE OR REPLACE PROCEDURE enleverQuantite (p_nomProduit IN Produit.nomProduit%TYPE, p_quantite IN PRODUIT.quantite%TYPE, p_catalogue IN produit.catalogue%TYPE) IS

BEGIN
	UPDATE Produit set quantite = quantite - p_quantite
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
END;


------------FONCTION RECUPERER QUANTITE
CREATE OR REPLACE FUNCTION recupQuantite (p_nomProduit IN Produit.nomProduit%TYPE, p_catalogue IN produit.catalogue%TYPE) RETURN INT IS
v_quantiteProd INT;
BEGIN
	SELECT quantite INTO v_quantiteProd
	FROM PRODUIT
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
	RETURN v_quantiteProd;
END;


------------FONCTION RECUPERER PRIX UNITAIRE HT
CREATE OR REPLACE FUNCTION recupPrixUnitHT (p_nomProduit IN Produit.nomProduit%TYPE, p_catalogue IN produit.catalogue%TYPE) RETURN FLOAT IS
v_prixUnitaire INT;
BEGIN
	SELECT prixHT INTO v_prixUnitaire
	FROM PRODUIT
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
	RETURN v_prixUnitaire;
END;

------------FONCTION RECUPERER PRIX UNITAIRE TTC
CREATE OR REPLACE FUNCTION recupPrixUnitTTC (p_nomProduit IN Produit.nomProduit%TYPE, p_catalogue IN produit.catalogue%TYPE) RETURN FLOAT IS
v_prixUnitaire INT;
BEGIN
	SELECT prixHT*1.2 INTO v_prixUnitaire
	FROM PRODUIT
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
	RETURN v_prixUnitaire;
END;

------------FONCTION RECUPERER PRIX STOCK TTC
CREATE OR REPLACE FUNCTION recupPrixStockTTC (f_idCatalogue IN  Produit.nomProduit%TYPE) RETURN FLOAT IS
v_prixStock INT;
BEGIN
	SELECT SUM(quantite*prixHT*1.2) AS Total INTO v_prixStock
	FROM PRODUIT
	WHERE idCatalogue = f_idCatalogue;
	RETURN v_prixStock;
END;

------------PS CHANGER nomProduit
CREATE OR REPLACE PROCEDURE changernomProduit (p_nomProduit IN Produit.nomProduit%TYPE, p_nouveaunomProduit IN Produit.nomProduit%TYPE, p_catalogue IN produit.catalogue%TYPE) IS

BEGIN
	UPDATE Produit set nomProduit = p_nouveaunomProduit
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
END;
------------PS SUPPRIMER PRODUIT
CREATE OR REPLACE PROCEDURE supprimerProd (p_nomProduit IN Produit.nomProduit%TYPE, p_catalogue IN produit.catalogue%TYPE) IS

BEGIN
	DELETE FROM Produit
	WHERE nomProduit = p_nomProduit AND idCatalogue = p_catalogue;
END;

------------DEC NOM PRODUIT
CREATE OR REPLACE TRIGGER trigNomProduit BEFORE INSERT ON Produit

FOR EACH ROW
DECLARE
	v_nombre INT;
BEGIN
	SELECT COUNT(nomProduit) INTO v_nombre
	FROM Produit
	WHERE nomProduit= :NEW.nomProduit AND catalogue = :NEW.catalogue;
	IF v_nombre = 1 THEN
		RAISE_APPLICATION_ERROR (-20001, 'Ce produit existe déjà dans le catalogue');
	END IF;
END;

--------------INSERTION DE TUPLES
call nouveauProduit('Orange', 2.99, 15, 1);
call nouveauProduit('Pomme', 1.56, 23, 1);
call nouveauProduit('Cerise', 0.56, 18, 1);
call nouveauProduit('Banane', 1.24, 32, 1);
