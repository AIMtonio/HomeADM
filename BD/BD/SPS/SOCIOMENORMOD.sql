-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENORMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOMENORMOD`;
DELIMITER $$

CREATE PROCEDURE `SOCIOMENORMOD`(
	Par_ClienteID			INT,
	Par_SucursalOri         INT,
	Par_TipoPersona         CHAR(1),
	Par_Titulo              VARCHAR(10),
	Par_PrimerNom           VARCHAR(50),

    Par_SegundoNom          VARCHAR(50),
	Par_TercerNom           VARCHAR(50),
	Par_ApellidoPat         VARCHAR(50),
	Par_ApellidoMat         VARCHAR(50),
	Par_FechaNac            VARCHAR(50),

	Par_LugarNac            INT,
	Par_EstadoID            INT,
	Par_Nacion              CHAR(1),
	Par_PaisResi            INT,
	Par_Sexo                CHAR(1),

    Par_CURP                CHAR(18),
	Par_RFC                 CHAR(13),
	Par_EstadoCivil         CHAR(2),
	Par_TelefonoCel         VARCHAR(20) ,
	Par_Telefono            VARCHAR(20) ,

	Par_Correo              VARCHAR(50),
	Par_RazonSocial         VARCHAR(150),
	Par_TipoSocID           INT,
	Par_RFCpm               CHAR(13),
	Par_GrupoEmp            INT,

    Par_Fax                 VARCHAR(20),
	Par_OcupacionID         INT,
	Par_Puesto              VARCHAR(100),
	Par_LugardeTrab         VARCHAR(100),
	Par_AntTra              float,

	Par_TelTrabajo          VARCHAR(20),
	Par_Clasific            CHAR(1),
	Par_MotivoApert         CHAR(1),
	Par_PagaISR             CHAR(1),
	Par_PagaIVA             CHAR(1),

    Par_PagaIDE             CHAR(1),
	Par_NivelRiesgo         CHAR(1),
	Par_SecGeneral          INT,
	Par_ActBancoMX          VARCHAR(15),
	Par_ActINEGI            INT,

	Par_ActFR			    BIGINT,
	Par_ActFOMUR			INT,
	Par_SecEconomic         INT,
	Par_PromotorIni         INT,
	Par_PromotorAct         INT,

    Par_EsMenorEdad         CHAR(1),
	Par_ClienteTutorID      INT,
	Par_NombreTutor         VARCHAR(150),
	Par_ExtTelefonoPart		VARCHAR(6),
	Par_ParentescoID		INT,

	Par_EjecutivoCap        INT, 				-- Ejecutivo de Captacion
    Par_PromotorExtInv      INT, 				-- Promotor Externo de Inversion

    Par_Salida            	CHAR(1),      		-- Sucursal salida
    INOUT Par_NumErr      	INT(11),        	-- Numero de error
	INOUT Par_ErrMen      	VARCHAR(400),   	-- Mensaje de error

	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE	Var_PaisID				INT;
	DECLARE Valida_RFC         		CHAR(13);
	DECLARE Var_RFCOficial      	CHAR(13);
	DECLARE Var_RelacionID			INT(11);
	DECLARE Var_ParentescoTutor 	INT(11);
	DECLARE Var_ParentescoMenor		INT(11);
	DECLARE Var_TipoRelacion		INT(11);

	DECLARE Var_FechaAct 			INT;
	DECLARE Var_AnioAct 			INT;
	DECLARE Var_MesAct  			INT;
	DECLARE Var_DiaAct  			INT;
	DECLARE Var_AnioNac 			INT;
	DECLARE Var_MesNac  			INT;
	DECLARE Var_DiaNac  			INT;
	DECLARE Var_Anios   			INT;
	DECLARE Var_ParentescoOriginal 	INT(11);
	DECLARE Var_RelacionadoOriginal	INT(11);
    DECLARE Var_Control				VARCHAR(100);
    DECLARE Var_Consecutivo			INT(11);

    -- Declaracion de Constantes
	DECLARE	 Fecha_Alta		  		DATE;
	DECLARE  NumeroEmpresa	  		INT;
	DECLARE  Cadena_Vacia     		CHAR(1);
	DECLARE  Fecha_Vacia      		DATE;
	DECLARE  Entero_Cero      		INT;
	DECLARE  NombreComplet    		VARCHAR(200);
	DECLARE  Pais             		INT;
	DECLARE  Per_Fisica       		CHAR(1);
	DECLARE  Per_ActEmp       		CHAR(1);
	DECLARE  Per_Moral        		CHAR(1);
	DECLARE	 MenorEdad	      		CHAR(1);
	DECLARE	 RelacionTutor    		INT(4);
	DECLARE  SalidaNo		  		VARCHAR(1);
    DECLARE Salida_SI		  		CHAR(1);
	DECLARE Par_RegistroHacienda    CHAR(1);

	-- Asiganacion de constantes
	SET NumeroEmpresa 			:= 1;
	SET Cadena_Vacia         	:= '';
	SET Fecha_Vacia          	:= '1900-01-01';
	SET Entero_Cero          	:= 0;
	SET NombreComplet        	:= '';
	SET Pais           		 	:= 700;
	SET Per_Fisica           	:= 'F';
	SET Per_ActEmp           	:= 'A';
	SET Per_Moral      		 	:= 'M';
	SET Var_PaisID				:= 0;
	SET Par_RegistroHacienda    :='N';
	SET Var_ParentescoTutor		:= 40;
	SET Var_ParentescoMenor		:= 41;
	SET	Var_TipoRelacion		:= 1;
	SET MenorEdad				:= 'S';
	SET SalidaNo				:= 'N';
	SET Salida_SI           	:= 'S';       -- Salida SI
	SET Par_PrimerNom       	:= rtrim(ltrim(ifnull(Par_PrimerNom, Cadena_Vacia)));
	SET Par_SegundoNom      	:= rtrim(ltrim(ifnull(Par_SegundoNom, Cadena_Vacia)));
	SET Par_TercerNom       	:= rtrim(ltrim(ifnull(Par_TercerNom, Cadena_Vacia)));
	SET Par_ApellidoPat     	:= rtrim(ltrim(ifnull(Par_ApellidoPat, Cadena_Vacia)));
	SET Par_ApellidoMat	  		:= rtrim(ltrim(ifnull(Par_ApellidoMat, Cadena_Vacia)));

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := concat('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-SOCIOMENORMOD');
		END;

		IF(not exists(SELECT ClienteID
			from CLIENTES
				WHERE ClienteID = Par_ClienteID)) then
			SET Par_NumErr  	:= 1;
			SET Par_ErrMen  	:= 'El Numero de Cliente no existe.';
			SET Var_Control 	:= 'numero';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;

		END IF;

		IF(ifnull(Par_SucursalOri, Entero_Cero))= Entero_Cero then
			SET Par_NumErr  	:= 6;
			SET Par_ErrMen  	:= 'La sucursal esta Vacia.';
			SET Var_Control 	:= 'sucursalOrigen';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia then
			SET Par_NumErr  	:= 7;
			SET Par_ErrMen  	:= 'El Titulo esta Vacio.';
			SET Var_Control 	:= 'titulo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia then
			SET Par_NumErr  	:= 8;
			SET Par_ErrMen  	:= 'El Primer Nombre esta Vacio.';
			SET Var_Control 	:= 'primerNombre';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(ifnull(Par_ApellidoPat, Cadena_Vacia))=Cadena_Vacia then
			SET Par_NumErr  	:= 9;
			SET Par_ErrMen  	:= 'El Apellido Paterno esta Vacio.';
			SET Var_Control 	:= 'apellidoPaterno';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(Par_LugarNac = Pais) then
			IF(ifnull(Par_estadoID, Entero_Cero))= Entero_Cero then
				SET Par_NumErr  	:= 11;
				SET Par_ErrMen  	:= 'El Estado esta Vacio.';
				SET Var_Control 	:= 'estadoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(ifnull(Par_Nacion, Cadena_Vacia))=Cadena_Vacia then
			SET Par_NumErr  	:= 12;
			SET Par_ErrMen  	:= 'La Nacionalidad esta Vacia.';
			SET Var_Control 	:= 'nacion';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_PaisResi, Entero_Cero))= Entero_Cero then
			SET Par_NumErr  	:= 13;
			SET Par_ErrMen  	:= 'El pais de Residencia esta Vacio.';
			SET Var_Control 	:= 'paisResidencia';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Sexo, Cadena_Vacia))= Cadena_Vacia then
			SET Par_NumErr  	:= 14;
			SET Par_ErrMen  	:= 'El Sexo esta Vacio.';
			SET Var_Control 	:= 'sexo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(ifnull(Par_CURP, Cadena_Vacia))= Cadena_Vacia then
			SET Par_NumErr  	:= 15;
			SET Par_ErrMen  	:= 'La CURP esta Vacia.';
			SET Var_Control 	:= 'sexo';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_Telefono , Cadena_Vacia))= Cadena_Vacia then
				SET   Par_Telefono	:= '0';
		END IF;

		SET Par_GrupoEmp 	:= ifnull(Par_GrupoEmp, Entero_Cero);

		SET Par_OcupacionID := ifnull(Par_OcupacionID, Entero_Cero);

        IF(ifnull(Par_PromotorIni, Entero_Cero))= Entero_Cero then
			SET Par_NumErr  	:= 29;
			SET Par_ErrMen  	:= 'El Promotor Inicial esta Vacio.';
			SET Var_Control 	:= 'promotorInicial';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(ifnull(Par_PromotorAct, Entero_Cero))= Entero_Cero then
			SET Par_NumErr  	:= 29;
			SET Par_ErrMen  	:= 'El Promotor Actual esta Vacio.';
			SET Var_Control 	:= 'promotorActual';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_LugarNac, Entero_Cero)) = Entero_Cero then
			SET Par_NumErr  	:= 32;
			SET Par_ErrMen  	:= 'El pais de Lugar de nacimiento esta Vacio.';
			SET Var_Control 	:= 'LugarNac';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_LugarNac, Entero_Cero))<> Entero_Cero then
			SELECT PaisID into Var_PaisID from PAISES WHERE PaisID = Par_LugarNac;
			IF(ifnull(Var_PaisID, Entero_Cero))= Entero_Cero then
				SET Par_NumErr  	:= 33;
				SET Par_ErrMen  	:= 'El pais especificado como el Lugar de Nacimiento no existe.';
				SET Var_Control 	:= 'lugarNac';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_ClienteTutorID, Entero_Cero)) > Entero_Cero then
			IF EXISTS (SELECT ClienteID
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteTutorID
					AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr  	:= 34;
			SET Par_ErrMen  	:= 'El Suscriptor es Menor de Edad.';
			SET Var_Control 	:= 'clienteTutorID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(ifnull(Par_EjecutivoCap, Cadena_Vacia)) = Cadena_Vacia then
			SET Par_NumErr  	:= 10;
			SET Par_ErrMen  	:= 'El Ejecutivo de Captacion esta Vacio.';
			SET Var_Control 	:= 'ejecutivoCap';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF(ifnull(Par_PromotorExtInv, Cadena_Vacia)) = Cadena_Vacia then
			SET Par_NumErr  	:= 10;
			SET Par_ErrMen  	:= 'El Promotor Externo de Inversion esta vacio.';
			SET Var_Control 	:= 'promotorExtInv';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		SET Var_ParentescoOriginal :=(SELECT TipoRelacionID  from SOCIOMENOR WHERE SocioMenorID = Par_ClienteID);

		UPDATE SOCIOMENOR 	SET
			ClienteTutorID 	= Par_ClienteTutorID,
			NombreTutor 	= Par_NombreTutor,
			TipoRelacionID	= Par_ParentescoID,
			EjecutivoCap    = Par_EjecutivoCap,
			PromotorExtInv  = Par_PromotorExtInv,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		WHERE SocioMenorID = Par_ClienteID;

		SET Var_RelacionadoOriginal :=(SELECT RelacionadoID  from RELACIONCLIEMPLEADO WHERE ClienteID = Par_ClienteID AND ParentescoID = Var_ParentescoOriginal Limit 1);


		IF (ifnull(Par_ClienteTutorID, Entero_Cero)) != Entero_Cero then

			IF EXISTS(SELECT ClienteID
				FROM 	RELACIONCLIEMPLEADO
					WHERE ClienteID = Par_ClienteID
						AND ParentescoID = Var_ParentescoOriginal)THEN

				UPDATE RELACIONCLIEMPLEADO SET
					RelacionadoID   = Par_ClienteTutorID,
					ParentescoID	= Par_ParentescoID,

					EmpresaID       = Par_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE ClienteID = Par_ClienteID
					AND ParentescoID = Var_ParentescoOriginal
					AND RelacionadoID = Var_RelacionadoOriginal;

				UPDATE RELACIONCLIEMPLEADO SET
					ClienteID 		= Par_ClienteTutorID,

					EmpresaID       = Par_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE RelacionadoID = Par_ClienteID
					AND ParentescoID = Var_ParentescoMenor;
			ELSE
				CALL FOLIOSAPLICAACT('RELACIONCLIEMPLEADO', Var_RelacionID);

				INSERT INTO RELACIONCLIEMPLEADO
					(RelacionID,		ClienteID,		RelacionadoID,		ParentescoID,		TipoRelacion,
					EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
					Sucursal,			NumTransaccion)
				VALUES
					(Var_RelacionID,	Par_ClienteID,	Par_ClienteTutorID,	Par_ParentescoID, Var_ParentescoTutor,
					Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,
					Sucursal,			NumTransaccion);

				CALL FOLIOSAPLICAACT('RELACIONCLIEMPLEADO', Var_RelacionID);

				INSERT INTO RELACIONCLIEMPLEADO
					(RelacionID,		ClienteID,		RelacionadoID,		ParentescoID,		TipoRelacion,
					EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
					Sucursal,			NumTransaccion)
				VALUES
					(Var_RelacionID,	Par_ClienteTutorID,	Par_ClienteID,	Var_ParentescoMenor, Var_ParentescoTutor,
					Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,
					Sucursal,			NumTransaccion);
			END IF;
		ELSE
			DELETE FROM RELACIONCLIEMPLEADO
				WHERE ClienteID = Par_ClienteID
					AND ParentescoID = Par_ParentescoID;

			DELETE FROM RELACIONCLIEMPLEADO
				WHERE  RelacionadoID = Par_ClienteID
					AND ParentescoID = Var_ParentescoMenor;
		END IF;

		-- Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
		CALL CLIENTESMOD (
			Par_ClienteID,		Par_SucursalOri,		Par_TipoPersona,		Par_Titulo,				Par_PrimerNom,
			Par_SegundoNom,		Par_TercerNom,			Par_ApellidoPat,		Par_ApellidoMat,		Par_FechaNac,
			Par_LugarNac,		Par_EstadoID,			Par_Nacion,				Par_PaisResi,			Par_Sexo,
			Par_CURP,			Par_RFC,				Par_EstadoCivil,		Par_TelefonoCel,		Par_Telefono,
			Par_Correo,			Par_RazonSocial,		Par_TipoSocID,			Par_RFCpm,				Par_GrupoEmp,
			Par_Fax,			Par_OcupacionID,		Par_Puesto,				Par_LugardeTrab,		Par_AntTra,
			Cadena_Vacia,		Par_TelTrabajo,			Par_Clasific,			Par_MotivoApert,		Par_PagaISR,
			Par_PagaIVA,		Par_PagaIDE,			Par_NivelRiesgo,		Par_SecGeneral,			Par_ActBancoMX,
			Par_ActINEGI,		Par_ActFR,				Par_ActFOMUR,			Par_SecEconomic,		Par_PromotorIni,
			Par_PromotorAct,	Par_EsMenorEdad,		Entero_Cero,			Par_RegistroHacienda,	Entero_Cero,
			Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Par_ExtTelefonoPart,
			Entero_Cero,		Par_EjecutivoCap,		Par_PromotorExtInv,		Entero_Cero,			Fecha_Vacia,
			Entero_Cero,		Cadena_Vacia,			Entero_Cero,			Fecha_Vacia,			Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,			Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,
			Par_LugarNac,		SalidaNo,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion );
		-- Fin de modificacion del llamado a CLIENTESMOD. Cardinal Sistemas Inteligentes

		 IF (Par_NumErr !=  Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr 		:= '000';
		SET Par_ErrMen 		:=  CONCAT('safilocale.cliente Menor Modificado Exitosamente: ',CONVERT(Par_ClienteID,CHAR(10)));
		SET Var_Control		:= 'numero';
		SET Var_Consecutivo	:= (SELECT LPAD(Par_ClienteID, 10, 0));

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$