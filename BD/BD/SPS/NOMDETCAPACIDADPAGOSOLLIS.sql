-- SP NOMDETCAPACIDADPAGOSOLLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMDETCAPACIDADPAGOSOLLIS;

DELIMITER $$

CREATE  PROCEDURE NOMDETCAPACIDADPAGOSOLLIS(
	-- Stored Procedure para Listar los Detalle de claves presupuestales por sus numero de capacidad de pago por solicitud de Credito
	Par_NomCapacidadPagoSolID	BIGINT(12),			-- Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.
	Par_ClasifClavePresupID		INT(11),			-- Indica el Numero de la Clasificacion de la Clave Presupuestal
	Par_Descripcion				VARCHAR(80),		-- Indica el tipo de clave presupuestal
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
	DECLARE Lis_ClasifClavPresup	INT(11);		-- Lista de las Clasificaciones de claves presupuestales registrado por capacidad de pago desolicitud de credito
	DECLARE Lis_ClavPresup			INT(11);		-- Lista de las claves presupuestales registrado por capacidad de pago desolicitud de credito

	-- Asignacion de constantes
	SET	Lis_ClasifClavPresup		:= 1;			-- Lista de las Clasificaciones de claves presupuestales registrado por capacidad de pago desolicitud de credito
	SET Lis_ClavPresup				:= 2;			-- Lista de las claves presupuestales registrado por capacidad de pago desolicitud de credito

	-- 1.- Lista de las Clasificaciones de claves presupuestales registrado por capacidad de pago desolicitud de credito
	IF(Par_NumLis = Lis_ClasifClavPresup) THEN
		SELECT DISTINCT(ClasifClavePresupID) AS NomClasifClavPresupID,		DescClasifClavePresup AS Descripcion
			FROM NOMDETCAPACIDADPAGOSOL
			WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID;
	END IF;

	-- 1.- Lista de las claves presupuestales registrado por capacidad de pago desolicitud de credito
	IF(Par_NumLis = Lis_ClavPresup) THEN
		SELECT ClavePresupID AS NomClavePresupID,	Clave,		DescClavePresup AS Descripcion,		ClasifClavePresupID AS NomClasifClavPresupID,	DescClasifClavePresup AS DescClasifClavPresup
			FROM NOMDETCAPACIDADPAGOSOL
			WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID
			AND ClasifClavePresupID = Par_ClasifClavePresupID;
	END IF;

END TerminaStore$$
