-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAGARANTIALIQACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAGARANTIALIQACT`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAGARANTIALIQACT`(
-- --------------------------------------------------------------------------------
-- Procedimiento para actualizar un producto de credito cuando no require garantia liquida
-- --------------------------------------------------------------------------------
	/* declaracion de parametros */
	Par_ProducCreditoID		INT(11),		# Id del producto de credito
	Par_GarantiaLiquida		CHAR(1),		# Indica si tiene Garantia Liquida
	Par_LiberarGaranLiq		CHAR(1),		# indica si la garantia liquida se libera automaticamente al liquidar el credito
    Par_BonificacionFOGA	CHAR(1),		# Especifica si se tendran bonificaciones por pagos puntuales del credito.  S: SI   N:NO
    Par_DesbloqAutFOGA		CHAR(1),		# Especifica si se pueden realizar desbloqueos automaticos de la garantia FOGA al ejecutar la cobranza automatica.  S:SI  N:NO

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	/* parametros de auditoria */
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN 	#bloque main del sp

	/* declaracion de variables*/
	DECLARE varControl 		    CHAR(15);	# almacena el elemento que es incorrecto
	DECLARE Var_ConsecutivoID	INT(10);
    DECLARE Var_CobraGarFin		CHAR(1);	# Indica si la institucion cobra garantias financiadas.

	/* declaracion de constantes*/
	DECLARE Entero_Cero			INT;		# entero cero
	DECLARE Decimal_Cero		DECIMAL;	# decimal cero
	DECLARE Cadena_Vacia		CHAR(1);	# cadena vacia
	DECLARE Salida_SI			CHAR(1);	# salida SI
	DECLARE Cons_SI				CHAR(1);		# Constante SI
	DECLARE LlaveGarFinanciada	VARCHAR(100);	# Llave para consultar el valor de Garantias Financiadas


	/* asignacion de constantes*/
	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Salida_SI			:='S';
	SET LlaveGarFinanciada	:= 'CobraGarantiaFinanciada';
	/* Asignacion de Variables */
	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';



	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAGARANTIALIQACT');
				SET varControl = 'SQLEXCEPTION' ;
			END;


        SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
		SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);

		IF(IFNULL(Par_ProducCreditoID,Entero_Cero))= Entero_Cero THEN
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
		IF(IFNULL(Par_BonificacionFOGA,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'La Bonificacion FOGA esta vacia.';
			SET varControl  := 'bonificacionFOGA' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DesbloqAutFOGA,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '008';
			SET Par_ErrMen  := 'El Desbloqueo Automatico FOGA esta vacio.';
			SET varControl  := 'desbloqAutFOGA' ;
			LEAVE ManejoErrores;
		END IF;



	END IF;
	# Elimina los esquemas si es que antes el producto de credito requeria de garantia liquida

	# Actualiza los datos correspondientes en la tabla PRODUCTOSCREDITO
	UPDATE PRODUCTOSCREDITO
			SET Garantizado		 	= Par_GarantiaLiquida,		-- si requiere garantia liquida
				LiberarGaranLiq	 	= Par_LiberarGaranLiq,		-- si la garantia liquida  se libera al liquidar el credito
                BonificacionFOGA	= Par_BonificacionFOGA,		-- Especifica si se tendran bonificaciones por pagos puntuales del credito.
                DesbloqAutFOGA		= Par_DesbloqAutFOGA,		-- Especifica si se pueden realizar desbloqueos automaticos de la garantia FOGA al ejecutar la cobranza automatica.

                EmpresaID 		 	= Par_EmpresaID,
				Usuario			 	= Aud_Usuario,
				FechaActual		 	= Aud_FechaActual,
				DireccionIP		 	= Aud_DireccionIP,
			 	ProgramaID		 	= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ProducCreditoID	= Par_ProducCreditoID;

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := 'Datos de Garantia Liquida grabados exitosamente.';
	SET varControl  := 'producCreditoID' ;
	LEAVE ManejoErrores;


END ManejoErrores; /*fin del manejador de errores*/



	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		 AS ErrMen,
				varControl		 AS control,
				Par_ProducCreditoID	 AS consecutivo;
	END IF;

END TerminaStore$$