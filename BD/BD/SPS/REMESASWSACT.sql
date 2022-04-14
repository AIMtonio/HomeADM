-- REMESASWSACT

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMESASWSACT`;

DELIMITER $$

CREATE PROCEDURE `REMESASWSACT`(
-- =====================================================================================
-- ------------------- STORED PARA LA ACTUALIZACION DE REMESA POR WS -------------------
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
	Par_DirFiscCiudadID			INT(11),			-- Indica la ciudad del domicilio de la persona fisica con actividad empresarial o moral

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
    Par_RemesaWSID				BIGINT(20),			-- ID Consecutivo de la remesa

    Par_SpeiSolDesID            INT(11),            -- ID de la de solicitud remesa.
	Par_Estatus					CHAR(1),			-- Estatus a la que se actualizara la remesa.
    Par_NumAct          		TINYINT UNSIGNED,	-- Numero de Actualizacion

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
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable Consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de Sistema
    DECLARE Var_CheckListRemWSID BIGINT(20);		-- ID Del Check List

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
	DECLARE Est_Actualizada     CHAR(1); 			-- Estatus: Actualizada

	DECLARE Est_Nuevo       	CHAR(1); 			-- Estatus: Nuevo
	DECLARE DescDocumento		VARCHAR(200);		-- Descripcion del Documento a Adjuntar
	DECLARE Act_RemesaRech		INT(11);			-- Tipo de Actualizacion: Actualiza Datos Remesa Rechazada
	DECLARE Act_SpeiSolRemesa   INT(11);            -- Actualización del ID de la de solicitud remesa.
	DECLARE Act_EstatusRemesa	INT(11);			-- Actualización estatus de la remesa.

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
	SET Est_Actualizada         := 'A';

	SET Est_Nuevo          		:= 'N';
	SET DescDocumento			:= 'DOCUMENTO DEL CHEK LIST ENVIADO POR WS';
	SET Act_RemesaRech			:= 1;
	SET Act_SpeiSolRemesa   	:= 2;
	SET Act_EstatusRemesa		:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-REMESASWSACT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual := NOW();

		-- 1.- Tipo de Actualizacion: Actualiza Datos Remesa Rechazada
		IF(Par_NumAct = Act_RemesaRech)THEN
			-- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA REMESASWS
			UPDATE REMESASWS
			SET Origen 					= Par_Origen,
				UsuarioExt 				= Par_UsuarioExt,
				RemesaCatalogoID 		= Par_RemesaCatalogoID,
				Monto 					= Par_Monto,
            	RemesaFolioID 			= Par_RemesaFolioID,
            	ClabeCobroRemesa 		= Par_ClabeCobroRemesa,
            	ClienteID 				= Par_ClienteID,
                PrimerNombre			= Par_PrimerNombre,
                SegundoNombre			= Par_SegundoNombre,
                TercerNombre			= Par_TercerNombre,

                ApellidoPaterno			= Par_ApellidoPaterno,
                ApellidoMaterno			= Par_ApellidoMaterno,
            	NombreCompleto 			= Par_NombreCompleto,
            	NombreCompletoRemit 	= Par_NombreCompletoRemit,
            	FolioIdentificRemit 	= Par_FolioIdentificRemit,
            	TipoIdentiIDRemit 		= Par_TipoIdentiIDRemit,
            	GeneroRemitente 		= Par_GeneroRemitente,
            	Direccion 				= Par_Direccion,
            	DirecRemitente 			= Par_DirecRemitente,
            	NumTelefonico 			= Par_NumTelefonico,

            	TipoIdentiID 			= Par_TipoIdentiID,
            	FolioIdentific 			= Par_FolioIdentific,
            	FormaPago 				= Par_FormaPago,
            	NumeroCuenta 			= Par_NumeroCuenta,
            	CuentaClabeRemesa 		= Par_CuentaClabeRemesa,
                TipoCuentaSpei			= Par_TipoCuentaSpei,
				InstitucionID			= Par_InstitucionID,
            	NumParticipanteSPEI 	= Par_NumParticipanteSPEI,
            	CURP 					= Par_CURP,
            	CurpRemitente 			= Par_CurpRemitente,

                RFC 					= Par_RFC,
            	RfcRemitente 			= Par_RfcRemitente,
            	RazonSocial 			= Par_RazonSocial,
            	NomRepresenLegal 		= Par_NomRepresenLegal,
            	PaisID 					= Par_PaisID,
            	PaisIDRemitente 		= Par_PaisIDRemitente,
            	EstadoID 				= Par_EstadoID,
            	EstadoIDRemitente 		= Par_EstadoIDRemitente,
            	CiudadIDRemitente 		= Par_CiudadIDRemitente,
            	ColoniaIDRemitente 		= Par_ColoniaIDRemitente,

                CodigoPostalRemitente 	= Par_CodigoPostalRemitente,
            	Genero 					= Par_Genero,
            	FechaNacimiento 		= Par_FechaNacimiento,
            	Nacionalidad 			= Par_Nacionalidad,
            	NacionalidadRemitente 	= Par_NacionalidadRemitente,
            	Email 					= Par_Email,
            	Fiel 					= Par_Fiel,
            	GiroMercantil 			= Par_GiroMercantil,
            	Actividad 				= Par_Actividad,
            	IdentificacionFiscal	= Par_IdentificacionFiscal,

                IdentiFiscalPaisID 		= Par_IdentiFiscalPaisID,
            	FechaConstitucion 		= Par_FechaConstitucion,
            	RutaIdentOficial 		= Par_RutaIdentOficial,
            	CedulaIdentiFiscal 		= Par_CedulaIdentiFiscal,
            	TipoPersona 			= Par_TipoPersona,
            	TipoPersonaRemitente 	= Par_TipoPersonaRemitente,
            	NivelRiesgo 			= Par_NivelRiesgo,
            	PermiteOperacion		= PermiteOperacion,
            	Comentarios 			= Comentarios,
            	Estatus 				= Est_Nuevo,

                EstatusActualiza		= Est_Actualizada,
            	NumActualizacion		= IFNULL(NumActualizacion,Entero_Cero) + Entero_Uno,

            	EmpresaID 				= Par_EmpresaID,
            	Usuario 				= Aud_Usuario,
            	FechaActual 			= Aud_FechaActual,
            	DireccionIP 			= Aud_DireccionIP,
            	ProgramaID 				= Aud_ProgramaID,
            	Sucursal 				= Aud_Sucursal,
            	NumTransaccion 			= Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA DETALLEDIRECREMESAWS
            UPDATE DETALLEDIRECREMESAWS
            SET Calle 					= Par_DirCalle,
            	Numero 					= Par_DirNumero,
            	ColoniaID 				= Par_DirColoniaID,
            	MunicipioID 			= Par_DirMunicipioID,
            	CiudadID 				= Par_DirCiudadID,
            	EstadoID 				= Par_DirEstadoID,
            	CodigoPostal 			= Par_DirCodigoPostal,
            	PaisID 					= Par_DirPaisID,

            	EmpresaID 				= Par_EmpresaID,
            	Usuario 				= Aud_Usuario,
            	FechaActual 			= Aud_FechaActual,
            	DireccionIP 			= Aud_DireccionIP,
            	ProgramaID 				= Aud_ProgramaID,
            	Sucursal 				= Aud_Sucursal,
            	NumTransaccion 			= Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA DETDIRECFISCALREMESASWS
            UPDATE DETDIRECFISCALREMESASWS
            SET Calle 					= Par_DirFiscCalle,
            	Numero 					= Par_DirFiscNumero,
            	ColoniaID 				= Par_DirFiscColoniaID,
            	MunicipioID 			= Par_DirFiscMunicipioID,
            	CiudadID 				= Par_DirFiscCiudadID,
            	EstadoID 				= Par_DirFiscEstadoID,
            	CodigoPostal 			= Par_DirFiscCodigoPostal,
            	PaisID 					= Par_DirFiscPaisID,

           		EmpresaID 				= Par_EmpresaID,
            	Usuario 				= Aud_Usuario,
            	FechaActual 			= Aud_FechaActual,
            	DireccionIP 			= Aud_DireccionIP,
            	ProgramaID 				= Aud_ProgramaID,
            	Sucursal 				= Aud_Sucursal,
            	NumTransaccion 			= Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA DIRREPLEGALREMESAPMWS
            UPDATE DIRREPLEGALREMESAPMWS
            SET Calle 					= Par_RepLegDirCalle,
            	Numero 					= Par_RepLegDirNumero,
            	ColoniaID 				= Par_RepLegDirColoniaID,
            	MunicipioID 			= Par_RepLegDirMunicipioID,
            	CiudadID 				= Par_RepLegDirCiudadID,
            	EstadoID 				= Par_RepLegDirEstadoID,
            	CodigoPostal 			= Par_RepLegDirCodigoPostal,
            	PaisID 					= Par_RepLegDirPaisID,

            	EmpresaID 				= Par_EmpresaID,
            	Usuario 				= Aud_Usuario,
            	FechaActual 			= Aud_FechaActual,
            	DireccionIP 			= Aud_DireccionIP,
            	ProgramaID 				= Aud_ProgramaID,
            	Sucursal 				= Aud_Sucursal,
            	NumTransaccion 			= Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA REPLEGALREMESASPMWS
            UPDATE REPLEGALREMESASPMWS
            SET NombreRepresenLegal 	= Par_NombreRepresenLegal,
            	PaisID 					= Par_RepLegPaisID,
            	FechaNacimiento 		= Par_RepLegFechaNacimiento,
            	Nacionalidad 			= Par_RepLegNacionalidad,
            	DirecRepLegRemWSID		= DirecRepLegRemWSID,
            	CURP 					= Par_RepLegCURP,
            	RFC 					= Par_RepLegRFC,
            	TipoIdendificacionID 	= Par_RepLegTipoIdendificacionID,
				IdentificacionID 		= Par_RepLegIdentificacionID,

            	EmpresaID 				= Par_EmpresaID,
            	Usuario 				= Aud_Usuario,
            	FechaActual 			= Aud_FechaActual,
            	DireccionIP 			= Aud_DireccionIP,
            	ProgramaID 				= Aud_ProgramaID,
            	Sucursal 				= Aud_Sucursal,
            	NumTransaccion 			= Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ELIMNAN LOS CHECK LIST DE LA REMESA A ACTUALIZAR
            DELETE FROM CHECKLISTREMESASWS WHERE RemesaWSID = Par_RemesaWSID;

            -- SE ACTUALIZAN LOS DATOS DE LA REMESA EN LA TABLA CHECKLISTREMESASWS
            -- IDENTIFICACION OFICIAL
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckIdentiOficialID, 	Par_CheckDocIdentOficial,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- COMPROBANTE DE DOMICILIO
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCompDomID,		Par_CheckDocCompDom,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- CURP
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCurpID,		Par_CheckDocCurp,		DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- RFC
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckRfcID,			Par_CheckDocRfc,		DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- FIEL
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,				Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 			ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckFielID,		Par_CheckDocFiel,		DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        --  ACTA CONSTITUTIVA
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 				Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 			DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckActaConstiID,	Par_CheckDocActaConsti,		DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        --  PODER DEL REPRESENTANTE LEGAL
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckPodRepreLegalID,	Par_CheckDocPodRepreLegal,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- REGISTRO PUBLICO DE LA PROPIEDAD
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckRegPubliPropID,	Par_CheckDocRegPubliProp,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- CEDULA DE IDENTIFICACION FISCAL
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,						Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 					ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCedulaIdenFiscalID,	Par_CheckDocCedulaIdenFiscal,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- NUMERO DE SERIE PARA FIRMA ELECTRONICA
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckSerieFirmaElecID,	Par_CheckDocSerieFirmaElec,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- DECLARACION PERSONAL
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,						Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 					ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckDeclaracionPersoID,	Par_CheckDocDeclaracionPerso,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- CUESTIONARIO ADICIONAL DEL USUARIO Y/O DECLARATORIA DE ORIGEN Y DESTENIO
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,						Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 					ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckCuestionAdicDeclaID,	Par_CheckDocCuestionAdicDecla,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- FORMATO DE VISITA
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckFormatVisitID,		Par_CheckDocFormatVisit,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- DECLARACION DE IMPUESTOS
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 						Archivo,						Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 					DireccionIP, 					ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckDeclaraImpuestoID,		Par_CheckDocDeclaraImpuesto,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

	        -- ESTADO FINANCIERO
	        SET Var_CheckListRemWSID := (SELECT IFNULL(MAX(CheckListRemWSID),Entero_Cero) + Entero_Uno FROM CHECKLISTREMESASWS);
	        INSERT INTO CHECKLISTREMESASWS(
				CheckListRemWSID, 			RemesaWSID, 			NumeroID, 					Archivo,					Descripcion,
	            EmpresaID, 					Usuario, 				FechaActual, 				DireccionIP, 				ProgramaID,
	            Sucursal, 					NumTransaccion
			)VALUES(
				Var_CheckListRemWSID,		Par_RemesaWSID,			Par_CheckEstadoFinanID,		Par_CheckDocEstadoFinan,	DescDocumento,
	            Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);
		END IF;

        IF (Par_NumAct = Act_SpeiSolRemesa) THEN

            UPDATE REMESASWS SET
                SpeiSolDesID    = Par_SpeiSolDesID,

                EmpresaID	  	= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID
            AND IFNULL(SpeiSolDesID, Entero_Cero) = Entero_Cero;
        END IF;

		IF (Par_NumAct = Act_EstatusRemesa) THEN

			UPDATE REMESASWS SET
                Estatus			= Par_Estatus,

                EmpresaID	  	= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
            WHERE RemesaWSID = Par_RemesaWSID;
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Remesa Actualizada Exitosamente: ',CAST(Par_RemesaWSID AS CHAR) );
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Par_RemesaWSID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
