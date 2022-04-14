-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALMACENESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS ALMACENESLIS;

DELIMITER $$
CREATE PROCEDURE `ALMACENESLIS`(
	-- Store Procedure: Que Lista los almacenes de Guarda Valores
	-- Modulo Guarda Valores
	Par_AlmacenID				INT(11),			-- ID de Tabla
	Par_SucursalID				INT(11),			-- ID de Sucursal
	Par_NombreAlmacen			VARCHAR(50),		-- Nombre de Almacen
	Par_NumLista				TINYINT UNSIGNED,	-- Numero de Lista

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
	DECLARE Lis_Principal			TINYINT UNSIGNED;	-- Lista Principal
	DECLARE Lis_AlmacenesActivos	TINYINT UNSIGNED;	-- Lista Almacenes Activos

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';
	SET Lis_Principal			:= 1;
	SET Lis_AlmacenesActivos	:= 2;
	SET Aud_FechaActual			:= NOW();

	-- Se realiza la Lista principal
	IF( Par_NumLista = Lis_Principal ) THEN

		SELECT	AlmacenID,		NombreAlmacen,		SucursalID,
		CASE WHEN Estatus = 'A' THEN 'ACTIVA'
			 WHEN Estatus = 'I' THEN 'INACTIVA'
			 ELSE 'INDEFINIDO'
		END AS Estatus
		FROM ALMACENES
		WHERE NombreAlmacen LIKE CONCAT("%", Par_NombreAlmacen, "%")
		LIMIT 0,15;

	END IF;

	-- Se realiza la Lista Almacenes Activos
	IF( Par_NumLista = Lis_AlmacenesActivos ) THEN

		SELECT	Alm.AlmacenID,		Alm.NombreAlmacen,		Suc.NombreSucurs AS SucursalID
		FROM ALMACENES Alm
		INNER JOIN SUCURSALES Suc ON Alm.SucursalID = Suc.SucursalID
		WHERE Alm.NombreAlmacen LIKE CONCAT("%", Par_NombreAlmacen, "%")
		  AND Alm.Estatus = Est_Activo
		  AND Alm.SucursalID = Par_SucursalID
		LIMIT 0,15;

	END IF;

END TerminaStore$$