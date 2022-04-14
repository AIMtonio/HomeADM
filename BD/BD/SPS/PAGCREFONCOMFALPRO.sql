-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREFONCOMFALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREFONCOMFALPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREFONCOMFALPRO`(
	/* sp para aplicar la comision por falta de pago de credito Pasivo*/
	Par_CreditoFonID	BIGINT(20),		/* ID del credito Pasivo*/
	Par_AmortizacionID	INT(4),			/* Numero de amortizacion */
	Par_MonedaID		INT,			/* Moneda del credito pasivo*/
	Par_InstitutFondID	INT(11),		/* id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO*/
	Par_InstitucionID	INT(11),		/* Numero de Institucion (INSTITUCIONES) */

	Par_NumCtaInstit	VARCHAR(20),	/* Numero de Cuenta Bancaria. */
	Par_PlazoContable	CHAR(1),		/* plazo contable C.- Corto plazo L.- Largo Plazo*/
	Par_TipoInstitID	INT(11),		/* Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION */
	Par_NacionalidadIns	CHAR(1),		/* Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON*/
	Par_DescripcionMov	VARCHAR(100),	/* descripcion de la Operacion*/
	Par_TipoFondeador   CHAR(1),        -- Tipo de Operacion: Inversion(I) o Fondeo(F)

	Par_Poliza			BIGINT,			/* Numero de Poliza COntable*/
	Par_Monto			DECIMAL(12,2),	/* Monto de la comision*/
	Par_IVAMonto		DECIMAL(12,2),	/* IVA de la comision */
	Par_FechaOperacion	DATE,			/* Fecha de Operacion */
	Par_FechaAplicacion	DATE,			/* Fecha de Aplicacion */

	Par_Referencia		VARCHAR(50),	/* Referencia */
    Par_Salida			CHAR(1),
INOUT	Par_NumErr		INT(11),
INOUT	Par_ErrMen		VARCHAR(400),
INOUT	Par_Consecutivo	BIGINT,
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,

	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_MontoMN		DECIMAL(12,2);
	DECLARE Var_CamMoneda	DECIMAL(12,2);
	DECLARE Var_IVAMonto	DECIMAL(12,2);

	/* DECLARACION DE CONSTANTES */
	DECLARE	Cadena_Vacia	CHAR(1);		/* Cadena Vacia */
	DECLARE	Entero_Cero		INT;			/* Entero Cero */
	DECLARE	Decimal_Cero	DECIMAL(12,2);	/* Decimal Cero */
	DECLARE	AltaPoliza_NO	CHAR(1);
	DECLARE	AltaMovCre_SI	CHAR(1);
	DECLARE	AltaMovCre_NO	CHAR(1);
	DECLARE	AltaMovTes_NO	CHAR(1);
	DECLARE	AltaConFond		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE Con_EgrFalPag 	INT;
	DECLARE Con_IVAFalPag 	INT;
	DECLARE Con_CtaOrdCom 	INT;
	DECLARE Con_CorComFal 	INT;
	DECLARE	Mov_ComFalPag	INT(4);		/* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
	DECLARE	Mov_IVAFalPag 	INT(4);		/* Movimiento de IVA por Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
	DECLARE MonedaMN		INT(11);

	/* ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';		/*Cadena Vacia */
	SET	Entero_Cero			:= 0;		/* Entero Cero */
	SET	Decimal_Cero		:= 0.00;	/* Decimal Cero */
	SET	AltaPoliza_NO		:= 'N';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaConFond			:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovTes_NO		:= 'N';
	SET	Salida_NO			:= 'N';
	SET	Salida_SI			:= 'S';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET	Mov_ComFalPag 		:= 40;			/* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
	SET Mov_IVAFalPag 		:= 22;			/* Movimiento de IVA por Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
	SET Con_EgrFalPag 		:= 10;			/* Resultados. Egreso por Com.Falta Pago. tabla -  CONCEPTOSFONDEO */
	SET Con_IVAFalPag 		:= 7;			/* IVA Com. Falta Pago . tabla -  CONCEPTOSFONDEO */
	SET Con_CtaOrdCom 		:= 15;			/* Cta. Orden Comision Falta Pago		. tabla -  CONCEPTOSFONDEO */
	SET Con_CorComFal 		:= 16;			/* Corr. Cta. Orden Com. Falta Pago. tabla -  CONCEPTOSFONDEO */
	SET MonedaMN			:= 1;

	ManejoErrores: BEGIN
		/*
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREFONCOMFALPRO');
			SET Var_Control := 'sqlException';
		END;
		*/

		IF (IFNULL(Par_Monto,Decimal_Cero) > Decimal_Cero) THEN
			SELECT 		TipCamFixCom 
				INTO 	Var_CamMoneda
				FROM MONEDAS
				WHERE MonedaID = Par_MonedaID;
			
			IF(Par_MonedaID <> MonedaMN) THEN
				SET Var_MontoMN := Par_Monto * Var_CamMoneda;
			ELSE 
				SET Var_MontoMN := Par_Monto;
			END IF;

			/* se manda a llamar al proceso que genera la parte contable para el concepto de la cuenta de Resultados
			 * Egreso por Comision por falta de pago. */
			CALL CONTAFONDEOPRO(
				MonedaMN,       	Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
				Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_EgrFalPag,
				Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Var_MontoMN,
				Par_Referencia,     Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Cargo,
				Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
				AltaMovCre_NO,      Par_AmortizacionID, Mov_ComFalPag,      AltaConFond,            Par_TipoFondeador,
				Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
				Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			/* Movimiento operativo */
			CALL CONTAFONDEOPRO(
				Par_MonedaID,       Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
				Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_EgrFalPag,
				Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,
				Par_Referencia,     Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Cargo,
				Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
				AltaMovCre_SI,      Par_AmortizacionID, Mov_ComFalPag,      AltaMovTes_NO,          Par_TipoFondeador,
				Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
				Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			/* se manda a llamar al proceso que genera la parte contable para el concepto de Cta. Orden Comision Falta Pago	*/
			CALL CONTAFONDEOPRO(
				MonedaMN,			Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_CtaOrdCom,
				Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Var_MontoMN,
				Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Abono,
				Nat_Abono,			Cadena_Vacia,		Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
				AltaMovCre_NO,		Par_AmortizacionID,	Mov_ComFalPag,			AltaConFond,			Par_TipoFondeador,
				Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,         	Par_ErrMen,
				Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,
				Aud_Sucursal,   	Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			/* se manda a llamar al proceso que genera la parte contable para el concepto de Cta. Orden correlativa Comision Falta Pago	*/
			CALL CONTAFONDEOPRO(
				MonedaMN,			Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_CorComFal,
				Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Var_MontoMN,
				Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
				Nat_Cargo,			Cadena_Vacia,		Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
				AltaMovCre_NO,		Par_AmortizacionID,	Mov_ComFalPag,			AltaConFond,			Par_TipoFondeador,
				Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
				Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,   	Aud_NumTransaccion  );

			IF(Par_NumErr = Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_NumErr	:= 0;
			ELSE
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MonedaID <> MonedaMN) THEN
				/* se manda a llamar al proceso que genera la parte contable para el concepto de Cta. Orden Comision Falta Pago	*/
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_CtaOrdCom,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Abono,			Cadena_Vacia,		Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_NO,		Par_AmortizacionID,	Mov_ComFalPag,			AltaConFond,			Par_TipoFondeador,
					Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,         	Par_ErrMen,
					Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				/* se manda a llamar al proceso que genera la parte contable para el concepto de Cta. Orden correlativa Comision Falta Pago	*/
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_CorComFal,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Abono,
					Nat_Cargo,			Cadena_Vacia,		Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_NO,		Par_AmortizacionID,	Mov_ComFalPag,			AltaConFond,			Par_TipoFondeador,
					Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_IVAMonto,Decimal_Cero) > Decimal_Cero) THEN /* Si hay un  monto de IVA */
				IF(Par_MonedaID <> MonedaMN) THEN
					SET Var_IVAMonto := Par_IVAMonto * Var_CamMoneda;
				ELSE 
					SET Var_IVAMonto := Par_IVAMonto;
				END IF;

				/* se manda a llamar al proceso que genera la parte contable para el concepto de  IVA Com. Falta Pago .*/
				CALL CONTAFONDEOPRO(
					MonedaMN,			Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IVAFalPag,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Var_IVAMonto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_NO,		Par_AmortizacionID,	Mov_IVAFalPag,			AltaConFond,			Par_TipoFondeador,
		            Salida_NO,      	Par_Poliza,         Par_Consecutivo,        Par_NumErr,         	Par_ErrMen,
		            Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    	Aud_ProgramaID,
		            Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				/* Movimiento Operativo .*/
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IVAFalPag,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_IVAMonto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_SI,		Par_AmortizacionID,	Mov_IVAFalPag,			AltaMovTes_NO,			Par_TipoFondeador,
		            Salida_NO,      	Par_Poliza,         Par_Consecutivo,        Par_NumErr,         	Par_ErrMen,
		            Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    	Aud_ProgramaID,
		            Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Proceso Realizado Exitosamente.';
		SET Var_Control		:= 'graba';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$