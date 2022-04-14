DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPARAMETROSSISCON`;
DELIMITER $$
CREATE PROCEDURE `BANPARAMETROSSISCON`(
	-- --------------------------------------------------------------------
	-- SP QUE REALIZA LA CONSULTA DE LOS PARAMETROS GENERALES DEL SISTEMA
	-- --------------------------------------------------------------------
	Par_EmpresaID		VARCHAR(11),		-- Numero de la Empresa
	Par_ClaveUsuario	VARCHAR(45),		-- Clave del Usuario
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 			-- Auditoria
	)
TerminaStore: BEGIN
	CALL PARAMETROSSISCON(	Par_EmpresaID,	Par_ClaveUsuario,	Par_NumCon, 	Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

END TerminaStore$$