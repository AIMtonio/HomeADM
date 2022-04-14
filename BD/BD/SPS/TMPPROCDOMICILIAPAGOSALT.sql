-- SP TMPPROCDOMICILIAPAGOSALT

DELIMITER ;

DROP PROCEDURE IF EXISTS TMPPROCDOMICILIAPAGOSALT;

DELIMITER $$

CREATE PROCEDURE `TMPPROCDOMICILIAPAGOSALT`(
# ========================================================================
# ---- STORE PARA EL REGISTRO DE DOMICILIACION DE PAGOS PARA PROCESAR ----
# ========================================================================
	Par_FolioID				BIGINT(20),			-- Numero de Folio
	Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe
    Par_CreditoID			BIGINT(12),			-- ID Credito
    Par_Monto				DECIMAL(14,2),		-- Monto de Cobro
    Par_MontoPendiente		DECIMAL(14,2),		-- Monto Pendiente

    Par_ClaveDomicilia		CHAR(2),			-- Clave de Domiciliacion

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP 
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa 
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     	VARCHAR(100);	-- Almacena el control de errores
    DECLARE	Var_ConsecutivoID	BIGINT(20);		-- ID Consecutivo
    DECLARE Var_CuentaClabe		VARCHAR(18);	-- Numero de Cuenta Clabe
    DECLARE Var_ClienteID       INT(11);		-- Numero del Cliente
	DECLARE Var_InstitucionID   INT(11);		-- Numero de la Institucion

    DECLARE Var_CreditoID		BIGINT(12);		-- ID Credito
    DECLARE Var_FolioInst		CHAR(3);		-- Folio de la Institucion Bancaria
    DECLARE Var_PrimerNom		VARCHAR(50);
    DECLARE Var_SegundoNom		VARCHAR(50);
    DECLARE Var_TercerNom		VARCHAR(50);
    DECLARE Var_ApellidoPat		VARCHAR(50);
    DECLARE Var_ApellidoMat		VARCHAR(50);
    DECLARE Var_TipoPersona		CHAR(1);
    DECLARE Var_RazonSocial		VARCHAR(150);
    DECLARE Var_RFC 			VARCHAR(13);
    DECLARE Var_RFCpm			VARCHAR(13);
    DECLARE Var_FechaNac		DATE;
    DECLARE Var_LugarNac 		INT(11);
    DECLARE Var_EstadoID		INT(11);
    DECLARE Var_NombreComplet	VARCHAR(500);
    DECLARE DescripOpera		VARCHAR(52);
	DECLARE CatMotivInusualID	VARCHAR(15);
	DECLARE CatProcIntID		VARCHAR(10);
	DECLARE RegistraSAFI		CHAR(4);
	DECLARE ClaveRegistra		CHAR(2);
	DECLARE Var_FechaDeteccion	DATE;
	DECLARE Var_OpeInusualID	BIGINT(20);
	DECLARE Con_LPB				CHAR(3);
	DECLARE Var_SoloApellido	VARCHAR(150);
	DECLARE Var_SoloNombre		VARCHAR(150);
	DECLARE Var_OpeInusualIDSPL	BIGINT(20);
	DECLARE Var_ErrMen			VARCHAR(400);
	DECLARE Var_RFCOficial		VARCHAR(13);
	DECLARE Var_PaisID			INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
    DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;	
	DECLARE	SalidaSI        CHAR(1);

    DECLARE	SalidaNO        CHAR(1);
    DECLARE ConstanteSI		CHAR(1);
	DECLARE ClaveExitosa	CHAR(2);
	DECLARE ConstanteNO 	CHAR(1);
	DECLARE EsCTE 			CHAR(3);
	DECLARE Per_Moral		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia 
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No
    SET ConstanteSI			:= 'S';				-- Constante: SI
	SET ClaveExitosa		:= '00';			-- Clave Exitosa
	SET ConstanteNO 		:= 'N';
	SET EsCTE 				:= 'CTE';
	SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas
	SET Per_Moral				:= 'M';


    ManejoErrores: BEGIN
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 

		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-TMPPROCDOMICILIAPAGOSALT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

        -- Se valida si existe la Cuenta Clabe de Domiciliacion
        SET Var_CuentaClabe 	:= (SELECT ClabeCtaDomici FROM SOLICITUDCREDITO WHERE ClabeCtaDomici = Par_CuentaClabe LIMIT 1);
		SET Var_CuentaClabe 	:= IFNULL(Var_CuentaClabe,Cadena_Vacia);

        IF(Var_CuentaClabe = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= CONCAT("La Cuenta Clabe No Existe ",Var_CuentaClabe,".");
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;
		
        -- Se valida que exista el Credito
        SET Var_CreditoID	:= (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET Var_CreditoID 	:= IFNULL(Var_CreditoID,Entero_Cero);

		IF(Var_CreditoID 	= Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= CONCAT("El Credito No Existe ",Var_CreditoID,".");
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        -- Se obtiene el Numero del Folio de la Institucion Bancaria a partir de la Cuenta Clabe
        SET Var_FolioInst :=(SELECT SUBSTRING(Par_CuentaClabe,1,3));

        -- Se obtiene el Numero de la Institucion Bancaria a partir del Folio
        SET Var_InstitucionID   := (SELECT InstitucionID FROM INSTITUCIONES WHERE Folio = Var_FolioInst);
		SET Var_InstitucionID 	:= IFNULL(Var_InstitucionID,Entero_Cero);  

        IF(Var_InstitucionID = Entero_Cero) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= CONCAT("El Numero de la Institucion Bancaria No Existe ",Var_InstitucionID,".");
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        -- Se obtiene el Numero del Cliente a partir del Numero de Credito
        SET Var_ClienteID 	:=(SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
        SET Var_ClienteID 	:= IFNULL(Var_ClienteID,Entero_Cero);

		-- Se valida si el codigo es diferente a Exitoso
        IF(Par_ClaveDomicilia != ClaveExitosa)THEN
			SET Par_MontoPendiente  := Par_Monto;
        END IF;

        IF Var_ClienteID != Entero_Cero THEN
        	SELECT 	PrimerNombre,	SegundoNombre,	TercerNombre,	ApellidoPaterno,	ApellidoMaterno,
        			TipoPersona,	RazonSocial, 	RFCOficial, 	RFCpm,				FechaNacimiento,
        			LugarNacimiento,EstadoID,		NombreCompleto
        	INTO 	Var_PrimerNom,	Var_SegundoNom,	Var_TercerNom,	Var_ApellidoPat,	Var_ApellidoMat,
        			Var_TipoPersona,Var_RazonSocial,Var_RFC,		Var_RFCpm,			Var_FechaNac,
        			Var_LugarNac,	Var_EstadoID,	Var_NombreComplet
        	FROM CLIENTES
        	WHERE ClienteID = Var_ClienteID;
       
    	/*SECCION PLD: Deteccion de operaciones inusuales*/
			CALL PLDDETECCIONPRO(
				Var_ClienteID,			Var_PrimerNom,			Var_SegundoNom,			Var_TercerNom,			Var_ApellidoPat,
				Var_ApellidoMat,		Var_TipoPersona,		Var_RazonSocial,		Var_RFC,				Var_RFCpm,
				Var_FechaNac,			Entero_Cero,			Var_LugarNac,			Var_EstadoID,			Var_NombreComplet,
				EsCTE,					ConstanteNO,			ConstanteSI,			ConstanteNO,				SalidaNO,
				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
		  

			IF(Par_NumErr!=Entero_Cero)THEN

				SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreComplet
											AND TipoPersonaSAFI = EsCTE
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Var_ClienteID LIMIT 1);

				IF (Var_TipoPersona = Per_Moral) THEN
					SET Var_NombreComplet	:= FNLIMPIACARACTERESGEN(TRIM(Var_RazonSocial),'M');
					SET Var_NombreComplet	:= IFNULL(Var_NombreComplet,Cadena_Vacia);
					SET Var_RFCOficial := Var_RFCpm;
					SET Var_FechaNac := Fecha_Vacia;
					SET Var_PaisID := 700;
					SET Var_SoloNombre := Cadena_Vacia;
					SET Var_SoloApellido := Cadena_Vacia;
				ELSE
					SET Var_RFCOficial := Var_RFC;
					SET Var_FechaNac := Var_FechaNac;
					SET Var_PaisID := Var_LugarNac;
					SET Var_SoloNombre			:=  FNGENNOMBRECOMPLETO(Var_PrimerNom, Var_SegundoNom,Var_TercerNom,Cadena_Vacia,Cadena_Vacia);
					SET Var_SoloApellido		:=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Var_ApellidoPat,Var_ApellidoMat);
				END IF;

				SET Var_ErrMen := Par_ErrMen;
				IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

					SELECT OpeInusualID INTO Var_OpeInusualIDSPL
					FROM PLDSEGPERSONALISTAS
					WHERE OpeInusualID = Var_OpeInusualID;

					IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN

						-- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
						CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	EsCTE,				Var_ClienteID,			Var_NombreComplet,		Var_FechaDeteccion,
													Con_LPB,			Var_SoloNombre,		Var_SoloApellido,		Var_FechaNac,			Var_RFCOficial,
													Var_PaisID,			SalidaNO,			Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
													Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,
													Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				SET Par_NumErr			:= 50; -- NO CAMBIAR ESTE NUMERO DE ERROR
				SET Par_ErrMen			:= 'Se encontraron coincidencias con la Listas de Personas Bloqueadas, revisar con &aacute;rea de cumplimiento';
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
		 END IF; 

        -- Se obtiene el valor consecutivo para el registro en la tabla TMPPROCDOMICILIAPAGOS
		SET Var_ConsecutivoID := (SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 FROM TMPPROCDOMICILIAPAGOS);

        -- Se obtiene la Fecha Actual
        SET Aud_FechaActual := NOW();

        -- Se registra la informacion en la tabla TMPPROCDOMICILIAPAGOS
		INSERT INTO TMPPROCDOMICILIAPAGOS(
			ConsecutivoID, 			FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
            CreditoID,				MontoTotal,				MontoPendiente,			ClaveDomicilia,			EmpresaID,
            Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
            NumTransaccion)
		VALUES( 		
			Var_ConsecutivoID, 		Par_FolioID,			Var_ClienteID,			Var_InstitucionID,		Par_CuentaClabe,
            Par_CreditoID,			Par_Monto,				Par_MontoPendiente,		Par_ClaveDomicilia,		Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
            Aud_NumTransaccion);

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Domiciliacion de Pagos Agregada Exitosamente.';
		SET Var_Control	:= 'procesar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$