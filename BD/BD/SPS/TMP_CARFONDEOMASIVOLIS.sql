-- SP TMP_CARFONDEOMASIVOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS TMP_CARFONDEOMASIVOLIS;

DELIMITER $$

CREATE  PROCEDURE TMP_CARFONDEOMASIVOLIS(
	-- SP para lista de Creditos a que se valdiaron y se detectaron detalle
	Par_TransaccionCargaID		BIGINT(20),		-- Parametro numero de transaccion

	Par_NumLis					TINYINT UNSIGNED,	-- Numero de consulta de la lista

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- ID de la Empresa
	Aud_Usuario					INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual				DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP				VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID				VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal				INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Numero de Transaccion
)TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Lis_CredFondVal			INT(11);		-- Variable para la lista de los creditos que se detectaron con detalles en la validacion
	DECLARE Estatus_Error			CHAR(1);		-- 'Estatus del Cambio de Fondeo :E = Error
	DECLARE Estatus_Advertencia		CHAR(1);		-- 'Estatus del Cambio de Fondeo :A = Advertencia

	-- Declaracion d eavariable
	DECLARE Var_CantError			INT(11);		-- Contador DE registro de errores
	DECLARE Var_CantAdvertencia		INT(11);		-- Contador DE registro de Advertencia

	-- Asignacion de constantes
	SET	Lis_CredFondVal				:= 1;			-- Variable para la lista de los creditos que se detectaron con detalles en la validacion

	SET Estatus_Error				:= 'E';			-- Estatus del Cambio de Fondeo :E = Error
	SET Estatus_Advertencia			:= 'A';			-- Estatus del Cambio de Fondeo :A = Advertencia

	-- 1.- Variable para la lista de combos de los tipos de claves presupuestales registrado
	IF(Par_NumLis = Lis_CredFondVal) THEN
		SELECT COUNT(CarFondeoMavisoID)
			INTO Var_CantError
			FROM TMP_CARFONDEOMASIVO
			WHERE Estatus = Estatus_Error
			AND TransaccionCargaID = Par_TransaccionCargaID;

		SELECT COUNT(CarFondeoMavisoID)
			INTO Var_CantAdvertencia
			FROM TMP_CARFONDEOMASIVO
			WHERE Estatus = Estatus_Advertencia
			AND TransaccionCargaID = Par_TransaccionCargaID;

		-- Nota: El estatus se ocupa como clase de estilo css en grid que en lista las validaciones
		SELECT	CarFondeoMavisoID,							FilaArchivo,							CreditoID,		DescripcionEstatus,		Var_CantError AS CantError,
				Var_CantAdvertencia AS CantAdvertencia,		CASE WHEN Estatus = 'E' THEN 'Error'
												WHEN Estatus = 'A' THEN 'Advertencia' END AS Estatus
			FROM TMP_CARFONDEOMASIVO
			WHERE Estatus IN (Estatus_Error,Estatus_Advertencia)
				AND TransaccionCargaID = Par_TransaccionCargaID
				ORDER BY Estatus DESC ,CarFondeoMavisoID ASC;
	END IF;

END TerminaStore$$