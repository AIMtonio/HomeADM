-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGOCIOAFILIADOALT`;DELIMITER $$

CREATE PROCEDURE `NEGOCIOAFILIADOALT`(


	Par_NombreContacto 				varchar(400),
	Par_DireccionCompleta			varchar(400),
	Par_TelefonoContacto 			varchar(20),
	Par_Email 						varchar(50),
	Par_RFC 						char(12),
	Par_RazonSocial 				varchar(200),
	Par_PromotorOrigen				int,
	Par_ClienteID					int,

	Par_Salida          			char(1),
	inout Par_NumErr    			int,
	inout Par_ErrMen    			varchar(400),

	Par_EmpresaID       			int(11),
	Aud_Usuario         			int,
	Aud_FechaActual     			DateTime,
	Aud_DireccionIP     			varchar(15),
	Aud_ProgramaID      			varchar(50),
	Aud_Sucursal        			int,
	Aud_NumTransaccion  			bigint
	)
TerminaStore : BEGIN



	DECLARE varControl 				varchar(20);
	DECLARE varFechaSis				date;
	DECLARE varConsecutivo			int;



	DECLARE Entero_Cero				int;
	DECLARE Cadena_Vacia			char(1);
	DECLARE Salida_SI				char(1);
	DECLARE Est_Activo				char(1);



	SET Entero_Cero					:=0;
	SET Cadena_Vacia				:='';
	SET Salida_SI					:='S';
	SET Est_Activo					:='A';



	SET Par_NumErr					:=0;
	SET Par_ErrMen					:='';

	ManejoErrores:BEGIN
			 DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = '999';
					SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
											 'estamos trabajando para resolverla. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-NEGOCIOAFILIADOALT');
					SET varControl = 'sqlException' ;
				END;

			IF(ifnull(Par_RazonSocial,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '001';
				SET Par_ErrMen  := 'La Razon Social esta vacia.';
				SET varControl  := 'razonSocial' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_DireccionCompleta,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '002';
				SET Par_ErrMen  := 'La Direccion esta vacia.';
				SET varControl  := 'direccionCompleta' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_TelefonoContacto,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '003';
				SET Par_ErrMen  := 'El Telefono esta vacio.';
				SET varControl  := 'telefonoCompleto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_NombreContacto,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := 'El Nombre esta vacio.';
				SET varControl  := 'nombreContacto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_Email,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '005';
				SET Par_ErrMen  := 'El Email esta vacio.';
				SET varControl  := 'email' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_PromotorOrigen,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := '006';
				SET Par_ErrMen  := 'El Promotor esta vacio.';
				SET varControl  := 'promotorOrigen' ;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT PromotorID
					FROM PROMOTORES
					WHERE PromotorID=Par_PromotorOrigen
					AND Estatus= Est_Activo)THEN
			SET Par_NumErr  := '007';
			SET Par_ErrMen  := 'El Promotor indicado NO existe.';
			SET varControl  := 'promotorID' ;
			LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_ClienteID,Entero_Cero))!= Entero_Cero THEN
				IF NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
						WHERE ClienteID=Par_ClienteID
						AND Estatus= Est_Activo)THEN
					SET Par_NumErr  := '008';
					SET Par_ErrMen  := 'El Cliente indicado NO existe.';
					SET varControl  := 'clienteID' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;






	SET varFechaSis 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Aud_FechaActual 	:= NOW();

	CALL FOLIOSAPLICAACT('NEGOCIOAFILIADO', varConsecutivo);


	INSERT INTO NEGOCIOAFILIADO(
		NegocioAfiliadoID,		RazonSocial,		RFC,				DireccionCompleta,		TelefonoContacto,
		NombreContacto,			Email,				FechaRegistro,		PromotorOrigen,			Estatus,
		ClienteID,				EmpresaID,			Usuario,			FechaActual,			DireccionIP,
		ProgramaID,				Sucursal,			NumTransaccion
		)
	VALUES(
		varConsecutivo, 		Par_RazonSocial,	Par_RFC, 			Par_DireccionCompleta,	Par_TelefonoContacto,
		Par_NombreContacto,		Par_Email,		 	varFechaSis,		Par_PromotorOrigen,		Est_Activo,
		Par_ClienteID,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
		);

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := concat('Negocio Afiliado Agregado Exitosamente:', convert(varConsecutivo,char)) ;
	SET varControl  := 'negocioAfiliadoID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			AS ErrMen,
				varControl			AS control,
				varConsecutivo		AS consecutivo;
	END IF;
END TerminaStore$$