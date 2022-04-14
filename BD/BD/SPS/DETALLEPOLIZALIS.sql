-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLIZALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLIZALIS`;
DELIMITER $$


CREATE PROCEDURE `DETALLEPOLIZALIS`(
-- ----------------------------------------------------------------
-- 			SP PARA OBTENER LA LISTA DE DETALLE DE POLIZA
-- ----------------------------------------------------------------
	Par_PolizaID 		BIGINT(20),				-- Parametro Poliza ID
	Par_NumLis			TINYINT UNSIGNED,		-- Parametro Numero de Lista

	Aud_EmpresaID		INT(11),				-- Parametro de auditoria de empresa
	Aud_Usuario			INT(11),				-- Parametro de auditoria de usuario
	Aud_FechaActual		DATETIME,				-- Parametro de auditoria de fecha actual
	Aud_DireccionIP		VARCHAR(15),			-- Parametro de auditoria de Direccion IP
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de auditoria de ID de Programa
	Aud_Sucursal		INT(11),				-- Parametro de auditoria de Sucursal
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de auditoria de Numero de Transaccion
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE		Cadena_Vacia	CHAR(1);		-- Constante de cadena vacia
	DECLARE		Fecha_Vacia		DATE;			-- Constante de fecha vacia
	DECLARE		Entero_Cero		INT(11);		-- Constante de Entero Cero
	DECLARE		Lis_Principal	INT(11);		-- Constante de Lista Principal

	-- Asignacion de constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Lis_Principal	:= 1;

	IF(Par_NumLis = Lis_Principal) THEN
		(SELECT	PolizaID,		CentroCostoID,	CuentaCompleta,	Referencia,	Descripcion, RFC,
				TotalFactura,	FolioUUID,		Cargos,			Abonos
			FROM  DETALLEPOLIZA
			WHERE	PolizaID = Par_PolizaID AND PolizaID != Entero_Cero)
		UNION ALL
		(SELECT 	PolizaID,	CentroCostoID,	CuentaCompleta,	Referencia,	Descripcion,
				RFC,		TotalFactura,   FolioUUID, 		Cargos,
				Abonos
			FROM `HIS-DETALLEPOL`
			WHERE	PolizaID = Par_PolizaID AND PolizaID != Entero_Cero);
	END IF;

END TerminaStore$$