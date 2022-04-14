-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNNUMCREDITOSAVALADOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNNUMCREDITOSAVALADOS`;DELIMITER $$

CREATE FUNCTION `FNNUMCREDITOSAVALADOS`(



    Par_AvalID   BIGINT,
    Par_Consulta	INT

) RETURNS int(3)
    DETERMINISTIC
BEGIN


	DECLARE Var_NumCreditosAvalados		INT(3);


	DECLARE Entero_Cero			INT(4);
    DECLARE	Desembolsado		CHAR(1);
    DECLARE EstaActivo			CHAR(1);
	DECLARE Con_Aval			INT(1);
	DECLARE Con_Cliente			INT(1);
	DECLARE Con_Prospecto		INT(1);
	DECLARE CredVigente			CHAR(1);
	DECLARE CredVencido			CHAR(1);


	SET Entero_Cero			:= 0;
    SET Desembolsado		:= 'D';
    SET EstaActivo			:= 'A';
	SET Con_Aval			:= 1;
	SET Con_Cliente			:= 2;
	SET Con_Prospecto		:= 3;
	SET CredVigente			:= 'V';
	SET CredVencido			:= 'B';

    CASE Par_Consulta
		WHEN Con_Aval THEN
				SELECT  COUNT(Sol.SolicitudCreditoID)
				INTO Var_NumCreditosAvalados
                FROM AVALES Ava
				LEFT JOIN  AVALESPORSOLICI AvaS
				ON AvaS.AvalID = Ava.AvalID
				LEFT JOIN SOLICITUDCREDITO Sol
				ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.Estatus = Desembolsado
				INNER JOIN CREDITOS Cre
				ON Cre.CreditoID = Sol.CreditoID AND (Cre.Estatus = CredVigente OR Cre.Estatus = CredVencido)
				WHERE Ava.AvalID = Par_AvalID
				GROUP BY Ava.AvalID;

		WHEN Con_Cliente THEN
				SELECT COUNT(Sol.SolicitudCreditoID)
                INTO Var_NumCreditosAvalados
				FROM CLIENTES Cli
				LEFT JOIN AVALESPORSOLICI AvaS
				ON AvaS.ClienteID = Cli.ClienteID AND Cli.Estatus = EstaActivo
				LEFT JOIN  SOLICITUDCREDITO Sol
				ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID AND  Sol.Estatus = Desembolsado

				INNER JOIN CREDITOS Cre
				ON Cre.CreditoID = Sol.CreditoID AND (Cre.Estatus = CredVigente OR Cre.Estatus = CredVencido)
				WHERE Cli.ClienteID = Par_AvalID
				GROUP BY Cli.ClienteID;

		WHEN Con_Prospecto THEN
				SELECT	COUNT(Sol.SolicitudCreditoID)
                INTO Var_NumCreditosAvalados
				FROM PROSPECTOS Pro
				LEFT JOIN AVALESPORSOLICI AvaS
				ON AvaS.ProspectoID = Pro.ProspectoID
				LEFT JOIN  SOLICITUDCREDITO Sol
				ON AvaS.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.Estatus = Desembolsado

				INNER JOIN CREDITOS Cre
				ON Cre.CreditoID = Sol.CreditoID AND (Cre.Estatus = CredVigente OR Cre.Estatus = CredVencido)
				WHERE Pro.ProspectoID = Par_AvalID
				GROUP BY Pro.ProspectoID;
	END CASE;

    RETURN Var_NumCreditosAvalados;
END$$