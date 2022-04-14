-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCAJASTRANSFERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCAJASTRANSFERLIS`;
DELIMITER $$

CREATE PROCEDURE `BANCAJASTRANSFERLIS`(
	Par_SucursalOrigen		INT(11),			-- Sucursal Origen para la Transferencia de Efectivo
	Par_SucursalDestino		INT(11),			-- Sucursal Destino para la Transferencia de Efectivo
	Par_CajaOrigen			INT(11),			-- Caja Origen para la Transferencia
	Par_CajaDestino			INT(11),			-- Caja Destino de la Transferencia
	Par_Estatus				CHAR(1),			-- Estatus de la Transferencia
	Par_Fecha				DATETIME,			-- Fecha de Transferencia

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;				-- Constante de Fecha Vacia
	DECLARE	Entero_Cero		INT(11);			-- Constante de Entero Cero

	DECLARE	Lis_Principal	INT(11);			-- Lista de las Transferencias de cajas para el WS de Milagro

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';				-- Constante de Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Constante de Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Constante de Entero Cero

	SET	Lis_Principal		:= 1;				-- Lista de las Transferencias de cajas para el WS de Milagro

	SET Par_SucursalOrigen	:= IFNULL(Par_SucursalOrigen, Entero_Cero);
	SET Par_SucursalDestino	:= IFNULL(Par_SucursalDestino, Entero_Cero);
	SET Par_CajaOrigen		:= IFNULL(Par_CajaOrigen, Entero_Cero);
	SET Par_CajaDestino		:= IFNULL(Par_CajaDestino, Entero_Cero);
	SET Par_Fecha			:= IFNULL(Par_Fecha, Fecha_Vacia);
	SET Par_Estatus			:= IFNULL(Par_Estatus, Cadena_Vacia);

	-- 1.- Lista de las Transferencias de cajas para el WS de Milagro
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	CajasTransferID,		SucursalOrigen,			SucursalDestino,		Fecha,			DenominacionID,
				Cantidad,				CajaOrigen,				CajaDestino,			Estatus,		MonedaID
			FROM CAJASTRANSFER
		WHERE SucursalOrigen = IF(Par_SucursalOrigen > Entero_Cero, Par_SucursalOrigen, SucursalOrigen)
			AND SucursalDestino = IF(Par_SucursalDestino > Entero_Cero, Par_SucursalDestino, SucursalDestino)
			AND CajaOrigen = IF(Par_CajaOrigen > Entero_Cero, Par_CajaOrigen, CajaOrigen)
			AND CajaDestino = IF(Par_CajaDestino > Entero_Cero, Par_CajaDestino, CajaDestino)
			AND CAST(Fecha AS DATE) = IF(Par_Fecha != Fecha_Vacia, Par_Fecha, CAST(Fecha AS DATE))
			AND Estatus = IF(Par_Estatus != Cadena_Vacia, Par_Estatus, Estatus);
	END IF;

END TerminaStore$$