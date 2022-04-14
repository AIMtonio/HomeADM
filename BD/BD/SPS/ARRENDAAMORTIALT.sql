-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTIALT`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTIALT`(
	-- STORED PROCEDURE PARA EL ALTA DE LAS AMORTIZACIONES
	Par_ArrendaID			BIGINT(12),			-- ID de arrendamiento
	Par_ClienteID			INT(11), 			-- ID del Cliente
	Par_Salida				CHAR(1),			-- Salida Si o No
	INOUT Par_NumErr		INT(11),			-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Control de Errores: Descripcion del Error

	Aud_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11), 			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME, 			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11), 			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20) 			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(100); 	-- Variable de control

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Entero_Cero 		INT(11);		-- Entero cero
	DECLARE Entero_Uno 			INT(11);		-- Entero uno
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal cero
	DECLARE Var_SI 				CHAR(1);		-- Variable si
	DECLARE Var_NO 				CHAR(1);		-- Variable no
	DECLARE Est_Inactiva		CHAR(1);		-- Estatus inactiva

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia 			:= ''; 				-- Cadena Vacia
	SET Fecha_Vacia 			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero 			:= 0; 				-- Entero cero
	SET Entero_Uno				:= 1; 				-- Entero uno
	SET Decimal_Cero 			:= 0; 				-- Decimal cero
	SET Var_SI 					:= 'S'; 			-- Permite Salida SI
	SET Var_NO 					:= 'N';				-- Permite Salida NO
	SET Est_Inactiva 			:= 'I'; 			-- Estatus inactivo

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual         := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDAAMORTIALT');
				SET Var_Control = 'sqlException';
			END;

		-- SE MANDA A LLAMAR A SP QUE DA DE BAJA LAS AMORTIZACIONES SI ES QUE LAS HUBIERA
		CALL ARRENDAAMORTIBAJ(  /*SP para dar de baja las amortizaciones de credito*/
			Par_ArrendaID, 		Var_NO, 			Par_NumErr, 		Par_ErrMen, 		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		INSERT INTO ARRENDAAMORTI(
			ArrendaAmortiID,		ArrendaID,				ClienteID,			FechaInicio, 		FechaVencim,
			FechaExigible, 			FechaLiquida,			Estatus,			CapitalRenta,		InteresRenta,
			Renta, 					IVARenta, 				SaldoInsoluto,		Seguro, 			SeguroVida,
			SaldoCapVigent,			SaldoCapAtrasad,		SaldoCapVencido, 	MontoIVACapital,	SaldoInteresVigente,
			SaldoInteresAtras,		SaldoInteresVen, 		MontoIVAInteres, 	SaldoSeguro,		MontoIVASeguro,
			SaldoSeguroVida,		MontoIVASeguroVida,		SaldoMoratorios, 	MontoIVAMora, 		SaldComFaltPago,
			MontoIVAComFalPag,		SaldoOtrasComis, 		MontoIVAComisi,		EmpresaID, 			Usuario,
			FechaActual, 			DireccionIP, 			ProgramaID, 		Sucursal,			NumTransaccion)
		SELECT
			Tmp_Consecutivo,		Par_ArrendaID,			Par_ClienteID, 		Tmp_FecIni,			Tmp_FecFin,
			Tmp_FecExi,				Fecha_Vacia, 			Tmp_Estatus, 		Tmp_Capital, 		Tmp_Interes,
			Tmp_Renta,				Tmp_Iva,				Tmp_Insoluto, 		Tmp_MontoSeg,		Tmp_MontoSegVida,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero, 		Decimal_Cero, 		Decimal_Cero,
			Decimal_Cero, 			Decimal_Cero, 			Decimal_Cero, 		Decimal_Cero, 		Decimal_Cero,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero, 		Decimal_Cero,		Decimal_Cero,
			Decimal_Cero, 			Decimal_Cero,			Decimal_Cero,		Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion
			FROM TMPARRENDAPAGOSIM
			WHERE	NumTransaccion = Aud_NumTransaccion;


		SET Par_NumErr		:= 000;
		SET Var_Control		:= 'arrendaID';
		SET Par_ErrMen 		:= CONCAT('Amortizaciones agregadas exitosamente ');
	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT  Par_NumErr                  AS NumErr,
				Par_ErrMen                  AS ErrMen,
				Var_Control                 AS Control,
				LPAD(Par_ArrendaID, 10, 0) AS Consecutivo;
	END IF;

END TerminaStore$$