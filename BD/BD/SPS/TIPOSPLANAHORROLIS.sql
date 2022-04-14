-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPLANAHORROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSPLANAHORROLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSPLANAHORROLIS`(
-- ==================================================
-- SP PARA LISTAR LOS TIPOS DE PLAN DE AHORRO
-- ==================================================

	Par_PlanID				VARCHAR(50),	-- Parametro Patron de busqueda
	Par_NumList				INT(11),		-- Numero de lista

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

	/*Declaracion de constantes*/
	DECLARE	ListPrincipal 	INT(11);
	DECLARE ListaCombo 		INT(11);

	DECLARE	Var_FechaActual DATE;

	/*Asignacion de constantes*/
	SET	ListPrincipal 	:= 1;
	SET ListaCombo		:= 2;

	SET Var_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS);

	IF(Par_NumList=ListPrincipal)THEN
		SELECT PlanID,		Nombre
		FROM TIPOSPLANAHORRO
		WHERE Nombre LIKE CONCAT('%',Par_PlanID,'%')
		AND FechaLiberacion >= Var_FechaActual
		LIMIT 0,15;
	ELSEIF(Par_NumList=ListaCombo)THEN
		SELECT PlanID,Nombre
		FROM TIPOSPLANAHORRO
		WHERE FechaVencimiento >= Var_FechaActual;
	END IF;

END TerminaStore$$