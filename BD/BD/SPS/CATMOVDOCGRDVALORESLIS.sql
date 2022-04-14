-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOVDOCGRDVALORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS CATMOVDOCGRDVALORESLIS;

DELIMITER $$
CREATE PROCEDURE `CATMOVDOCGRDVALORESLIS`(
	-- Store Procedure: Que Lista los Tipos de Movimiento Guarda Valores
	-- Modulo Guarda Valores
	Par_CatMovimientoID			INT(11),			-- ID de Tabla
	Par_NombreDocumento			VARCHAR(50),		-- Nombre de Almacen
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
	DECLARE Entero_Cero			INT(11);			-- Constante de Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante de Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Lis_Principal		TINYINT UNSIGNED;	-- Lista Principal
	DECLARE Lis_MovimientosAct	TINYINT UNSIGNED;	-- Lista de Movimientos Activos

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Est_Activo				:= 'A';
	SET Lis_Principal			:= 1;
	SET Lis_MovimientosAct		:= 2;

	-- Se realiza la Lista principal
	IF( Par_NumLista = Lis_Principal ) THEN

		SELECT	CatMovimientoID,	NombreMovimiento,	Descripcion	,	Estatus
		FROM CATMOVDOCGRDVALORES
		WHERE CatMovimientoID = Par_CatMovimientoID;
	END IF;

	-- Se realiza la Lista de Movimientos Activos
	IF( Par_NumLista = Lis_MovimientosAct ) THEN

		SELECT	CatMovimientoID,	NombreMovimiento,	Descripcion	,	Estatus
		FROM CATMOVDOCGRDVALORES
		WHERE Estatus = Est_Activo;
	END IF;

END TerminaStore$$