-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITNOMINALIS`;
DELIMITER $$


CREATE PROCEDURE `INSTITNOMINALIS`(
	Par_ClienteID  		INT(11),		-- CLIENTE
    Par_InstitNominaID  VARCHAR(20),	-- INTITUCION
    Par_TipoLis			INT(11),		-- TIPO DE LISTA

	Par_EmpresaID		INT(11),		-- AUDITORIA
	Aud_Usuario			INT(11),		-- AUDITORIA
	Aud_FechaActual		DATETIME,		-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal		INT(11),		-- AUDITORIA
	Aud_NumTransaccion	BIGINT			-- AUDITORIA
	)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control     varchar(100);

	-- DECLARACION DE CONSTANTES
	DECLARE EstatusActivo   CHAR(1);
    DECLARE Lis_Principal   INT(11);
	DECLARE Lis_clientesNom INT(11);
	DECLARE Lis_InstBitDom		INT(11);	-- lista para la pantalla de bitacora de pagos de domiciliacion
	DECLARE Lis_InstNomBitacora INT(11);	-- lists para la pantalla de bitacora para el campo nomina
	DECLARE Lis_TodosNomina		INT(11);	-- Lista para las instituciones de nómina

	-- ASIGNACION DE CONSTANTES
	SET EstatusActivo 		:= 'A';
    SET Lis_Principal		:= 1;
    SET Lis_clientesNom		:= 2;
    SET Lis_InstBitDom		:= 3;
    SET Lis_InstNomBitacora := 4;
    SET Lis_TodosNomina		:=5;


	-- CONSULTA PRINCIPAL
	IF(Par_TipoLis = Lis_Principal)THEN
	   SELECT InstitNominaID, NombreInstit
		FROM INSTITNOMINA
		WHERE Estatus = EstatusActivo
			AND NombreInstit like CONCAT("%", Par_InstitNominaID, "%")
		LIMIT  0,15;
	END IF;

    -- LISTA CLIENTES NOMINA
    IF(Par_TipoLis = Lis_clientesNom)THEN
	   SELECT DISTINCT(INS.InstitNominaID), INS.NombreInstit
		FROM INSTITNOMINA INS
        INNER JOIN NOMINAEMPLEADOS NOM ON NOM.InstitNominaID=INS.InstitNominaID
		WHERE INS.Estatus = EstatusActivo
			AND NOM.ClienteID = Par_ClienteID
            AND INS.NombreInstit LIKE CONCAT("%", Par_InstitNominaID, "%")
		LIMIT  0,15;
	END IF;

    IF(Par_TipoLis = Lis_InstBitDom)THEN

		SELECT DISTINCT BTC.FolioID, NOM.NombreInstit
			FROM INSTITNOMINA NOM
			INNER JOIN BITACORADOMICIPAGOS BTC ON NOM.InstitNominaID = BTC.InstitNominaID
			WHERE  NOM.NombreInstit LIKE CONCAT("%",Par_InstitNominaID,"%") LIMIT 0,15;
	END IF;

	IF(Par_TipoLis = Lis_InstNomBitacora)THEN

		SELECT DISTINCT NOM.InstitNominaID, NOM.NombreInstit
			FROM INSTITNOMINA NOM
			INNER JOIN BITACORADOMICIPAGOS BTC ON NOM.InstitNominaID = BTC.InstitNominaID
			WHERE  NOM.NombreInstit LIKE CONCAT("%",Par_InstitNominaID,"%") LIMIT 0,15;
	END IF;

	IF(Par_TipoLis = Lis_TodosNomina)THEN

		SELECT NOM.InstitNominaID, CONCAT(CONVERT(NOM.InstitNominaID,CHAR),' ',NOM.NombreInstit) AS NombreInstit
			FROM INSTITNOMINA NOM;
	END IF;



END TerminaStore$$