-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREFONINTPROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREFONINTPROPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGCREFONINTPROPRO`(
	/* sp para aplicar pago por Interes Provicionado en pago de credito Pasivo*/
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

# DECLARACION DE VARIABLES
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_Refinancia			CHAR(1);		# Indica si el credito refinancia los intereses
DECLARE Var_EsAgropecuario		CHAR(1);		# Indica si el credito es agropecuario
DECLARE Var_MontoAcumulado		DECIMAL(14,2);	# Indica el Monto Acumulado de Intereses del Credito
DECLARE Var_MontoRefinanciar	DECIMAL(14,2);	# Indica el Monto a Refinanciar de Intereses del Credito
DECLARE Var_Estatus				CHAR(1);		# Estatus de la Amortizacion
DECLARE Var_FechaVencimiento	DATE;			# Fecha de Vencimiento de la Amortizacion
DECLARE Var_IVAMontoMN			DECIMAL(12,2);

/* DECLARACION DE CONSTANTES */
DECLARE	Cadena_Vacia	CHAR(1);		/* Cadena Vacia */
DECLARE	Entero_Cero		INT;			/* Entero Cero */
DECLARE	Decimal_Cero	DECIMAL(12, 2);	/* Decimal Cero */
DECLARE	AltaPoliza_NO	CHAR(1);
DECLARE	AltaMovCre_SI	CHAR(1);
DECLARE	AltaMovCre_NO	CHAR(1);
DECLARE	AltaMovTes_NO	CHAR(1);
DECLARE	AltaConFond		CHAR(1);
DECLARE	Salida_NO		CHAR(1);
DECLARE	Salida_SI		CHAR(1);
DECLARE	Nat_Cargo		CHAR(1);
DECLARE	Nat_Abono		CHAR(1);
DECLARE Est_Vigente		CHAR(1);
DECLARE Cons_SI			CHAR(1);
DECLARE Con_IntProvis 	INT;
DECLARE Con_IVAInteres 	INT;
DECLARE Con_ComplInt	INT;			/* Concepto Contable: Complemento cambio de Interes . tabla -  CONCEPTOSFONDEO */
DECLARE	Mov_IntProvis	INT(4);			/* Movimiento de interes moratorio  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IVAInteres 	INT(4);			/* Movimiento de IVA de interes moratorio   tabla - TIPOSMOVSFONDEO*/
DECLARE Var_CamMoneda	DECIMAL(12,2);
DECLARE Var_IntereMN	DECIMAL(12,2);
DECLARE MonedaMexico	INT(11);

/* ASIGNACION DE CONSTANTES */
SET	Cadena_Vacia		:= '';			/*Cadena Vacia */
SET	Entero_Cero			:= 0;			/* Entero Cero */
SET	Decimal_Cero		:= 0.00;		/* Decimal Cero */
SET	AltaPoliza_NO		:= 'N';
SET	AltaMovCre_SI		:= 'S';
SET	AltaConFond			:= 'S';
SET	AltaMovCre_NO		:= 'N';
SET	AltaMovTes_NO		:= 'N';
SET	Salida_NO			:= 'N';
SET	Salida_SI			:= 'S';
SET Nat_Cargo			:= 'C';
SET Nat_Abono			:= 'A';
SET Est_Vigente			:= 'N';			# Estatus Vigente
SET Cons_SI				:= 'S';			# Constante SI
SET Mov_IntProvis		:= 10;			/* Movimiento Operativo de Credito: Interes Provisionado tabla - TIPOSMOVSFONDEO*/
SET Mov_IVAInteres		:= 20;			/* Movimiento Operativo de Credito: IVA de Interes tabla - TIPOSMOVSFONDEO*/
SET Con_IntProvis		:= 8;			/* Resultados. Concepto Contable: Interes Provisionado. tabla -  CONCEPTOSFONDEO */
SET Con_IVAInteres		:= 5;			/* Concepto Contable: IVA Interes Provisionado . tabla -  CONCEPTOSFONDEO */
SET Con_ComplInt		:= 29;			/* Concepto Contable: Complemento cambio de Interes . tabla -  CONCEPTOSFONDEO */
SET MonedaMexico		:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREFONINTPROPRO');
			SET Var_Control := 'sqlException';
		END;

		SELECT  Refinancia,		EsAgropecuario,		InteresAcumulado,	InteresRefinanciar
		INTO 	Var_Refinancia, Var_EsAgropecuario,	Var_MontoAcumulado,	Var_MontoRefinanciar
		FROM 	CREDITOFONDEO
		WHERE 	CreditoFondeoID = Par_CreditoFonID;

        SELECT Estatus, FechaVencimiento INTO Var_Estatus, Var_FechaVencimiento
			FROM AMORTIZAFONDEO
			WHERE CreditoFondeoID = Par_CreditoFonID
			AND AmortizacionID = Par_AmortizacionID;

		SET Var_Refinancia 			:= IFNULL(Var_Refinancia, Cadena_Vacia);
		SET Var_EsAgropecuario		:= IFNULL(Var_EsAgropecuario, Cadena_Vacia);
		SET Var_MontoAcumulado		:= IFNULL(Var_MontoAcumulado, Decimal_Cero);
		SET Var_MontoRefinanciar	:= IFNULL(Var_MontoRefinanciar, Decimal_Cero);
        SET Var_Estatus				:= IFNULL(Var_Estatus, Cadena_Vacia);

        SELECT 		TipCamFixCom
        	INTO 	Var_CamMoneda
        	FROM MONEDAS
        	WHERE MonedaID = Par_MonedaID;

		IF (IFNULL(Par_Monto,Decimal_Cero) > Decimal_Cero) THEN
			# VALIDA SI EL CREDITO ES AGROPECUARIO Y REFINANCIA INTERESES
			IF(Var_EsAgropecuario = Cons_SI AND Var_Refinancia = Cons_SI AND Var_Estatus = Est_Vigente AND Var_FechaVencimiento > Par_FechaOperacion) THEN
				# VALIDA SI EL MONTO A PAGAR ES MAYOR AL MONTO BASE DE INTERES PARA EL CALCULO
				IF(Par_Monto > Var_MontoRefinanciar) THEN
					# AL INTERES ACUMULADO SE LE RESTA LO QUE SE ESTÁ PAGANDO Y EL INTERES SE QUEDA EN CERO
					UPDATE CREDITOFONDEO
							SET	InteresAcumulado 	= CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
												ELSE InteresAcumulado - Par_Monto END,
								InteresRefinanciar 	= Decimal_Cero
							WHERE CreditoFondeoID 	= Par_CreditoFonID;

				ELSE
					# SI EL MONTO A PAGAR NO ES MAYOR, AL INTERES ACUMULADO E INTERES A REFINANCIAR SE LE RESTA EL MONTO PAGADO
					UPDATE CREDITOFONDEO
							SET	InteresAcumulado 	= CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
												ELSE InteresAcumulado - Par_Monto END,
								InteresRefinanciar 	= InteresRefinanciar - Par_Monto
							WHERE CreditoFondeoID 	= Par_CreditoFonID;
				END IF;

			END IF;
			
			IF(Par_MonedaID <> MonedaMexico) THEN
				SET Var_IntereMN := Par_Monto * Var_CamMoneda;
			ELSE 
				SET Var_IntereMN := Par_Monto;
			END IF;

			
			/* se manda a llamar al proceso que genera la parte contable para el concepto de la cuenta de Resultados
			 * Egreso por Interes Moratorio */
			CALL CONTAFONDEOPRO(
				MonedaMexico,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IntProvis,
				Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Var_IntereMN,
				Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
				Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
				AltaMovCre_NO,		Par_AmortizacionID,	Mov_IntProvis,			AltaConFond,			Par_TipoFondeador,
		        Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
		        Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
		        Aud_Sucursal,   	Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			/* Movimiento Operativo */
			CALL CONTAFONDEOPRO(
				Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
				Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IntProvis,
				Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,
				Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
				Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
				AltaMovCre_SI,		Par_AmortizacionID,	Mov_IntProvis,			AltaMovTes_NO,			Par_TipoFondeador,
		        Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
		        Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
		        Aud_Sucursal,   	Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
			
			IF(Par_MonedaID <> MonedaMexico) THEN
			
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IntProvis,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Cargo,			Nat_Cargo,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_NO,		Par_AmortizacionID,	Mov_IntProvis,			AltaConFond,			Par_TipoFondeador,
					Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
				
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_ComplInt,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_Monto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Abono,
					Nat_Abono,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_No,		Par_AmortizacionID,	Mov_IntProvis,			AltaConFond,			Par_TipoFondeador,
					Salida_NO,      	Par_Poliza,         Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,  	Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			
			
			END IF;
			
			
			IF(IFNULL(Par_IVAMonto,Decimal_Cero) > Decimal_Cero) THEN /* Si hay un  monto de IVA */
				IF(Par_MonedaID <> MonedaMexico) THEN
					SET Var_IVAMontoMN := Par_IVAMonto * Var_CamMoneda;
				ELSE 
					SET Var_IVAMontoMN := Par_IVAMonto;
				END IF;
				/* se manda a llamar al proceso que genera la parte contable para el concepto de  IVA Interes Moratorio .*/
				CALL CONTAFONDEOPRO(
					MonedaMexico,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IVAInteres,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Var_IVAMontoMN,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_No,		Par_AmortizacionID,	Mov_IVAInteres,			AltaConFond,			Par_TipoFondeador,
		            Salida_NO,      Par_Poliza,     Par_Consecutivo,    Par_NumErr,         Par_ErrMen,
		            Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
		            Aud_Sucursal,   Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				/* Movimiento Operativo .*/
				CALL CONTAFONDEOPRO(
					Par_MonedaID,		Entero_Cero,		Par_InstitutFondID,		Par_InstitucionID,		Par_NumCtaInstit,
					Par_CreditoFonID,	Par_PlazoContable,	Par_TipoInstitID,		Par_NacionalidadIns,	Con_IVAInteres,
					Par_DescripcionMov,	Par_FechaOperacion, Par_FechaOperacion,		Par_FechaAplicacion,	Par_IVAMonto,
					Par_Referencia,		Par_Referencia,		AltaPoliza_NO,			Entero_Cero,			Nat_Cargo,
					Nat_Cargo,			Nat_Abono,			Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_SI,		Par_AmortizacionID,	Mov_IVAInteres,			AltaMovTes_NO,			Par_TipoFondeador,
		            Salida_NO,      	Par_Poliza,     	Par_Consecutivo,    	Par_NumErr,         	Par_ErrMen,
		            Par_EmpresaID,  	Aud_Usuario,    	Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,
		            Aud_Sucursal,   	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del sp */
					SET Par_Consecutivo := Entero_Cero;
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
