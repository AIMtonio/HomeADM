-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMITESOPECLIENTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMITESOPECLIENTEMOD`;DELIMITER $$

CREATE PROCEDURE `LIMITESOPECLIENTEMOD`(



    Par_LimiteOperID		INT(11),
    Par_ClienteID			INT(11),
	Par_BancaMovil			CHAR(1),
	Par_MonMaxBcaMovil	   	DECIMAL(18,2),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	inout Par_ErrMen		VARCHAR(400),

    Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore:BEGIN


	DECLARE Var_Control 	    VARCHAR(100);
    DECLARE Var_LimiteBcaMovil	CHAR(1);


	DECLARE	 Cadena_Vacia		CHAR(1);
	DECLARE	 Fecha_Vacia		DATE;
	DECLARE	 Hora_Vacia 		TIME;
	DECLARE	 Entero_Cero		INT;
	DECLARE	 Decimal_Cero		DECIMAL(12,2);
	DECLARE  Salida_SI        	CHAR(1);
    DECLARE  Salida_NO        	CHAR(1);


	SET	Cadena_Vacia		    := '';
	SET	Fecha_Vacia			    := '1900-01-01';
	SET	Hora_Vacia			    := '00:00:00';
	SET	Entero_Cero			    := 0;
	SET	Decimal_Cero		    := 0.00;
	SET Salida_SI        	    := 'S';
	SET Salida_NO        	    := 'N';
    SET Var_LimiteBcaMovil		:= 'S';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-LIMITESOPECLIENTEMOD');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'La Cuenta del Participante spei esta vacia.';
			SET Var_Control := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_BancaMovil,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Si tiene Limite en Banca Movil esta vacio.';
			SET Var_Control := 'bancaMovil' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT	ClienteID
			FROM LIMITESOPERCLIENTE
			WHERE	ClienteID	= Par_ClienteID)THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := CONCAT('El Cliente ',Par_ClienteID, ' no se ecuentra registrado.');
				SET Var_Control := 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE LIMITESOPERCLIENTE SET
			BancaMovil			= Par_BancaMovil,
			MonMaxBcaMovil      = Par_MonMaxBcaMovil,

            EmpresaID		    = Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE	ClienteID		= Par_ClienteID
          AND	LimiteOperID	= Par_LimiteOperID;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Limites Modificados Exitosamente.';
		SET Var_Control := 'limiteOperID' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen	AS ErrMen,
					Var_Control AS control,
					Par_LimiteOperID AS consecutivo;
		END IF;

END TerminaStore$$