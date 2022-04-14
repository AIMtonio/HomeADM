-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARFOGAFIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARFOGAFIACT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARFOGAFIACT`(
-- ========================================================================
-- SP PARA ACTUALIZAR LOS ESQUEMAS DE GARANTÍA PARA EL PRODUCTO DE CRÉDITO
-- ========================================================================
	Par_ProducCreditoID		INT(11),		# Indica el Número de Producto de Crédito
	Par_GarantiaLiquida		CHAR(1),		# Indica si Requiere Garantía Líquida
	Par_LiberarGaranLiq		CHAR(1),		# Indica Si Libera Garantía Liquida
    Par_GarantiaFOGAFI		CHAR(1),		# indica si Requiere Garantía FOGAFI

	Par_ModalidadFOGAFI		CHAR(1),		# Indica la Modalidad de Cobro para FOGAFI
    Par_BonificacionFOGAFI	CHAR(1),		# Indica Si FOGAFI Bonifica
    Par_DesbloqAutFOGAFI	CHAR(1),		# indica Si desbloqueo automático o no.!!
	Par_Salida				CHAR(1), 		# Indica Salida Si
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	# Parametros de Auditoria
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN

	/* Declaracion de Variables */
	DECLARE VarControl 		    CHAR(15);		# Variable del Controlador en Pantalla
	DECLARE Var_ConsecutivoID	INT(10);		# Variable de Consecutivo para Numerar Registros
    DECLARE Var_CobraGarFin		CHAR(1);		# Indica si Cobra o No Garantía Líquida

	/* Declaracion de Constantes */
	DECLARE Entero_Cero			INT;			# Constante: Entero Cero
	DECLARE Decimal_Cero		DECIMAL;		# Constante: Decimal Cero
	DECLARE Cadena_Vacia		CHAR(1);		# Constante: Cadena Vacía
	DECLARE Salida_SI			CHAR(1);		# Constante: Salida Si
	DECLARE Cons_SI				CHAR(1);		# Constante: Si
	DECLARE LlaveGarFinanciada	VARCHAR(100);	# Constante: Llave Parametro que indica si cobra o no.


	/* Asignación de Constantes */
	SET Entero_Cero			:=0;			# Constante: Entero Cero
	SET Decimal_Cero		:=0.0;			# Constante: Cedimal Cero
	SET Cadena_Vacia		:='';			# Constante: Cadena Vacia
	SET Salida_SI			:='S';			# Constante: Salida Si
	SET LlaveGarFinanciada	:= 'CobraGarantiaFinanciada';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := '999';
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAGARFOGAFIACT');
				SET VarControl := 'sqlException' ;
			END;


        SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
		SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);

		IF(ifnull(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Producto de Credito esta vacio.';
			SET varControl  := 'producCreditoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ProducCreditoID
					FROM PRODUCTOSCREDITO
					WHERE ProducCreditoID = Par_ProducCreditoID)THEN
				SET Par_NumErr  := '006';
				SET Par_ErrMen  := 'NO existe el Producto de Credito.';
				SET varControl  := 'producCreditoID' ;
				LEAVE ManejoErrores;
		END IF;

		 # Estas validaciones se van a requerir cuando la institucion cobre garantias financiadas FOGA/FOGAFI
		IF(Var_CobraGarFin = Cons_SI) THEN
			IF(IFNULL(Par_GarantiaFOGAFI,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '009';
				SET Par_ErrMen  := 'La Garantia FOGAFI esta vacia.';
				SET varControl  := 'garantiaFOGAFI' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ModalidadFOGAFI,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '010';
				SET Par_ErrMen  := 'La Modalidad FOGAFI esta vacia.';
				SET varControl  := 'modalidadFOGAFI' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_BonificacionFOGAFI,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '011';
				SET Par_ErrMen  := 'La Bonificacion FOGAFI esta vacia.';
				SET varControl  := 'bonificacionFOGAFI' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_DesbloqAutFOGAFI,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '012';
				SET Par_ErrMen  := 'El Desbloqueo Automatico FOGAFI esta vacio.';
				SET varControl  := 'desbloqAutFOGAFI' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;


		UPDATE PRODUCTOSCREDITO
			SET Garantizado		 	= Par_GarantiaLiquida,		-- si requiere garantia liquida
				LiberarGaranLiq	 	= Par_LiberarGaranLiq,		-- si la garantia liquida  se libera al liquidar el credito
                RequiereGarFOGAFI 	= Par_GarantiaFOGAFI,		-- Especifica si el Tipo de Credito Requiere Garantia FOGAFI(Garantia Liquida Financiada).

                ModalidadFOGAFI		= Par_ModalidadFOGAFI,		-- Indica si la garantia FOGAFI, se cobrara de manera anticipada o periodica.
                BonificacionFOGAFI	= Par_BonificacionFOGAFI,	-- Especifica si se tendran bonificaciones por pagos puntuales del credito.
                DesbloqAutFOGAFI	= Par_DesbloqAutFOGAFI, 	-- Especifica si se pueden realizar desbloqueos automaticos de la garantia FOGAFI al ejecutar la cobranza automatica.

                EmpresaID 		 	= Par_EmpresaID,
				Usuario			 	= Aud_Usuario,
				FechaActual		 	= Aud_FechaActual,
				DireccionIP		 	= Aud_DireccionIP,
			 	ProgramaID		 	= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ProducCreditoID	= Par_ProducCreditoID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Datos de Garantia FOGAFI grabados exitosamente.';
		SET varControl  := 'producCreditoID' ;
		LEAVE ManejoErrores;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				varControl		 AS control,
				Par_ProducCreditoID	 AS consecutivo;
	end IF;

END TerminaStore$$