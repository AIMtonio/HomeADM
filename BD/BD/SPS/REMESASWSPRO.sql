-- REMESASWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESASWSPRO`;
DELIMITER $$

CREATE PROCEDURE `REMESASWSPRO`(
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
	DECLARE Var_ActDatosRemesa	CHAR(1);			-- Almacena el valor de Actualizacion de Datos de la Remesa

	-- DECLARACION DE VARIABLES PARA EL PERFIL TRANSACCIONAL DE USUARIO
	DECLARE Var_MontoMaxRet		 DECIMAL(16,2);		-- Monto maximo de retiros
	DECLARE Var_MontoMaxDep		 DECIMAL(16,2);		-- Monto maximo de depositos
	DECLARE Var_NumDepositos	 INT(11);			-- Numero de depositos
	DECLARE Var_NumRetiros		 INT(11);			-- NUmero de retiros
	DECLARE Var_OrigenRecID		 INT(11);			-- Origen de Recursos
	DECLARE Var_OrigenRecComen   VARCHAR(600);		-- Comentario de origen de recursos
	DECLARE Var_DestinoRecID	 INT(11);			-- Destino de recursos
	DECLARE Var_DestinoRecComen  VARCHAR(600);		-- Comentario de destino de recursos

	-- DECLARACION DE VARIABLES PARA CUENTA EXTERNA
	DECLARE Var_TipoCuentaSPEI	 INT(11);			-- Variable que indica si es Clabe interbancaria, tarjeta de debito o celular
	DECLARE Var_Cuenta	 		 VARCHAR(20);		-- Variable para Clabe interbancaria, tarjeta de debito o celular
	DECLARE Var_Beneficiario	 VARCHAR(100);		-- Nombre completo del cliente o usuario de servicio
	DECLARE Var_Alias			 VARCHAR(30);		-- Alias del cliente o usuario de servicio
	DECLARE Var_Estatus			 CHAR(1);			-- Estatus de la cuenta
	DECLARE Var_TipoCuenta		 CHAR(1);			-- Tipo de cuenta (interna o externa)
	DECLARE Var_EsPrincipal      CHAR(1);			-- Indica si es cuenta principal
	DECLARE Var_AplicaPara		 CHAR(1);			-- Indica si aplica para cuenta, credito o ambas
	DECLARE Var_EsCuentaExterna  CHAR(1);			-- Indica si la cuenta del usuario o cliente pertenece a una cuenta

	-- DECLARACION DE VARIABLES PARA LA VALIDACION DE ABONO A CUENTA (Funcionalida 1.7)
	DECLARE Var_AbonoCuenta	     CHAR(1);			-- Forma de pago Abono a cuenta 'A'
	DECLARE Var_NumPartSPEI		 BIGINT(20);		-- Numero que le asigno SPEI a la institucion para operar con SPEI valor esperado 90646
	DECLARE Var_NumCuentaInst	 VARCHAR(18);		-- Variable para almacenar el valor 6461802111 que pertenece a SOFIEXPRESS
    DECLARE Var_NumCuentaDigi	 VARCHAR(18);		-- Variable para almacenar los primeros 10 digitos de la cuenta del cliente para verificar que pertenece a SOFIEXPRESS

    DECLARE Var_SpeiSolDesID     BIGINT(20);		-- ID Solicitud de descarga

	DECLARE Var_TipoPersSAFI	VARCHAR(3);			-- CTE. Cliente USU. Usuario de Servicios AVA Aval PRO Prosepecto REL Relacionado a la cuenta, NA. No Aplica
	DECLARE Var_ClavePersonaInv	INT(11);			-- Numero de Cliente, Usuario de Servicios , Aval, Prospecto, o Relacionado a la cuenta, cero si es en el alta
	DECLARE Var_TipoBeneficiario CHAR(1);     		-- Tipo de Beneficiario cliente = C, usuario de servicios = U
	DECLARE Var_MontoBloqueoRemesa	INT(11);
	DECLARE Var_OperPermitRemesas	VARCHAR(10);

    DECLARE Var_TipCamDofDolar		DECIMAL(18,6);
    DECLARE Var_ClienteID   		INT(11);        	-- ClienteID que genero error
    DECLARE	Var_CuentaTranID		INT(11);			-- No consecutivo de cuentas transfer por cliente
    DECLARE Var_UsuarioServicioID	INT(11);			-- Identificador del Usuario de Servicio
	DECLARE Var_ExisteUsuario		INT(11);			-- Valida si existe el Usuario de Servicio

    DECLARE Var_EstatusRemesa		CHAR(1);			-- Estatus de la remesa
	DECLARE Var_InstiRemitente	   	INT(11);			-- INSTITUCIONESSPEI   InstitucionID
	DECLARE Var_InstitucionIDSPEI	INT(11); 			-- Institucion de la cuenta externa INSTITUCIONESSPEI
	DECLARE Var_FechaSinGuion		VARCHAR(7);			-- Variable para almacenar la fecha sin guiones
	DECLARE Var_ReferenciaNum		INT(7);				-- Variable para almacenar la referencia numerica del envio SPEI

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Entero_Dos     		INT(1);       		-- Constante Entero dos 2
	DECLARE Entero_Cuatro     	INT(1);       		-- Constante Entero cuatro 4
	DECLARE Entero_Cinco     	INT(1);       		-- Constante Entero cinco 5
	DECLARE Entero_Ocho     	INT(1);       		-- Constante Entero ocho 8
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI


	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
	DECLARE Es_Cliente    		CHAR(1); 			-- Es cliente
	DECLARE Es_UsuarioServicio	CHAR(1); 			-- Es usuario de servicios
	DECLARE Est_Rechazado		CHAR(1);			-- Estatus: Rechazado

	DECLARE Act_RemesaRech		INT(11);			-- Tipo de Actualizacion: Actualiza Datos Remesa Rechazada

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Entero_Dos				:= 2;
	SET Entero_Cuatro			:= 4;
	SET Entero_Cinco			:= 5;
	SET Entero_Ocho				:= 8;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';


	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
	SET Est_Rechazado			:= 'C';

	SET Act_RemesaRech			:= 1;

	-- ASIGNACION DE VARIABLES PARA EL PERFIL TRANSACCIONAL DE USUARIO
	SET Var_MontoMaxRet	 		:= (Par_Monto * Entero_Dos);		-- Default sera el doble del monto
	SET Var_MontoMaxDep		 	:= (Par_Monto * Entero_Dos);		-- Default sera el doble del monto
	SET Var_NumDepositos	 	:= Entero_Cinco;					-- Default sera 5
	SET Var_NumRetiros			:= Entero_Cinco;					-- Default sera 5
	SET Var_OrigenRecID		 	:= Entero_Ocho;						-- Default sera el Num ID 8 de la tabla CATPLDORIGENREC (Remesa Familiar)
	SET Var_OrigenRecComen   	:= 'Los recursos provienen de remesa familiar que es enviada por mi familiar, el cual radica y trabaja en Estados Unidos.';
	SET Var_DestinoRecID		:= Entero_Cuatro;					-- Default sera el Num ID 4 de la tabla CATPLDDESTINOREC (Gastos Personales)
	SET Var_DestinoRecComen  	:= 'Los recursos seran destinados para gastos de manutencion, como alimento, vestido, calzado, educacion.';

	-- ASIGNACION DE VARIABLES PARA CUENTA EXTERNA
	SET Var_Cuenta	 		 := '';						-- Variable para Clabe interbancaria, tarjeta de debito o celular
	SET Var_Estatus			 := 'A';					-- Valor por default es 'A'
	SET Var_TipoCuenta		 := 'E';					-- Valor por default es Externa 'E'
	SET Var_EsPrincipal      := Salida_NO;				-- Valor por default N
	SET Var_AplicaPara		 := Salida_SI;				-- Valor por default S

	-- ASIGNACION DE VARIABLES PARA LA VALIDACION DE ABONO A CUENTA (Funcionalida 1.7)
	SET Var_AbonoCuenta	     := 'A';					-- Valor A
	SET Var_NumPartSPEI	     := 90646;					-- Valor por default
	SET Var_NumCuentaInst	 := '6461802111';			-- Valor por default
	SET Es_Cliente         		:= 'C';
	SET Es_UsuarioServicio      := 'U';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-REMESASWSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

		SET Aud_FechaActual := NOW();
        SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_ActDatosRemesa	:= 'N';
        SET Var_UsuarioServicioID := 0;

        -- IENTIFICAMOS SI ES CLIENTE O USUARIO DE SERVICIOS EL BENEFICIARIO
        IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SET Var_TipoBeneficiario := Es_Cliente;
		ELSE
			SET Var_TipoBeneficiario := Es_UsuarioServicio;
        END IF;

        -- SE VALIDA SI YA EXISTE LA REMESA CON LA MISMA REFERENCIA O CLABE DE COBRO CON ESTATUS DIFERENTE RECHAZADO
        SELECT RemesaWSID,	Estatus
			INTO Var_RemesaWSID,	Var_EstatusRemesa
        FROM REMESASWS
        WHERE (RemesaFolioID = Par_RemesaFolioID
			OR ClabeCobroRemesa = Par_ClabeCobroRemesa)
			AND Estatus <> Est_Rechazado;

		IF(IFNULL(Var_RemesaWSID, Entero_Cero) > Entero_Cero)THEN
			SET Par_NumErr			:= 1;
			SET Par_ErrMen			:= CONCAT('Ya Existe una Remesa con la misma Referencia o Clabe de Cobro.');
			SET Var_Control			:= 'agrega';
			LEAVE ManejoErrores;
        END IF;

		-- SI REQUIERE ACTUALIZACION
        -- SE VALIDA SI YA EXISTE LA REMESA CON LA MISMA REFERENCIA Y CLABE DE COBRO CON ESTATUS RECHAZADO
        SET Var_RemesaWSID := Entero_Cero;
        SELECT RemesaWSID
			INTO Var_RemesaWSID
        FROM REMESASWS
        WHERE RemesaFolioID = Par_RemesaFolioID
			AND ClabeCobroRemesa = Par_ClabeCobroRemesa
			AND Estatus = Est_Rechazado;

        SET Var_RemesaWSID := IFNULL(Var_RemesaWSID,Entero_Cero);
        IF(Var_RemesaWSID > Entero_Cero)THEN
        	-- SE ACTUALIZA LA BANDERA DE ACTUALIZACION DE DATOS DE LA REMESA A S
        	SET Var_ActDatosRemesa	:= 'S';
		ELSE
        	SET Var_ActDatosRemesa	:= 'N';
		END IF;

        IF(Var_ActDatosRemesa = Cons_NO)THEN

	        -- INICIO ALMACENAR INFORMACION PROVENIENTE DEL WS
	        CALL REMESASWSALT(
				Par_Origen, 					Par_UsuarioExt, 				Par_RemesaCatalogoID, 			Par_Monto, 						Par_RemesaFolioID,
				Par_ClabeCobroRemesa, 			Par_ClienteID, 					Par_PrimerNombre,				Par_SegundoNombre,				Par_TercerNombre,
				Par_ApellidoPaterno,			Par_ApellidoMaterno,        	Par_NombreCompleto, 			Par_NombreCompletoRemit, 		Par_FolioIdentificRemit,
				Par_TipoIdentiIDRemit, 			Par_GeneroRemitente,			Par_Direccion, 					Par_DirecRemitente, 			Par_NumTelefonico,
				Par_TipoIdentiID, 				Par_FolioIdentific, 			Par_FormaPago, 					Par_NumeroCuenta, 				Par_CuentaClabeRemesa,

	            Par_TipoCuentaSpei,				Par_InstitucionID,				Par_NumParticipanteSPEI, 		Par_CURP, 						Par_CurpRemitente,
	            Par_RFC, 						Par_RfcRemitente,				Par_RazonSocial, 				Par_NomRepresenLegal, 			Par_PaisID,
	            Par_PaisIDRemitente, 			Par_EstadoID,					Par_EstadoIDRemitente, 			Par_CiudadIDRemitente, 			Par_ColoniaIDRemitente,
	            Par_CodigoPostalRemitente, 		Par_Genero,						Par_FechaNacimiento, 			Par_Nacionalidad, 				Par_NacionalidadRemitente,
	            Par_Email, 						Par_Fiel,						Par_DirCalle, 					Par_DirNumero, 					Par_DirColoniaID,

	            Par_DirMunicipioID, 			Par_DirCiudadID,				Par_DirEstadoID, 				Par_DirCodigoPostal, 			Par_DirPaisID,
	            Par_DirFiscCalle, 				Par_DirFiscNumero,				Par_DirFiscColoniaID, 			Par_DirFiscMunicipioID, 		Par_DirFiscCiudadID,
	            Par_DirFiscEstadoID, 			Par_DirFiscCodigoPostal,		Par_DirFiscPaisID, 				Par_GiroMercantil, 				Par_Actividad,
	            Par_IdentificacionFiscal, 		Par_IdentiFiscalPaisID,			Par_FechaConstitucion, 			Par_NombreRepresenLegal, 		Par_RepLegPaisID,
	            Par_RepLegFechaNacimiento, 		Par_RepLegNacionalidad,			Par_RepLegDirCalle, 			Par_RepLegDirNumero, 			Par_RepLegDirColoniaID,

	            Par_RepLegDirMunicipioID, 		Par_RepLegDirCiudadID,			Par_RepLegDirEstadoID, 			Par_RepLegDirCodigoPostal, 		Par_RepLegDirPaisID,
	            Par_RepLegCURP, 				Par_RepLegRFC,					Par_RepLegTipoIdendificacionID, Par_RepLegIdentificacionID, 	Par_RutaIdentOficial,
	            Par_CedulaIdentiFiscal, 		Par_TipoPersona,				Par_TipoPersonaRemitente, 		Par_NivelRiesgo, 				Par_CheckIdentiOficialID,
	            Par_CheckDocIdentOficial, 		Par_CheckCompDomID,				Par_CheckDocCompDom, 			Par_CheckCurpID, 				Par_CheckDocCurp,
	            Par_CheckRfcID, 				Par_CheckDocRfc,				Par_CheckFielID, 				Par_CheckDocFiel, 				Par_CheckActaConstiID,

	            Par_CheckDocActaConsti, 		Par_CheckPodRepreLegalID,		Par_CheckDocPodRepreLegal, 		Par_CheckRegPubliPropID, 		Par_CheckDocRegPubliProp,
	            Par_CheckCedulaIdenFiscalID, 	Par_CheckDocCedulaIdenFiscal,	Par_CheckSerieFirmaElecID,		Par_CheckDocSerieFirmaElec, 	Par_CheckDeclaracionPersoID,
	            Par_CheckDocDeclaracionPerso, 	Par_CheckCuestionAdicDeclaID,	Par_CheckDocCuestionAdicDecla,	Par_CheckFormatVisitID, 		Par_CheckDocFormatVisit,
	            Par_CheckDeclaraImpuestoID, 	Par_CheckDocDeclaraImpuesto,	Par_CheckEstadoFinanID, 		Par_CheckDocEstadoFinan,		Var_RemesaWSID,

	            Salida_NO, 						Par_NumErr, 					Par_ErrMen, 					Par_EmpresaID, 					Aud_Usuario,
	            Aud_FechaActual, 				Aud_DireccionIP,				Aud_ProgramaID, 				Aud_Sucursal, 					Aud_NumTransaccion
			);

	        IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
	        END IF;
        	-- FIN ALMACENAR INFORMACION PROVENIENTE DEL WS

        END IF;

        --  INICIO VALIDACION DE CAMPOS REQUERIDOS POR NIVEL DE RIESGO Y LISTAS PLD
        CALL PLDNIVELRIESGOREMESAWSVAL(
			Par_Origen, 					Par_UsuarioExt, 				Par_RemesaCatalogoID, 			Par_Monto, 						Par_RemesaFolioID,
			Par_ClabeCobroRemesa, 			Par_ClienteID, 					Par_PrimerNombre,				Par_SegundoNombre,				Par_TercerNombre,
			Par_ApellidoPaterno,			Par_ApellidoMaterno,        	Par_NombreCompleto, 			Par_NombreCompletoRemit, 		Par_FolioIdentificRemit,
			Par_TipoIdentiIDRemit, 			Par_GeneroRemitente,			Par_Direccion, 					Par_DirecRemitente, 			Par_NumTelefonico,
			Par_TipoIdentiID, 				Par_FolioIdentific, 			Par_FormaPago, 					Par_NumeroCuenta, 				Par_CuentaClabeRemesa,

            Par_TipoCuentaSpei,				Par_InstitucionID,				Par_NumParticipanteSPEI, 		Par_CURP, 						Par_CurpRemitente,
            Par_RFC, 						Par_RfcRemitente,				Par_RazonSocial, 				Par_NomRepresenLegal, 			Par_PaisID,
            Par_PaisIDRemitente, 			Par_EstadoID,					Par_EstadoIDRemitente, 			Par_CiudadIDRemitente, 			Par_ColoniaIDRemitente,
            Par_CodigoPostalRemitente, 		Par_Genero,						Par_FechaNacimiento, 			Par_Nacionalidad, 				Par_NacionalidadRemitente,
            Par_Email, 						Par_Fiel,						Par_DirCalle, 					Par_DirNumero, 					Par_DirColoniaID,

            Par_DirMunicipioID, 			Par_DirCiudadID,				Par_DirEstadoID, 				Par_DirCodigoPostal, 			Par_DirPaisID,
            Par_DirFiscCalle, 				Par_DirFiscNumero,				Par_DirFiscColoniaID, 			Par_DirFiscMunicipioID, 		Par_DirFiscCiudadID,
            Par_DirFiscEstadoID, 			Par_DirFiscCodigoPostal,		Par_DirFiscPaisID, 				Par_GiroMercantil, 				Par_Actividad,
            Par_IdentificacionFiscal, 		Par_IdentiFiscalPaisID,			Par_FechaConstitucion, 			Par_NombreRepresenLegal, 		Par_RepLegPaisID,
            Par_RepLegFechaNacimiento, 		Par_RepLegNacionalidad,			Par_RepLegDirCalle, 			Par_RepLegDirNumero, 			Par_RepLegDirColoniaID,

            Par_RepLegDirMunicipioID, 		Par_RepLegDirCiudadID,			Par_RepLegDirEstadoID, 			Par_RepLegDirCodigoPostal, 		Par_RepLegDirPaisID,
            Par_RepLegCURP, 				Par_RepLegRFC,					Par_RepLegTipoIdendificacionID, Par_RepLegIdentificacionID, 	Par_RutaIdentOficial,
            Par_CedulaIdentiFiscal, 		Par_TipoPersona,				Par_TipoPersonaRemitente, 		Par_NivelRiesgo, 				Par_CheckIdentiOficialID,
            Par_CheckDocIdentOficial, 		Par_CheckCompDomID,				Par_CheckDocCompDom, 			Par_CheckCurpID, 				Par_CheckDocCurp,
            Par_CheckRfcID, 				Par_CheckDocRfc,				Par_CheckFielID, 				Par_CheckDocFiel, 				Par_CheckActaConstiID,

            Par_CheckDocActaConsti, 		Par_CheckPodRepreLegalID,		Par_CheckDocPodRepreLegal, 		Par_CheckRegPubliPropID, 		Par_CheckDocRegPubliProp,
            Par_CheckCedulaIdenFiscalID, 	Par_CheckDocCedulaIdenFiscal,	Par_CheckSerieFirmaElecID,		Par_CheckDocSerieFirmaElec, 	Par_CheckDeclaracionPersoID,
            Par_CheckDocDeclaracionPerso, 	Par_CheckCuestionAdicDeclaID,	Par_CheckDocCuestionAdicDecla,	Par_CheckFormatVisitID, 		Par_CheckDocFormatVisit,
            Par_CheckDeclaraImpuestoID, 	Par_CheckDocDeclaraImpuesto,	Par_CheckEstadoFinanID, 		Par_CheckDocEstadoFinan,

            Salida_NO, 						Par_NumErr, 					Par_ErrMen, 					Par_EmpresaID, 					Aud_Usuario,
            Aud_FechaActual, 				Aud_DireccionIP,				Aud_ProgramaID, 				Aud_Sucursal, 					Aud_NumTransaccion
		);

        IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
        END IF;
        --  FIN VALIDACION DE CAMPOS REQUERIDOS POR NIVEL DE RIESGO Y LISTAS PLD

        -- INICIO SI EXISTE LA REMESA CON LA MISMA REFERENCIA Y CLABE DE COBRO CON ESTATUS RECHAZADO
        IF(Var_ActDatosRemesa = 'S')THEN

	        -- SE REALIZA LA LLAMADA AL PROCESO REMESASWSACT
	        CALL REMESASWSACT(
	        	Par_Origen, 					Par_UsuarioExt, 				Par_RemesaCatalogoID, 			Par_Monto, 						Par_RemesaFolioID,
				Par_ClabeCobroRemesa, 			Par_ClienteID, 					Par_PrimerNombre,				Par_SegundoNombre,				Par_TercerNombre,
				Par_ApellidoPaterno,			Par_ApellidoMaterno,        	Par_NombreCompleto, 			Par_NombreCompletoRemit, 		Par_FolioIdentificRemit,
				Par_TipoIdentiIDRemit, 			Par_GeneroRemitente,			Par_Direccion, 					Par_DirecRemitente, 			Par_NumTelefonico,
				Par_TipoIdentiID, 				Par_FolioIdentific, 			Par_FormaPago, 					Par_NumeroCuenta, 				Par_CuentaClabeRemesa,

	            Par_TipoCuentaSpei,				Par_InstitucionID,				Par_NumParticipanteSPEI, 		Par_CURP, 						Par_CurpRemitente,
	            Par_RFC, 						Par_RfcRemitente,				Par_RazonSocial, 				Par_NomRepresenLegal, 			Par_PaisID,
	            Par_PaisIDRemitente, 			Par_EstadoID,					Par_EstadoIDRemitente, 			Par_CiudadIDRemitente, 			Par_ColoniaIDRemitente,
	            Par_CodigoPostalRemitente, 		Par_Genero,						Par_FechaNacimiento, 			Par_Nacionalidad, 				Par_NacionalidadRemitente,
	            Par_Email, 						Par_Fiel,						Par_DirCalle, 					Par_DirNumero, 					Par_DirColoniaID,

	            Par_DirMunicipioID, 			Par_DirCiudadID,				Par_DirEstadoID, 				Par_DirCodigoPostal, 			Par_DirPaisID,
	            Par_DirFiscCalle, 				Par_DirFiscNumero,				Par_DirFiscColoniaID, 			Par_DirFiscMunicipioID, 		Par_DirFiscCiudadID,
	            Par_DirFiscEstadoID, 			Par_DirFiscCodigoPostal,		Par_DirFiscPaisID, 				Par_GiroMercantil, 				Par_Actividad,
	            Par_IdentificacionFiscal, 		Par_IdentiFiscalPaisID,			Par_FechaConstitucion, 			Par_NombreRepresenLegal, 		Par_RepLegPaisID,
	            Par_RepLegFechaNacimiento, 		Par_RepLegNacionalidad,			Par_RepLegDirCalle, 			Par_RepLegDirNumero, 			Par_RepLegDirColoniaID,

	            Par_RepLegDirMunicipioID, 		Par_RepLegDirCiudadID,			Par_RepLegDirEstadoID, 			Par_RepLegDirCodigoPostal, 		Par_RepLegDirPaisID,
	            Par_RepLegCURP, 				Par_RepLegRFC,					Par_RepLegTipoIdendificacionID, Par_RepLegIdentificacionID, 	Par_RutaIdentOficial,
	            Par_CedulaIdentiFiscal, 		Par_TipoPersona,				Par_TipoPersonaRemitente, 		Par_NivelRiesgo, 				Par_CheckIdentiOficialID,
	            Par_CheckDocIdentOficial, 		Par_CheckCompDomID,				Par_CheckDocCompDom, 			Par_CheckCurpID, 				Par_CheckDocCurp,
	            Par_CheckRfcID, 				Par_CheckDocRfc,				Par_CheckFielID, 				Par_CheckDocFiel, 				Par_CheckActaConstiID,

	            Par_CheckDocActaConsti, 		Par_CheckPodRepreLegalID,		Par_CheckDocPodRepreLegal, 		Par_CheckRegPubliPropID, 		Par_CheckDocRegPubliProp,
	            Par_CheckCedulaIdenFiscalID, 	Par_CheckDocCedulaIdenFiscal,	Par_CheckSerieFirmaElecID,		Par_CheckDocSerieFirmaElec, 	Par_CheckDeclaracionPersoID,
	            Par_CheckDocDeclaracionPerso, 	Par_CheckCuestionAdicDeclaID,	Par_CheckDocCuestionAdicDecla,	Par_CheckFormatVisitID, 		Par_CheckDocFormatVisit,
	            Par_CheckDeclaraImpuestoID, 	Par_CheckDocDeclaraImpuesto,	Par_CheckEstadoFinanID, 		Par_CheckDocEstadoFinan,		Var_RemesaWSID,
                Entero_Cero,					Cadena_Vacia,					Act_RemesaRech,

	            Salida_NO, 						Par_NumErr, 				Par_ErrMen, 				Par_EmpresaID, 					Aud_Usuario,
	            Aud_FechaActual, 				Aud_DireccionIP,			Aud_ProgramaID, 			Aud_Sucursal, 					Aud_NumTransaccion);

	         IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
	        END IF;
	     END IF;
        -- FIN SI EXISTE LA REMESA CON LA MISMA REFERENCIA Y CLABE DE COBRO CON ESTATUS RECHAZADO

		-- PARAMETROS PARA LISTA PLD
        IF(Var_TipoBeneficiario = Es_Cliente)THEN
			SET Var_ClavePersonaInv := Par_ClienteID;
            SET Var_TipoPersSAFI := 'CTE';
		END IF;

        IF(Var_TipoBeneficiario = Es_UsuarioServicio)THEN
			SET Var_ClavePersonaInv := Entero_Cero;
            SET Var_TipoPersSAFI := 'USU';
        END IF;

        -- INICIO SI NO SE ACTUALIZAN LOS DATOS DE LA REMESA
        IF(Var_ActDatosRemesa = Cons_NO)THEN
	        -- INICIO BUSQUEDA EN LISTAS DE PERSONAS BLOQUEADAS
			CALL PLDDETECCIONPRO(
				Var_ClavePersonaInv,	Par_PrimerNombre,			Par_SegundoNombre,			Par_TercerNombre,			Par_ApellidoPaterno,
				Par_ApellidoMaterno,	Par_TipoPersona,			Par_RazonSocial,			Par_RFC,					Par_RFC,
				Par_FechaNacimiento,	Entero_Cero,				Par_PaisID,					Par_EstadoID,				Par_NombreCompleto,
				Var_TipoPersSAFI,		Cons_NO,					Cons_SI,					Cons_NO,
	            Cons_NO,				Par_NumErr,					Par_ErrMen,		          	Par_EmpresaID,				Aud_Usuario,
	            Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,	            Aud_Sucursal,				Aud_NumTransaccion
			);

			IF(Par_NumErr!=Entero_Cero)THEN
				UPDATE REMESASWS SET
					Estatus = 'B',
                    Comentarios = Par_ErrMen
				WHERE RemesaWSID = Var_RemesaWSID;

				SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
				SET Par_ErrMen			:= Par_ErrMen;
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
	        -- FIN BUSQUEDA EN LISTAS DE PERSONAS BLOQUEADAS


			-- INICIO VALIDACIONES PARAMGENERALES MONTO BLOQUEO REMESA
			SET Var_MontoBloqueoRemesa := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'MontoBloqueoRemesa');
			SET Var_OperPermitRemesas := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'OperacionesPermitidasRemesas');

			IF(LOCATE(Par_FormaPago,Var_OperPermitRemesas) > Entero_Cero)THEN
				SET Var_TipCamDofDolar := (SELECT TipCamDof FROM MONEDAS WHERE MonedaID = 2);
				SET Var_MontoBloqueoRemesa := Var_MontoBloqueoRemesa * Var_TipCamDofDolar;

				IF(Par_Monto >= Var_MontoBloqueoRemesa )THEN
					SET Par_NumErr 		:= 2;
					SET Par_ErrMen 		:= 'El Monto supero el Monto de Bloqueo de Remesa Permitido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;
			-- FIN VALIDACIONES PARAMGENERALES MONTO BLOQUEO REMESA
		END IF;
	     -- FIN SI NO SE ACTUALIZAN LOS DATOS DE LA REMESA

        -- INICIO LISTAS NEGRAS
		CALL PLDDETECCIONPRO(
			Var_ClavePersonaInv,	Par_PrimerNombre,			Par_SegundoNombre,			Par_TercerNombre,			Par_ApellidoPaterno,
			Par_ApellidoMaterno,	Par_TipoPersona,			Par_RazonSocial,			Par_RFC,					Par_RFC,
			Par_FechaNacimiento,	Entero_Cero,				Par_PaisID,					Par_EstadoID,				Par_NombreCompleto,
			Var_TipoPersSAFI,		Cons_SI,					Cons_NO,					Cons_NO,
            Cons_NO,				Par_NumErr,					Par_ErrMen,		          	Par_EmpresaID,				Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,	            Aud_Sucursal,				Aud_NumTransaccion
		);

		IF(Par_NumErr = Entero_Cero AND Par_ErrMen LIKE CONCAT("%", '%se encuentra en La Lista de Personas en Listas Negras%', "%"))THEN
			UPDATE REMESASWS SET
				Estatus = 'R',
				Comentarios = Par_ErrMen
			WHERE RemesaWSID = Var_RemesaWSID;

			SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
			SET Par_ErrMen			:= Par_ErrMen;
			SET Var_Control			:= 'agrega';
			LEAVE ManejoErrores;
		END IF;
		-- FIN  LISTAS NEGRAS

        -- OPERACIONES RELEVANTES, INUSUALES, FRACCIONADAS

		-- INICIO FORMA DE PAGO SPEI
		IF(IFNULL(Par_FormaPago,Cadena_Vacia) = 'S')THEN

            -- VALIDACIONES CUENTAS CLABE
            SELECT CTA.ClienteID, CTA.InstitucionID
				INTO Var_ClienteID,	Var_InstiRemitente
            FROM CUENTASTRANSFER CTA
				INNER JOIN CLIENTES CTE
					ON CTA.ClienteID = CTE.ClienteID
			WHERE CTA.TipoCuenta = 'E'
				AND CTA.Clabe = Par_CuentaClabeRemesa
				AND IF(Par_TipoPersonaRemitente = 'M',
						CTE.RFCOficial = Par_RfcRemitente,
						CTE.CURP = Par_CurpRemitente)
			LIMIT 1;

            IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'La Cuenta Clabe no esta Registrada a la Remesadora(acountIDRemittance)';
				LEAVE ManejoErrores;
            END IF;

            SET Var_InstitucionIDSPEI := (SELECT InstitucionID FROM INSTITUCIONESSPEI WHERE InstitucionID =  Par_InstitucionID);

            IF(IFNULL(Var_InstitucionIDSPEI, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 2;
				SET Par_ErrMen	:= 'La Institucion SPEI(INSTITUCIONESSPEI) No existe(institutionID)';
				LEAVE ManejoErrores;
            END IF;

			-- ALTA DE CABECERA SOLICITUD DE DESCARGA
            SET Var_SpeiSolDesID := Entero_Cero;

			SELECT SUBSTRING(DATE_FORMAT(FechaSistema, '%y%m%d'), 1, 7)
				INTO Var_FechaSinGuion
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_FechaSinGuion := IFNULL(Var_FechaSinGuion, Cadena_Vacia);
			SET Var_ReferenciaNum := CAST(Var_FechaSinGuion AS UNSIGNED);

			-- ALTA DE DESCARGA DE REMESAS*********************************************************************
			CALL SPEIDESCARGASREMALT (
				Var_SpeiSolDesID,		Cadena_Vacia,		1,						40,		Par_CuentaClabeRemesa,
				SUBSTR(Par_NombreCompletoRemit, 1, 40),Par_RfcRemitente,		4,						Par_Monto,			Entero_Cero,
				Entero_Cero,			Entero_Cero,		Var_InstiRemitente,		Par_InstitucionID,	Par_NumeroCuenta,
				Par_NombreCompleto,		Par_RFC,			Par_TipoCuentaSpei,		'REMESASWS',		Cadena_Vacia,
				Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,			Cadena_Vacia,		Cadena_Vacia,
				Var_ReferenciaNum,		Entero_Cero,		Entero_Uno,				Cadena_Vacia,		8,
				NOW(),					Entero_Cero,		Cadena_Vacia,			Entero_Cero,		Entero_Cero,
				Entero_Cero,			Cadena_Vacia,		Var_RemesaWSID,
                'N',					Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

            SET Var_CuentaTranID := (SELECT CTA.CuentaTranID FROM CUENTASTRANSFER CTA
										INNER JOIN CLIENTES CTE
											ON CTA.ClienteID = CTE.ClienteID
									WHERE CTA.ClienteID = Var_ClienteID
										AND CTA.TipoCuenta = 'E'
										AND CTA.Clabe = Par_NumeroCuenta
                                        AND CTA.TipoCuentaSpei = Par_TipoCuentaSpei
                                        AND CTA.Estatus = 'A'
                                        AND (CTA.RFCBeneficiario = Par_RFC OR CTA.RFCBeneficiario = Par_CURP)
									LIMIT 1);

            -- SI NO EXISTE LA CUENTA DEL BENEFICIARIO RELACIONADA ALA REMESADORA COMO CUENTA EXTERNA SE DA DE ALTA
            IF(IFNULL(Var_CuentaTranID, Entero_Cero) = Entero_Cero)THEN
				CALL CUENTASTRANSFERALT(
					Var_ClienteID, 					Entero_Cero,		Par_InstitucionID,		Par_NumeroCuenta,	Par_NombreCompleto,
					CONCAT(Par_PrimerNombre,'-REMESASWS'),Var_FechaSistema,	'E',				Entero_Cero,		Entero_Cero,
					Entero_Cero,					Entero_Cero,		Par_TipoCuentaSpei,		Par_RFC,			Cons_NO,
					'S',							Entero_Cero,
                    Salida_NO, 						Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario,
					Aud_FechaActual, 				Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
            END IF;



        END IF;
        -- FIN FORMA DE PAGO SPEI

        -- INICIO OPERACIONES REALIZADAS POR USUARIOS DE SERVICIO
        CALL USUARIOSERVICIOREMESASWSPRO(
        	Var_RemesaWSID,		Var_UsuarioServicioID,	Salida_NO,			Par_NumErr,		   	Par_ErrMen,
        	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
        	Aud_Sucursal,		Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
        END IF;
        -- FIN OPERACIONES REALIZADAS POR USUARIOS DE SERVICIO

		-- INICIO VALIDACION SI ES UN USUARIO DE SERVICIO PARA PODER DAR DE ALTA EL PERFIL TRANSACCIONAL
		IF(Var_UsuarioServicioID > Entero_Cero)THEN
			-- SE VERIFICA SI NO EXISTE EL PERFIL TRANSACCIONAL DEL USUARIO
			SET Var_ExisteUsuario := (SELECT IFNULL(UsuarioServicioID,Entero_Cero) FROM PLDPERFILTRANS WHERE UsuarioServicioID = Var_UsuarioServicioID);

			IF(Var_ExisteUsuario = Entero_Cero)THEN
				CALL PLDPERFILTRANSACCIONALALT(
					Entero_Cero,		Var_UsuarioServicioID,		Var_MontoMaxDep,		Var_MontoMaxRet,		Var_NumDepositos,
					Var_NumRetiros,		Var_OrigenRecID,			Var_DestinoRecID,		Var_OrigenRecComen,		Var_DestinoRecComen,
					Salida_NO,			Par_NumErr,		   			Par_ErrMen,		    	Par_EmpresaID, 			Aud_Usuario,
	            	Aud_FechaActual, 	Aud_DireccionIP,			Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
		        END IF;
		     END IF;
		END IF;
        -- FIN VALIDACION SI ES UN USUARIO DE SERVICIO PARA PODER DAR DE ALTA EL PERFIL TRANSACCIONAL

		-- INICIO VALIDACION PARA LA FORMA DE PAGO ES ABONO A CUENTA
		IF(Par_FormaPago = Var_AbonoCuenta)THEN

			IF(IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr			:= 01;
				SET Par_ErrMen			:= 'El Numero de Cliente esta Vacio.';
				SET Var_Control			:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NombreCompleto, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr			:= 02;
				SET Par_ErrMen			:= 'El Nombre del Cliente esta Vacio.';
				SET Var_Control			:= 'nombreCompleto';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumeroCuenta, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr			:= 03;
				SET Par_ErrMen			:= 'El Numero de Cuenta Clabe del Cliente esta Vacio.';
				SET Var_Control			:= 'numeroCuenta';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto, Decimal_Cero) = Decimal_Cero)THEN
				SET Par_NumErr			:= 04;
				SET Par_ErrMen			:= 'El Monto de la Operacion esta Vacio.';
				SET Var_Control			:= 'monto';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_RemesaFolioID, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr			:= 05;
				SET Par_ErrMen			:= 'La Referencia de la Remesa esta vacio.';
				SET Var_Control			:= 'remesaFolioID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NumParticipanteSPEI <> Var_NumPartSPEI)THEN
				SET Par_NumErr			:= 06;
				SET Par_ErrMen			:= 'El Numero de Participante SPEI es distinto a la asignada.';
				SET Var_Control			:= 'numParticipanteSPEI';
				LEAVE ManejoErrores;
			END IF;

			-- Se extraen los primeros 10 digitos del numero de cuenta del cliente
			SET Var_NumCuentaDigi := (SELECT LEFT(Par_NumeroCuenta,10));

			IF(Var_NumCuentaInst <> Var_NumCuentaDigi)THEN
				SET Par_NumErr			:= 07;
				SET Par_ErrMen			:= 'El Numero de Cuenta del Cliente No Pertenece a SOFIEXPRESS.';
				SET Var_Control			:= 'numeroCuenta';
				LEAVE ManejoErrores;
			END IF;

			SELECT 	NombreCompleto
			INTO 	Par_NombreCompleto
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

			-- SE REALIZA LLAMADA AL PROCESO SPEITRANSFERENCIASALT PARA EL REGISTRO EN LA TABLA SPEITRANSFERENCIAS
			CALL SPEITRANSFERENCIASALT(
				Entero_Cero,		Par_NombreCompleto,	Par_NumeroCuenta,	Par_Monto,			Par_RemesaFolioID,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
		-- FIN VALIDACION PARA LA FORMA DE PAGO ES ABONO A CUENTA

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Remesa Procesada Exitosamente: ',CAST(Var_RemesaWSID AS CHAR) );
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
