-- SP BANPARAMGENERALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS BANPARAMGENERALESCON;

DELIMITER $$
CREATE PROCEDURE `BANPARAMGENERALESCON`(
	/* SP QUE CONSULTA LOS PARAMETROS GENERALES DEL SISTEMA */
	Par_NumConsulta			TINYINT UNSIGNED,	-- Numero de Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore:BEGIN
	CALL PARAMGENERALESCON(
		Par_NumConsulta,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
	);
END TerminaStore$$
