-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARBITASPEIREMESASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBITASPEIREMESASLIS`;

DELIMITER $$

CREATE PROCEDURE `TARBITASPEIREMESASLIS`(

	Par_NumLis						TINYINT UNSIGNED,

	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)

TerminaStore:BEGIN


	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(1);
	DECLARE Var_EstPendiente		CHAR(1);
	DECLARE Var_ReportarPago		CHAR(1);
	DECLARE Var_Devolucion			CHAR(1);
	DECLARE Var_LisPendRepPago		TINYINT UNSIGNED;
	DECLARE Var_LisPendDevol		TINYINT UNSIGNED;


	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Var_EstPendiente			:= 'P';
	SET Var_ReportarPago			:= 'R';
	SET Var_Devolucion				:= 'D';
	SET Var_LisPendRepPago			:= 1;
	SET Var_LisPendDevol			:= 2;


	IF (Par_NumLis = Var_LisPendRepPago) THEN

		SELECT		SpeiRemID,		ClaveRastreo,		TransaccionPago
			FROM	TARBITASPEIREMESAS
			WHERE	Metodo = Var_ReportarPago
			  AND	Estatus = Var_EstPendiente
			ORDER BY FechaHoraAlta ASC;

	END IF;


	IF (Par_NumLis = Var_LisPendDevol) THEN

		SELECT		SpeiRemID,		ClaveRastreo
			FROM	TARBITASPEIREMESAS
			WHERE	Metodo = Var_Devolucion
			  AND	Estatus = Var_EstPendiente
			ORDER BY FechaHoraAlta ASC;

	END IF;

END TerminaStore$$