-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESCNOMINAREALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESCNOMINAREALALT`;
DELIMITER $$

CREATE PROCEDURE `DESCNOMINAREALALT`(
	-- SP PARA REGISTRAR LAS APLICACIONES DE PAGOS DE CREDITOS DE NOMINA EN TABLA REAL
	Par_FolioNominaID		INT(11),		-- ID del folio generado
	Par_FolioCargaID		INT(11),		-- Folio de carga del archivo
	Par_EmpresaNominaID		INT(11),		-- ID de la empresa de nomina
   	Par_FechaCarga			DATE,			-- Fecha de carga del archivo
	Par_CreditoID			BIGINT(12),		-- ID del credito

	Par_MontoPago			DECIMAL(18,2),	-- Monto del pago
	Par_FechaPagoInst		DATE,			-- Fecha de pago de la institucion
	Par_MontoAplicado		DECIMAL(18,2),	-- Monto aplicado
	Par_FechaAplicacion		DATE,			-- Fecha de aplicacion del pago
	Par_ClienteID			INT(11),		-- ID del cliente

	Par_Salida          	CHAR(1),		-- Indica si espera un select de salida
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT			-- Parametro de auditoria
	)
TerminaStore: BEGIN


DECLARE Var_InstitNominaID  VARCHAR(20);	-- Variable para el id de la institucion de nomina
DECLARE Var_Control         VARCHAR(100);	-- Variable de control
DECLARE Var_NumeroAmort		INT(11);		-- Cantidad de amortizaciones afectadas
DECLARE Var_AmortizacionID	INT(11);		-- ID de la amortizacion
DECLARE Var_Offset			INT(11);		-- Variable de apoyo para obtener los rangos de registros
DECLARE Var_FechaVenci		DATE;			-- Fecha de vencimiento de la cuota
DECLARE Var_FechaExigible	DATE;			-- Fecha exigible de la cuota
DECLARE Var_AplicaTabla		CHAR(1);		-- Indica si el credito aplica tabla S:SI/N:NO
DECLARE Var_FechaSis		DATE;
DECLARE Var_Registro		INT(11);		-- Variable Contador

DECLARE Estatus_Activo  CHAR(1);			-- Constante estatus activo 'A'
DECLARE Estatus_Vigente	CHAR(1);			-- Estatus vigente 'V'
DECLARE Cadena_Vacia    CHAR(1);			-- Constante cadena vacia
DECLARE Entero_Cero     INT(11);			-- Constante entero cero
DECLARE SalidaSI        CHAR(1);			-- Constante salida si
DECLARE Entero_Uno      INT(11);			-- Constante entero uno
DECLARE Cons_No			CHAR(1);			-- Constante NO
DECLARE Cons_Si			CHAR(1);			-- Constante SI


SET Estatus_Activo  := 'A';
SET Estatus_Vigente	:= 'V';
SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET Var_Offset		:= 0;
SET Entero_Uno		:= 1;
SET Cons_No			:= 'N';
SET Cons_Si			:= 'S';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set Par_NumErr = 999;
				set Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DESCNOMINAREALALT');
						SET Var_Control = 'sqlException' ;
			END;

	SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

	IF(IFNULL(Par_FolioNominaID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'El folio esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EmpresaNominaID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr  := 002;
		SET Par_ErrMen  := 'La empresa de nomina esta vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := 'El credito esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT * FROM CREDITOS WHERE CreditoID = Par_CreditoID) THEN
		SET Par_NumErr  := 004;
		SET Par_ErrMen  := 'El credito no existe.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoPago, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr  := 005;
		SET Par_ErrMen  := 'El monto del pago esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	SET Var_AplicaTabla := (SELECT AplicaTabla FROM  INSTITNOMINA WHERE InstitNominaID = Par_EmpresaNominaID);
	SET Var_AplicaTabla := IFNULL(Var_AplicaTabla,Cons_No);

	-- verificar si el credito aplica tabla real
	IF (Var_AplicaTabla = Cons_Si) THEN

		SELECT COUNT(AmortizacionID)  INTO Var_NumeroAmort
		FROM AMORTICREDITO
			WHERE  CreditoID = Par_CreditoID
			AND NumTransaccion = Aud_NumTransaccion;

		SET Var_NumeroAmort := IFNULL(Var_NumeroAmort,Entero_Cero);

		WHILE Var_NumeroAmort > Entero_Cero DO

			SET Var_Offset := Var_NumeroAmort-Entero_Uno;

			SELECT AmortizacionID,FechaVencim,FechaExigible
				INTO Var_AmortizacionID, Var_FechaVenci, Var_FechaExigible
			FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND NumTransaccion = Aud_NumTransaccion
				ORDER BY AmortizacionID DESC
				LIMIT Var_Offset , Entero_Uno;

			SET Par_FolioNominaID	:= (SELECT IFNULL(MAX(FolioNominaID),Entero_Cero) + Entero_Uno  FROM DESCNOMINAREAL);

			-- obtener el monto real aplicado en la cuota
			SET Par_MontoPago := (SELECT SUM(MontoTotPago)
									FROM DETALLEPAGCRE
									WHERE CreditoID = Par_CreditoID
									AND FechaPago = Var_FechaSis
									AND AmortizacionID = Var_AmortizacionID
									AND NumTransaccion = Aud_NumTransaccion);
			-- fin obtener monto real aplicado a la cuota

			SELECT COUNT(*)
			INTO Var_Registro
			FROM DESCNOMINAREAL
				WHERE FolioCargaID = Par_FolioCargaID
					AND EmpresaNominaID = Par_EmpresaNominaID
					AND CreditoID = Par_CreditoID
					AND AmortizacionID = Var_AmortizacionID;

			IF(Var_Registro = Entero_Cero)THEN

				INSERT INTO DESCNOMINAREAL (
					FolioNominaID,		FolioCargaID,		EmpresaNominaID,	FechaCarga,		CreditoID,
					AmortizacionID,		MontoPago,			Estatus,			EstatPagBanco,	FechaPagoIns,
					MontoAplicado,		FechaAplicacion,	FechaVencimiento,	FechaExigible,	ClienteID,
					EmpresaID,			Usuario,			FechaActual,		DireccionIP,	ProgramaID,
					Sucursal, 			NumTransaccion)
				VALUES(
					Par_FolioNominaID,		Par_FolioCargaID,		Par_EmpresaNominaID,	Par_FechaCarga,		Par_CreditoID,
					Var_AmortizacionID,		Par_MontoPago,			Estatus_Activo,			Estatus_Vigente,	Par_FechaPagoInst,
					Par_MontoAplicado,		Par_FechaAplicacion,	Var_FechaVenci, 		Var_FechaExigible,	Par_ClienteID,
					Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);

			ELSE

				UPDATE DESCNOMINAREAL SET
					MontoPago = Par_MontoPago
				WHERE FolioCargaID = Par_FolioCargaID
					AND CreditoID = Par_CreditoID
					AND EmpresaNominaID = Par_EmpresaNominaID
					AND AmortizacionID = Var_AmortizacionID;
			END IF;

			SET Var_NumeroAmort := Var_NumeroAmort - Entero_Uno;
		END WHILE;
	END IF; -- Fin if aplica tabla

		SET Par_NumErr  := 000;
        SET Par_ErrMen  :=  concat("Registro de aplicacion de pago realizado exitosamente: ",
        							CONVERT(Par_FolioNominaID, CHAR));

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$