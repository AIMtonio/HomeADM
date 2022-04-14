-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSOTORGARCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSOTORGARCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOSOTORGARCON`(
	Par_NumCon			TINYINT UNSIGNED,
    Par_ProducCredito	VARCHAR(100),
    Par_Sucurs			VARCHAR(100),
    Par_EmpNom			VARCHAR(100),
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

-- VARIABLES
DECLARE MontoTotal			DECIMAL(14,2);
DECLARE Var_Nomina			CHAR(1);

-- CONSTANTES
DECLARE Entero_Cero			INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Con_Principal   	INT(11);
DECLARE Con_ProdCredito    	INT(11);
DECLARE Con_Sucursal    	INT(11);
DECLARE Con_EmpresaNomina	INT(11);
DECLARE Con_General			INT(11);
DECLARE Est_Autorizado		CHAR(1);
DECLARE Es_Nomina			CHAR(1);

/* Asignacion de Constantes */

SET Entero_Cero			:= 0;
SET Cadena_Vacia		:= '';
SET Con_Principal       := 1;
SET Con_ProdCredito     := 2;
SET Con_Sucursal		:= 3;
SET Con_EmpresaNomina   := 4;
SET Con_General			:= 5;
SET Est_Autorizado		:= 'A';
SET Es_Nomina			:= 'S';


IF(Par_NumCon = Con_Principal) THEN
	DROP TABLE IF EXISTS MONITORDESEMBOLSO;
	CREATE TEMPORARY TABLE MONITORDESEMBOLSO(SELECT Cre.CreditoID, Cli.NombreCompleto,	Cre.ProductoCreditoID, Pro.Descripcion,	Pro.ProductoNomina, Cre.SucursalID,	 Suc.NombreSucurs, Sol.InstitucionNominaID,	Ins.NombreInstit, Cre.MontoCredito
	FROM CREDITOS Cre
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			LEFT JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
			LEFT JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			LEFT JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
			LEFT JOIN INSTITNOMINA Ins ON Sol.InstitucionNominaID = Ins.InstitNominaID
			WHERE Cre.Estatus = Est_Autorizado);

    SELECT SUM(MontoCredito) INTO MontoTotal
	FROM MONITORDESEMBOLSO;

	SELECT MontoTotal;
END IF;

IF(Par_NumCon = Con_ProdCredito) THEN
	DROP TABLE IF EXISTS MONITORDESEMBOLSO;
	CREATE TEMPORARY TABLE MONITORDESEMBOLSO(SELECT Cre.CreditoID, Cli.NombreCompleto,	Cre.ProductoCreditoID, Pro.Descripcion,	Pro.ProductoNomina, Cre.SucursalID,	 Suc.NombreSucurs, Sol.InstitucionNominaID,	Ins.NombreInstit, Cre.MontoCredito
	FROM CREDITOS Cre
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			LEFT JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
			LEFT JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			LEFT JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
			LEFT JOIN INSTITNOMINA Ins ON Sol.InstitucionNominaID = Ins.InstitNominaID
			WHERE Cre.Estatus = Est_Autorizado);

	SELECT Descripcion,SUM(MontoCredito) AS Monto
	 FROM MONITORDESEMBOLSO
	 GROUP BY ProductoCreditoID, Descripcion;

END IF;


IF(Par_NumCon = Con_Sucursal) THEN
	DELETE FROM MONITORDESEMBOLSO
	WHERE Descripcion <> Par_ProducCredito;

	SELECT NombreSucurs, Descripcion, SUM(MontoCredito) AS Monto, ProductoNomina
	FROM MONITORDESEMBOLSO
	GROUP BY SucursalID, NombreSucurs, Descripcion, ProductoNomina;

END IF;
IF(Par_NumCon = Con_EmpresaNomina) THEN
	DELETE FROM MONITORDESEMBOLSO
	WHERE  NombreSucurs <> Par_ProducCredito;

		SELECT IFNULL(NombreInstit, Cadena_Vacia) AS NombreInstit, SUM(MontoCredito) AS Monto
		 FROM MONITORDESEMBOLSO
		 GROUP BY InstitucionNominaID, NombreInstit;
END IF;


IF(Par_NumCon = Con_General) THEN

		ALTER TABLE MONITORDESEMBOLSO ADD COLUMN Estatus CHAR(1) DEFAULT 'N';
        UPDATE MONITORDESEMBOLSO SET Estatus = 'N';

        SET Var_Nomina := (SELECT ProductoNomina FROM MONITORDESEMBOLSO LIMIT 1);
        IF(Var_Nomina = Es_Nomina) THEN
			DELETE FROM MONITORDESEMBOLSO
				WHERE NombreInstit <> Par_ProducCredito;
			ELSE
            DELETE FROM MONITORDESEMBOLSO
				WHERE  NombreSucurs <> Par_ProducCredito;
		END IF;
		SELECT @s:=@s+1 AS Num,	Descripcion, NombreCompleto, MontoCredito, Estatus, CreditoID
		 FROM MONITORDESEMBOLSO,
         (SELECT @s:= Entero_Cero) AS s
		 ORDER BY CreditoID;

END IF;


END TerminaStore$$