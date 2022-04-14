-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGOCIOAFILIADOMOD`;DELIMITER $$

CREATE PROCEDURE `NEGOCIOAFILIADOMOD`(


	Par_NegocioAfiliadoID			int,
	Par_NombreContacto 				varchar(400),
	Par_DireccionCompleta			varchar(400),
	Par_TelefonoContacto 			varchar(20),
	Par_Email 						varchar(50),
	Par_RFC 						char(12),
	Par_RazonSocial 				varchar(200),
	Par_PromotorOrigen				int,
	Par_ClienteID					bigint,

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
											 'esto le ocasiona. Ref: SP-NEGOCIOAFILIADOMOD');
					SET varControl = 'sqlException' ;
				END;

			IF (ifnull(Par_NegocioAfiliadoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  :='001';
				SET Par_ErrMen  :='El Negocio Afiliado esta vacio.';
				SET varControl	:='negocioAfiliadoID';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT NegocioAfiliadoID
					FROM NEGOCIOAFILIADO
					WHERE NegocioAfiliadoID=Par_NegocioAfiliadoID)	THEN
					SET Par_NumErr  := '002';
					SET Par_ErrMen  := 'El Negocio Afiliado NO existe.';
					SET varControl  := 'negocioAfiliadoID' ;
					LEAVE ManejoErrores;
			END IF;


			IF(ifnull(Par_RazonSocial,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '003';
				SET Par_ErrMen  := 'La Razon Social esta vacia.';
				SET varControl  := 'razonSocial' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_DireccionCompleta,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '004';
				SET Par_ErrMen  := 'La Direccion esta vacia.';
				SET varControl  := 'direccionCompleta' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_TelefonoContacto,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '005';
				SET Par_ErrMen  := 'El Telefono esta vacio.';
				SET varControl  := 'telefonoCompleto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_NombreContacto,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '006';
				SET Par_ErrMen  := 'El Nombre esta vacio.';
				SET varControl  := 'nombreContacto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_Email,Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := '007';
				SET Par_ErrMen  := 'El Email esta vacio.';
				SET varControl  := 'email' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_PromotorOrigen,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := '008';
				SET Par_ErrMen  := 'El Promotor esta vacio.';
				SET varControl  := 'promotorOrigen' ;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT PromotorID
					FROM PROMOTORES
					WHERE PromotorID=Par_PromotorOrigen
					AND Estatus= Est_Activo)THEN
				SET Par_NumErr  := '009';
				SET Par_ErrMen  := 'El Promotor indicado NO existe.';
				SET varControl  := 'promotorID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_ClienteID,Entero_Cero))!= Entero_Cero THEN
				IF NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
						WHERE ClienteID=Par_ClienteID
						AND Estatus= Est_Activo)THEN
					SET Par_NumErr  := '010';
					SET Par_ErrMen  := 'El Cliente indicado NO existe.';
					SET varControl  := 'clienteID' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;



	SET Aud_FechaActual 	:= NOW();

	UPDATE NEGOCIOAFILIADO SET
		RazonSocial			=Par_RazonSocial,
		RFC					=Par_RFC,
		DireccionCompleta	=Par_DireccionCompleta,
		TelefonoContacto	=Par_TelefonoContacto,
		NombreContacto		=Par_NombreContacto,
		Email				=Par_Email,
		PromotorOrigen		=Par_PromotorOrigen,
		EmpresaID			=Par_EmpresaID,
		Usuario				=Aud_Usuario,
		FechaActual			=Aud_FechaActual,
		DireccionIP			=Aud_DireccionIP,
		ProgramaID			=Aud_ProgramaID,
		Sucursal			=Aud_Sucursal,
		NumTransaccion		=Aud_NumTransaccion,
		ClienteID			=Par_ClienteID

	WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID;

	SET Par_NumErr  := '000';
	SET Par_ErrMen  := concat('Negocio Afiliado Modificado Exitosamente:', convert(Par_NegocioAfiliadoID,char));
	SET varControl  := 'negocioAfiliadoID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT convert(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen				AS ErrMen,
				varControl				AS control,
				Par_NegocioAfiliadoID	AS consecutivo;
	END IF;
END TerminaStore$$