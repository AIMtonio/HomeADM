-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAPACIDADPAGOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAPACIDADPAGOALT`;DELIMITER $$

CREATE PROCEDURE `CAPACIDADPAGOALT`(




	Par_ClienteID			INT(11),
	Par_UsuarioID			int(11),
    Par_SucursalID			int(11),
    Par_ProducCredito1		int(11),
	Par_ProducCredito2		int(11),
    Par_ProducCredito3	    int(11),
    Par_TasaInteres1		decimal(14,2),
    Par_TasaInteres2		decimal(14,2),
    Par_TasaInteres3		decimal(14,2),
    Par_IngresoMensual		decimal(14,2),
    Par_GastoMensual		decimal(14,2),
    Par_MontoSolicitado		decimal(14,2),
    Par_AbonoPropuesto		decimal(14,2),
    Par_Plazo				varchar(750),
    Par_AbonoEstimado		decimal(14,2),
    Par_IngresosGastos		decimal(14,2),
    Par_Cobertura			decimal(14,2),
    Par_CobSinPrestamo 		decimal(14,2),
    Par_CobConPrestamo  	decimal(14,2),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE varControl 			    CHAR(15);
	DECLARE Var_CapacidadPAgoID		INT(11);
	DECLARE Var_FechaCalculo		DATE;


	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Salida_SI			CHAR(1);
	DECLARE MenorEdad			CHAR(1);


	SET Estatus_Activo		:='A';
	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.0;
	SET Cadena_Vacia		:='';
	SET Fecha_Vacia			:='1900-01-01';
	SET Salida_SI			:='S';


	SET Par_NumErr			:= 0;
	SET Par_ErrMen			:= '';
	SET Var_FechaCalculo    := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET MenorEdad			:= 'S';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CAPACIDADPAGOALT');
				SET varControl = 'sqlException' ;
			END;

		IF(ifnull(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El ID del safilocale.cliente  esta vacio.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_UsuarioID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El ID del Usuario que registra la Estimacion de Capacidad de Pago esta vacio.';
			SET varControl  := 'usuarioID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_ProducCredito1,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'El Producto de Credito 1 esta vacio.';
			SET varControl  := 'producCredito1' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_ProducCredito2,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El Producto de Credito 2 esta vacio.';
			SET varControl  := 'producCredito2' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_ProducCredito3,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'El Producto de Credito 3 esta vacio.';
			SET varControl  := 'producCredito3' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_MontoSolicitado,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := '009';
			SET Par_ErrMen  := 'El Monto Solicitado esta vacio.';
			SET varControl  := 'montoSolicitado' ;
			LEAVE ManejoErrores;
		END IF;
		IF(ifnull(Par_AbonoPropuesto,Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr  := '010';
			SET Par_ErrMen  := 'El Abono Propuesto esta vacio.';
			SET varControl  := 'abonoPropuesto' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Plazo,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '011';
			SET Par_ErrMen  := 'El Plazo esta vacio.';
			SET varControl  := 'plazo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_SucursalID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '012';
			SET Par_ErrMen  := 'La Sucursal esta vacia.';
			SET varControl  := 'sucuarsalID' ;
			LEAVE ManejoErrores;
		END IF;



		IF NOT EXISTS(SELECT ClienteID
					FROM 	CLIENTES
					WHERE ClienteID = Par_ClienteID  AND Estatus=Estatus_Activo)THEN
				SET Par_NumErr  := '013';
				SET Par_ErrMen  := 'El safilocale.cliente  no existe.';
				SET varControl  := 'clienteID' ;
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT UsuarioID
					FROM 	USUARIOS
					WHERE UsuarioID = Par_UsuarioID  AND Estatus=Estatus_Activo)THEN
				SET Par_NumErr  := '014';
				SET Par_ErrMen  := 'El safilocale.cliente  no existe.';
				SET varControl  := 'usuarioID' ;
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT SucursalID
					FROM 	SUCURSALES
					WHERE SucursalID = Par_SucursalID AND Estatus=Estatus_Activo)THEN
				SET Par_NumErr  := '015';
				SET Par_ErrMen  := 'La Sucursal no existe.';
				SET varControl  := 'sucursalID' ;
				LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT ClienteID
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID
			AND EsMenorEdad = MenorEdad)THEN
				 SET Par_NumErr  := '016';
				 SET Par_ErrMen  := 'El safilocale.cliente es Menor de Edad.';
				 SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

	DELETE FROM CAPACIDADPAGO WHERE ClienteID = Par_ClienteID;

	CALL FOLIOSAPLICAACT('CAPACIDADPAGO', Var_CapacidadPAgoID);


			SET Aud_FechaActual 	:= NOW();

			 INSERT INTO CAPACIDADPAGO(
							  CapacidadPagoID,		ClienteID,			UsuarioID,			SucursalID,			ProducCredito1,
							  ProducCredito2,		ProducCredito3,		TasaInteres1,		TasaInteres2,		TasaInteres3,
							  IngresoMensual,		GastoMensual,		MontoSolicitado,	AbonoPropuesto,		Plazo,
							  AbonoEstimado,		IngresosGastos,		Cobertura,			CobSinPrestamo,		CobConPrestamo,
							  Fecha,
							  EmpresaID,			  Usuario,			  FechaActual,	  DireccionIP,		  ProgramaID,
							  Sucursal,  		      NumTransaccion)
					VALUES(
							  Var_CapacidadPagoID,		Par_ClienteID,			Par_UsuarioID,			Par_SucursalID,			Par_ProducCredito1,
							  Par_ProducCredito2,		Par_ProducCredito3,		Par_TasaInteres1,		Par_TasaInteres2,		Par_TasaInteres3,
							  Par_IngresoMensual,		Par_GastoMensual,		Par_MontoSolicitado,	Par_AbonoPropuesto,		Par_Plazo,
							  Par_AbonoEstimado,		Par_IngresosGastos,		Par_Cobertura,			Par_CobSinPrestamo,		Par_CobConPrestamo,
							  Var_FechaCalculo,
							  Par_EmpresaID,		  Aud_Usuario,		 	Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
							  Aud_Sucursal,	 		  Aud_NumTransaccion);


					 INSERT INTO HISCAPACIDADPAGO(
							  CapacidadPagoID,		ClienteID,			UsuarioID,			SucursalID,			ProducCredito1,
							  ProducCredito2,		ProducCredito3,		TasaInteres1,		TasaInteres2,		TasaInteres3,
							  IngresoMensual,		GastoMensual,		MontoSolicitado,	AbonoPropuesto,		Plazo,
							  AbonoEstimado,		IngresosGastos,		Cobertura,			CobSinPrestamo,		CobConPrestamo,
							  Fecha,
							  EmpresaID,			Usuario,			  FechaActual,	  DireccionIP,		  ProgramaID,
							  Sucursal,  		    NumTransaccion)
					VALUES(
							  Var_CapacidadPagoID,		Par_ClienteID,			Par_UsuarioID,			Par_SucursalID,			Par_ProducCredito1,
							  Par_ProducCredito2,		Par_ProducCredito3,		Par_TasaInteres1,		Par_TasaInteres2,		Par_TasaInteres3,
							  Par_IngresoMensual,		Par_GastoMensual,		Par_MontoSolicitado,	Par_AbonoPropuesto,		Par_Plazo,
							  Par_AbonoEstimado,		Par_IngresosGastos,		Par_Cobertura,			Par_CobSinPrestamo,		Par_CobConPrestamo,
							  Var_FechaCalculo,
							  Par_EmpresaID,		  	Aud_Usuario,		 	Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
							  Aud_Sucursal,	 		  	Aud_NumTransaccion);

			SET Par_NumErr  := '000';
			SET Par_ErrMen  := CONCAT('Estimacion de Capacidad de Pago Grabada Exitosamente: ', Var_CapacidadPagoID);
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;



END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				varControl			 AS control,
				Par_ClienteID		 AS consecutivo;
	end IF;

END TerminaStore$$