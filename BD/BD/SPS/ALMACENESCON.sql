-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALMACENESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS ALMACENESCON;

DELIMITER $$
CREATE PROCEDURE `ALMACENESCON`(
	-- Store Procedure: Que Consulta de Almacenes de Guarda Valores
	-- Modulo Guarda Valores
	Par_AlmacenID				INT(11),			-- ID de Tabla
	Par_SucursalID				INT(11),			-- ID de Sucursal
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo				CHAR(1);			-- Estatus Activo
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal
	DECLARE Con_AlmacenesActivos	TINYINT UNSIGNED;	-- Lista Almacenes Activos

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';
	SET Con_Principal			:= 1;
	SET Con_AlmacenesActivos	:= 2;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SELECT	AlmacenID,		NombreAlmacen,		Estatus,	SucursalID
		FROM ALMACENES
		WHERE AlmacenID = Par_AlmacenID;

	END IF;

	-- Se realiza la consulta Almacenes Activos
	IF( Par_NumConsulta = Con_AlmacenesActivos ) THEN

		SELECT	AlmacenID,		NombreAlmacen,		Estatus,	SucursalID
		FROM ALMACENES
		WHERE AlmacenID = Par_AlmacenID
		  AND SucursalID = Par_SucursalID
		  AND Estatus = Est_Activo;

	END IF;

END TerminaStore$$