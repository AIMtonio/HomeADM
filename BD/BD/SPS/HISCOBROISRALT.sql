-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCOBROISRALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISCOBROISRALT`;DELIMITER $$

CREATE PROCEDURE `HISCOBROISRALT`(
# =====================================================================================
# -------SP PARA EL PASO A HISTORICO DE LAS TABLAS DE COBROISR---------
# =====================================================================================
	Par_FechaOperacion		DATE,				-- Fecha de operacion cuando se realiza el cierre
    Par_Salida    			CHAR(1), 			-- Tipo de Salida.
    INOUT	Par_NumErr 		INT(11),			-- Numero de Error.
    INOUT	Par_ErrMen  	VARCHAR(400),		-- Mensaje de Error.

    Par_EmpresaID       	INT(11),			-- Parametro de Auditoria
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      	VARCHAR(150),		-- Parametro de Auditoria
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria
	)
TerminaStore : BEGIN

-- Declaracion de variables
DECLARE Var_Control		VARCHAR(50);		-- Control ID

-- Declaracion de constantes
DECLARE Entero_Cero		INT(11);
DECLARE Est_Aplicado    CHAR(1);
DECLARE Est_Calculado	CHAR(1);
DECLARE SalidaSI	 	CHAR(1);

-- Asignacion de constantes
SET Entero_Cero			:= 0;
SET Est_Aplicado		:= 'A';
SET Est_Calculado		:= 'C';
SET SalidaSI			:= 'S';			-- El Store si regresa una Salida

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-HISCOBROISRALT');
			SET Var_Control := 'sqlException';
		END;

    -- ====================== COBROISR ====================== --
   /*Se mueven a la tabla historica los cobros que ya fueron aplicados*/
	INSERT INTO `HISCOBROISR`(
		Fecha,		 	ClienteID,		InstrumentoID,		ProductoID,			PagaISR,
		TasaISR,	 	SumSaldos,		SaldoProm,			InicioPeriodo,		FinPeriodo,
        ISRTotal,	 	ISR,			Factor,				Estatus,			TipoRegistro,
		EmpresaID,		Usuario,		FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,		NumTransaccion)
	SELECT
		Fecha,		 	ClienteID,		InstrumentoID,		ProductoID,			PagaISR,
		TasaISR,	 	SumSaldos,		SaldoProm,			InicioPeriodo,		FinPeriodo,
        ISRTotal,	 	ISR,			Factor,				Estatus,			TipoRegistro,
		EmpresaID,		Usuario,		FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,		NumTransaccion
	FROM COBROISR
		WHERE Fecha    <= Par_FechaOperacion
        AND   Estatus	= Est_Aplicado;

   /*Se eliminan de la tabla cobro ISR*/
	DELETE FROM  COBROISR
				WHERE Fecha    <= Par_FechaOperacion
                AND   Estatus	= Est_Aplicado;

    -- ====================== TOTALCAPTACION ====================== --
    INSERT INTO `HISTOTALCAPTACION`
						(   Fecha,		 ClienteID,		 TotalCaptacion,	Estatus,
							EmpresaID,	 Usuario,		 FechaActual,		DireccionIP,
							ProgramaID,	 Sucursal,		 NumTransaccion)

		SELECT   			Fecha,		 ClienteID,		 TotalCaptacion,	Estatus,
							EmpresaID,	 Usuario,		 FechaActual,		DireccionIP,
							ProgramaID,	 Sucursal,		 NumTransaccion
			FROM TOTALCAPTACION
				 WHERE Fecha 	<= Par_FechaOperacion
                 AND   Estatus   = Est_Calculado;

   /*Se eliminan de la tabla cobro TOTALCAPTACION*/
	DELETE FROM  TOTALCAPTACION
				WHERE Fecha    <= Par_FechaOperacion
                AND   Estatus	= Est_Calculado;

	-- ====================== FACTORINVERSION ====================== --
    INSERT INTO `HISFACTORINVERSION`
						(  Fecha,		 	  ClienteID,		InversionID,	  Capital,
						   TotalCaptacion,	  Factor,			Estatus,		  EmpresaID,
						   Usuario,		      FechaActual,		DireccionIP,	  ProgramaID,
						   Sucursal,		  NumTransaccion)

	    SELECT 			   Fecha,		 	  ClienteID,		InversionID,	  Capital,
						   TotalCaptacion,	  Factor,			Estatus,		  EmpresaID,
						   Usuario,		      FechaActual,		DireccionIP,	  ProgramaID,
						   Sucursal,		  NumTransaccion
			FROM FACTORINVERSION
				WHERE Fecha 	<= Par_FechaOperacion
				AND   Estatus    = Est_Calculado;

	/*Se eliminan de la tabla cobro FACTORINVERSION*/
	 DELETE FROM  FACTORINVERSION
				WHERE Fecha    <= Par_FechaOperacion
                AND   Estatus	= Est_Calculado;

	-- ====================== FACTORCEDES ====================== --
	INSERT INTO `HISFACTORCEDES`
					   (  Fecha,			ClienteID,		CedeID,			Capital,
						  TotalCaptacion,	Factor,			Estatus,		EmpresaID,
						  Usuario,			FechaActual,	DireccionIP,	ProgramaID,
						  Sucursal,			NumTransaccion)
		SELECT  		  Fecha,			ClienteID,		CedeID,			Capital,
						  TotalCaptacion,	Factor,			Estatus,		EmpresaID,
						  Usuario,			FechaActual,	DireccionIP,	ProgramaID,
						  Sucursal,			NumTransaccion
			FROM FACTORCEDES
				WHERE Fecha 	<= Par_FechaOperacion
				AND   Estatus    = Est_Calculado;

	/*Se eliminan de la tabla cobro FACTORCEDES*/
	 DELETE FROM  FACTORCEDES
				WHERE Fecha    <= Par_FechaOperacion
                AND   Estatus	= Est_Calculado;

   	-- ====================== FACTORAHORRO` ====================== --
	INSERT INTO `HISFACTORAHORRO`
					  (	 Fecha,			    ClienteID,		CuentaAhoID,		Saldo,
						 TotalCaptacion,	Factor,			Estatus,			EmpresaID,
						 Usuario,			FechaActual,	DireccionIP,		ProgramaID,
						 Sucursal,			NumTransaccion)
		 SELECT     	 Fecha,			    ClienteID,		CuentaAhoID,		Saldo,
						 TotalCaptacion,	Factor,			Estatus,			EmpresaID,
						 Usuario,			FechaActual,	DireccionIP,		ProgramaID,
						 Sucursal,			NumTransaccion
			FROM FACTORAHORRO
				WHERE Fecha 	<= Par_FechaOperacion
				AND   Estatus    = Est_Calculado;

	/*Se eliminan de la tabla cobro FACTORAHORRO*/
	 DELETE FROM  FACTORAHORRO
				WHERE Fecha    <= Par_FechaOperacion
                AND   Estatus	= Est_Calculado;

	-- ====================== FACTOR CAPTACION ====================== --
	SET @Var_FactorCapID := (SELECT MAX(FactorCapID) FROM HISFACTORCAPTACION);
	SET @Var_FactorCapID := (IFNULL(@Var_FactorCapID, Entero_Cero) + 1);

	INSERT INTO `HISFACTORCAPTACION`(
		FactorCapID,
		Fecha,			ClienteID,		InstrumentoID,	ProductoID,		Saldo,
		TotalCaptacion,	Factor,			Estatus,		EmpresaID,		Usuario,
		FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
	SELECT
		(@Var_FactorCapID:= @Var_FactorCapID+1),
		Fecha,			ClienteID,		InstrumentoID,	ProductoID,		Saldo,
		TotalCaptacion,	Factor,			Estatus,		EmpresaID,		Usuario,
		FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion
	FROM FACTORCAPTACION
		WHERE Fecha <= Par_FechaOperacion;

	/* Se eliminan de la tabla cobro FACTORCAPTACION */
	DELETE FROM  FACTORCAPTACION
		WHERE Fecha <= Par_FechaOperacion;

	SET Par_NumErr 	:=	0;
	SET Par_ErrMen	:= 'Historico de COBROISR Realizado Exitosamente';
	SET Var_Control := 'clienteID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr  AS NumErr,
			Par_ErrMen  AS ErrMen,
			Var_Control AS Control;
	END IF;

END TerminaStore$$