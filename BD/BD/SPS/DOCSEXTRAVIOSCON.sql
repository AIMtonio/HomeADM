-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCSEXTRAVIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DOCSEXTRAVIOSCON`;DELIMITER $$

CREATE PROCEDURE `DOCSEXTRAVIOSCON`(
-- ===============================================================
-- SP PARA DATOS DEL REPORTE DE EXTRAVIO DE DOCUMENTOS
-- ===============================================================
	Par_TipoRep			CHAR,		-- Tipo de Reporte
	Par_CuentaID		BIGINT,		-- Número de cuenta
	Par_InversionID		INT(11),	-- Número de inversión

	/* Parametros Auditoria */
	Aud_EmpresaID		   	INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual		   	DATETIME,
	Aud_DireccionIP		   	VARCHAR(20),
	Aud_ProgramaID		   	VARCHAR(50),
	Aud_Sucursal		   	INT(11),
	Aud_NumTransaccion	   	BIGINT(20)
)
TerminaStore:BEGIN
	/* Declaracion de Contantes */
	DECLARE RepCuenta		CHAR(1);
	DECLARE RepInversion	CHAR(1);

	/* Asignación de Constantes */
	SET RepCuenta 		:= 'C';
	SET RepInversion	:= 'I';

	IF(Par_TipoRep=RepCuenta)THEN
		SELECT RegistroRECA AS Var_RECA
		FROM PRODUCTOSCREDITO PD
		INNER JOIN CREDITOS CRE
			ON PD.ProducCreditoID = CRE.ProductoCreditoID
			AND CRE.CuentaID = Par_CuentaID
		LIMIT 1;

	ELSEIF (Par_TipoRep=RepInversion) THEN
		SELECT NumRegistroRECA AS Var_RECA
		FROM CATINVERSION TI
		INNER JOIN INVERSIONES INV
			ON TI.TipoInversionID = INV.TipoInversionID
			AND INV.InversionID = Par_InversionID
		LIMIT 1;

	END IF;
END TerminaStore$$