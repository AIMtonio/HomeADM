-- SOLICITUDTRANSFERCAJACON
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDTRANSFERCAJACON;
DELIMITER $$

CREATE PROCEDURE SOLICITUDTRANSFERCAJACON(
	Par_SolicitudTransID	BIGINT(20),
	Par_NumCon				INT(11),

	Aud_EmpresaID			INT(11),
	Aud_Usuario         	INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(60),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT(11);
DECLARE Con_Principal   INT(11);
DECLARE OrigenM			CHAR(1);
DECLARE OrigenS			CHAR(1);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET	OrigenM			:= 'M';
SET OrigenS			:= 'S';

	IF(Par_NumCon = Con_Principal) THEN
		DROP TABLE IF EXISTS TMPSOLICITUDTRANSFERCAJA;
		
	
		CREATE TEMPORARY TABLE TMPSOLICITUDTRANSFERCAJA (SELECT SolicitudTransID,		CajaOrigen,			CajaDestino,		DenominacionID,		Cantidad,
																Referencia,				Estatus,			FechaOperacion,		SucursalOrigen,		SucursalDestino,
																MonedaID,				OrigenM AS Origen,	MontoTransferencia
															FROM SOLICITUDTRANSFERCAJA
															WHERE SolicitudTransID = Par_SolicitudTransID);
													
		INSERT INTO TMPSOLICITUDTRANSFERCAJA
			SELECT 	CT.CajasTransferID,		CT.CajaOrigen,			CT.CajaDestino,		CT.DenominacionID,		CT.Cantidad,
					Cadena_Vacia,			CT.Estatus,				CT.Fecha,			CT.SucursalOrigen,		CT.SucursalDestino,
					CT.MonedaID,			OrigenS,				CT.Cantidad * DEN.Valor AS MontoTransferencia
				FROM CAJASTRANSFER CT
				INNER JOIN DENOMINACIONES DEN ON DEN.DenominacionID = CT.DenominacionID
				WHERE CT.CajasTransferID = Par_SolicitudTransID;
		
		SELECT	SolicitudTransID,		CajaOrigen,			CajaDestino,		DenominacionID,		Cantidad,
				Referencia,				Estatus,			FechaOperacion,		SucursalOrigen,		SucursalDestino,
				MonedaID,				Origen,				MontoTransferencia
		FROM TMPSOLICITUDTRANSFERCAJA Limit 1;
		
		
	END IF;

END TerminaStore$$
