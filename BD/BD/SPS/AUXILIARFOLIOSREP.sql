-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AUXILIARFOLIOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AUXILIARFOLIOSREP`;DELIMITER $$

CREATE PROCEDURE `AUXILIARFOLIOSREP`(
	Par_FechaCreacion		VARCHAR(10),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore:BEGIN
	-- Declaracion de Constantes
    DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE	Fecha_Vacia			VARCHAR(10);
	DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE Entero_Cero			INT(11);
	DECLARE Tipo				INT(2);
	DECLARE	ConsePoliza			INT(11);
	DECLARE ConseDetalleNac		INT(11);
	DECLARE	ConseComprobante	INT(11);
	DECLARE FechaFinMes			VARCHAR(10);

	-- Asignacion de Constantes
    SET Decimal_Cero		:= '0.00';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Cadena_Vacia		:= '';
    SET Entero_Cero			:= 0;
	SET	Tipo				:= 1;
	SET	ConsePoliza			:= 1;
	SET	ConseDetalleNac		:= 2;
	SET	ConseComprobante	:= 3;

	SET FechaFinMes			:=	LAST_DAY(Par_FechaCreacion);

	-- TABLA QUE ALMACENA LOS DETALLES DE LOS MOVIMIENTOS DE UNA POLIZA
	DROP TABLE IF EXISTS TEMPAUXILIARFOLIOS;
	CREATE TEMPORARY TABLE TEMPAUXILIARFOLIOS (
											Consecutivo		INT(11),
											PolizaID		BIGINT(20),
											Fecha			DATE,
											FolioUUID  		VARCHAR(100),
											RFC				CHAR(13),
                                            MetodoPago		VARCHAR(200),
											MontoTotal		DECIMAL(14,2),
											MonedaFac		VARCHAR(80),
                                            TipoCambio		DECIMAL(14,2),
                                            PersonaID		INT(11),
											INDEX (PolizaID),
                                            INDEX (Fecha),
											INDEX (Consecutivo));

-- SE INSERTAM LAS POLIZAS QUE SE GENERARON EN CIERTO PERIODO
	INSERT INTO TEMPAUXILIARFOLIOS
	(SELECT	ConsePoliza,	P.PolizaID,		P.Fecha,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,	Decimal_Cero,	Cadena_Vacia, 	Decimal_Cero,	Entero_Cero
    FROM `HIS-POLIZACONTA` P
			INNER JOIN `HIS-DETALLEPOL` D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID
            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes
            GROUP BY P.PolizaID, P.Fecha)


	UNION ALL
	(SELECT	ConsePoliza,	P.PolizaID,		P.Fecha,		Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,	Decimal_Cero,	Cadena_Vacia, 	Decimal_Cero,	Entero_Cero
		FROM POLIZACONTABLE P
			INNER JOIN DETALLEPOLIZA D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID
            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes
            GROUP BY P.PolizaID, P.Fecha);

-- SE INSERTAN LOS DETALLES DE LAS POLIZAS QUE SE GENERARON EN CIERTO PERIODO
	INSERT INTO TEMPAUXILIARFOLIOS
	(SELECT	ConseDetalleNac,		P.PolizaID,		Fecha_Vacia,	D.FolioUUID,    D.RFC,
			MP.MetodoPagoID,	D.TotalFactura,		CASE
														WHEN PD.MonedaID != Entero_Cero THEN 'MXN'
													ELSE Cadena_Vacia
                                                    END,		M.TipCamDof,	PD.PersonaID
        FROM `HIS-POLIZACONTA` P
			INNER JOIN `HIS-DETALLEPOL` D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID

            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes)

	UNION ALL
	(SELECT 	ConseDetalleNac,		P.PolizaID,		Fecha_Vacia,	D.FolioUUID,    D.RFC,
			MP.MetodoPagoID,	D.TotalFactura,		CASE
														WHEN PD.MonedaID != Entero_Cero THEN 'MXN'
													ELSE Cadena_Vacia
                                                    END,		M.TipCamDof,	PD.PersonaID
		FROM POLIZACONTABLE P
			INNER JOIN DETALLEPOLIZA  D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID
            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes);


	INSERT INTO TEMPAUXILIARFOLIOS
	(SELECT	ConseComprobante,	P.PolizaID,		Fecha_Vacia,	Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Decimal_Cero,	Cadena_Vacia,	Decimal_Cero,	Entero_Cero
    FROM `HIS-POLIZACONTA` P
			INNER JOIN `HIS-DETALLEPOL` D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID
            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes
            GROUP BY P.PolizaID)


	UNION ALL
	(SELECT ConseComprobante,	P.PolizaID,		Fecha_Vacia,	 Cadena_Vacia,	Cadena_Vacia,
			Cadena_Vacia,		Decimal_Cero,	Cadena_Vacia, 	Decimal_Cero,	Entero_Cero
		FROM POLIZACONTABLE P
			INNER JOIN DETALLEPOLIZA D ON P.PolizaID=D.PolizaID
            LEFT JOIN POLIZAINFADICIONAL PD
			ON P.PolizaID = PD.PolizaID
			LEFT JOIN MONEDAS M
			ON PD.MonedaID = M.MonedaID
			LEFT JOIN CATMETODOSPAGO MP
			ON PD.MetodoPagoID = MP.MetodoPagoID
            WHERE	P.Fecha>=Par_FechaCreacion
				AND P.Fecha<=FechaFinMes
            GROUP BY P.PolizaID);



SELECT	Consecutivo,	PolizaID,	Fecha,		FolioUUID,		RFC	,
	IFNULL(MetodoPago, Cadena_Vacia) AS MetodoPago,				MontoTotal,
	IFNULL(MonedaFac, Cadena_Vacia) AS Moneda,
    IFNULL(TipoCambio, Decimal_Cero) AS TipoCambio,	PersonaID
	FROM TEMPAUXILIARFOLIOS
	ORDER BY PolizaID,Consecutivo;



END TerminaStore$$