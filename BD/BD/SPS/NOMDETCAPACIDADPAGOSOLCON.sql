-- SP NOMDETCAPACIDADPAGOSOLCON

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMDETCAPACIDADPAGOSOLCON;

DELIMITER $$

CREATE  PROCEDURE NOMDETCAPACIDADPAGOSOLCON(
	-- Stored Procedure para Listar los Detalle de claves presupuestales por sus numero de capacidad de pago por solicitud de Credito
	Par_NomCapacidadPagoSolID	BIGINT(12),			-- Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.
	Par_ClasifClavePresupID		INT(11),			-- Indica el Numero de la Clasificacion de la Clave Presupuestal
	Par_ClavePresupID			INT(11),			-- Indica el tipo de clave presupuestal
	Par_NumCon					TINYINT UNSIGNED,	-- Numero de consulta de la lista

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
	DECLARE Con_ClavPresup			INT(11);		-- Lista de las claves presupuestales registrado por capacidad de pago desolicitud de credito

	-- Asignacion de constantes
	SET Con_ClavPresup				:= 1;			-- Lista de las claves presupuestales registrado por capacidad de pago desolicitud de credito

	-- 1.- COnsulta de las Clasificaciones de claves presupuestales registrado por capacidad de pago desolicitud de credito
	IF(Par_NumCon = Con_ClavPresup) THEN
		SELECT ClasifClavePresupID,		ClavePresupID,		Clave,		Monto
			FROM NOMDETCAPACIDADPAGOSOL
			WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID
			AND ClasifClavePresupID = Par_ClasifClavePresupID
			AND ClavePresupID = Par_ClavePresupID;
	END IF;

END TerminaStore$$
