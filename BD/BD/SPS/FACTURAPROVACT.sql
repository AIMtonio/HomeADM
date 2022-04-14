-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROVACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAPROVACT`;
DELIMITER $$

CREATE PROCEDURE `FACTURAPROVACT`(

	Par_ProveedorID     INT,
	Par_NoFactura       VARCHAR(20),
	Par_RutaImgFact     VARCHAR(150),
	Par_RutaXMLFact     VARCHAR(150),
	Par_MotivoCancela   VARCHAR(150),
	Par_Monto           DECIMAL(14,2),
	Par_NumAct          TINYINT UNSIGNED,
	Par_FolioUUID       VARCHAR(100),
	Par_Salida          CHAR(1),

INOUT Par_NumErr        INT,
INOUT Par_ErrMen        VARCHAR(400),

	Par_EmpresaID       INT(11),
	Aud_Usuario         INT,
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT,
	Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN


DECLARE Var_NumReqFact      INT;
DECLARE Var_SaldoFactura    DECIMAL(14,2);
DECLARE Var_Deferencia      DECIMAL(14,2);
DECLARE Var_Estatus         CHAR(1);
DECLARE Var_Control         VARCHAR(100);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_EstatusFac      CHAR(1);
DECLARE Var_Pol             BIGINT;
DECLARE Var_FechaFact       DATE;
DECLARE Var_GenAsiento      CHAR(1);
DECLARE Var_CenCostos       INT;
DECLARE Var_NumFactDisp     INT(11);
DECLARE Var_Factura         VARCHAR(20);
DECLARE Var_EstPeriodo      CHAR(1);
DECLARE Var_FecIniMes       DATE;
DECLARE Var_NumReqGasID     INT(11);
DECLARE Var_NumAnticipos    INT(11);
DECLARE Var_CantNumReq      INT(11);
DECLARE Var_ConFolio        INT(11);

DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE SalidaNO            CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE NumActCancela       INT;
DECLARE NumActRutaArch      INT;
DECLARE NumActPagada        INT;
DECLARE Act_EstatusReq      INT;
DECLARE Act_CancelaReq      INT;
DECLARE Act_SaldoFact       INT;
DECLARE Act_FolioUUID       INT;
DECLARE Act_EstatusAct      INT;
DECLARE EstatusCancela      CHAR(1);
DECLARE Est_Requisicion     CHAR(1);
DECLARE Est_Liquidada       CHAR(1);
DECLARE Est_PagoParcial     CHAR(1);
DECLARE Est_Cerrado         CHAR(1);
DECLARE Est_Abierto         CHAR(1);
DECLARE Poliza              BIGINT;
DECLARE SiGenera            CHAR(1);
DECLARE Pol_Automatica      CHAR(1);
DECLARE ConceptoID          INT;
DECLARE DesConcepto         VARCHAR(150);
DECLARE Var_PolizaNue       BIGINT;
DECLARE TipOperacion        INT;
DECLARE MatrizSucursal      VARCHAR(20);
DECLARE Var_NoFactura       VARCHAR(20) ;
DECLARE Salida_SI           CHAR(1);
DECLARE Var_Poliza          BIGINT(20);
DECLARE Entero_Negativo     INT;
DECLARE Estatus_Cancelado   CHAR(1);
DECLARE Var_PolizaID		BIGINT(20);
DECLARE Var_OrigenFactura	VARCHAR(3);
DECLARE Var_TotalAbono		  DECIMAL(16,2);			-- TOTAL DE ABONOS
DECLARE Var_TotalCargo		  DECIMAL(16,2);			-- TOTAL DE CARGOS
DECLARE Var_DiferenciaTotales DECIMAL(16,2);			-- TOTAL DE CARGOS



SET Entero_Cero             := 0;
SET Decimal_Cero            := 0.0;
SET Cadena_Vacia            := '';
SET SalidaSI                := 'S';
SET SalidaNO                := 'N';
SET Fecha_Vacia             := '1900-01-01';
SET NumActCancela           := 1;
SET NumActRutaArch          := 2;
SET Act_EstatusReq          := 3;
SET NumActPagada            := 4;
SET Act_CancelaReq          := 5;
SET Act_SaldoFact           := 6;
SET Act_FolioUUID           := 7;
SET Act_EstatusAct			:= 8;
SET Salida_SI               := 'S';
SET Entero_Negativo         := -1;
SET EstatusCancela          := 'C';
SET Est_Requisicion         := 'R';
SET Est_Liquidada           := 'L';
SET Est_PagoParcial         := 'P';
SET SiGenera                := 'S';
SET Pol_Automatica          := 'A';
SET MatrizSucursal          := 'MatrizSucursales';
SET Est_Cerrado             := 'C';
SET Est_Abierto             := 'N';
SET Estatus_Cancelado       := 'C';

ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-FACTURAPROVACT');
				SET Var_Control = 'sqlException' ;
			END;

IF(IFNULL(Par_ProveedorID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El Proveedor esta vacio.';
	LEAVE ManejoErrores;
END IF;

SELECT IFNULL(NoFactura,Cadena_Vacia)
  INTO Var_NoFactura
  FROM FACTURAPROV
 WHERE NoFactura     = Par_NoFactura
   AND ProveedorID   = Par_ProveedorID;


IF(Var_NoFactura = Cadena_Vacia)THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen :='La Factura No Existe.';
	LEAVE ManejoErrores;
END IF;


SET Aud_FechaActual := CURRENT_TIMESTAMP();
SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;

IF(Par_NumAct = NumActCancela)THEN

	SELECT FechaFactura
	INTO Var_FechaFact
	FROM FACTURAPROV
	WHERE ProveedorID = Par_ProveedorID
	AND NoFactura     = Par_NoFactura;

	SET Var_FecIniMes    := CONVERT(DATE_ADD(Var_FechaFact, INTERVAL -1*(DAY(Var_FechaFact))+1 DAY),DATE);

	SELECT  Estatus
	   INTO Var_EstPeriodo
	FROM PERIODOCONTABLE
	WHERE Inicio = Var_FecIniMes;

	SET Var_EstPeriodo := IFNULL(Var_EstPeriodo,Cadena_Vacia);

	IF (Var_EstPeriodo = Est_Abierto)THEN

		SELECT COUNT(NoFactura)
		INTO Var_NumAnticipos
		FROM ANTICIPOFACTURA
		WHERE NoFactura= Par_NoFactura
		AND ProveedorID = Par_ProveedorID
		AND EstatusAnticipo != Estatus_Cancelado;

		IF (Var_NumAnticipos = Entero_Cero)THEN

			SELECT COUNT(D.FacturaProvID)
			INTO Var_NumFactDisp
			FROM FACTURAPROV F INNER JOIN DISPERSIONMOV D ON  F.FacturaProvID=D.FacturaProvID
			WHERE F.NoFactura= Par_NoFactura
			AND F.ProveedorID = Par_ProveedorID;


			IF (Var_NumFactDisp = Entero_Cero)THEN

				UPDATE FACTURAPROV SET
				Estatus          = EstatusCancela,
				MotivoCancela    = Par_MotivoCancela,
				FechaCancelacion = Var_FechaSistema,

				EmpresaID        = Par_EmpresaID,
				Usuario          = Aud_Usuario,
				FechaActual      = Aud_FechaActual,
				DireccionIP      = Aud_DireccionIP,
				ProgramaID       = Aud_ProgramaID,
				Sucursal         = Aud_Sucursal,
				NumTransaccion   = Aud_NumTransaccion

				WHERE NoFactura     = Par_NoFactura
				  AND ProveedorID   = Par_ProveedorID;

				SET Par_NumErr = Entero_Cero;


				CALL FACTURACONTACAN(
					Par_ProveedorID,    Par_NoFactura,  Par_FolioUUID,      SalidaNO,           Par_NumErr,         Par_ErrMen,
					Poliza,             Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
					Aud_Sucursal,       Aud_NumTransaccion);

					SELECT NumReqGasID
					INTO Var_NumReqGasID
					FROM REQGASTOSUCURMOV
						WHERE   NoFactura = Par_NoFactura
						AND ProveedorID   = Par_ProveedorID
					LIMIT 1;

					DELETE FROM REQGASTOSUCURMOV WHERE  NoFactura     = Par_NoFactura
													AND ProveedorID   = Par_ProveedorID;
					SELECT COUNT(NumReqGasID)
					INTO Var_CantNumReq
					FROM REQGASTOSUCURMOV
						WHERE   NumReqGasID = Var_NumReqGasID;

				IF(Var_CantNumReq = Entero_Cero)THEN
					DELETE FROM REQGASTOSUCUR  WHERE NumReqGasID     = Var_NumReqGasID;
				END IF;


			ELSE

				SET Par_NumErr := 3;
				SET Par_ErrMen :='La factura ya esta en una dispersion, no puede ser Cancelada.';
				SET Var_Control := Par_NoFactura;
				LEAVE ManejoErrores;

			END IF;

		ELSE
			SET Par_NumErr := 4;
			SET Par_ErrMen :='La factura ya esta en un anticipo, no puede ser Cancelada.';
			SET Var_Control := Par_NoFactura;
			LEAVE ManejoErrores;
		END IF;

	ELSE

		SET Par_NumErr := 5;
		SET Par_ErrMen :='El periodo contable esta cerrado, la factura no puede ser cancelada.';
		SET Var_Control := Par_NoFactura;
		LEAVE ManejoErrores;

	END IF;
END IF;


IF(Par_NumAct = NumActRutaArch)THEN
	UPDATE FACTURAPROV SET
		RutaImagenFact  = Par_RutaImgFact,
		RutaXMLFact     = Par_RutaXMLFact,

		EmpresaID       = Par_EmpresaID,
		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		WHERE NoFactura     = Par_NoFactura
		  AND ProveedorID   = Par_ProveedorID;

	SET Par_NumErr := 0;
	SET Par_ErrMen :=   CONCAT('La Factura: ',Par_NoFactura,' fue Actualizada.') ;
	SET Var_Control := Par_NoFactura;
END IF;



IF(Par_NumAct = Act_EstatusReq) THEN
	UPDATE FACTURAPROV SET
		Estatus = Est_Requisicion,

		EmpresaID       = Par_EmpresaID,
		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

	WHERE NoFactura     = Par_NoFactura
	  AND ProveedorID   = Par_ProveedorID;
END IF;


IF(Par_NumAct = NumActPagada) THEN
	UPDATE FACTURAPROV SET
		Estatus             = Est_Liquidada,
		SaldoFactura        = Decimal_Cero,

		EmpresaID           = Par_EmpresaID,
		Usuario             = Aud_Usuario,
		FechaActual         = Aud_FechaActual,
		DireccionIP         = Aud_DireccionIP,
		ProgramaID          = Aud_ProgramaID,
		Sucursal            = Aud_Sucursal,
		NumTransaccion      = Aud_NumTransaccion
		WHERE NoFactura     = Par_NoFactura
		AND ProveedorID     = Par_ProveedorID;
END IF;


IF(Par_NumAct = Act_CancelaReq)THEN
	SELECT Estatus INTO Var_EstatusFac
		FROM FACTURAPROV
		WHERE NoFactura     = Par_NoFactura
		  AND ProveedorID   = Par_ProveedorID;

	IF(Var_EstatusFac!=EstatusCancela) THEN
		UPDATE FACTURAPROV SET
			Estatus         = EstatusCancela,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			WHERE NoFactura     = Par_NoFactura
			  AND ProveedorID   = Par_ProveedorID;

		SET Par_NumErr = 0;


		CALL FACTURACONTACAN(
			Par_ProveedorID,    Par_NoFactura,  Par_FolioUUID,   SalidaNO,       Par_NumErr,         Par_ErrMen,
			Poliza,         Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		ELSE
				SET Par_NumErr = Entero_Cero;

		END IF;


	IF(Par_NumErr = Entero_Cero)THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '000' AS NumErr,
					CONCAT('La Factura con Folio:',Par_NoFactura,' fue Cancelada.') AS ErrMen,
					'noFactura' AS control,
					Par_NoFactura AS consecutivo;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen :=   CONCAT('La Factura con Folio:',Par_NoFactura,' fue Cancelada.') ;
			SET Var_Control := Par_NoFactura;
		END IF;
	ELSE
		IF(Par_Salida = SalidaSI) THEN
			SELECT Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					'noFactura' AS control,
					Par_NoFactura AS consecutivo;
		END IF;
		LEAVE ManejoErrores;
	END IF;

END IF;



IF(Par_NumAct = Act_SaldoFact) THEN

	SET Var_SaldoFactura := (SELECT SaldoFactura
								FROM FACTURAPROV
								WHERE   ProveedorID = Par_ProveedorID
									AND NoFactura   = Par_NoFactura);
	SET Var_Deferencia  := IFNULL(Var_SaldoFactura,Entero_Cero)- Par_Monto;

	IF( Var_Deferencia = Entero_Cero )THEN
		SET Var_Estatus := Est_Liquidada;
	ELSE
		SET Var_Estatus := Est_PagoParcial;
	END IF;

	UPDATE FACTURAPROV SET
		Estatus         = Var_Estatus,
		SaldoFactura    = SaldoFactura - Par_Monto,

		EmpresaID       = Par_EmpresaID,
		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion
	WHERE NoFactura     = Par_NoFactura
	 AND ProveedorID    = Par_ProveedorID;



	IF(Par_Salida = SalidaSI) THEN
		SELECT '000' AS NumErr,
				CONCAT('La Factura: ',Par_NoFactura,' fue Actualizada.') AS ErrMen,
				'noFactura' AS control,
				Par_NoFactura AS consecutivo;
	ELSE
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen :=   CONCAT('La Factura: ',Par_NoFactura,' fue Actualizada.') ;
		SET Var_Control := Par_NoFactura;
	END IF;

END IF;





IF(Par_NumAct = Act_FolioUUID) THEN

	 SELECT COUNT(FolioUUID)AS FolioUUID
	INTO Var_ConFolio
	FROM FACTURAPROV
	WHERE FolioUUID = Par_FolioUUID;

	IF(Var_ConFolio != Cadena_Vacia)THEN

		SET Par_NumErr := 2;
		SET Par_ErrMen :='El FolioUUID ya se fue Registrado.';
		SET Var_Control := 'folioUUID';
		LEAVE ManejoErrores;

	END IF;



	UPDATE FACTURAPROV SET
		FolioUUID       = Par_FolioUUID,
		EmpresaID       = Par_EmpresaID,
		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion
	WHERE ProveedorID   = Par_ProveedorID
	 AND NoFactura      = Par_NoFactura;


	SELECT FechaFactura
	INTO Var_FechaFact
	FROM FACTURAPROV
	WHERE ProveedorID   = Par_ProveedorID
	AND NoFactura     = Par_NoFactura;


	 SELECT Estatus
	 INTO Var_EstPeriodo
	 FROM PERIODOCONTABLE
	 WHERE Inicio<= Var_FechaFact AND Fin>= Var_FechaFact;


	 IF (Var_EstPeriodo = Est_Abierto)THEN

		UPDATE DETALLEPOLIZA DET, FACTURAPROV FAC
		   SET DET.FolioUUID = Par_FolioUUID
		 WHERE FAC.ProveedorID = Par_ProveedorID
		   AND FAC.NoFactura = Par_NoFactura
		   AND FAC.PolizaID = DET.PolizaID
		   AND FAC.FechaFactura = DET.Fecha;
	ELSE

		UPDATE `HIS-DETALLEPOL` DET, FACTURAPROV FAC
		   SET DET.FolioUUID = Par_FolioUUID
		 WHERE FAC.ProveedorID = Par_ProveedorID
		   AND FAC.NoFactura = Par_NoFactura
		   AND FAC.PolizaID = DET.PolizaID
		   AND FAC.FechaFactura = DET.Fecha;
	END IF;
END IF;

IF(Par_NumAct = Act_EstatusAct)THEN

	SELECT OrigenFactura, 			PolizaID
		INTO Var_OrigenFactura, 	Var_PolizaID
	FROM FACTURAPROV
	WHERE NoFactura   = Par_NoFactura
	AND ProveedorID   = Par_ProveedorID;

	IF(Var_PolizaID > Entero_Cero AND Var_OrigenFactura="FM")THEN

		SELECT 	SUM(Abonos),		SUM(Cargos)	INTO
				Var_TotalAbono, 	Var_TotalCargo
			FROM DETALLEPOLIZA
			WHERE PolizaID = Var_PolizaID;

			SET Var_TotalAbono := IFNULL(Var_TotalAbono, Entero_Cero);
			SET Var_TotalCargo := IFNULL(Var_TotalCargo, Entero_Cero);
			SET Var_DiferenciaTotales := ABS(Var_TotalCargo - Var_TotalAbono);

			IF(Var_TotalAbono != Var_TotalCargo)THEN
				SET Par_NumErr := 12;
				SET Par_ErrMen := CONCAT('Poliza descuadrada. DATOS: [Factura: ',Par_NoFactura,'<br>
																	Total Abono: ',Var_TotalAbono,'<br>
																	Total Cargo: ',Var_TotalCargo,'<br>
																	Diferencia: ', Var_DiferenciaTotales,']');
				SET Var_Control := 'noFactura';
				LEAVE ManejoErrores;
			END IF;

	END IF;
	UPDATE FACTURAPROV SET
		Estatus  		= "A",
		EmpresaID       = Par_EmpresaID,
		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		WHERE NoFactura     = Par_NoFactura
		  AND ProveedorID   = Par_ProveedorID;

	SET Par_NumErr := 0;
	SET Par_ErrMen :=   CONCAT('La Factura: ',Par_NoFactura,' fue Actualizada.') ;
	SET Var_Control := Par_NoFactura;
END IF;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := CONCAT('La Factura: ',Par_NoFactura,' fue Actualizada.');
SET Var_Control := Par_NoFactura;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr  AS NumErr,
			Par_ErrMen  AS ErrMen,
			'noFactura' AS control,
			 Var_Control AS consecutivo;
END IF;

END TerminaStore$$