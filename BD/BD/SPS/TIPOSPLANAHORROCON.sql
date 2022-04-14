-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPLANAHORROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSPLANAHORROCON`;
DELIMITER $$

CREATE PROCEDURE `TIPOSPLANAHORROCON`(
-- ====================================================
-- SP PARA CONSULTAR EL PLAN DE AHORRO POR ID
-- ====================================================
	Par_PlanID 			INT(11),		-- Identificador del Plan de Ahorro
	Par_NumCont 		INT(11),		-- Tipo de Consulta

	/* Parametros de Auditoria */
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore:BEGIN

	/*Declaracion de Constantes*/
	DECLARE Con_Principal 		INT(11);
	DECLARE Entero_Cero			INT(11);
	DECLARE Var_TiposCuentas	VARCHAR(100);
    DECLARE SerieActual			INT(11);

	/*Asignacion de Constantes*/
	SET Con_Principal 	:= 1;
	SET Entero_Cero		:= 0;

	IF(Par_NumCont=Con_Principal) THEN
		SET Var_TiposCuentas := (SELECT GROUP_CONCAT(TipoCuentaID) FROM TIPOSCUEPLANAHORRO WHERE PlanAhoID=Par_PlanID);
        SET SerieActual := (SELECT MAX(Serie) FROM FOLIOSPLANAHORRO WHERE PlanID=Par_PlanID);

		SELECT
			PlanID,			Nombre,		FechaInicio,	FechaVencimiento,			FechaLiberacion,
			DepositoBase,	MaxDep,		Prefijo,		IFNULL(SerieActual,Serie) AS Serie,	LeyendaBloqueo,
			LeyendaTicket,	Var_TiposCuentas AS TiposCuentas, DiasDesbloqueo
		FROM TIPOSPLANAHORRO
		WHERE PlanID=Par_PlanID;
	END IF;

END TerminaStore$$