-- PLDNIVELRIESGOREMESAWSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDNIVELRIESGOREMESAWSVAL`;
DELIMITER $$

CREATE PROCEDURE `PLDNIVELRIESGOREMESAWSVAL`(
-- =====================================================================================
-- ------- STORED PARA VALIDACIONES POR NIVEL DE RIESGO EN LAS REMESESAS POR WS --------
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
    DECLARE Var_RemesaWSID		BIGINT(20);			-- ID Consecutivo de la remesa
    DECLARE Var_DetDirecRemesaWSID BIGINT(20);		-- ID Consecutivo de la direccion

    DECLARE Var_DetDirecFiscalRemWSID BIGINT(20);	-- ID Consecutivo de la direccion fiscal
    DECLARE Var_RepLegalRemWSID BIGINT(20);			-- ID Consecutivo del representante legal
    DECLARE Var_DirecRepLegRemWSID BIGINT(20);		-- ID Consecutivo de la direccion del representante legal
    DECLARE Var_CheckListRemWSID BIGINT(20);		-- ID Del check list
    DECLARE Var_NivelRiesgo		CHAR(1);			-- India el nivel de riego para la operacion ya sea para personas fisica, fisica con actividad empresarial o moral

	DECLARE Var_Estatus			CHAR(1);			-- Estatus de la remesa
    DECLARE Var_CasoID			INT(11);			-- ID de caso de nivel de riesgo
	DECLARE Var_ClienteID		INT(11);			-- Indica el cliente que recibira el pago de la remesa.
	DECLARE Var_TipoIdentiID	INT(11);			-- Indica el ID del tipo de identificacion
    DECLARE Var_ClavePersonaInv	INT(11);			-- Numero de Cliente, Usuario de Servicios , Aval, Prospecto, o Relacionado a la cuenta, cero si es en el alta

	DECLARE Var_PrimerNombre	VARCHAR(50);		-- Primer Nombre
	DECLARE Var_SegundoNombre	VARCHAR(50);		-- Segundo Nombre
	DECLARE Var_TercerNombre	VARCHAR(50);		-- Tercer Nombre
	DECLARE Var_ApellidoPaterno	VARCHAR(50);		-- Apellido Paterno
	DECLARE Var_ApellidoMaterno	VARCHAR(50);		-- Apellido Materno

    DECLARE Var_TipoPersSAFI	VARCHAR(3);			-- CTE. Cliente USU. Usuario de Servicios AVA Aval PRO Prosepecto REL Relacionado a la cuenta, NA. No Aplica

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
	DECLARE NivelRiesgo_Bajo	CHAR(1); 			-- Nivel de riesgo Bajo
	DECLARE NivelRiesgo_Medio	CHAR(1); 			-- Nivel de riesgo Medio
	DECLARE NivelRiesgo_Alto	CHAR(1); 			-- Nivel de riesgo Alto

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
    SET NivelRiesgo_Bajo		:= 'B';
    SET NivelRiesgo_Medio		:= 'M';
    SET NivelRiesgo_Alto		:= 'A';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-PLDNIVELRIESGOREMESAWSVAL','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

		IF(IFNULL(Par_TipoPersona, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Tipo de Persona esta Vacio.';
			SET Var_Control		:= '';
			LEAVE ManejoErrores;
		END IF;

        -- Campos requeridos para poder realizar la bUsqueda para personas fIsicas o fIsicas con actividad empresarial
        IF(Par_TipoPersona = 'F' OR Par_TipoPersona = 'A')THEN
			IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr 		:= 2;
				SET Par_ErrMen 		:= 'El Nombre Completo esta Vacio.';
				SET Var_Control		:= '';
				LEAVE ManejoErrores;
            END IF;

			IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr 		:= 3;
				SET Par_ErrMen 		:= 'El Pais esta Vacio.';
				SET Var_Control		:= '';
				LEAVE ManejoErrores;
            END IF;

			IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
				SET Par_NumErr 		:= 4;
				SET Par_ErrMen 		:= 'El Estado esta Vacio.';
				SET Var_Control		:= '';
				LEAVE ManejoErrores;
            END IF;
        END IF;

        -- Campos requeridos para poder realizar la bUsqueda con personas mora
        IF(Par_TipoPersona = 'M')THEN
			IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr 		:= 5;
				SET Par_ErrMen 		:= 'El RFC esta Vacio.';
				SET Var_Control		:= '';
				LEAVE ManejoErrores;
            END IF;

			IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr 		:= 6;
				SET Par_ErrMen 		:= 'La Razon Social esta Vacia.';
				SET Var_Control		:= '';
				LEAVE ManejoErrores;
            END IF;
        END IF;

        -- DATOS REMESA WS
        SET Var_Estatus := (SELECT Estatus FROM REMESASWS WHERE RemesaFolioID = Par_RemesaFolioID);

        -- DATOS SI ES CLIENTE DE LA REMESA
        IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SELECT NivelRiesgo,	 ClienteID
				INTO Var_NivelRiesgo, Var_ClienteID
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
		END IF;

        -- casos son aplicables unicamente para las remesas cuyo tipo de operacion (payType) sea  Efectivo(R) o SPEI(S).
        IF(Par_FormaPago IN('R','S'))THEN
			-- OBTIENE NIVEL DE RIESGO SI ES CLIENTE SE OBTIENE DEL SAFI
            IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
				SET Var_NivelRiesgo := Var_NivelRiesgo;
            ELSE -- SI NO ES UN CLIENTE
				-- SE CONSIDERA EL NIVEL DE RIEGO PROVENIENTE DEL WS UNICAMENTE PARA LA PRIMER OPERACION
                IF(IFNULL(Var_Estatus, Cadena_Vacia) = 'N')THEN
					SET Var_NivelRiesgo := Par_NivelRiesgo;
				ELSE -- ES UNA SEGUNDA OPERACION SE TOMA EL VALOR DEL SAFI
					SET Var_NivelRiesgo := '';-- FALTA SABER DE DONDE SE TOMA EL VALOR DEL NIVEL DE RIESGO DEL USUARIO DE SERVICO*****************************************
                END IF;
            END IF;

             -- BUSCAMOS EN QUE CASO DE NIVEL DE RIEGO ENTRA
			SELECT
				REM.CasoID
			INTO Var_CasoID FROM
				REMESAWSCASOSNIVRIE REM
					INNER JOIN
				MONEDAS MON ON REM.MonedaID = MON.MonedaId
			WHERE
				REM.NivelRiesgo LIKE CONCAT('%', Var_NivelRiesgo, '%')
					AND REM.TipoPersona LIKE CONCAT('%', Par_TipoPersona, '%')
					AND IF(REM.OperadorMontoMax <> '',
					CASE
						WHEN REM.OperadorMontoMax = '<' THEN Par_Monto < (REM.MontoMax * MON.TipCamDof)
						WHEN REM.OperadorMontoMax = '>' THEN Par_Monto > (REM.MontoMax * MON.TipCamDof)
						WHEN REM.OperadorMontoMax = '<=' THEN Par_Monto <= (REM.MontoMax * MON.TipCamDof)
						WHEN REM.OperadorMontoMax = '>=' THEN Par_Monto >= (REM.MontoMax * MON.TipCamDof)
						ELSE TRUE
					END,
					TRUE)
					AND IF(REM.OperadorMontoMin <> '',
					CASE
						WHEN REM.OperadorMontoMin = '<' THEN Par_Monto < (REM.MontoMin * MON.TipCamDof)
						WHEN REM.OperadorMontoMin = '>' THEN Par_Monto > (REM.MontoMin * MON.TipCamDof)
						WHEN REM.OperadorMontoMin = '<=' THEN Par_Monto <= (REM.MontoMin * MON.TipCamDof)
						WHEN REM.OperadorMontoMin = '>=' THEN Par_Monto >= (REM.MontoMin * MON.TipCamDof)
						ELSE TRUE
					END,
					TRUE);

			SET Var_CasoID := IFNULL(Var_CasoID, Entero_Cero);

            -- INICIO CASO 1
            IF(Var_CasoID = 1)THEN

                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 7;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 8;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 9;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 10;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 11;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 12;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 13;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

            END IF; -- FIN CASO 1

            -- INICIO CASO 2
            IF(Var_CasoID = 2)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 14;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 15;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 16;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NomRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 17;
					SET Par_ErrMen 		:= 'El Nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- FIN CASO 2

            -- INICIO CASO 3
            IF(Var_CasoID = 3)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 18;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 19;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 20;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 21;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 22;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 23;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 24;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 25;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 26;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 27;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 28;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 29;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 30;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 31;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 32;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 33;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 34;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 35;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 36;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 37;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 38;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- FIN CASO 3

            -- INICIO CASO 4
            IF(Var_CasoID = 4)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 39;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 40;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 41;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 42;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 43;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 44;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 45;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 46;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 47;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 48;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 49;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 49;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 51;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 52;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 53;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 54;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 55;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 56;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 57;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 58;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 59;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 60;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 61;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 62;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 63;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 64;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 65;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 66;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 67;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 68;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- FIN CASO 4

            -- INICIO CASO 5
            IF(Var_CasoID = 5)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 69;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 70;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_GiroMercantil, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 71;
					SET Par_ErrMen 		:= 'El Giro Mercantil esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Actividad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 72;
					SET Par_ErrMen 		:= 'La Actividad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 73;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentificacionFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 72;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentiFiscalPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 73;
					SET Par_ErrMen 		:= 'El Pais de la Identificacion Fiscal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 74;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 75;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 76;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 77;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 78;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 79;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 80;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 81;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 82;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Email, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 81;
					SET Par_ErrMen 		:= 'El Correo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 82;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaConstitucion, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 83;
					SET Par_ErrMen 		:= 'La Fecha de Constitucion esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 84;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- INICIO REPRESENTANTE LEGAL
				IF(IFNULL(Par_NombreRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 85;
					SET Par_ErrMen 		:= 'El nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 86;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegFechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 87;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegNacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 88;
					SET Par_ErrMen 		:= 'La Nacionalidad del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 89;
					SET Par_ErrMen 		:= 'La Calle del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 90;
					SET Par_ErrMen 		:= 'El Numero del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 91;
					SET Par_ErrMen 		:= 'La Colonia del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 92;
					SET Par_ErrMen 		:= 'El Municipio del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 93;
					SET Par_ErrMen 		:= 'La Ciudad del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 94;
					SET Par_ErrMen 		:= 'El Estado del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 95;
					SET Par_ErrMen 		:= 'El Codigo Postal del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 96;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegCURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 97;
					SET Par_ErrMen 		:= 'La CURP del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegRFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 98;
					SET Par_ErrMen 		:= 'El RFC del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegTipoIdendificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 99;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegIdentificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 99;
					SET Par_ErrMen 		:= 'El Numero de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
                -- FIN REPRESENTANTE LEGAL

			END IF; -- FIN CASO 5

            -- INICIO CASO 6
            IF(Var_CasoID = 6)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 100;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 101;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 102;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 103;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 104;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 105;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 106;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 107;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 108;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 109;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 110;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 111;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 112;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 113;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 114;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 115;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 116;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 117;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 118;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 119;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 120;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 121;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

			END IF; -- FIN CASO 6

            -- INICIO CASO 7
            IF(Var_CasoID = 7)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 122;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 123;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 124;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 125;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 126;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 127;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 128;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 129;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 130;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 131;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 132;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 133;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 134;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 135;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 136;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 137;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 138;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 139;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 140;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 141;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 142;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 143;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 144;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 145;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 146;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 147;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 148;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 149;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 150;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 151;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 152;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 7

            -- INICIO CASO 8
            IF(Var_CasoID = 8)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 153;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 154;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_GiroMercantil, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 155;
					SET Par_ErrMen 		:= 'El Giro Mercantil esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Actividad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 156;
					SET Par_ErrMen 		:= 'La Actividad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 157;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentificacionFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 158;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentiFiscalPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 159;
					SET Par_ErrMen 		:= 'El Pais de la Identificacion Fiscal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 160;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 161;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 162;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 163;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 164;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 165;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 166;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 167;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 168;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Email, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 169;
					SET Par_ErrMen 		:= 'El Correo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 170;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaConstitucion, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 171;
					SET Par_ErrMen 		:= 'La Fecha de Constitucion esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 172;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- INICIO REPRESENTANTE LEGAL
				IF(IFNULL(Par_NombreRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 173;
					SET Par_ErrMen 		:= 'El nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 174;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegFechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 175;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegNacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 176;
					SET Par_ErrMen 		:= 'La Nacionalidad del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 177;
					SET Par_ErrMen 		:= 'La Calle del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 178;
					SET Par_ErrMen 		:= 'El Numero del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 179;
					SET Par_ErrMen 		:= 'La Colonia del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 180;
					SET Par_ErrMen 		:= 'El Municipio del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 181;
					SET Par_ErrMen 		:= 'La Ciudad del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 182;
					SET Par_ErrMen 		:= 'El Estado del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 183;
					SET Par_ErrMen 		:= 'El Codigo Postal del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 184;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegCURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 185;
					SET Par_ErrMen 		:= 'La CURP del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegRFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 186;
					SET Par_ErrMen 		:= 'El RFC del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegTipoIdendificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 187;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegIdentificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 188;
					SET Par_ErrMen 		:= 'El Numero de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
                -- FIN REPRESENTANTE LEGAL

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 189;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CedulaIdentiFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 190;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal de la Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 8

            -- INICIO CASO 9
            IF(Var_CasoID = 9)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 191;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 192;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 193;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 194;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 195;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 196;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 197;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 198;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 199;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 200;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 201;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 202;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 203;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 204;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 205;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 206;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 207;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 208;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 209;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 210;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 211;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 212;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 213;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 214;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 215;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 216;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 217;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 218;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 219;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 220;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 9

            -- INICIO CASO 10
            IF(Var_CasoID = 10)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 221;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 222;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 223;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 224;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 225;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 226;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 227;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 228;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 229;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 230;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 231;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 232;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 233;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 234;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 235;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 236;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 237;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 238;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 239;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 240;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 241;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 242;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 243;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 244;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 245;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 246;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 247;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 248;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 249;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 250;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 251;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 252;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 253;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 254;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 255;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 256;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 257;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRfcID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 258;
					SET Par_ErrMen 		:= 'El ID del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRfc, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 259;
					SET Par_ErrMen 		:= 'El Documento del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFielID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 260;
					SET Par_ErrMen 		:= 'El ID del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 261;
					SET Par_ErrMen 		:= 'El Documento del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 262;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 263;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 10

            -- INICIO CASO 11
            IF(Var_CasoID = 11)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 264;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 265;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_GiroMercantil, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 266;
					SET Par_ErrMen 		:= 'El Giro Mercantil esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Actividad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 267;
					SET Par_ErrMen 		:= 'La Actividad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 268;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentificacionFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 269;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentiFiscalPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 270;
					SET Par_ErrMen 		:= 'El Pais de la Identificacion Fiscal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 271;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 272;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 273;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 274;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 275;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 276;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 277;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 278;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 279;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Email, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 280;
					SET Par_ErrMen 		:= 'El Correo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 281;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaConstitucion, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 282;
					SET Par_ErrMen 		:= 'La Fecha de Constitucion esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 283;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- INICIO REPRESENTANTE LEGAL
				IF(IFNULL(Par_NombreRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 284;
					SET Par_ErrMen 		:= 'El nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 285;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegFechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 286;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegNacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 287;
					SET Par_ErrMen 		:= 'La Nacionalidad del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 288;
					SET Par_ErrMen 		:= 'La Calle del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 289;
					SET Par_ErrMen 		:= 'El Numero del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 290;
					SET Par_ErrMen 		:= 'La Colonia del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 291;
					SET Par_ErrMen 		:= 'El Municipio del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 292;
					SET Par_ErrMen 		:= 'La Ciudad del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 293;
					SET Par_ErrMen 		:= 'El Estado del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 294;
					SET Par_ErrMen 		:= 'El Codigo Postal del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 295;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegCURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 296;
					SET Par_ErrMen 		:= 'La CURP del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegRFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 297;
					SET Par_ErrMen 		:= 'El RFC del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegTipoIdendificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 298;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegIdentificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 299;
					SET Par_ErrMen 		:= 'El Numero de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
                -- FIN REPRESENTANTE LEGAL

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 300;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CedulaIdentiFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 301;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal de la Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 302;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 303;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 304;
					SET Par_ErrMen 		:= 'El ID de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 305;
					SET Par_ErrMen 		:= 'El Documento de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckActaConstiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 306;
					SET Par_ErrMen 		:= 'El ID de la Acta Constitutiva esta vacia(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocActaConsti, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 307;
					SET Par_ErrMen 		:= 'El Documento de la Acta Constitutiva esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckPodRepreLegalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 308;
					SET Par_ErrMen 		:= 'El ID del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocPodRepreLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 309;
					SET Par_ErrMen 		:= 'El Documento del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRegPubliPropID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 210;
					SET Par_ErrMen 		:= 'El ID del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRegPubliProp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 311;
					SET Par_ErrMen 		:= 'El Documento del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 312;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 313;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCedulaIdenFiscalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 314;
					SET Par_ErrMen 		:= 'El ID de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCedulaIdenFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 315;
					SET Par_ErrMen 		:= 'El Documento de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckSerieFirmaElecID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 316;
					SET Par_ErrMen 		:= 'El ID del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocSerieFirmaElec, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 317;
					SET Par_ErrMen 		:= 'El Documento del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 318;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 319;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 11

            -- INICIO CASO 12
            IF(Var_CasoID = 12)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 320;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 321;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 322;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 323;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 324;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 325;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 326;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 327;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 328;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 329;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 330;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 331;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 332;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 333;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 334;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 335;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 336;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 337;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 338;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 339;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 340;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 341;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 342;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 343;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 344;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 345;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 346;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 347;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 348;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 349;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 350;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 351;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 12

            -- INICIO CASO 13
            IF(Var_CasoID = 13)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 352;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 353;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 354;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 355;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 356;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 357;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 358;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 359;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 360;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 361;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 362;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 363;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 364;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 365;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 366;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 367;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 368;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 369;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 370;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 371;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 372;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 373;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 374;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 375;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 376;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 377;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 378;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 379;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 380;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 381;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 382;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 383;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 384;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 385;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 386;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 387;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 388;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRfcID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 389;
					SET Par_ErrMen 		:= 'El ID del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRfc, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 390;
					SET Par_ErrMen 		:= 'El Documento del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFielID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 391;
					SET Par_ErrMen 		:= 'El ID del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 392;
					SET Par_ErrMen 		:= 'El Documento del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 393;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 394;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 395;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 396;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 13

            -- INICIO CASO 14
            IF(Var_CasoID = 14)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 397;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 398;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_GiroMercantil, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 399;
					SET Par_ErrMen 		:= 'El Giro Mercantil esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Actividad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 400;
					SET Par_ErrMen 		:= 'La Actividad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 401;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentificacionFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 402;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentiFiscalPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 403;
					SET Par_ErrMen 		:= 'El Pais de la Identificacion Fiscal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 404;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 405;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 406;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 407;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 408;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 409;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 410;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 411;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 412;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Email, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 413;
					SET Par_ErrMen 		:= 'El Correo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 414;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaConstitucion, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 415;
					SET Par_ErrMen 		:= 'La Fecha de Constitucion esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 416;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- INICIO REPRESENTANTE LEGAL
				IF(IFNULL(Par_NombreRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 417;
					SET Par_ErrMen 		:= 'El nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 418;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegFechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 419;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegNacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 420;
					SET Par_ErrMen 		:= 'La Nacionalidad del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 421;
					SET Par_ErrMen 		:= 'La Calle del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 422;
					SET Par_ErrMen 		:= 'El Numero del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 423;
					SET Par_ErrMen 		:= 'La Colonia del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 424;
					SET Par_ErrMen 		:= 'El Municipio del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 425;
					SET Par_ErrMen 		:= 'La Ciudad del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 426;
					SET Par_ErrMen 		:= 'El Estado del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 427;
					SET Par_ErrMen 		:= 'El Codigo Postal del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 428;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegCURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 429;
					SET Par_ErrMen 		:= 'La CURP del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegRFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 430;
					SET Par_ErrMen 		:= 'El RFC del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegTipoIdendificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 431;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegIdentificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 432;
					SET Par_ErrMen 		:= 'El Numero de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
                -- FIN REPRESENTANTE LEGAL

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 433;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CedulaIdentiFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 434;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal de la Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 435;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 436;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 437;
					SET Par_ErrMen 		:= 'El ID de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 438;
					SET Par_ErrMen 		:= 'El Documento de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckActaConstiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 439;
					SET Par_ErrMen 		:= 'El ID de la Acta Constitutiva esta vacia(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocActaConsti, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 440;
					SET Par_ErrMen 		:= 'El Documento de la Acta Constitutiva esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckPodRepreLegalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 441;
					SET Par_ErrMen 		:= 'El ID del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocPodRepreLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 442;
					SET Par_ErrMen 		:= 'El Documento del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRegPubliPropID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 443;
					SET Par_ErrMen 		:= 'El ID del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRegPubliProp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 444;
					SET Par_ErrMen 		:= 'El Documento del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 445;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 446;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCedulaIdenFiscalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 447;
					SET Par_ErrMen 		:= 'El ID de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCedulaIdenFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 448;
					SET Par_ErrMen 		:= 'El Documento de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckSerieFirmaElecID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 449;
					SET Par_ErrMen 		:= 'El ID del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocSerieFirmaElec, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 450;
					SET Par_ErrMen 		:= 'El Documento del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 451;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 452;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 14

            -- INICIO CASO 15
            IF(Var_CasoID = 15)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 453;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 454;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 455;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 456;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 457;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 458;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 459;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 460;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 461;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 462;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 463;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 464;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 465;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 466;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 467;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 468;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 469;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 470;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 471;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 472;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 473;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 474;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 475;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 476;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 477;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 478;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 479;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 480;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 481;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 482;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 483;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 484;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFormatVisitID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 485;
					SET Par_ErrMen 		:= 'El ID del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFormatVisit, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 486;
					SET Par_ErrMen 		:= 'El Documento del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 15

            -- INICIO CASO 16
            IF(Var_CasoID = 16)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 487;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 488;
					SET Par_ErrMen 		:= 'El Nombre Completo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_PaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 489;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero AND Par_PaisID = 700)THEN
					SET Par_NumErr 		:= 490;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Genero, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 491;
					SET Par_ErrMen 		:= 'El Genero esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 492;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 493;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 494;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 495;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 496;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 497;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 498;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 499;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 500;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 501;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 502;
					SET Par_ErrMen 		:= 'La CURP esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 503;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 504;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 505;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                SET Var_TipoIdentiID := (SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentiID);
				IF(IFNULL(Var_TipoIdentiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 506;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion No Existe(TIPOSIDENTI).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FolioIdentific, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 507;
					SET Par_ErrMen 		:= 'El Numero de Identificacion esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 508;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 509;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 510;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 511;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 512;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 513;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 514;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 515;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 516;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 517;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 518;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 519;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 520;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 521;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 522;
					SET Par_ErrMen 		:= 'El ID de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 523;
					SET Par_ErrMen 		:= 'El Documento de la CURP esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRfcID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 524;
					SET Par_ErrMen 		:= 'El ID del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRfc, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 525;
					SET Par_ErrMen 		:= 'El Documento del RFC esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFielID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 526;
					SET Par_ErrMen 		:= 'El ID del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 527;
					SET Par_ErrMen 		:= 'El Documento del Fiel esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaracionPersoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 528;
					SET Par_ErrMen 		:= 'El ID de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaracionPerso, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 529;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion Personal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 530;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 531;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFormatVisitID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 532;
					SET Par_ErrMen 		:= 'El ID del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFormatVisit, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 533;
					SET Par_ErrMen 		:= 'El Documento del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaraImpuestoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 534;
					SET Par_ErrMen 		:= 'El ID de la Declaracion de Impuestos esta vacia(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaraImpuesto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 535;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion de Impuestos esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckEstadoFinanID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 536;
					SET Par_ErrMen 		:= 'El ID del Estado Financiero esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocEstadoFinan, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 537;
					SET Par_ErrMen 		:= 'El Documento del Estado Financiero esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 16

            -- INICIO CASO 17
            IF(Var_CasoID = 17)THEN
                IF(Par_ClienteID > Entero_Cero)THEN
					IF(IFNULL(Var_ClienteID, Entero_Cero) <= Entero_Cero)THEN
						SET Par_NumErr 		:= 538;
						SET Par_ErrMen 		:= 'El Cliente no existe en SAFI.';
						SET Var_Control		:= '';
						LEAVE ManejoErrores;
					END IF;
                END IF;

				IF(IFNULL(Par_RazonSocial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 539;
					SET Par_ErrMen 		:= 'La Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_GiroMercantil, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 540;
					SET Par_ErrMen 		:= 'El Giro Mercantil esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Actividad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 541;
					SET Par_ErrMen 		:= 'La Actividad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 542;
					SET Par_ErrMen 		:= 'El RFC esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentificacionFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 543;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_IdentiFiscalPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 544;
					SET Par_ErrMen 		:= 'El Pais de la Identificacion Fiscal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Fiel, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 545;
					SET Par_ErrMen 		:= 'El Fiel esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 546;
					SET Par_ErrMen 		:= 'La Calle esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 547;
					SET Par_ErrMen 		:= 'El Numero esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 548;
					SET Par_ErrMen 		:= 'La Colonia esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 549;
					SET Par_ErrMen 		:= 'El Municipio esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 550;
					SET Par_ErrMen 		:= 'La Ciudad esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 551;
					SET Par_ErrMen 		:= 'El Estado esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 552;
					SET Par_ErrMen 		:= 'La Codigo Postal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_DirFiscPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 553;
					SET Par_ErrMen 		:= 'El Pais esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Email, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 554;
					SET Par_ErrMen 		:= 'El Correo esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NumTelefonico, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 555;
					SET Par_ErrMen 		:= 'El Numero de Telefono esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_FechaConstitucion, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 556;
					SET Par_ErrMen 		:= 'La Fecha de Constitucion esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_Nacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 557;
					SET Par_ErrMen 		:= 'La Nacionalidad esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- INICIO REPRESENTANTE LEGAL
				IF(IFNULL(Par_NombreRepresenLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 558;
					SET Par_ErrMen 		:= 'El nombre del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 559;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegFechaNacimiento, Fecha_Vacia) = Fecha_Vacia)THEN
					SET Par_NumErr 		:= 560;
					SET Par_ErrMen 		:= 'La Fecha de Nacimiento del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegNacionalidad, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 561;
					SET Par_ErrMen 		:= 'La Nacionalidad del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCalle, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 562;
					SET Par_ErrMen 		:= 'La Calle del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirNumero, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 563;
					SET Par_ErrMen 		:= 'El Numero del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirColoniaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 564;
					SET Par_ErrMen 		:= 'La Colonia del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirMunicipioID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 565;
					SET Par_ErrMen 		:= 'El Municipio del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCiudadID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 566;
					SET Par_ErrMen 		:= 'La Ciudad del Representante Legal esta Vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirEstadoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 567;
					SET Par_ErrMen 		:= 'El Estado del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirCodigoPostal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 568;
					SET Par_ErrMen 		:= 'El Codigo Postal del Representante Legal esta vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegDirPaisID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 569;
					SET Par_ErrMen 		:= 'El Pais del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegCURP, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 570;
					SET Par_ErrMen 		:= 'La CURP del Representante Legal esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegRFC, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 571;
					SET Par_ErrMen 		:= 'El RFC del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegTipoIdendificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 572;
					SET Par_ErrMen 		:= 'El Tipo de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_RepLegIdentificacionID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 573;
					SET Par_ErrMen 		:= 'El Numero de Identificacion del Representante Legal esta Vacio.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
                -- FIN REPRESENTANTE LEGAL

				IF(IFNULL(Par_RutaIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 574;
					SET Par_ErrMen 		:= 'La Ruta del archivo de la copia de la identificacion oficial esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CedulaIdentiFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 575;
					SET Par_ErrMen 		:= 'La Identificacion Fiscal de la Razon Social esta vacia.';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

                -- CHECKL  LIST
				IF(IFNULL(Par_CheckIdentiOficialID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 576;
					SET Par_ErrMen 		:= 'El ID de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocIdentOficial, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 577;
					SET Par_ErrMen 		:= 'El Documento de Identificacion Oficial esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCurpID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 578;
					SET Par_ErrMen 		:= 'El ID de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCurp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 579;
					SET Par_ErrMen 		:= 'El Documento de la CURP Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckActaConstiID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 580;
					SET Par_ErrMen 		:= 'El ID de la Acta Constitutiva esta vacia(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocActaConsti, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 581;
					SET Par_ErrMen 		:= 'El Documento de la Acta Constitutiva esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckPodRepreLegalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 582;
					SET Par_ErrMen 		:= 'El ID del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocPodRepreLegal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 583;
					SET Par_ErrMen 		:= 'El Documento del Poder del Representante Legal esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckRegPubliPropID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 584;
					SET Par_ErrMen 		:= 'El ID del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocRegPubliProp, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 585;
					SET Par_ErrMen 		:= 'El Documento del Registro Publico de la Propiedad esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCompDomID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 586;
					SET Par_ErrMen 		:= 'El ID del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCompDom, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 587;
					SET Par_ErrMen 		:= 'El Documento del Comprobante de Domicilio de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCedulaIdenFiscalID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 588;
					SET Par_ErrMen 		:= 'El ID de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCedulaIdenFiscal, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 589;
					SET Par_ErrMen 		:= 'El Documento de la Cedula de Identificacion Fiscal de la Razon Social esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckSerieFirmaElecID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 590;
					SET Par_ErrMen 		:= 'El ID del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocSerieFirmaElec, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 591;
					SET Par_ErrMen 		:= 'El Documento del Numero de la Firma Electronica esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckCuestionAdicDeclaID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 592;
					SET Par_ErrMen 		:= 'El ID del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocCuestionAdicDecla, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 593;
					SET Par_ErrMen 		:= 'El Documento del Cuestionario Adicional esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckFormatVisitID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 594;
					SET Par_ErrMen 		:= 'El ID del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocFormatVisit, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 595;
					SET Par_ErrMen 		:= 'El Documento del Formato de Visita esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDeclaraImpuestoID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 596;
					SET Par_ErrMen 		:= 'El ID de la Declaracion de Impuestos esta vacia(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocDeclaraImpuesto, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 597;
					SET Par_ErrMen 		:= 'El Documento de la Declaracion de Impuestos esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckEstadoFinanID, Entero_Cero) = Entero_Cero)THEN
					SET Par_NumErr 		:= 598;
					SET Par_ErrMen 		:= 'El ID del Estado Financiero esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CheckDocEstadoFinan, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr 		:= 599;
					SET Par_ErrMen 		:= 'El Documento del Estado Financiero esta vacio(CHECKLIST).';
					SET Var_Control		:= '';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN CASO 17

        END IF; -- FIN-- casos son aplicables

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Remesa Agregada Exitosamente: ',CAST(Var_RemesaWSID AS CHAR) );
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Var_RemesaWSID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
