-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREFONCAPVIGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREFONCAPVIGPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGCREFONCAPVIGPRO`(
	/* sp para aplicar pago por capital vigente  en pago de credito Pasivo*/
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
INOUT	Par_NumErr		INT,
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
	/*DECLARACION DE VARIABLES*/
	DECLARE Var_Control			VARCHAR(50);

	/* DECLARACION DE CONSTANTES */
	DECLARE	Cadena_Vacia	CHAR(1);		/* Cadena Vacia */
	DECLARE	Entero_Cero		INT;			/* Entero Cero */
	DECLARE	Decimal_Cero	DECIMAL(12, 2);	/* Decimal Cero */
	DECLARE	AltaPoliza_NO	CHAR(1);
	DECLARE	AltaMovCre_SI	CHAR(1);
	DECLARE	AltaMovCre_NO	CHAR(1);
	DECLARE	AltaMovTes_NO	CHAR(1);
	DECLARE	AltaConFond		CHAR(1);	--
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE Con_CapVigente 	INT;
	DECLARE	Mov_CapVigente 	INT(4);		/* Movimiento de IVA de interes moratorio   tabla - TIPOSMOVSFONDEO*/
	DECLARE MonedaMN		INT(11);
	DECLARE Con_CompCap		INT(11);	/* concepto contable Complemento cambio de capital  -  CONCEPTOSFONDEO */
	DECLARE Var_MontoMN		DECIMAL(12,2);
	DECLARE Var_CamMoneda	DECIMAL(12,2);

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
	SET Mov_CapVigente		:= 1;		/* Movimiento de capital vigente tabla - TIPOSMOVSFONDEO*/
	SET Con_CapVigente		:= 1;		/* concepto contable de capital vigente  -  CONCEPTOSFONDEO */
	SET Con_CompCap			:= 28;		/* concepto contable Complemento cambio de capital  -  CONCEPTOSFONDEO */
	SET MonedaMN			:= 1;
	
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREFONCAPVIGPRO');
			SET Var_Control := 'sqlException';
		END;

		IF (IFNULL(Par_Monto,Decimal_Cero) > Decimal_Cero) THEN
		
			IF(Par_MonedaID <> MonedaMN) then
				SELECT TipCamFixCom INTO Var_CamMoneda FROM MONEDAS WHERE MonedaID = Par_MonedaID;
				SET Var_MontoMN := Par_Monto * Var_CamMoneda;
			ELSE 
				SET Var_MontoMN := Par_Monto;
			END IF;
			
			/* se manda a llamar al proceso que genera la parte contable para el concepto de  capital
				vigente */
		    CALL CONTAFONDEOPRO(
		        MonedaMN,			Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
		        Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_CapVigente,
		        Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Var_MontoMN,
		        Par_Referencia,		Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Cargo,
		        Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
		        AltaMovCre_NO,      Par_AmortizacionID, Mov_CapVigente,     AltaConFond,            Par_TipoFondeador,
		        Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
		        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
		        Aud_Sucursal,       Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			/* se manda a llamar al proceso que genera la parte operativa e para el concepto de  capital
				vigente */
		    CALL CONTAFONDEOPRO(
		        Par_MonedaID,		Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
		        Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_CapVigente,
		        Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,
		        Par_Referencia,		Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Cargo,
		        Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
		        AltaMovCre_SI,      Par_AmortizacionID, Mov_CapVigente,     AltaMovTes_NO,          Par_TipoFondeador,
		        Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
		        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
		        Aud_Sucursal,       Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			
			IF(Par_MonedaID <> MonedaMN) THEN
				-- se realiza el cargo para capital moneda Extranjera
				CALL CONTAFONDEOPRO(
					Par_MonedaID,       Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
					Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_CapVigente,
					Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,
					Par_Referencia,		Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Cargo,
					Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
					AltaMovCre_NO,      Par_AmortizacionID, Mov_CapVigente,     AltaConFond,            Par_TipoFondeador,
					Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,       Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
				-- Se realiza el abono para capital moneda Extranjera
				CALL CONTAFONDEOPRO(
					Par_MonedaID,       Entero_Cero,        Par_InstitutFondID, Par_InstitucionID,      Par_NumCtaInstit,
					Par_CreditoFonID,   Par_PlazoContable,  Par_TipoInstitID,   Par_NacionalidadIns,    Con_CompCap,
					Par_DescripcionMov, Par_FechaOperacion, Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,
					Par_Referencia,		Par_Referencia,     AltaPoliza_NO,      Entero_Cero,            Nat_Abono,
					Nat_Cargo,          Nat_Abono,          Cadena_Vacia,       AltaMovTes_NO,          Cadena_Vacia,
					AltaMovCre_NO,      Par_AmortizacionID, Mov_CapVigente,     AltaConFond,            Par_TipoFondeador,
					Salida_NO,          Par_Poliza,         Par_Consecutivo,    Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,       Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
			
		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Proceso Realizado Exitosamente';
		SET Var_Control		:= 'graba';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$
