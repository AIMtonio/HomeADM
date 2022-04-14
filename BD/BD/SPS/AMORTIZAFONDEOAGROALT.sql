-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOAGROALT`;
DELIMITER $$


CREATE PROCEDURE `AMORTIZAFONDEOAGROALT`(

    /* SP PARA REGISTRAR LAS AMORTIZACIONES DEL CALENDARIO DE PAGOS DE UN CREDITO PASIVO */

	Par_CreditoFonID		BIGINT(20),		-- Numero del credito Pasivo
    Par_CreditoID			BIGINT(20),		-- Numero del Credito Activo
	Par_Salida				CHAR(1),		-- Salida S:SI  N:NO

	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	INOUT Par_Consecutivo	BIGINT(20),		-- Consecutivo

	/* PARAMETROS DE AUDITORIA  */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_MaxConsecutivo	INT(11);	-- Consecutivo de la tabla de amortizacion
    DECLARE Var_Control 		VARCHAR(50);


	-- Declaracion de Constantes
	DECLARE Entero_Cero       	INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Est_Vigente			CHAR(1);		-- Estatus Vigente
    DECLARE Est_Pagado			CHAR(1);		-- Estatus Pagado
	DECLARE	Salida_SI			CHAR(1);		-- Constante SI
	DECLARE	Nat_Cargo			CHAR(1);		-- Naturaleza Cargo


	-- Asignacion de Constantes
	SET	Entero_Cero				:= 0;				-- Entero en Cero
	SET	Decimal_Cero			:= 0.00;			-- Decimal en Cero
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Est_Vigente				:= 'N';				-- Estatus Vigente
    SET Est_Pagado				:= 'P';				-- Estatus Pagado
	SET	Salida_SI				:= 'S';				-- Valor cuando requiere una Salida
	SET	Nat_Cargo				:= 'C';				-- Naturaleza Cargo

	-- Asignacion de Variables

	SET Aud_FechaActual := CURRENT_TIMESTAMP();


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTIZAFONDEOAGROALT');
			SET Var_Control := 'sqlexception';
		END;

		SET @Var_MaxConsecutivo	:= (SELECT MAX(AmortizacionID) FROM AMORTIZAFONDEO WHERE CreditoFondeoID	= Par_CreditoFonID);

		INSERT INTO AMORTIZAFONDEO(
			CreditoFondeoID,			AmortizacionID,			FechaInicio,			FechaVencimiento,			FechaExigible,
			FechaLiquida,				Estatus,				Capital,				Interes,					IVAInteres,

			SaldoCapVigente,			SaldoCapAtrasad,		SaldoInteresAtra,		SaldoInteresPro,			SaldoIVAInteres,
			SaldoMoratorios,			SaldoIVAMora,			SaldoComFaltaPa,		SaldoIVAComFalP,			SaldoOtrasComis,
			SaldoIVAComisi,				ProvisionAcum,			SaldoCapital,			SaldoRetencion,				Retencion,
			EmpresaID,					Usuario,				FechaActual,			DireccionIP,				ProgramaID,
			Sucursal,					NumTransaccion)
		SELECT
			Par_CreditoFonID,
										@Var_MaxConsecutivo:= @Var_MaxConsecutivo + 1,	FechaInicio,				FechaVencim,				FechaExigible,
			FechaLiquida,				Est_Vigente,			Decimal_Cero,			Entero_Cero,				Entero_Cero,

			Entero_Cero,				Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
			Entero_Cero,				Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
			Entero_Cero,				Entero_Cero,			SaldoCapVigente,		Entero_Cero,				Entero_Cero,
			EmpresaID,					Usuario,				FechaActual,			DireccionIP,				ProgramaID,
			Sucursal,					NumTransaccion
		FROM AMORTICREDITO
				WHERE
				CreditoID = Par_CreditoID
				AND Estatus <> Est_Pagado;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Amortizaciones Guardadas.';

	END ManejoErrores;  -- End del Handler de Errores

    IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'creditoFondeoID' 	AS control,
				Par_CreditoFonID 	AS consecutivo;
	 END IF;

END TerminaStore$$