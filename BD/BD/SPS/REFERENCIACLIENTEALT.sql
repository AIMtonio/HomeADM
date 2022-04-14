-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFERENCIACLIENTEALT`;
DELIMITER $$

CREATE PROCEDURE `REFERENCIACLIENTEALT`(

	Par_SolicitudCreditoID	BIGINT(20),
	Par_PrimerNombre		VARCHAR(50),
	Par_SegundoNombre		VARCHAR(50),
	Par_TercerNombre		VARCHAR(50),
	Par_ApellidoPaterno		VARCHAR(50),

	Par_ApellidoMaterno		VARCHAR(50),
	Par_Telefono			VARCHAR(20),
	Par_ExtTelefonoPart		VARCHAR(7),
	Par_Validado			CHAR(1),

	Par_Interesado			CHAR(1),
	Par_TipoRelacionID		INT(11),
	Par_EstadoID			INT(11),
	Par_MunicipioID			INT(11),
	Par_LocalidadID			INT(11),

	Par_ColoniaID			INT(11),
	Par_Calle 				VARCHAR(50),
	Par_NumeroCasa			VARCHAR(10),
	Par_NumInterior			VARCHAR(10),
	Par_Piso				VARCHAR(50),

	Par_CP 					VARCHAR(5),
	Par_Salida 				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Aud_Usuario				INT(11),
	Aud_Empresa				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN

	DECLARE Var_ReferenciaID		INT(11);
	DECLARE Var_SolicitudCreditoID	BIGINT(20);
	DECLARE Var_Control				VARCHAR(20);
	DECLARE Var_Consecutivo			VARCHAR(50);
    DECLARE Var_NombreCompleto		VARCHAR(250);
    DECLARE Var_DireccionCompleta	VARCHAR(500);
    DECLARE Var_NombEstado			VARCHAR(200);
    DECLARE Var_NombMunicipio		VARCHAR(200);
    DECLARE Var_NombreColonia		VARCHAR(200);
    DECLARE Var_ConsecRef			INT(11);
    DECLARE Var_ClienteID			INT(11);			-- Clave del Cliente
    DECLARE Var_Clasificacion		CHAR(1);			-- Clasificacion del cliente

    DECLARE Cadena_Vacia			VARCHAR(1);
    DECLARE Entero_Cero				INT(11);
    DECLARE Cons_NO					CHAR(1);
    DECLARE Salida_SI				CHAR(1);
    DECLARE Clasif_Emp_Nomina		CHAR(1);			-- Clasificacion del empleado de nomina
	DECLARE EnteroDiez              INT(11);

    SET Cadena_Vacia				:= '';
    SET Entero_Cero					:= 0;
    SET Cons_NO						:= 'N';
    SET Salida_SI					:= 'S';

	SET Var_Control					:= 'solicitudCreditoID';
	SET Var_Consecutivo				:= 0;
	SET Clasif_Emp_Nomina			:= 'M';				-- Clasificacion del empleado de nomina
	SET EnteroDiez                  := 10;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-REFERENCIACLIENTEALT');
				SET Var_Control:= 'sqlException';
			END;

		SET Var_SolicitudCreditoID	:= (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolicitudCreditoID);
		SET Var_ConsecRef			:= (SELECT (COUNT(SolicitudCreditoID)+1) FROM REFERENCIACLIENTE WHERE SolicitudCreditoID=Par_SolicitudCreditoID);
		SET Var_ConsecRef			:= IFNULL(Var_ConsecRef,Entero_Cero);

		SELECT ClienteID
			INTO Var_ClienteID
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID=Par_SolicitudCreditoID;

		SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

		IF(Var_ClienteID <> Entero_Cero) THEN
			SELECT Clasificacion
				INTO Var_Clasificacion
				FROM CLIENTES
				WHERE ClienteID = Var_ClienteID;
		END IF;

		SET Var_Clasificacion := IFNULL(Var_Clasificacion, Cadena_Vacia);

        IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Solicitud de Credito Esta Vacio.';
			SET Var_Control	:= 'solicitudCreditoID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 002;
			SET	Par_ErrMen	:= 'El Numero de Solicitud de Credito No Existe.';
			SET Var_Control	:= 'solicitudCreditoID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr	:= 003;
			SET	Par_ErrMen	:= 'El Nombre esta Vacio.';
			SET Var_Control	:= 'primerNombre';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_ApellidoPaterno, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr	:= 004;
			SET	Par_ErrMen	:= 'El Apellido Paterno esta Vacio.';
			SET Var_Control	:= 'apellidoPaterno';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr	:= 005;
			SET	Par_ErrMen	:= 'El Estado esta Vacio.' ;
			SET Var_Control := 'estadoID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		ELSE
			IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
						WHERE EstadoID = Par_EstadoID
							LIMIT 1) AND IFNULL(Par_EstadoID,Entero_Cero) <> Entero_Cero THEN
				SET Par_NumErr := 006;
				SET Par_ErrMen := 'El Valor Indicado del Estado No Existe.';
				SET Var_Control	:= 'estadoID';
                SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_MunicipioID , Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr := 007;
			SET	Par_ErrMen := 'El Municipio esta vacio.';
			SET Var_Control := 'municipioID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		  ELSE
				IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
				   WHERE MunicipioID = Par_MunicipioID
				   AND EstadoID = Par_EstadoID
				   LIMIT 1) AND IFNULL(Par_MunicipioID , Entero_Cero) <> Entero_Cero THEN
					SET Par_NumErr := 008;
					SET Par_ErrMen := 'El Municipio Indicado No Existe.';
					SET Var_Control	:= 'municipioID';
                    SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
		END IF;

		IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr := 009;
			SET	Par_ErrMen := 'La Localidad esta Vacia.';
			SET Var_Control := 'localidadID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		ELSE
			IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
						WHERE LocalidadID = Par_LocalidadID
							AND EstadoID = Par_EstadoID
							AND MunicipioID = Par_MunicipioID
							LIMIT 1) AND IFNULL(Par_LocalidadID, Entero_Cero) <> Entero_Cero THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'El Valor Indicado para la Localidad No Existe.';
				SET Var_Control	:= 'localidadID';
                SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr := 011;
			SET	Par_ErrMen := 'La Colonia esta Vacia.';
			SET Var_Control := 'colonia';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		ELSE
			IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
				   WHERE EstadoID = Par_EstadoID
				   AND MunicipioID = Par_MunicipioID
				   AND ColoniaID = Par_ColoniaID
				   LIMIT 1) AND IFNULL(Par_ColoniaID, Entero_Cero) <> Entero_Cero THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= 'El Valor Indicado para la Colonia No Existe.';
				SET Var_Control	:= 'coloniaID';
                SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'La Calle esta Vacia.';
			SET Var_Control	:= 'calle';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr := 015;
			SET	Par_ErrMen := 'El Numero esta Vacio.' ;
			SET Var_Control := 'numeroCasa';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_CP , Cadena_Vacia)) = Cadena_Vacia AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET	Par_NumErr := 015;
			SET	Par_ErrMen := 'El Codigo postal esta Vacio.';
			SET Var_Control := 'cp';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'El Telefono esta Vacio.';
			SET Var_Control	:= 'telefono';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(LENGTH(Par_Telefono) <> EnteroDiez)THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'Telefono incorrecto permitidos 10 digitos';
			SET Var_Control	:= 'telefono';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TipoRelacionID,Entero_Cero) = Entero_Cero) AND Var_Clasificacion <> Clasif_Emp_Nomina THEN
			SET Par_NumErr := 018;
			SET Par_ErrMen := 'El Tipo de Relacion Esta Vacio.';
			SET Var_Control	:= 'tipoRelacionID';
            SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		 ELSE
			 IF NOT EXISTS(SELECT TipoRelacionID FROM TIPORELACIONES
					   WHERE TipoRelacionID = Par_TipoRelacionID
					   LIMIT 1) AND IFNULL(Par_TipoRelacionID,Entero_Cero) <> Entero_Cero THEN
				SET Par_NumErr	:= 019;
				SET Par_ErrMen	:= 'El Valor Indicado para la el tipo de relacion No Existe.';
				SET Var_Control	:= 'tipoRelacionID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_PrimerNombre       	:= UPPER(TRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
		SET Par_SegundoNombre      	:= UPPER(TRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
		SET Par_TercerNombre     	:= UPPER(TRIM(IFNULL(Par_TercerNombre, Cadena_Vacia)));
		SET Par_ApellidoPaterno		:= UPPER(TRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia)));
		SET Par_ApellidoMaterno		:= UPPER(TRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia)));

        SET Var_NombreCompleto		:= CONCAT(Par_PrimerNombre
										,CASE WHEN CHAR_LENGTH(Par_SegundoNombre)  > 0 THEN CONCAT(" ", Par_SegundoNombre) ELSE '' END
										,CASE WHEN CHAR_LENGTH(Par_TercerNombre)   > 0 THEN CONCAT(" ", Par_TercerNombre) ELSE '' END
										,CASE WHEN CHAR_LENGTH(Par_ApellidoPaterno) > 0 THEN CONCAT(" ",Par_ApellidoPaterno) ELSE '' END
										,CASE WHEN CHAR_LENGTH(Par_ApellidoMaterno) > 0 THEN CONCAT(" ",Par_ApellidoMaterno) ELSE '' END
										);

		SET Par_Telefono			:= IFNULL(Par_Telefono, Cadena_Vacia);
		SET Par_ExtTelefonoPart		:= IFNULL(Par_ExtTelefonoPart, Cadena_Vacia);
		SET Par_Validado			:= IFNULL(Par_Validado, Cons_NO);
		SET Par_Interesado			:= IFNULL(Par_Interesado, Cons_NO);
		SET Par_TipoRelacionID		:= IFNULL(Par_TipoRelacionID, Entero_Cero);
		SET Par_EstadoID			:= IFNULL(Par_EstadoID, Entero_Cero);
		SET Par_MunicipioID			:= IFNULL(Par_MunicipioID, Entero_Cero);
		SET Par_LocalidadID			:= IFNULL(Par_LocalidadID, Entero_Cero);
		SET Par_ColoniaID			:= IFNULL(Par_ColoniaID, Entero_Cero);
		SET Par_Calle				:= IFNULL(Par_Calle, Cadena_Vacia);
		SET Par_NumeroCasa			:= IFNULL(Par_NumeroCasa, Cadena_Vacia);
		SET Par_NumInterior			:= IFNULL(Par_NumInterior, Cadena_Vacia);
		SET Par_Piso				:= IFNULL(Par_Piso, Cadena_Vacia);
		SET Par_CP					:= IFNULL(Par_CP, Cadena_Vacia);

        SET Var_NombEstado			:= (SELECT Nombre
										  FROM ESTADOSREPUB
										  WHERE EstadoID = Par_EstadoID);
		SET Var_NombEstado			:=IFNULL(Var_NombEstado, Cadena_Vacia);
		SET Var_NombMunicipio		:= (SELECT M.Nombre
										 FROM MUNICIPIOSREPUB M,ESTADOSREPUB E
										 WHERE E.EstadoID=M.EstadoID
											AND E.EstadoID=Par_EstadoID
                                            AND M.MunicipioID=Par_MunicipioID);
		SET Var_NombMunicipio		:=IFNULL(Var_NombMunicipio, Cadena_Vacia);
		SET Var_NombreColonia		:= (SELECT concat(TipoAsenta, ' ',Asentamiento)
										FROM COLONIASREPUB
										   WHERE EstadoID = Par_EstadoID
										   AND MunicipioID = Par_MunicipioID
										   AND ColoniaID =Par_ColoniaID);
		SET Var_NombreColonia		:=IFNULL(Var_NombreColonia, Cadena_Vacia);


		SET Var_DireccionCompleta := Par_Calle;

		IF(Par_NumeroCasa != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,', No. ',Par_NumeroCasa);
		END IF;

		IF(Par_NumInterior != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,', INTERIOR ',Par_NumInterior);
		END IF;

		IF(Par_Piso != Cadena_Vacia) THEN
			SET Var_DireccionCompleta := CONCAT(Var_DireccionCompleta,', PISO ',Par_Piso);
		END IF;

		SET Var_DireccionCompleta := UPPER(CONCAT(Var_DireccionCompleta,', COL. ',Var_NombreColonia,', C.P. ',Par_CP,', ',Var_NombMunicipio,', ',Var_NombEstado,'.'));

		SET Aud_FechaActual := NOW();
        set Var_ReferenciaID := (SELECT ifnull(Max(ReferenciaID),Entero_Cero) + 1
									FROM REFERENCIACLIENTE);
		INSERT INTO REFERENCIACLIENTE(
			ReferenciaID,			SolicitudCreditoID,		Consecutivo,			PrimerNombre,		SegundoNombre,		TercerNombre,
			ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			Telefono,			ExtTelefonoPart,
			Validado,				Interesado,				TipoRelacionID,			EstadoID,			MunicipioID,
			LocalidadID,			ColoniaID,				Calle,					NumeroCasa,			NumInterior,
			Piso,					CP,						DireccionCompleta,		Usuario,			Empresa,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
		VALUES(
			Var_ReferenciaID,		Par_SolicitudCreditoID,	Var_ConsecRef,			Par_PrimerNombre,	Par_SegundoNombre,	Par_TercerNombre,
			Par_ApellidoPaterno,	Par_ApellidoMaterno,	Var_NombreCompleto,		Par_Telefono,		Par_ExtTelefonoPart,
			Par_Validado,			Par_Interesado,			Par_TipoRelacionID,		Par_EstadoID,		Par_MunicipioID,
			Par_LocalidadID,		Par_ColoniaID,			Par_Calle,				Par_NumeroCasa,		Par_NumInterior,
			Par_Piso,				Par_CP,					Var_DireccionCompleta,	Aud_Usuario,		Aud_Empresa,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
		);
	 SET Par_NumErr := 000;
	 SET Par_ErrMen := CONCAT('Referencia(s) Grabada(s) Exitosamente para la Solicitud de Credito: ',Par_SolicitudCreditoID);
	 SET Var_Control := 'solicitudCreditoID';
	 SET Var_Consecutivo := Par_SolicitudCreditoID;
	END ManejoErrores;

    IF(Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
