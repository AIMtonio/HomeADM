-- SP NOMCONDICIONCREDLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCONDICIONCREDLIS;

DELIMITER $$

CREATE PROCEDURE NOMCONDICIONCREDLIS (
	-- STORE PROCEDURE PARA LISTAS DE LA TABLA NOMCONDICIONCRED
	Par_InstitNominaID		INT(11),			-- Empresa de nomina a la cual pertenece el convenio
    Par_ConvenioNominaID	BIGINT UNSIGNED,	-- Numero del convenio de nomina

	Par_NumLis				TINYINT,			-- Numero de lista

	Par_EmpresaID 			INT(11), 			-- Parametros de auditoria
	Aud_Usuario				INT(11),			-- Parametros de auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal			INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Var_LisGrid			TINYINT UNSIGNED;	-- Lista grid de la tabla NOMCONDICIONCRED
	DECLARE Entero_Cero			INT(1);				-- Entero cero
	DECLARE Est_Programado 		CHAR(1);			-- Estatus programado
	DECLARE Est_Vencido			CHAR(1);			-- Estatus vencido
	DECLARE Est_Cancelado		CHAR(1);			-- Estatus cancelado

	-- Asignacion de constantes
	SET Var_LisGrid			:= 1;				-- Lista grid de la tabla de NOMCONDICIONCRED

	SET Entero_Cero			:= 0;				-- Entero cero


	IF (Par_NumLis = Var_LisGrid) THEN
		SELECT 	CondicionCredID, 			ConvenioNominaID, 			InstitNominaID, 			ProducCreditoID,			TipoTasa,
				ValorTasa,					TipoCobMora,				ValorMora
			FROM NOMCONDICIONCRED
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID =  Par_ConvenioNominaID;
	END IF;




END TerminaStore$$
