-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESTAMODOCGRDVALORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS PRESTAMODOCGRDVALORESCON;

DELIMITER $$
CREATE PROCEDURE `PRESTAMODOCGRDVALORESCON`(
	-- Store Procedure: De Consulta los Prestamos de Documentos de Guarda Valores
	-- Modulo Guarda Valores
	Par_PrestamoDocGrdValoresID	BIGINT(20),		-- ID de tabla
	Par_CatMovimientoID			INT(11),		-- ID de Tabla CATMOVDOCGRDVALORES
	Par_NumeroConsulta			TINYINT UNSIGNED,-- Numero de Consulta

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Consulta_Principal		TINYINT UNSIGNED;-- Consulta Num. 1.- Consulta Principal

	-- Asignacion  de constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Consulta_Principal	:= 1;

	-- Consulta Num. 1.- Consulta Principal
	IF( Par_NumeroConsulta = Consulta_Principal ) THEN

		SELECT 	PrestamoDocGrdValoresID,	CatMovimientoID,	DocumentoID,		HoraRegistro,			FechaRegistro,
				UsuarioRegistroID, 			UsuarioPrestamoID,	UsuarioAutorizaID,	UsuarioDevolucionID,	FechaDevolucion,
				Observaciones,				SucursalID,			Estatus
		FROM PRESTAMODOCGRDVALORES
		WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID;
	END IF;

END TerminaStore$$