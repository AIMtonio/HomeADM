-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEIMPFACTALTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEIMPFACTALTPRO`;
DELIMITER $$


CREATE PROCEDURE `DETALLEIMPFACTALTPRO`(
# =====================================================================================
# SP PARA ALTA DE DETALLE DE IVA
# =====================================================================================
    Par_ProveedorID         INT(11),
    Par_NoFactura           VARCHAR(20),
    Par_NoPartidaID         INT(11),
    Par_PagoAnticipado      CHAR(1),
    Par_TipoPagoAnt         CHAR(1),
    Par_FechaFactura        DATE,

    Par_CentroCostoID       INT(11),
    Par_CenCostoAntID       INT(11),
    Par_CenCostoManualID    INT(11),
    Par_EmpleadoID          INT(11),
    Par_FolioUUID           VARCHAR(100),
    Par_ImpuestoID          INT(11),

    Par_ImporteImpuesto     DECIMAL(14,2),
    Par_Poliza              BIGINT,
    Par_ProrrateaImp        CHAR(1),

    Par_GeneraConta         CHAR(1),			-- GENERA CONTABILIDAD S.-SI N.-NO
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )

TerminaStore: BEGIN


DECLARE Var_Control     VARCHAR(200);
DECLARE Var_Consecutivo INT(11);
DECLARE Var_Poliza      BIGINT;
DECLARE Var_CtaContable VARCHAR(25);
DECLARE Var_RFC         CHAR(13);
DECLARE Var_NatConta    CHAR(2);
DECLARE Var_TraCue      VARCHAR(25);
DECLARE Var_ReaCue      VARCHAR(25);
DECLARE Var_TipoImp     CHAR(1);
DECLARE Var_DescripMov 	VARCHAR(50);


DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE SalidaNO            CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE Tipo_PagAntFact     CHAR(1);
DECLARE AltaPoliza_NO       CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Tipo_RegFact        CHAR(1);
DECLARE Imp_Gravado         CHAR(1);
DECLARE Imp_Retenido        CHAR(1);
DECLARE Con_PagoAntSI       CHAR(1);
DECLARE Con_PagAntFact      INT(11);
DECLARE Des_PagoAntFact     VARCHAR(100);
DECLARE Con_IngFactura      INT(11);
DECLARE Des_IngrFactura     VARCHAR(100);
DECLARE Cuenta_Vacia        VARCHAR(15);
DECLARE Par_PagoAntNO       CHAR(1);
DECLARE Con_ProrrateaImpNO  CHAR(1);


SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET SalidaSI            := 'S';
SET SalidaNO            := 'N';
SET Tipo_RegFact        := 'R';
SET Tipo_PagAntFact     := 'G';
SET AltaPoliza_NO       := 'N';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Imp_Gravado         := 'G';
SET Imp_Retenido        := 'R';
SET Con_PagoAntSI       := 'S';
SET Con_PagAntFact      := 85;
SET Des_PagoAntFact     := 'PAGO ANTICIPADO DE FACTURA';
SET Con_IngFactura      := 71;
SET Des_IngrFactura     := 'REGISTRO DE FACTURA';
SET Cuenta_Vacia        := '000000000000000';
SET Par_PagoAntNO       := 'N';
SET Con_ProrrateaImpNO  :='N';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN

                    SET Par_NumErr = 999;
                    SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-DETALLEIMPFACTALTPRO');
                    SET Var_Control = 'sqlException';

            END;


    IF(Par_PagoAnticipado = Con_PagoAntSI)THEN
        SET Par_CenCostoAntID := IFNULL(Par_CenCostoAntID,Entero_Cero);
            IF(Par_CenCostoAntID=Entero_Cero) THEN
                SET Par_NumErr  :=  1;
                SET Par_ErrMen  := 'El Centro de Costo de Pago Anticipo esta vacio';
                SET Var_Control := 'cenCostoAntID';
                LEAVE ManejoErrores;
            END IF;
        SET Par_EmpleadoID := IFNULL(Par_EmpleadoID,Entero_Cero);
        IF(Par_EmpleadoID=Entero_Cero)THEN
                SET Par_NumErr  :=  2;
                SET Par_ErrMen  := 'El Numero de Empleado esta vacio';
                SET Var_Control := 'noEmpleadoID';
                LEAVE ManejoErrores;
        END IF;
    END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Var_RFC:= IFNULL(Var_RFC,Cadena_Vacia);

INSERT INTO DETALLEIMPFACT  (
    ProveedorID,        NoFactura,          NoPartidaID,    ImpuestoID,     ImporteImpuesto,
    EmpresaID,          Usuario,            FechaActual,    DireccionIP,    ProgramaID,
    Sucursal,           NumTransaccion)
    VALUES (
    Par_ProveedorID,    Par_NoFactura,      Par_NoPartidaID,Par_ImpuestoID, Par_ImporteImpuesto,
    Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
    Aud_Sucursal,       Aud_NumTransaccion);

        SET Par_NumErr := 000;
        SET Par_ErrMen := 'Importe de Impuesto Agregado Exitosamente';
        SET Var_Control:= 'importeImpuesto';

     SELECT IFNULL(Descripcion,'')AS Descripcion
     INTO Var_DescripMov
     FROM DETALLEFACTPROV
     WHERE NoFactura = Par_NoFactura
     AND ProveedorID = Par_ProveedorID
     AND NoPartidaID = Par_NoPartidaID;


    SELECT CtaEnTransito, CtaRealizado, GravaRetiene
    INTO   Var_TraCue,    Var_ReaCue,   Var_TipoImp
    FROM IMPUESTOS
    WHERE ImpuestoID = Par_ImpuestoID;

    SET Var_TraCue := IFNULL(Var_TraCue, Cuenta_Vacia);
    SET Var_ReaCue := IFNULL(Var_ReaCue, Cuenta_Vacia);

	IF(Par_GeneraConta = "S")THEN

		 IF(Par_PagoAnticipado = Con_PagoAntSI)THEN

			IF(Var_TipoImp = Imp_Gravado)THEN
				SET Var_NatConta := Nat_Cargo;
			ELSE
				IF(Var_TipoImp = Imp_Retenido)THEN
					SET Var_NatConta := Nat_Abono;
				END IF;

			END IF;

			 SET Var_CtaContable := Var_ReaCue;

			 CALL CONTAFACTURAPRO(
				Par_ProveedorID,        Par_NoFactura,          Tipo_PagAntFact,        Par_PagoAnticipado,     AltaPoliza_NO,
				Par_Poliza,             Par_FechaFactura,       Par_ImporteImpuesto,    Par_CentroCostoID,      Par_CenCostoManualID,
				Var_CtaContable,        Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
				Con_PagAntFact,         Des_PagoAntFact,       	Entero_Cero,            Par_Salida,             Par_NumErr,
				Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


		ELSE

			SET Var_CtaContable := Var_TraCue;


			IF(Var_TipoImp = Imp_Gravado)THEN
				SET Var_NatConta := Nat_Cargo;
			ELSE
				IF(Var_TipoImp = Imp_Retenido)THEN
					SET Var_NatConta := Nat_Abono;
				END IF;

			END IF;

			CALL CONTAFACTURAPRO(
				Par_ProveedorID,        Par_NoFactura,          Tipo_RegFact,           Par_PagoAntNO,          AltaPoliza_NO,
				Par_Poliza,             Par_FechaFactura,       Par_ImporteImpuesto,    Par_CenCostoManualID,   Par_CentroCostoID,
				Var_CtaContable,        Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
				Con_IngFactura,         Des_IngrFactura,        Entero_Cero,            Par_Salida,             Par_NumErr,
				Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

	END IF;
END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Par_NoFactura   AS Consecutivo;
    END IF;

END TerminaStore$$