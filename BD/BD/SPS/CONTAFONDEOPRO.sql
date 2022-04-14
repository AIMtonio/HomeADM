-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAFONDEOPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTAFONDEOPRO`(
	/*SP PARA DAR DE ALTA LA CONTABILIDAD DEL PROCESO DE FONDEO*/
	Par_MonedaID			INT,				-- Moneda o Divisa
	Par_LineaFondeoID		INT(11),			-- Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondID		INT(11),			-- Id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	Par_InstitucionID		INT(11),			-- Numero de Institucion (INSTITUCIONES)
	Par_NumCtaInstit		VARCHAR(20),		-- Numero de Cuenta Bancaria

	Par_CreditoFondeoID		BIGINT(20),			-- ID del credito de fondeo
	Par_PlazoContable		CHAR(1),			-- Plazo contable C.- Corto plazo L.- Largo Plazo
	Par_TipoInstitID		INT(11),			-- Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	Par_NacionalidadIns		CHAR(1),			-- Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON
	Par_ConceptoOpera		INT,				-- Concepto de operacion, corresponde con la tabla CONCEPTOSFONDEO

	Par_DescripcionMov		VARCHAR(100),		-- Descripcion de la Operacion
	Par_FechaOperacion		DATE,
	Par_FechaContable		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(14,4),

	Par_Referencia			VARCHAR(50),
	Par_Instrumento			VARCHAR(20),
	Par_AltaEncPoliza		CHAR(1),			-- Indica si se dara o no de alta el encabezado de la poliza
	Par_ConceptoCon			INT,				-- Corresponde el concepto contable - tabla CONCEPTOSCONTA
	Par_NatConFon			CHAR(1),			-- Indica la naturaleza contable del Fondeo

	Par_NatConTeso			CHAR(1),			-- Indica la naturaleza contable de tesoreria
	Par_NatOpeFon			CHAR(1),			-- Indica la naturaleza operativa de fondeo
	Par_NatOpeTeso			CHAR(1),			-- Indica la naturaleza operativa de tesoreria
	Par_AltaMovsTeso		CHAR(1),			-- Indica si se dara de alta los movs operativos y contables de tesoreria
	Par_TipMovTeso			CHAR(4),			-- Indica el tipo de movimiento de tesoreria tabla TIPOSMOVTESO

	Par_AltaMovsFond		CHAR(1),			-- Indica si se dara de alta los movs operativos del credito pasivo
	Par_AmortizacionID		INT(4),				-- ID de la Amortizacion de fondeo
	Par_TipoMovFondeoID 	INT(4),				-- Tipo de movimiento de fondeo tabla .- TIPOSMOVSFONDEO
	Par_AltaConFond			CHAR(1),			-- Indica si se dara de alta los movs contables  del credito pasivo
	Par_TipoFondeador		CHAR(1),			-- Tipo de Operacion: Inversion(I) o Fondeo(F)

	Par_Salida				CHAR(1),
	INOUT	Par_Poliza		BIGINT,
	INOUT	Par_Consecutivo	BIGINT,
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia		CHAR(1);		/* Cadena Vacia*/
	DECLARE	Entero_Cero			INT;			/* Entero en Cero*/
	DECLARE Entero_Cien			INT(11);		/* Entero en 100*/
	DECLARE	Decimal_Cero		DECIMAL(12,2);	/* Decimal en Cero*/
	DECLARE	Fecha_Vacia			DATE;			/* Fecha Vacia*/
	DECLARE	Salida_SI			CHAR(1);		/* Valor para devolver una Salida */
	DECLARE	Salida_NO			CHAR(1);		/* Valor para no devolver una Salida */
	DECLARE	Var_SI				CHAR(1);		/* Si */
	DECLARE	AltaPoliza_NO		CHAR(1);		/* Indica que no se dara de alta el encabezado de la poliza*/
	DECLARE	Pol_Automatica		CHAR(1);		/* Indica que se trata de una poliza automatica */
	DECLARE Conciliado_NO		CHAR(1);		/* Indica que el movimiento no ha sido conciliado */
	DECLARE Reg_Automatico		CHAR(1);		/* Indica que fue un registro automatico */
	DECLARE OtorgaCrePasID		CHAR(4); 		/* ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	DECLARE PagoCrePasID		CHAR(4); 		/* ID del TIPOSMOVTESO - PAGO CREDITO PASIVO */
	DECLARE OtorgaCrePasDes		VARCHAR(150);	/* descripcion del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	DECLARE PagoCrePasDes		VARCHAR(150);	/* descripcion del TIPOSMOVTESO - PAGO CREDITO PASIVO */
	DECLARE Sin_ErrorChar		CHAR(3); 		/* Indica que no hubo error*/
	DECLARE Procedimiento		VARCHAR(20);	/* Procedimiento que ejecuta el detalle de poliza */
	DECLARE	Nat_Cargo			CHAR(1);		/* Naturaleza de Cargo  */
	DECLARE	Nat_Abono			CHAR(1);		/* Naturaleza de Abono  */

	/* DECLARACION DE VARIABLES */
	DECLARE Var_CtaContaBan		VARCHAR(25);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_CentroCosto		INT;
	DECLARE Var_FolioMovTeso	BIGINT;
	DECLARE Var_NumErrChar		CHAR(3);
	DECLARE Var_MontoCargo		DECIMAL(14,4);
	DECLARE Var_MontoAbono		DECIMAL(14,4);
	DECLARE Var_FiguraFondeador	CHAR(1);
	DECLARE TipoInstrumentoID 	INT(11);
	DECLARE Var_Control			VARCHAR(50);
    DECLARE Var_EsContingente	CHAR(1);			-- Variable para saber si se trata de un pasivo contingente
    DECLARE Var_ConceptosFondID	INT(11);			/*Variable para verificar si el concepto de fondeo pertenece a mov. contingentes*/
	DECLARE Var_MonedaID		INT(11);
	
	/* ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';					/* Cadena Vacia	 */
    SET Entero_Cien			:= 100;
	SET	Entero_Cero			:= 0;					/* Entero en Cero */
	SET	Salida_SI			:= 'S';					/* Valor para devolver una Salida */
	SET	Salida_NO			:= 'N';					/* Valor para no devolver una Salida */
	SET	Decimal_Cero		:= 0.00;				/* Valor para devolver una Salida */
	SET	Fecha_Vacia			:= '1900-01-01';		/* Fecha Vacia */
	SET	Var_SI				:= 'S';					/* Si */
	SET	Pol_Automatica		:= 'A';					/* Indica que se trata de una poliza automatica */
	SET Reg_Automatico		:= 'A';
	SET Conciliado_NO		:= 'N';
	SET OtorgaCrePasID		:= 30; 					/* ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	SET PagoCrePasID		:= 31; 					/* ID del TIPOSMOVTESO - PAGO CREDITO PASIVO */
	SET OtorgaCrePasDes		:= 'OTORGAMIENTO CREDITO PASIVO';	/* descripcion del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO*/
	SET PagoCrePasDes		:= 'PAGO CREDITO PASIVO'; 			/* descripcion del TIPOSMOVTESO - PAGO CREDITO PASIVO */
	SET Sin_ErrorChar		:= '000';				/* Indica que no hubo error*/
	SET	Nat_Cargo			:= 'C';					/* Naturaleza de Cargo 			 */
	SET	Nat_Abono			:= 'A';					/* Naturaleza de Abono */
	SET	Procedimiento		:= 'CONTAFONDEOPRO';	/*Nombre del SP*/
	SET TipoInstrumentoID 	:= 21;  -- TIPO INSTRUMENTO CUENTA BANCARIA --

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAFONDEOPRO');
			SET Var_Control := 'sqlException';
		END;

		SET Var_FiguraFondeador		:=  (SELECT TipoFondeador
										FROM INSTITUTFONDEO
											WHERE InstitutFondID = Par_InstitutFondID);
		SET Var_FiguraFondeador		:= IFNULL(Var_FiguraFondeador, Cadena_Vacia);

        -- Verificamos que el credito es contingente
        SELECT EsContingente, MonedaID	INTO Var_EsContingente, Var_MonedaID
			FROM CREDITOFONDEO WHERE CreditoFondeoID= Par_CreditoFondeoID;

		IF (Par_AltaEncPoliza = Var_SI) THEN /* se da de alta el encabezado de la poliza */
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_EmpresaID,		Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
				Par_DescripcionMov,	Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_AltaMovsTeso = Var_SI) THEN /* se da de alta los movs operativos y contables de tesoreria*/
			SELECT	CuentaCompletaID,	CuentaAhoID,		CentroCostoID INTO
					Var_CtaContaBan,	Var_CuentaAhoID,	Var_CentroCosto
				FROM CUENTASAHOTESO
				WHERE InstitucionID = Par_InstitucionID
				  AND NumCtaInstit  = Par_NumCtaInstit;

			SET Var_CtaContaBan := IFNULL(Var_CtaContaBan, Cadena_Vacia);
			IF (Var_CtaContaBan = Cadena_Vacia) THEN
				SET Par_NumErr      := 001;
				SET Par_ErrMen      := 'La Cuenta de Bancos no Existe';
				SET Par_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			CALL TESORERIAMOVALT( /* se insertan los movimientos operativos de tesoreria*/
				Var_CuentaAhoID,	Par_FechaOperacion,	Par_Monto,			Par_DescripcionMov,		Par_Referencia,
				Conciliado_NO,		Par_NatOpeTeso,		Reg_Automatico,		Par_TipMovTeso,			Entero_Cero,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Var_FolioMovTeso,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN /* valida que no exista error */
				LEAVE ManejoErrores;
			END IF;

			CALL SALDOSCUENTATESOACT( /* se actualiza el salfo de la cuenta bancaria*/
				Par_NumCtaInstit,		Par_InstitucionID,		Par_Monto,				Par_NatOpeTeso,
				Entero_Cero,			Salida_NO,				Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN /* valida que no exista error */
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NatConTeso = Nat_Cargo) THEN
				SET Var_MontoCargo  := Par_Monto;
				SET Var_MontoAbono  := Entero_Cero;
			ELSE
				SET Var_MontoCargo  := Entero_Cero;
				SET Var_MontoAbono  := Par_Monto;
			END IF;

			CALL DETALLEPOLIZASALT(
				Par_EmpresaID, 			Par_Poliza,		Par_FechaContable,		Var_CentroCosto,	Var_CtaContaBan,
				Par_NumCtaInstit,		Par_MonedaID,	Var_MontoCargo,			Var_MontoAbono,		Par_DescripcionMov,
				Par_Referencia,			Procedimiento,	TipoInstrumentoID,		Cadena_Vacia,		Entero_Cero,
				Cadena_Vacia, 			Salida_NO,		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_NatConFon = Nat_Cargo) THEN
			SET Var_MontoCargo  := Par_Monto;
			SET Var_MontoAbono  := Entero_Cero;
		ELSE
			SET Var_MontoCargo  := Entero_Cero;
			SET Var_MontoAbono  := Par_Monto;
		END IF;

		IF(Par_AltaConFond = Var_SI) THEN

			/* Mapeamos el concepto de fondeo, mediante la tabla CATMAPEOCONPASCONT si existe y es contingente ingresa al SP  CONTAPASIVOCONTPRO*/
			SELECT ConceptosFondID INTO Var_ConceptosFondID FROM CATMAPEOCONPASCONT
				WHERE ConceptosFondID=Par_ConceptoOpera;

            /*Se agregan validaciones para creditos pasivos contingentes*/
            IF(IFNULL(Var_EsContingente,Salida_NO )=Var_SI AND IFNULL(Var_ConceptosFondID,Entero_Cero)!=Entero_Cero)THEN

				/* Si se trata de un contingente se llalamra nuevo sp*/
				CALL CONTAPASIVOCONTPRO(
					Par_CreditoFondeoID,	Par_ConceptoOpera,		Par_MonedaID,		Par_DescripcionMov,		Par_FechaAplicacion,
                    Par_Monto,				Par_NatConFon,			Salida_NO,			Par_Poliza,				Par_Consecutivo,
                    Par_NumErr,				Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,            Aud_FechaActual,
                    Aud_DireccionIP,        Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
				/*se insertan el movimiento contable del fondeador.*/
				CALL POLIZAFONDEOPRO(
					Par_Poliza,			    Par_FechaContable,		Par_PlazoContable,      Par_TipoInstitID,
					Par_NacionalidadIns,    Par_InstitutFondID,     Par_ConceptoOpera,      Par_Instrumento,
					Par_MonedaID,           Var_MontoCargo,         Var_MontoAbono,         Par_DescripcionMov,
					Par_Referencia,         Var_FiguraFondeador,    Par_TipoFondeador,     	Salida_NO,
					Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(Par_AltaMovsFond = Var_SI) THEN
			/*se insertan el movimiento operativo del fondeador.*/
			CALL CREDITOFONDMOVSALT(
				Par_CreditoFondeoID,	Par_AmortizacionID,		Aud_NumTransaccion,		Par_FechaOperacion,		Par_FechaAplicacion,
				Par_TipoMovFondeoID,	Par_NatOpeFon,			Par_MonedaID,			Par_Monto,				Par_DescripcionMov,
				Par_Referencia,			Par_Salida,				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);
			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr			:= 000;
		SET Par_ErrMen			:= 'Contabilidad Realizada';
		SET Par_Consecutivo		:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				'poliza' AS control,
				Par_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
