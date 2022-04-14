-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPAGOCOMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBPAGOCOMPRO`;
DELIMITER $$


CREATE PROCEDURE `TARDEBPAGOCOMPRO`(
-- --------------------------------------------------------------------------------
-- Registra el pago de comision anual de las tarjetas de debito
-- --------------------------------------------------------------------------------
	/* declaracion de parametros */
	Par_TipoTarjetaDebID	INT(11),			# ID del tipo de tarjeta debito a la cual se le cobrará la comisión anual
	Par_UsuarioID			INT(11),			# ID del usuario que ejecuta el proceso

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
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
	DECLARE varControl 			    CHAR(25);		# almacena el elemento que es incorrecto
	DECLARE Var_FechaSis			DATE;			# almacena la fecha del sistema
	DECLARE Var_FechaCompara		DATE;			# almacena la fecha actual del sistema menos un dia


	/* declaracion de constantes*/
	DECLARE Estatus_Activo		CHAR(1);			# estatus activo
	DECLARE Entero_Cero			INT;				# entero cero
	DECLARE Decimal_Cero		DECIMAL(14,2);		# decimal cero
	DECLARE Cadena_Vacia		CHAR(1);			# cadena vacia
	DECLARE Fecha_Vacia			DATE;				# fecha vacia
	DECLARE Salida_SI			CHAR(1);			# salida SI
	DECLARE Salida_NO			CHAR(1);			# salida NO
	DECLARE Con_Dias			INT(11);			# numero de dias que se restara a la fecha actual del sistema
	DECLARE Con_Meses			INT(11);			# numero de meses a partir de los cuales se cobrara la comision anual a las tarjetas debito
	DECLARE TD_Activada			INT(11);			# estatus activada de una tarjeta de debito
	DECLARE TD_Bloqueada		INT(11);			# estatus bloqueada por motivo: Bloqueo por No Pago Anualidad
	DECLARE Estatus_Bloqueado	INT(11);		# Estado bloqueado de una  tarjeta de debito


	/* asignacion de constantes*/
	SET Estatus_Activo		:='A';
	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Fecha_Vacia			:='1900-01-01';
	SET Salida_SI			:='S';
	SET Salida_NO			:= 'N';
	SET Con_Dias			:= 1;
	SET Con_Meses			:= 6;
	SET TD_Activada			:= 7;
	SET TD_Bloqueada		:= 13;
	SET Estatus_Bloqueado	:= 8;


	/* Asignacion de Variables */
	SET Par_NumErr			:= 0;
	SET Par_ErrMen			:= '';

	SET Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS);



	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-TARDEBPAGOCOMPRO');
				SET varControl := 'sqlException' ;
			END;

		IF(ifnull(Par_TipoTarjetaDebID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Tipo de Tarjeta de Debito esta vacio.';
			SET varControl  := 'tipoTarjetaDebID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT TipoTarjetaDebID
					FROM 	TIPOTARJETADEB
					WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID
					LIMIT 1)THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'El Tipo de Tarjeta de Debito No existe.';
				SET varControl  := 'tipoTarjetaDebID' ;
				LEAVE ManejoErrores;
		END IF;

		IF EXISTS(SELECT TipoTarjetaDebID
					FROM 	BITACORAPAGOCOM
					WHERE TipoTarjetaDebID	 = Par_TipoTarjetaDebID AND Fecha = Var_FechaSis
					LIMIT 1)THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Cobro de Comision Anual para el Tipo de Tarjeta indicada ya fue realizado.';
				SET varControl  := 'tipoTarjetaDebID' ;
				LEAVE ManejoErrores;
		END IF;

		# Resta un dia y 6 meses a la fecha actual del sistema
		SET Var_FechaCompara	:=  DATE_SUB(DATE_SUB(Var_FechaSis, INTERVAL Con_Dias DAY) , INTERVAL Con_Meses MONTH);


		CALL TARDEBPAGOCOMCUR(Par_TipoTarjetaDebID,		Var_FechaCompara,  		TD_Activada,		TD_Bloqueada,		Estatus_Bloqueado,
							  Var_FechaSis,
							  Salida_NO,  				Par_NumErr,   			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
							  Aud_FechaActual,			Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		/* Efectuamos la insercion */
		SET Aud_FechaActual 	:= NOW();

		INSERT INTO BITACORAPAGOCOM(
					  TipoTarjetaDebID,	  	UsuarioID,	    	Fecha,
					  EmpresaID,			Usuario,			FechaActual,	  		DireccionIP,		    ProgramaID,
					  Sucursal,  			NumTransaccion)
			VALUES(
					  Par_TipoTarjetaDebID,		Par_UsuarioID,			Var_FechaSis,
					  Par_EmpresaID,			Aud_Usuario,		 	Aud_FechaActual, 			Aud_DireccionIP,			Aud_ProgramaID,
					  Aud_Sucursal,	 			Aud_NumTransaccion);


			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Cobro de Comision Anual Realizado Exitosamente.';
			SET varControl  := 'tipoTarjetaDebID' ;
			LEAVE ManejoErrores;



END ManejoErrores; #fin del manejador de errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				varControl			 AS control,
				Par_TipoTarjetaDebID AS consecutivo;
	end IF;

END TerminaStore$$