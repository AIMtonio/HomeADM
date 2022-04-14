-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTADEPREAMORTIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTADEPREAMORTIPRO`;DELIMITER $$

CREATE PROCEDURE `CONTADEPREAMORTIPRO`(
# =====================================================================================
# -- STORED PARA MOVIMIENTOS CONTABLES EN LA DEPRECIACION Y AMORTIZACION DE ACTIVOS ---
# =====================================================================================
    Par_ActivoID  			INT(11),        --  ID del activo
    Par_TipoActivo      	INT(11),        --  Moneda: Tabla (TIPOSACTIVOS)
    Par_ConceptoActivoID 	INT(11),		--  Concepto de Activos (CONCEPTOSACTIVOS)
    Par_Fecha           	DATE,           --  fecha
    Par_SucOperacion		INT(11),		--  ID sucursal de operacion

    Par_Referencia      	VARCHAR(200),   --  Referencia
    Par_MonedaID        	INT(11),        --  ID de moneda
    Par_Monto		   		DECIMAL(14,2),  --  monto de pago servicio cuando es independiente (sin iva ) o cuando es tercero indica el monto pagado sin comision
    Par_ProveedorID     	INT(11),        -- Tipo de Proveedor: Tabla (PROVEEDORES)
    Par_AltaEncPol      	CHAR(1),        --  Indica si da de alta el encabezado de la poliza

    Par_AltaDetPol      	CHAR(1),        --  Indica si da de alta el detalle de la poliza
    Par_NatDetPol       	CHAR(1),        --  indica la naturaleza de los detalles de la poliza
	Par_Anio				INT(11),		-- Anio
	Par_Mes					INT(11),		-- Mes

    INOUT Par_Poliza    	BIGINT(20), 	--  Numero de poliza
    Par_Salida    			CHAR(1),		--  Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		--  Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	--  Parametro de salida mensaje de error

	Par_EmpresaID       	INT(11),		-- Parametro de Auditoria
    Aud_Usuario         	INT(11),		-- Parametro de Auditoria
    Aud_FechaActual     	DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        	INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  	BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE Var_Control         	VARCHAR(100);
    DECLARE Var_VtaTiempoAireID 	BIGINT(12);
	DECLARE Var_Consecutivo         BIGINT(12);
	DECLARE Var_ConceptoConDes      VARCHAR(150);
	DECLARE Var_Cargos              DECIMAL(16,4);

	DECLARE Var_Abonos              DECIMAL(16,4);

	-- Declaracion de Constantes

	DECLARE Cadena_Vacia        	CHAR(1);
	DECLARE Entero_Cero         	INT(11);
	DECLARE Decimal_Cero        	DECIMAL(12,2);
	DECLARE Fecha_Vacia         	DATE;
	DECLARE Salida_SI           	CHAR(1);

	DECLARE Salida_NO           	CHAR(1);
	DECLARE Alta_Si     			CHAR(1);        /*Indica SI en alta pago de servicios*/
	DECLARE AltaEncPol_Si       	CHAR(1);        /*Indica SI en alta encabezado de la poliza*/
	DECLARE AltaDetPol_Si       	CHAR(1);        /*Indica SI en alta detalle de la poliza*/
	DECLARE Pol_Automatica      	CHAR(1);		/* Genera poliza automatica*/

	DECLARE Var_ConceptoConID   	INT(11);    	/* ID Concepto contable venta de tiempo aire*/
	DECLARE Nat_Cargo           	CHAR(1);		/* Naturaleza Cargo*/
	DECLARE TipoInstrumentoID   	INT(11); 		/* Tipo de Instrumento*/
    DECLARE ID_ConcepCajacomiVTA	INT(11);		/* id concepto caja comision venta de tiempo aire */

    DECLARE ID_ConcepCajaIVAcomVTA	INT(11);		/* id concepto caja IVA comision venta de tiempo aire */

	-- Asignacion de Constantes

	SET Cadena_Vacia        	:= '';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero        	:= 0.0;
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Salida_SI           	:= 'S';

	SET Salida_NO           	:= 'N';
	SET Alta_Si     			:= 'S';
	SET AltaEncPol_Si       	:= 'S';
	SET AltaDetPol_Si       	:= 'S';
	SET Pol_Automatica      	:= 'A';

	SET Var_ConceptoConID   	:= 1000;
	SET Nat_Cargo           	:='C';
	SET TipoInstrumentoID   	:= 8;
    SET ID_ConcepCajacomiVTA	:= 11;

    SET ID_ConcepCajaIVAcomVTA	:= 12;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTADEPREAMORTIPRO');
			END;

	IF (Par_AltaEncPol = AltaEncPol_Si) THEN /* se da de alta el encabezado de la poliza */

		SET  Var_ConceptoConDes := (SELECT Descripcion  -- se obtiene la descripcion del concepto contable
										FROM CONCEPTOSCONTA
										WHERE ConceptoContaID = Var_ConceptoConID);
		SET Var_ConceptoConDes := CONCAT(Var_ConceptoConDes,' ', CASE Par_Mes
																	WHEN 1 THEN 'ENERO'
																	WHEN 2 THEN 'FEBRERO'
																	WHEN 3 THEN 'MARZO'
																	WHEN 4 THEN 'ABRIL'
																	WHEN 5 THEN 'MAYO'
																	WHEN 6 THEN 'JUNIO'
																	WHEN 7 THEN 'JULIO'
																	WHEN 8 THEN 'AGOSTO'
																	WHEN 9 THEN 'SEPTIEMBRE'
																	WHEN 10 THEN 'OCTUBRE'
																	WHEN 11 THEN 'NOVIEMBRE'
																	WHEN 12 THEN 'DICIEMBRE'
																	END,' ',Par_Anio);

		CALL MAESTROPOLIZASALT(
			Par_Poliza,         Par_EmpresaID,  	Par_Fecha,          Pol_Automatica,     Var_ConceptoConID,
			Var_ConceptoConDes,
            Salida_NO,      	Par_NumErr,     	Par_ErrMen,			Aud_Usuario,        Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE TerminaStore;
		END IF;

	END IF;

	IF(Par_AltaDetPol = AltaDetPol_Si) THEN  /* valida si se da de alta el detalle de la poliza */

        IF(Par_Monto > Decimal_Cero) THEN

			IF(Par_NatDetPol    = Nat_Cargo) THEN
				SET Var_Cargos  := Par_Monto;
				SET Var_Abonos  := Entero_Cero;
			ELSE
				SET Var_Cargos  := Entero_Cero;
				SET Var_Abonos  := Par_Monto;
			END IF;

			CALL POLIZASACTIVOSPRO(
				Par_Poliza,         Par_Fecha,   			Par_ActivoID,		Par_SucOperacion,		Par_ConceptoActivoID,
                Var_Cargos,         Var_Abonos,             Par_TipoActivo,		Par_MonedaID,  			Par_ProveedorID,
                Cadena_Vacia,       Par_Referencia,
                Salida_NO,          Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,		    Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion
			);

            IF(Par_NumErr !=  Entero_Cero) THEN
				LEAVE ManejoErrores;
            END IF;

		END IF;-- Monto del Servicio >0

	END IF; -- Alta en el detalle de la Poliza

	SET Par_NumErr 		:= 0;
	SET Par_ErrMen := "Movimientos Realizados.";
	SET Var_Control		:= '';
	SET Var_Consecutivo	:= Par_ActivoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$