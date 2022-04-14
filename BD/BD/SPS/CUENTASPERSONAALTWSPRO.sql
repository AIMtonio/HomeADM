-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONAALTWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONAALTWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CUENTASPERSONAALTWSPRO`(

/** ***** STORE UTILIZADO PARA EL  WS accountRelated microfinws/cuentaspersona/CuentaRelacionadaControlador***** */
	Par_CuentaAhoID 		BIGINT(12),
	Par_EsApoderado			CHAR(1),
	Par_EsTitular			CHAR(1),
	Par_EsCotitular			CHAR(1),
	Par_EsBeneficiario		CHAR(1),

	Par_EsProvRecurso		CHAR(1),
	Par_EsPropReal			CHAR(1),
	Par_EsFirmante			CHAR(1),
	Par_Titulo 				VARCHAR(10),
	Par_PrimerNom 			VARCHAR(50),

	Par_SegundoNom 			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat			VARCHAR(50),
	Par_ApellidoMat 		VARCHAR(50),
	Par_FechaNac 			DATE,

	Par_PaisNac 			INT(5),
	Par_EdoNac				INT(11),
	Par_EdoCivil 			CHAR(2),
	Par_Sexo 				CHAR(1),
	Par_Nacion 				CHAR(1),

	Par_CURP 				CHAR(18),
	Par_RFC 				CHAR(13),
	Par_OcupacionID 		INT(5),
	Par_FEA					VARCHAR(250),    
    Par_PaisFEA				INT(11),               

	Par_PaisRFC				INT(11),
	Par_PuestoA				VARCHAR(100),
	Par_SectorGral 			INT(3),
	Par_ActBancoMX 			VARCHAR(15),
	Par_ActINEGI 			INT(5),         

	Par_SecEcono			INT(3),      
	Par_TipoIdentiID		INT(11),
	Par_OtraIden 			VARCHAR(20),
	Par_NumIden				VARCHAR(20),
	Par_FecExIden 			DATE,      

	Par_FecVenIden 			DATE,    
	Par_Domicilio 			VARCHAR(200),
	Par_TelCasa 			VARCHAR(20),
	Par_TelCel 				VARCHAR(20),
	Par_Correo 				VARCHAR(50),    

	Par_PaisRes				INT(5),
	Par_DocEstLegal 		VARCHAR(3),
	Par_DocExisLegal		VARCHAR(30),
	Par_FechaVenEst			DATE,        
	Par_NumEscPub 			VARCHAR(50),   

	Par_FechaEscPub 		DATE,
	Par_EstadoID 			INT(11),
	Par_MunicipioID 		INT(11),
	Par_NotariaID 			INT(11),
	Par_TitularNotaria		VARCHAR(100), 

	Par_RazonSocial 		VARCHAR(150),
	Par_Fax 				VARCHAR(30),
	Par_ParentescoID		INT(11),
	Par_Porcentaje 			FLOAT,
	Par_ClienteID			INT(11),    

	Par_ExtTelefonoPart		VARCHAR(6),    
	Par_IngreRealoRecur		DECIMAL(14,2),

    Par_CorreoPM			VARCHAR(50),			-- Correo de Persona Moral
    Par_TelefonoPM        	VARCHAR(20),			-- Telefono fijo del cliente	Persona Moral
    Par_ExtTelefonoPM       VARCHAR(6),				-- Extencion Telefono fijo del cliente	Persona Moral
    Par_DomicilioOfiPM		VARCHAR(200),			-- Domicilio oficial de Persona Moral
    Par_RazonSocialPM		VARCHAR(200),			-- Razon Social de PM                                          

    Par_FechaRegistroPM		DATE,
    Par_PaisConstitucion	INT(5),
    Par_RFCpm               CHAR(12),
	Par_EsAccionista		CHAR(1),
	Par_PorcentajeAcc		DECIMAL(12,4),		

    Par_FeaPM				VARCHAR(250),
    Par_PaisFeaPM			INT(11),		

	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

    /* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control             VARCHAR(200);
	DECLARE	Var_Consecutivo		    INT(11);
	DECLARE Var_CampoGenerico		INT(11);
	DECLARE Var_TipoPersSAFI		VARCHAR(3);

	-- Declaracion de Constantes
	DECLARE	NumPersona			INT;
	DECLARE	Var_NombreCompleto	VARCHAR(200);
	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);

	DECLARE	Fecha				DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Vacio			FLOAT;
	DECLARE	Si					CHAR(1);
	DECLARE	SumaPor				FLOAT;
	DECLARE	Fisica				CHAR(1);
	DECLARE	Moral				CHAR(1);
	DECLARE PaisMexico			INT(11);
	DECLARE Huella_SI			CHAR(1);
	DECLARE Vigente				CHAR(1);
	DECLARE	Cancelado			CHAR(1);
	DECLARE Extranjero			CHAR(1);
	DECLARE Constante_No		CHAR(1);
	DECLARE	EsCliente			VARCHAR(3);
	DECLARE	EsUsServ			VARCHAR(3);
	DECLARE	EsNA				VARCHAR(3);
	DECLARE Cons_Si				CHAR(1);
	DECLARE SumaPorAcc			DECIMAL(12,4);
	DECLARE Mayusculas			CHAR(2);

    DECLARE Num_Actualizar		TINYINT;

	--  Asignacion De Constantes
	SET	Var_NombreCompleto	:= ''; 			-- Nombre Completo de la persona
	SET	Estatus_Activo		:= 'A';			-- Estatus activo
	SET	Cadena_Vacia		:= '';			-- Cadena Vacia
	SET	Fecha				:= '1900-01-01';-- Fecha DEFAULT
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET	Float_Vacio			:= 0;			-- Flotante Cero
	SET	Si					:= 'S';			-- Si =S
	SET	SumaPor				:= 0;			-- suma  porcentaje
	SET SumaPorAcc			:= 0;			-- Suma de porcentaje de acciones

	SET	Fisica				:= 'F';			-- Persona Fisica
	SET	Moral				:= 'M';			-- PErsona Moral
	SET PaisMexico			:= 700;			-- valor en la tabla de paised de Mexico
	SET Par_PrimerNom       := TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
	SET Par_SegundoNom      := TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
	SET Par_TercerNom       := TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
	SET Par_ApellidoPat     := TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
	SET Par_ApellidoMat     := TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));
	SET Huella_SI			:="S";
	SET Vigente				:='V';
	SET Cancelado			:='C';
	SET Extranjero			:= 'E';
	SET Constante_No		:= 'N'; 		-- Constante NO
	SET Var_CampoGenerico	:= 0;
	SET	EsCliente			:= 'CTE';		-- Se trata de un cliente
	SET	EsUsServ			:= 'USU';		-- Se trata de un usuario de servicios
	SET	EsNA				:= 'NA';		-- No se trata ni de un cliente ni de un usuario de servicios
	SET Cons_Si				:= 'S';
	SET Mayusculas			:= 'MA';	   -- Obtener el resultado en Mayusculas
    SET Num_Actualizar		:=	2;			-- opcion de Actualizacion del registro de firmas
    SET Var_Consecutivo		:= 0;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-CUENTASPERSONAALTWSPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;
			
		

			SET Var_Control = Cadena_Vacia;
		
     
			CALL CUENTASPERSONAALT (
				Par_CuentaAhoID, 	Par_EsApoderado,	Par_EsTitular,		Par_EsCotitular, 	Par_EsBeneficiario,
				Par_EsProvRecurso,	Par_EsPropReal,		Par_EsFirmante,		Par_Titulo,			Par_PrimerNom,
				Par_SegundoNom,		Par_TercerNom,		Par_ApellidoPat,	Par_ApellidoMat,	Par_FechaNac,
				Par_PaisNac,		Par_EdoNac,			Par_EdoCivil,		Par_Sexo,			Par_Nacion,	
				Par_CURP,			Par_RFC,			Par_OcupacionID,	Par_Fea,			Par_PaisFea,
				Par_PaisRFC,		Par_PuestoA,		Par_SectorGral,		Par_ActBancoMX,		Par_ActINEGI,
				Par_SecEcono,		Par_TipoIdentiID,	Par_OtraIden,		Par_NumIden,		Par_FecExIden,
				Par_FecVenIden,		Par_Domicilio,		Par_TelCasa,		Par_TelCel,			Par_Correo,
				Par_PaisRes,		Par_DocEstLegal,	Par_DocExisLegal,	Par_FechaVenEst,	Par_NumEscPub,
				Par_FechaEscPub,	Par_EstadoID,		Par_MunicipioID,	Par_NotariaID,		Par_TitularNotaria,
				Par_RazonSocial,	Par_Fax,			Par_ParentescoID,	Par_Porcentaje,		Par_ClienteID,
				Par_ExtTelefonoPart,Par_IngreRealoRecur,Par_CorreoPM,		Par_TelefonoPM,	 	Par_ExtTelefonoPM,
                Par_DomicilioOfiPM,	Par_RazonSocialPM, 	Par_FechaRegistroPM,Par_PaisConstitucion, Par_RFCpm,
                Par_EsAccionista,	Par_PorcentajeAcc,	Par_FeaPM,			Par_PaisFeaPM,		
                
                Par_Salida,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				
			IF( Par_NumErr != Entero_Cero) THEN 
				LEAVE ManejoErrores;
			END IF;

			SELECT PersonaID INTO Var_Consecutivo
				FROM CUENTASPERSONA
					WHERE	NumTransaccion 	= Aud_NumTransaccion  LIMIT 1;
			
			SET Par_NumErr      := 0;
			SET Par_ErrMen      := CONCAT('Persona Relacionada a la Cuenta: ', CONVERT(Par_CuentaAhoID, CHAR), ' Agregada Exitosamente');
			SET Var_Control     := 'CuentaAhoID';


	END ManejoErrores;

	IF (Par_Salida = Si) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$
