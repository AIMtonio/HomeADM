-- SOLICITUDTRANSFERCAJALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDTRANSFERCAJALIS;
DELIMITER $$


CREATE PROCEDURE SOLICITUDTRANSFERCAJALIS(
	Par_SucursalOrigen		INT(11),			-- Sucursal Origen para la Transferencia de Efectivo
	Par_SucursalDestino		INT(11),			-- Sucursal Destino para la Transferencia de Efectivo
	Par_CajaOrigen			INT(11),			-- Caja Origen para la Transferencia
	Par_CajaDestino			INT(11),			-- Caja Destino de la Transferencia
	Par_Estatus				CHAR(1),			-- Estatus de la Transferencia
	Par_Fecha				DATETIME,			-- Fecha de Transferencia
	Par_NumLis				INT(11),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
	DECLARE Entero_Cero				INT(1);							-- Entero cero
	DECLARE Cadena_Vacia        	CHAR(1);
	DECLARE Entero_Uno				INT(11);						-- Entero uno
	DECLARE Fecha_Vacia				DATE;							-- Fecha Vacia 
	DECLARE	Lis_Principal			INT(11);
	DECLARE OrigenM					CHAR(1);
	DECLARE OrigenS					CHAR(1);

	SET Entero_Cero				:= 0;								-- Entero cero
	SET Cadena_Vacia        	:= '';
	SET Entero_Uno				:= 1;								-- Entero uno
	SET Fecha_Vacia				:= '1900-01-01';					-- Fecha Vacia 
	SET	Lis_Principal			:= 1;
	SET	OrigenM					:= 'M';
	SET OrigenS					:= 'S';


	IF(Par_NumLis = Lis_Principal) THEN
	
		
		DROP TABLE IF EXISTS TMPSOLICITUDTRANSFERCAJA;
		
	
		CREATE TEMPORARY TABLE TMPSOLICITUDTRANSFERCAJA (SELECT SolicitudTransID,		CajaOrigen,			CajaDestino,		DenominacionID,		Cantidad,
																Referencia,				Estatus,			FechaOperacion,		SucursalOrigen,		SucursalDestino,
																MonedaID,				OrigenM AS Origen,  MontoTransferencia
															FROM SOLICITUDTRANSFERCAJA
															WHERE SucursalOrigen = IF(Par_SucursalOrigen > Entero_Cero, Par_SucursalOrigen, SucursalOrigen)
															AND SucursalDestino = IF(Par_SucursalDestino > Entero_Cero, Par_SucursalDestino, SucursalDestino)
															AND CajaOrigen = IF(Par_CajaOrigen > Entero_Cero, Par_CajaOrigen, CajaOrigen)
															AND CajaDestino = IF(Par_CajaDestino > Entero_Cero, Par_CajaDestino, CajaDestino)
															AND CAST(FechaOperacion AS DATE) = IF(Par_Fecha != Fecha_Vacia, Par_Fecha, CAST(FechaOperacion AS DATE))
															AND Estatus = IF(Par_Estatus != Cadena_Vacia, Par_Estatus, Estatus));
		
		INSERT INTO TMPSOLICITUDTRANSFERCAJA
			SELECT	CT.CajasTransferID,		CT.CajaOrigen,		CT.CajaDestino,		CT.DenominacionID,			CT.Cantidad,
					Cadena_Vacia,			CT.Estatus,			CT.Fecha,			CT.SucursalOrigen,			CT.SucursalDestino,
					CT.MonedaID,			OrigenS,            CT.Cantidad * DEN.Valor AS MontoTransferencia
			FROM CAJASTRANSFER CT
			LEFT JOIN SOLICITUDTRANSFERCAJA STC ON CT.CajasTransferID = STC.SolicitudTransID
			INNER JOIN DENOMINACIONES DEN ON DEN.DenominacionID = CT.DenominacionID
            WHERE STC.SolicitudTransID IS NULL
				AND CT.SucursalOrigen = IF(Par_SucursalOrigen > Entero_Cero, Par_SucursalOrigen, CT.SucursalOrigen)
				AND CT.SucursalDestino = IF(Par_SucursalDestino > Entero_Cero, Par_SucursalDestino, CT.SucursalDestino)
				AND CT.CajaOrigen = IF(Par_CajaOrigen > Entero_Cero, Par_CajaOrigen, CT.CajaOrigen)
				AND CT.CajaDestino = IF(Par_CajaDestino > Entero_Cero, Par_CajaDestino, CT.CajaDestino)
				AND CAST(CT.Fecha AS DATE) = IF(Par_Fecha != Fecha_Vacia, Par_Fecha, CAST(CT.Fecha AS DATE))
				AND CT.Estatus = IF(Par_Estatus != Cadena_Vacia, Par_Estatus, CT.Estatus);
		
		SELECT	SolicitudTransID,		CajaOrigen,			CajaDestino,		DenominacionID,		MontoTransferencia,
				Referencia,				Estatus,			FechaOperacion,		SucursalOrigen,		SucursalDestino,
				MonedaID,				Origen,				Cantidad
		FROM TMPSOLICITUDTRANSFERCAJA;
		
	END IF;

END TerminaStore$$
