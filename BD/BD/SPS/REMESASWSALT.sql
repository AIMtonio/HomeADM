-- REMESASWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESASWSALT`;
DELIMITER $$

CREATE PROCEDURE `REMESASWSALT`(
-- =====================================================================================
-- ------- STORED PARA ALTA DE REMESA POR WS ---------
-- =====================================================================================
	Par_Origen					VARCHAR(10),		-- Indica el origen de la informacion a registrar en el sistema
	Par_UsuarioExt				VARCHAR(45),		-- indica el usuario de cajas de la empresa remesadora.
	Par_RemesaCatalogoID		INT(11),			-- Indica el ID de la remesadora que realiza el pago
	Par_Monto					DECIMAL(14,2),		-- Indica el monto a pagar.
	Par_RemesaFolioID			VARCHAR(45),		-- Indica la referencia de pago.

	Par_ClabeCobroRemesa		VARCHAR(45),		-- Indica la clave de cobro para la remesa
	Par_ClienteID				INT(11),			-- Indica el cliente que recibira el pago de la remesa.
	Par_PrimerNombre			VARCHAR(50), 		-- Primer Nombre
	Par_SegundoNombre			VARCHAR(50), 		-- Segundo Nombre
	Par_TercerNombre			VARCHAR(50), 		-- Tercer Nombre

	Par_ApellidoPaterno			VARCHAR(50), 		-- Apellido Paterno
	Par_ApellidoMaterno			VARCHAR(50), 		-- Apellido Materno
	Par_NombreCompleto			VARCHAR(200),		-- Indica el nombre completo del cliente o usuario
	Par_NombreCompletoRemit		VARCHAR(200),		-- Indica el nombre de la persona que envia el pago.
	Par_FolioIdentificRemit		BIGINT(20),			-- Indica el numero de indentificador del remitente

	Par_TipoIdentiIDRemit		INT(11),			-- Indica el tipo de identificacion utilizada para el envio de la remesa
	Par_GeneroRemitente			CHAR(1),			-- Indica el genero del remitente de la remesa
	Par_Direccion				VARCHAR(500),		-- Indica la direccion del beneficiario
	Par_DirecRemitente			VARCHAR(500),		-- Indica la direccion del remitente
	Par_NumTelefonico			VARCHAR(20),		-- Indica el telefono del beneficiario

	Par_TipoIdentiID			INT(11),			-- Indica el ID del tipo de identificacion
	Par_FolioIdentific			VARCHAR(45),		-- Indica el numero de identificacion
	Par_FormaPago				CHAR(1),			-- Indica la clave para identificar la forma de pago. R: Retiro en efectivo, S: SPEI,  A: Abono a cuenta
	Par_NumeroCuenta			VARCHAR(18),		-- Indica la cuenta CLABE del cliente o usuario.
	Par_CuentaClabeRemesa		VARCHAR(18),		-- Indica la cuenta CLABE de la remesadora

	Par_TipoCuentaSpei			INT(11), 			-- Tipo de Cuenta de Envio para SPEI
	Par_InstitucionID			INT(11), 			-- Institucion de la cuenta externa
	Par_NumParticipanteSPEI		BIGINT(20),			-- Indica el numero que le asigno SPEI a la institucion para operar con SPEI
	Par_CURP					CHAR(18),			-- Indica la clave CURP del cliente o usuario
	Par_CurpRemitente			CHAR(18),			-- Curp del remitente

	Par_RFC						CHAR(13),			-- Indica el RFC del cliente o usuario
	Par_RfcRemitente			CHAR(13),			-- Indica RFC del remitente
	Par_RazonSocial				VARCHAR(150),		-- Indica la Razon social del cliente o usuario
	Par_NomRepresenLegal		VARCHAR(200),		-- Indica el nombre del representante legal de la persona moral
	Par_PaisID					INT(11),			-- Indica el Pais de nacimiento del cliente o usuario este valor debe existir en el catalogo del PAISES del SAFI

    Par_PaisIDRemitente			INT(11),			-- Indica el pais de nacimiento del remitente este valor debe existir en el catalogo del PAISES del SAFI
	Par_EstadoID				INT(11),			-- Indica la entidad federativa del cliente o usuario este valor debe existir en el catalogo de ESTADOS del SAFI
	Par_EstadoIDRemitente		INT(11),			-- Indica la entidad federativoa del remitente
	Par_CiudadIDRemitente		INT(11),			-- Indica la ciudad del remitente
	Par_ColoniaIDRemitente		INT(11),			-- Indica la colonia del remitente

    Par_CodigoPostalRemitente	CHAR(5),			-- Indica el codigo postal del remitente
	Par_Genero					CHAR(1),			-- Indica el genero del cliente o usuario valores validos M (Masculino) F(Femenino)
	Par_FechaNacimiento			DATE,				-- Indica la fecha de nacimiento del cliente o usuario formato valido (aaaa-MM-dd)
	Par_Nacionalidad			CHAR(1),			-- Indica la nacionalidad del cliente o usuario N.- Nacional , E.- Extranjero
	Par_NacionalidadRemitente	CHAR(1),			-- Indica la nacionalidad del remitenteo usuario N.- Nacional , E.- Extranjero

	Par_Email					VARCHAR(50),		-- Indica el correo electronico del cliente o usuario
	Par_Fiel					VARCHAR(50),		-- Indica el FIEL del cliente o usuario
	Par_DirCalle				VARCHAR(500),		-- Indica la calle del detalle de la direccion de la persona fisica o fisica con actividad empresarial
	Par_DirNumero				INT(11),			-- Indica el numero del domicilio de la persona fisica o fisica con activiad empresarial
	Par_DirColoniaID			INT(11),			-- Indicia la colonia del domicilio de la persona fisica o fisica con actividad empresarial

	Par_DirMunicipioID			INT(11),			-- Indica el municipio del domicilio de la persona fisica o fisica con actividad empresarial
	Par_DirCiudadID				INT(11),			-- Indica la ciudad del domicilio de la persona fisica o fisica con actividad empresarial
	Par_DirEstadoID				INT(11),			-- Indica el estado de la persona fisica o fisica con actividad empresarial
	Par_DirCodigoPostal			CHAR(5),			-- Indica el codigo postal de la persona fisica o fisica con actividad empresarial
	Par_DirPaisID				INT(11),			-- Indica el pais de la persona fisica o fisica con actividad empresarial

	Par_DirFiscCalle			VARCHAR(500),		-- Indica la calle del detalle de la direccion de la persona fisica con actividad empresarial o moral
	Par_DirFiscNumero			INT(11),			-- Indica el numero del domicilio de la persona fisica con activiad empresarial o moral
	Par_DirFiscColoniaID		INT(11),			-- Indicia la colonia del domicilio de la persona fisica con actividad empresarial o moral
	Par_DirFiscMunicipioID		INT(11),			-- Indica el municipio del domicilio de la persona fisica con actividad empresarial o moral
	Par_DirFiscCiudadID			INT(11),		-- Indica la ciudad del domicilio de la persona fisica con actividad empresarial o moral

	Par_DirFiscEstadoID			INT(11),			-- Indica el estado de la persona fisica con actividad empresarial o moral
	Par_DirFiscCodigoPostal		CHAR(5),			-- Indica el codigo postal de la persona fisica con actividad empresarial o moral
	Par_DirFiscPaisID			INT(11),			-- Indica el pais de la persona fisica con actividad empresarial o moral
	Par_GiroMercantil			VARCHAR(200),		-- Indica el giro mercantil solo aplica para personas morales
	Par_Actividad				VARCHAR(200),		-- Indica la actividad u objeto social para persona moral.

	Par_IdentificacionFiscal	VARCHAR(30),		-- Indica la identificacion fiscal o equivalente para persona moral
	Par_IdentiFiscalPaisID		INT(11),			-- Indica el Pais que asigno la identificacion fiscal para personas morales codigo del pais del catalogo de SAFI
	Par_FechaConstitucion		DATE,				-- Indica la fecha de constitucion de la persona moral formato valido (aaaa-MM-dd)
	Par_NombreRepresenLegal		VARCHAR(50),		-- Indica el nombre del representante legal para persona moral
	Par_RepLegPaisID			INT(11),			-- Indica el pais del representante legal para persona moral codigo del pais del catalogo de SAFI

	Par_RepLegFechaNacimiento	DATE,				-- Indica la fecha de nacimiento del representante legal de la personas moral formato valido (aaaa-MM-dd)
	Par_RepLegNacionalidad		CHAR(1),			-- Indica la nacionalidad del representante legal N.- Nacional , E .- Extranjero
	Par_RepLegDirCalle			VARCHAR(500),		-- Indica la calle del domicilio del representante legal
	Par_RepLegDirNumero			INT(11),			-- Indica el numero del domicilio del representant legal
	Par_RepLegDirColoniaID		INT(11),			-- Indica la colonia del domicilio del representante legal codigo de la colonia del catalogo de SAFI

	Par_RepLegDirMunicipioID	INT(11),			-- Indica el municipio del domicilio del representante legal codigo del municipio del catalogo de SAFI
	Par_RepLegDirCiudadID		INT(11),			-- Indica la ciudad del domicilio del representante legal
	Par_RepLegDirEstadoID		INT(11),			-- Indica el estado del domicilio del representante legal codigo del estado del catalogo de SAFI
	Par_RepLegDirCodigoPostal	CHAR(5),			-- Indica el codigo postal del domicilio del representante legal
	Par_RepLegDirPaisID			INT(11),			-- Indica el pais del domicilio del representante legal codigo del pais del catalogo de SAFI

	Par_RepLegCURP				CHAR(18),			-- Indica la CURP del representante legal de la persona moral
	Par_RepLegRFC				CHAR(13),			-- Indica el RFC del representante legal de la persona moral
	Par_RepLegTipoIdendificacionID INT(11),			-- Indica el identificador del tipo de identificacion del represetante legal de la persona moral
	Par_RepLegIdentificacionID	INT(11),			-- Indica el numero de identificacion del representante legal de la persona moral
	Par_RutaIdentOficial		VARCHAR(1000),		-- Indica la ruta o el archivo digitalizado de al identificacion oficial.

	Par_CedulaIdentiFiscal		VARCHAR(1000),		-- Indica la cedula de la identificacion fiscal de la razon social solo para personas morales
	Par_TipoPersona				CHAR(1),			-- Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el cliente o usuario
	Par_TipoPersonaRemitente	CHAR(1),			-- Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el remitente
	Par_NivelRiesgo				CHAR(1),			-- India el nivel de riego para la operacion ya sea para personas fisica, fisica con actividad empresarial o moral
	Par_CheckIdentiOficialID	INT(11),			-- Indica el identificador del tipo de documento para la identificacion oficial en el check list

	Par_CheckDocIdentOficial	VARCHAR(1000),		-- Indica el documento que representa a la identificacion oficial para el check list
	Par_CheckCompDomID			INT(11),			-- Indica el identificador del tipo de documento para el comprobante de domicilio en el check list
	Par_CheckDocCompDom			VARCHAR(1000),		-- Indica el documento que representa el comprobante de domicilio
	Par_CheckCurpID				INT(11),			-- Indica el identificador del tipo de documento para la curp en el ckeck list
	Par_CheckDocCurp			VARCHAR(1000),		-- Indica el documento que representa la CURP

	Par_CheckRfcID				INT(11),			-- Indica el identificador del tipo de documento para el rfc en el check list
	Par_CheckDocRfc				VARCHAR(1000),		-- Indica el documento que representa el RFC
	Par_CheckFielID				INT(11),			-- Indica el identificador del tipo de documento que representa el  FIEL en el check list
	Par_CheckDocFiel			VARCHAR(1000),		-- Indicia el documento que representa el FIEL
	Par_CheckActaConstiID		INT(11),			-- Indica el identificador del tipo de documento para la acta constitutiva

	Par_CheckDocActaConsti		VARCHAR(1000),		-- Indica el documento que representa el acta constitutiva
	Par_CheckPodRepreLegalID	INT(11),			-- Indicia el identificador para el poder del representante legal
	Par_CheckDocPodRepreLegal	VARCHAR(1000),		-- Indica el documento que representa el poder del representante legal
	Par_CheckRegPubliPropID		INT(11),			-- Indicia el identificador del tipo de documento para el registro publico de la propiedad
	Par_CheckDocRegPubliProp	VARCHAR(1000),		-- Indica el documento que representa el registor publico de la propiedad

	Par_CheckCedulaIdenFiscalID	INT(11),			-- Indica el identificaodor del tipo de documento para la cedula de la identificacion fiscal de la razon social
	Par_CheckDocCedulaIdenFiscal VARCHAR(1000),		-- Indicia el documento que representa la cedula de la identificacion fiscal de la razon social
	Par_CheckSerieFirmaElecID	INT(11),			-- Indica el identificador del tipo de documento para el numero de serie de la firma electronica
	Par_CheckDocSerieFirmaElec	VARCHAR(1000),		-- Indica el documento que representa el numero de serie de la firma electronica
	Par_CheckDeclaracionPersoID	INT(11),			-- Indica el identificador del tipo de documento para la declaracion personal

	Par_CheckDocDeclaracionPerso VARCHAR(1000),		-- Indica el documento que representa la declaracion personal
	Par_CheckCuestionAdicDeclaID INT(11),			-- Indica el identificador del tipo de documento para el cuestionario adicional del usuario y/o declaratoria de origen y destino
	Par_CheckDocCuestionAdicDecla VARCHAR(1000),	-- Indica el documento que representa el cuestionario adicional del usuario y/o declaratoria de origen y destino
	Par_CheckFormatVisitID		INT(11),			-- Indica el identificador del tipo de documento del formato de visita.
	Par_CheckDocFormatVisit		VARCHAR(1000),		-- Indicia el documento que representa el formato de visita

	Par_CheckDeclaraImpuestoID	INT(11),			-- Indica el identificador del tipo de documento para la declaracon de impuestos
	Par_CheckDocDeclaraImpuesto	VARCHAR(1000),		-- Indica el documento que representa la declaracion de impuestos
	Par_CheckEstadoFinanID		INT(11),			-- Indica el identificador del tipo de documento para el estado financiero
	Par_CheckDocEstadoFinan		VARCHAR(1000),		-- Indica el documento que representa el estado financiero
    INOUT Par_RemesaWSID		BIGINT(20),			-- ID Consecutivo de la remesa

    Par_Salida    				CHAR(1),			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 			INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  			VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       		INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         		INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     		DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     		VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      		VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        		INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema
    DECLARE Var_DetDirecRemesaWSID BIGINT(20);		-- ID Consecutivo de la direccion

    DECLARE Var_DetDirecFiscalRemWSID BIGINT(20);	-- ID Consecutivo de la direccion fiscal
    DECLARE Var_RepLegalRemWSID BIGINT(20);			-- ID Consecutivo del representante legal
    DECLARE Var_DirecRepLegRemWSID BIGINT(20);		-- ID Consecutivo de la direccion del representante legal
    DECLARE Var_CheckListRemWSID BIGINT(20);		-- ID Del check list
    DECLARE Var_TipoBeneficiario CHAR(1);     		-- Tipo de Beneficiario cliente = C, usuario de servicios = U

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
	DECLARE DescDocumento		VARCHAR(200);		-- Descripcion del Documento a Adjuntar

	DECLARE Est_Nuevo       	CHAR(1); 			-- Constante  N, valor no
	DECLARE Es_Cliente    		CHAR(1); 			-- Es cliente
	DECLARE Es_UsuarioSerivio	CHAR(1); 			-- Es usuario de servicios

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
	SET DescDocumento			:= 'DOCUMENTO DEL CHEK LIST ENVIADO POR WS';

	SET Est_Nuevo          		:= 'N';
	SET Es_Cliente         		:= 'C';
	SET Es_UsuarioSerivio      	:= 'U';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-REMESASWSALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;
		SET Aud_FechaActual := NOW();

        -- IDENTIFICAMOS SI ES CLIENTE O USUARIO DE SERVICIOS EL BENEFICIARIO
        IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SET Var_TipoBeneficiario := Es_Cliente;
		ELSE
			SET Var_TipoBeneficiario := Es_UsuarioSerivio;
        END IF;

		-- DATOS REMESA
		SET Par_RemesaWSID := (SELECT IFNULL(MAX(RemesaWSID),Entero_Cero) + Entero_Uno FROM REMESASWS);
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		INSERT INTO REMESASWS(
			RemesaWSID, 				Origen, 					UsuarioExt, 			RemesaCatalogoID, 			Monto,
            RemesaFolioID, 				ClabeCobroRemesa, 			ClienteID, 				PrimerNombre,				SegundoNombre,
			TercerNombre,				ApellidoPaterno,			ApellidoMaterno,		NombreCompleto, 			NombreCompletoRemit,
            FolioIdentificRemit, 		TipoIdentiIDRemit, 			GeneroRemitente, 		Direccion,	 				DirecRemitente,
            NumTelefonico, 				TipoIdentiID,				FolioIdentific, 		FormaPago, 					NumeroCuenta,
            CuentaClabeRemesa, 			TipoCuentaSpei,				InstitucionID,			NumParticipanteSPEI,		CURP,
            CurpRemitente, 				RFC,			            RfcRemitente, 			RazonSocial, 				NomRepresenLegal,
            PaisID, 					PaisIDRemitente,            EstadoID, 				EstadoIDRemitente,			CiudadIDRemitente,
            ColoniaIDRemitente, 		CodigoPostalRemitente,      Genero, 				FechaNacimiento, 			Nacionalidad,
            NacionalidadRemitente, 		Email,			            Fiel, 					GiroMercantil, 				Actividad,
            IdentificacionFiscal, 		IdentiFiscalPaisID,         FechaConstitucion, 		RutaIdentOficial, 			CedulaIdentiFiscal,
            TipoPersona, 				TipoPersonaRemitente,       NivelRiesgo, 			PermiteOperacion, 			Comentarios,
            Estatus,					MotivoRevision,				EstatusActualiza,		NumActualizacion,			UsuarioServicioID,
            TipoBeneficiario,			EsNuevo,					SpeiSolDesID,			FechaRegistro,
            EmpresaID,		 			Usuario, 					FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Par_RemesaWSID,				Par_Origen, 				Par_UsuarioExt, 		Par_RemesaCatalogoID, 		Par_Monto,
            Par_RemesaFolioID, 			Par_ClabeCobroRemesa,	 	Par_ClienteID, 			Par_PrimerNombre,			Par_SegundoNombre,
			Par_TercerNombre,			Par_ApellidoPaterno,		Par_ApellidoMaterno,    Par_NombreCompleto, 		Par_NombreCompletoRemit,
            Par_FolioIdentificRemit, 	Par_TipoIdentiIDRemit, 		Par_GeneroRemitente, 	Par_Direccion, 				Par_DirecRemitente,
            Par_NumTelefonico, 			Par_TipoIdentiID, 			Par_FolioIdentific, 	Par_FormaPago, 				Par_NumeroCuenta,
            Par_CuentaClabeRemesa, 		Par_TipoCuentaSpei,			Par_InstitucionID,		Par_NumParticipanteSPEI,	Par_CURP,
            Par_CurpRemitente, 			Par_RFC,            		Par_RfcRemitente, 		Par_RazonSocial, 			Par_NomRepresenLegal,
            Par_PaisID, 				Par_PaisIDRemitente,        Par_EstadoID, 			Par_EstadoIDRemitente, 		Par_CiudadIDRemitente,
            Par_ColoniaIDRemitente, 	Par_CodigoPostalRemitente,  Par_Genero,				Par_FechaNacimiento, 		Par_Nacionalidad,
            Par_NacionalidadRemitente, 	Par_Email,            		Par_Fiel,        		Par_GiroMercantil, 			Par_Actividad,
            Par_IdentificacionFiscal, 	Par_IdentiFiscalPaisID,		Par_FechaConstitucion, 	Par_RutaIdentOficial,		Par_CedulaIdentiFiscal,
            Par_TipoPersona, 			Par_TipoPersonaRemitente,   Par_NivelRiesgo,        Cadena_Vacia,				Cadena_Vacia,
            Est_Nuevo,					Cadena_Vacia,				Cadena_Vacia,			Entero_Cero,				Entero_Cero,
            Var_TipoBeneficiario,		Cadena_Vacia,				Entero_Cero,			Var_FechaSistema,
            Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
		);

		-- DATOS DIRECCION
		SET Var_DetDirecRemesaWSID := (SELECT IFNULL(MAX(DetDirecRemesaWSID),Entero_Cero) + Entero_Uno FROM DETALLEDIRECREMESAWS);

		INSERT INTO DETALLEDIRECREMESAWS(
			DetDirecRemesaWSID, 		RemesaWSID, 			Calle, 					Numero,						ColoniaID,
            MunicipioID, 				CiudadID, 				EstadoID, 				CodigoPostal, 				PaisID,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 					NumTransaccion
        )VALUES(
			Var_DetDirecRemesaWSID,		Par_RemesaWSID,			Par_DirCalle,			Par_DirNumero,				Par_DirColoniaID,
			Par_DirMunicipioID,			Par_DirCiudadID,		Par_DirEstadoID,		Par_DirCodigoPostal,		Par_DirPaisID,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- DATOS DIRECCION FISCAL
        SET Var_DetDirecFiscalRemWSID := (SELECT IFNULL(MAX(DetDirecFiscalRemWSID),Entero_Cero) + Entero_Uno FROM DETDIRECFISCALREMESASWS);
		SET Par_DirFiscCiudadID := IF((Par_DirFiscCiudadID IS NULL OR Par_DirFiscCiudadID = Cadena_Vacia), '0', Par_DirFiscCiudadID);

        INSERT INTO DETDIRECFISCALREMESASWS(
			DetDirecFiscalRemWSID, 		RemesaWSID, 			Calle,					Numero, 					ColoniaID,
            MunicipioID, 				CiudadID, 				EstadoID, 				CodigoPostal, 				PaisID,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 					NumTransaccion
        )VALUES(
			Var_DetDirecFiscalRemWSID,	Par_RemesaWSID, 		Par_DirFiscCalle,		Par_DirFiscNumero,		Par_DirFiscColoniaID,
			Par_DirFiscMunicipioID,		Par_DirFiscCiudadID,	Par_DirFiscEstadoID,	Par_DirFiscCodigoPostal,	Par_DirFiscPaisID,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- DETALLES DIRECCION REPRESENTANTE LEGAL
        SET Var_DirecRepLegRemWSID := (SELECT IFNULL(MAX(DirecRepLegRemWSID),Entero_Cero) + Entero_Uno FROM DIRREPLEGALREMESAPMWS);

        INSERT INTO DIRREPLEGALREMESAPMWS(
			DirecRepLegRemWSID, 		RemesaWSID, 			Calle, 					Numero, 					ColoniaID,
            MunicipioID, 				CiudadID, 				EstadoID, 				CodigoPostal, 				PaisID,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 					NumTransaccion
        )VALUES(
			Var_DirecRepLegRemWSID,		Par_RemesaWSID,			Par_RepLegDirCalle,		Par_RepLegDirNumero,		Par_RepLegDirColoniaID,
			Par_RepLegDirMunicipioID,	Par_RepLegDirCiudadID,	Par_RepLegDirEstadoID,	Par_RepLegDirCodigoPostal,	Par_RepLegDirPaisID,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- DETALLES REPRESENTANTE LEGAL
        SET Var_RepLegalRemWSID := (SELECT IFNULL(MAX(RepLegalRemWSID),Entero_Cero) + Entero_Uno FROM REPLEGALREMESASPMWS);

		INSERT INTO REPLEGALREMESASPMWS(
			RepLegalRemWSID, 			RemesaWSID, 			NombreRepresenLegal, 	PaisID, 					FechaNacimiento,
            Nacionalidad, 				DirecRepLegRemWSID, 	CURP, 					RFC, 						TipoIdendificacionID,
			IdentificacionID,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_RepLegalRemWSID,		Par_RemesaWSID,			Par_NombreRepresenLegal,Par_RepLegPaisID,			Par_RepLegFechaNacimiento,
			Par_RepLegNacionalidad,		Var_DirecRepLegRemWSID,	Par_RepLegCURP,			Par_RepLegRFC,				Par_RepLegTipoIdendificacionID,
			Par_RepLegIdentificacionID,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- CHECK LIST
        -- IDENTIFICACION OFICIAL
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckIdentiOficialID, Par_CheckDocIdentOficial,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- COMPROBANTE DE DOMICILIO
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCompDomID,		Par_CheckDocCompDom,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- CURP
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCurpID,		Par_CheckDocCurp,		DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- RFC
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckRfcID,			Par_CheckDocRfc,		DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- FIEL
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckFielID,		Par_CheckDocFiel,		DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        --  ACTA CONSTITUTIVA
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckActaConstiID,	Par_CheckDocActaConsti,		DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        --  PODER DEL REPRESENTANTE LEGAL
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckPodRepreLegalID,	Par_CheckDocPodRepreLegal,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- REGISTRO PUBLICO DE LA PROPIEDAD
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckRegPubliPropID,	Par_CheckDocRegPubliProp,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- CEDULA DE IDENTIFICACION FISCAL
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCedulaIdenFiscalID,	Par_CheckDocCedulaIdenFiscal,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- NUMERO DE SERIE PARA FIRMA ELECTRONICA
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckSerieFirmaElecID,	Par_CheckDocSerieFirmaElec,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- DECLARACION PERSONAL
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckDeclaracionPersoID,	Par_CheckDocDeclaracionPerso,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- CUESTIONARIO ADICIONAL DEL USUARIO Y/O DECLARATORIA DE ORIGEN Y DESTENIO
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCuestionAdicDeclaID,	Par_CheckDocCuestionAdicDecla,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- FORMATO DE VISITA
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckFormatVisitID,	Par_CheckDocFormatVisit,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- DECLARACION DE IMPUESTOS
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckDeclaraImpuestoID,	Par_CheckDocDeclaraImpuesto,DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

        -- ESTADO FINANCIERO
        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
        INSERT INTO CHECKLISTREMESASWS(
			CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
		)VALUES(
			Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckEstadoFinanID,	Par_CheckDocEstadoFinan,	DescDocumento,
            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Remesa Agregada Exitosamente: ',CAST(Par_RemesaWSID AS CHAR) );
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Par_RemesaWSID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
