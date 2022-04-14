-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOLACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCOLARSOLACT`;DELIMITER $$

CREATE PROCEDURE `APOYOESCOLARSOLACT`(

	Par_ClienteID			INT(11),
	Par_ApoyoEscSolID		INT(11),
	Par_Estatus				CHAR(1),
	Par_UsuarioAutoriza		INT(11),
	Par_Comentario			VARCHAR(300),

	Par_TransaccionPago		BIGINT,
	Par_PolizaID			BIGINT,
	Par_CajaID				INT(11),
	Par_SucursalCajaID		INT(11),
	Par_RecibePago			varchar(200),

	Par_NumAct				TINYINT UNSIGNED,
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


	DECLARE varControl 			CHAR(15);
	DECLARE Var_FechaAut		DATE;
	DECLARE Var_FechaPag       	DATE;



	DECLARE	Estatus_Reg			CHAR(1);
	DECLARE	Estatus_Aut			CHAR(1);
	DECLARE	Estatus_Rec			CHAR(1);
	DECLARE Estatus_Pag			CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Act_PorAutoriza		INT;
	DECLARE Act_PorPago     	INT;



	SET Estatus_Reg			:='R';
	SET Estatus_Aut			:='A';
	SET Estatus_Rec			:='X';
	SET Estatus_Pag			:='P';
	SET Entero_Cero			:=0;
	SET Decimal_Cero		:=0.00;
	SET Cadena_Vacia		:='';
	SET Fecha_Vacia			:='1900-01-01';
	SET Estatus_Activo		:='A';
	SET Salida_SI			:='S';
	SET Act_PorAutoriza		:=1;
	SET Act_PorPago			:=2;




	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= '';
	SET Var_FechaAut	:=(SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaPag	:=(SELECT FechaSistema FROM PARAMETROSSIS);


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-APOYOESCOLARSOLACT');
				SET varControl = 'sqlException' ;
			END;


		IF(ifnull(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El ID de safilocale.cliente esta vacio.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_ApoyoEscSolID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El ID de la solicitud de apoyo escolar esta vacio.';
			SET varControl  := 'apoyoEscSolID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID=Par_ClienteID
					AND Estatus= Estatus_Activo)THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El safilocale.cliente NO se encuentra registrado.';
			SET varControl  := 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ApoyoEscSolID
				FROM APOYOESCOLARSOL
				WHERE ApoyoEscSolID 	= Par_ApoyoEscSolID
				AND	  ClienteID			= Par_ClienteID)THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'La solicitud no existe o no pertenece al safilocale.cliente especificado.';
			SET varControl  := 'apoyoEscSolID' ;
			LEAVE ManejoErrores;
		END IF;





	IF(Par_NumAct = Act_PorAutoriza) THEN

		IF NOT EXISTS(SELECT U.UsuarioID
				FROM USUARIOS U INNER JOIN ROLES R ON U.RolID=U.RolID
				INNER JOIN PARAMETROSCAJA PC ON PC.RolAutoApoyoEsc=R.RolID
				WHERE U.UsuarioID 		= Par_UsuarioAutoriza
				AND	  U.Estatus 			= Estatus_Activo)THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'El usuario no tiene privilegios para autorizar la solicitud.';
			SET varControl  := 'usuarioAutoriza' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Estatus,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'Debe indicar el estatus de la solicitud.';
			SET varControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_UsuarioAutoriza,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '008';
			SET Par_ErrMen  := 'El ID de usuario que autoriza esta vacio.';
			SET varControl  := 'usuarioAutoriza' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Var_FechaAut,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr  := '009';
			SET Par_ErrMen  := 'La fecha de autorizacion esta vacia.';
			SET varControl  := 'fechaAutoriza' ;
			LEAVE ManejoErrores;
		END IF;
		IF(Par_Estatus = Estatus_rec) THEN
			IF(ifnull(Par_Comentario,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '010';
				SET Par_ErrMen  := 'El comentario esta vacio.';
				SET varControl  := 'comentario' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF NOT EXISTS(SELECT ApoyoEscSolID
				FROM APOYOESCOLARSOL
				WHERE ApoyoEscSolID 		= Par_ApoyoEscSolID
				AND	  Estatus 			= Estatus_Reg
				AND	  ClienteID			= Par_ClienteID)THEN
			SET Par_NumErr  := '011';
			SET Par_ErrMen  := 'El safilocale.cliente NO cuenta con una solicitud de apoyo escolar que pueda ser autorizada.';
			SET varControl  := 'apoyoEscSolID' ;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual		 := NOW();
		UPDATE APOYOESCOLARSOL SET
							Estatus					= Par_Estatus,
							UsuarioAutoriza			= Par_UsuarioAutoriza,
							FechaAutoriza			= Var_FechaAut,
							Comentario				= Par_Comentario,

							EmpresaID				= Par_EmpresaID,
							Usuario					= Aud_Usuario,
							FechaActual				= Aud_FechaActual,
							DireccionIP				= Aud_DireccionIP,
							ProgramaID				= Aud_ProgramaID,
							Sucursal				= Aud_Sucursal,
							NumTransaccion			= Aud_NumTransaccion
							WHERE ClienteID	=Par_ClienteID
							AND  ApoyoEscSolID 		= Par_ApoyoEscSolID;


	SET Par_NumErr  := '000';
	IF(Par_Estatus = Estatus_Aut) THEN
		SET Par_ErrMen  := CONCAT('Solicitud de Apoyo Escolar Autorizada exitosamente: ',Par_ApoyoEscSolID);
	END IF;

	IF(Par_Estatus = Estatus_Rec) THEN
		SET Par_ErrMen  := CONCAT('Solicitud de Apoyo Escolar Rechazada exitosamente: ',Par_ApoyoEscSolID);
	END IF;

	SET varControl  := 'apoyoEscSolID' ;
	LEAVE ManejoErrores;





	ELSE IF(Par_NumAct = Act_PorPago) THEN

		IF(ifnull(Par_TransaccionPago,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '012';
			SET Par_ErrMen  := 'El numero de transaccion de pago esta vacio.';
			SET varControl  := 'transaccionPago' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_CajaID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '013';
			SET Par_ErrMen  := 'El numero de caja esta vacio.';
			SET varControl  := 'cajaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_PolizaID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '014';
			SET Par_ErrMen  := 'El numero de poliza esta vacio.';
			SET varControl  := 'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_SucursalCajaID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '015';
			SET Par_ErrMen  := 'El numero de sucursal esta vacio.';
			SET varControl  := 'sucursalCajaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ApoyoEscSolID
				FROM APOYOESCOLARSOL
				WHERE ApoyoEscSolID 		= Par_ApoyoEscSolID
				AND	  Estatus 			= Estatus_Aut
				AND	  ClienteID			= Par_ClienteID)THEN
			SET Par_NumErr  := '016';
			SET Par_ErrMen  := 'La solicitud de apoyo escolar no esta autorizada.';
			SET varControl  := 'apoyoEscSolID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT CajaID
				FROM CAJASVENTANILLA
				WHERE CajaID 		= Par_CajaID
				AND Estatus=Estatus_Activo
				AND SucursalID = Par_SucursalCajaID)THEN
			SET Par_NumErr  := '017';
			SET Par_ErrMen  := 'El numero de caja no existe.';
			SET varControl  := 'cajaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT SucursalID
				FROM SUCURSALES
				WHERE SucursalID 		= Par_SucursalCajaID)THEN
			SET Par_NumErr  := '018';
			SET Par_ErrMen  := 'El numero de sucursal no existe.';
			SET varControl  := 'sucursalCajaID' ;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual		 := NOW();
		UPDATE APOYOESCOLARSOL SET
							Estatus					= Estatus_Pag,
							FechaPago				= Var_FechaPag,
							TransaccionPago			= Par_TransaccionPago,
							PolizaID				= Par_PolizaID,
							CajaID					= Par_CajaID,
							SucursalCajaID			= Par_SucursalCajaID,
							RecibePago				= Par_RecibePago,

							EmpresaID				= Par_EmpresaID,
							Usuario					= Aud_Usuario,
							FechaActual				= Aud_FechaActual,
							DireccionIP				= Aud_DireccionIP,
							ProgramaID				= Aud_ProgramaID,
							Sucursal				= Aud_Sucursal,
							NumTransaccion			= Aud_NumTransaccion
							WHERE ClienteID	=Par_ClienteID
							AND  ApoyoEscSolID 		= Par_ApoyoEscSolID;


	SET Par_NumErr  := '000';
	SET Par_ErrMen  := CONCAT('Pago de Apoyo Escolar registrado con exito: ',Par_ApoyoEscSolID);
	SET varControl  := 'apoyoEscSolID' ;
	LEAVE ManejoErrores;

		END IF;
	END IF;
END ManejoErrores;



	IF (Par_Salida = Salida_SI) THEN
		SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				varControl			 AS control,
				Par_ApoyoEscSolID	 AS consecutivo;
	end IF;

END TerminaStore$$