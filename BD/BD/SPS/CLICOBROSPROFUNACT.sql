-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICOBROSPROFUNACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICOBROSPROFUNACT`;DELIMITER $$

CREATE PROCEDURE `CLICOBROSPROFUNACT`(
	/* SP para dar de actualizar valores de  cobros generados por PROFUN */
	Par_ClienteID		INT(11),			/* Numero de cliente al que se le aplicara el cobro*/
	Par_Fecha			DATE,				/* Fecha en que se genera el Cobro */
	Par_Monto			DECIMAL(12,2),		/* Monto del Cargo*/
	Par_NumAct			TINYINT UNSIGNED,	/* no. del tipo de actualizacion*/
	Par_Salida			CHAR(1),

	INOUT Par_NumErr	INT,
	INOUT Par_ErrMen	VARCHAR(400),
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
DECLARE VarControl		CHAR(15);		# alamacena el elmento que es incorrecto

/* declaracion de constantes*/
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Cliente_Activo	CHAR(1);
DECLARE Salida_SI		CHAR(1);

DECLARE Act_RegistroCob	INT(11);
DECLARE Act_AplicaCobro	INT(11);
DECLARE Act_CancelaCli	INT(11);

/* asignacion de constantes*/
SET Entero_Cero			:= 0;		# entero cero
SET Decimal_Cero		:= 0.0;		# decimal cero
SET Cadena_Vacia		:= '';		# cadena vacia
SET Cliente_Activo		:= 'A';		# cliente activo
SET Salida_SI			:= 'S';		# salida SI

SET Act_RegistroCob		:= 1;		/*Registro de cobro de cliente profun*/
SET Act_AplicaCobro		:= 2;		/*Aplicacion de Cobro PROFUN*/
SET Act_CancelaCli	:= 3;		/*Aplicacion de Cobro PROFUN*/

/* Asignacion de Variables */
SET Par_NumErr			:= 0;
SET Par_ErrMen			:= '';

ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CLICOBROSPROFUNACT');
			SET VarControl := 'sqlException' ;
		END;


	IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'El numero de cliente esta vacio.';
		SET VarControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT ClienteID
				FROM CLIENTESPROFUN
				WHERE ClienteID=Par_ClienteID)THEN
		SET Par_NumErr  := '002';
		SET Par_ErrMen  := 'El cliente NO se encuentra registrado.';
		SET VarControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NumAct = Act_RegistroCob OR Par_NumAct = Act_AplicaCobro ) THEN
		IF(IFNULL(Par_Monto,Decimal_Cero)= Decimal_Cero) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El monto esta Vacio.';
			SET VarControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	/* efectuamos la actualizacion */
	SET Aud_FechaActual := NOW();

	/* Acutaliza el cobro generado por el cierre diario de PROFUN*/
	IF(Par_NumAct = Act_RegistroCob) THEN

		UPDATE CLICOBROSPROFUN SET
			Monto			= Monto + Par_Monto,
			MontoPendiente	= MontoPendiente + Par_Monto,
			Fecha			= Par_Fecha,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE	ClienteID = Par_ClienteID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Registro Actualizado Exitosamente.';
		SET VarControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	/* actualiza descontando el monto cobrado de profun*/
	IF(Par_NumAct = Act_AplicaCobro) THEN
		UPDATE CLICOBROSPROFUN SET
			MontoCobrado	= MontoCobrado + Par_Monto,
			MontoPendiente	= MontoPendiente - Par_Monto,
			FechaCobro		= Par_Fecha,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE	ClienteID = Par_ClienteID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Registro Actualizado Exitosamente.';
		SET VarControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	/* actualiza la fecha de baja cuando se cancela un cliente de PROFUN*/
	IF(Par_NumAct = Act_CancelaCli) THEN
		UPDATE CLICOBROSPROFUN SET
			FechaBaja		= Par_Fecha,
			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE	ClienteID = Par_ClienteID;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Registro Actualizado Exitosamente.';
		SET VarControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores; #fin del manejador de errores

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			VarControl		 AS control,
			Par_ClienteID			AS consecutivo;
END IF;

END TerminaStore$$