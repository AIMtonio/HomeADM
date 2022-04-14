-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCLIENTESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCLIENTESALT`;
DELIMITER $$

CREATE PROCEDURE `BANCLIENTESALT`(
  # ========== SP PARA ALTA DE CLIENTES =============================================
	Par_SucursalOri         INT(11),        	-- Sucursal de Origen del cliente
	Par_TipoPersona         CHAR(1),      		-- Tipo de persona
	Par_Titulo              VARCHAR(10),    	-- Titulo de la persona SR SRA SRITA
	Par_PrimerNom           VARCHAR(50),    	-- Primer nombre del cliente
	Par_SegundoNom          VARCHAR(50),    	-- Segundo nombre del cliente

	Par_TercerNom           VARCHAR(50),    	-- Tercer nombre del cliente
	Par_ApellidoPat         VARCHAR(50),    	-- Apellido paterno del cliente
	Par_ApellidoMat         VARCHAR(50),    	-- Apellido materno del cliente
	Par_FechaNac            DATE,       		-- Fecha de nacimiento de cliente
	Par_LugarNac            INT(11),       		-- Pais lugar de nacimiento

	Par_estadoID            INT(11),        	-- Estado del cliente
	Par_Nacion              CHAR(1),      		-- Pais nacionalidad
	Par_PaisResi            INT(11),        	-- Pais de residencia del cliente
	Par_Sexo                CHAR(1),     		-- Sexo del cliente
	Par_CURP                CHAR(18),     		-- CURP del cliente

	Par_RFC                 CHAR(13),     		-- RFC del Cliente
	Par_EstadoCivil         CHAR(2),     		-- Estado civil del cliente
	Par_TelefonoCel         VARCHAR(20) ,   	-- Telefono celular del cliente
	Par_Telefono            VARCHAR(20) ,   	-- Telefono fijo del cliente
	Par_Correo              VARCHAR(50),    	-- Correo electronico del cliente

	Par_RazonSocial         VARCHAR(150),   	-- Razon social del cliente
	Par_TipoSocID           INT(11),        	-- Tipo de sociedad
	Par_RFCpm               CHAR(13),     		-- RFC
	Par_GrupoEmp            INT(11),        	-- Grupo
	Par_Fax                 VARCHAR(30),    	-- Fax de contacto del cliente

	Par_OcupacionID         INT(11),        	-- Ocupacion ID del cliente
	Par_Puesto              VARCHAR(100),   	-- Puesto que ocupa el cliente
	Par_LugardeTrab         VARCHAR(100),   	-- Nombre de la empresa en la que trabaja el cliente
	Par_AntTra              FLOAT,        		-- Fecha y mes de antiguedad de trabajo del cliente
	Par_DomicilioTrabajo	VARCHAR(500),		-- Domicilio de trabajo del cliente
	Par_TelTrabajo          VARCHAR(20),    	-- Telefono de contacto de cliente

	Par_Clasific            CHAR(1),      		-- Clasificacion
	Par_MotivoApert         CHAR(1),      		-- Motivo de apertura de cuenta
	Par_PagaISR             CHAR(1),      		-- Paga ISR S:N
	Par_PagaIVA             CHAR(1),      		-- Paga IVA
	Par_PagaIDE             CHAR(1),      		-- Especifica si Cobra Impuesto de Depositos En Efectivo N=No S= Si

	Par_NivelRiesgo         CHAR(1),      		-- Nivel de riesgo
	Par_SecGeneral          INT(11),        	-- ID del sector general
	Par_ActBancoMX          VARCHAR(15),    	-- Actividad
	Par_ActINEGI            INT(11),        	-- Clave de la actividad economiva segun INEGI
	Par_SecEconomic         INT(11),        	-- Sector economico al que pertenece el cliente

	Par_ActFR         		BIGINT,       		-- Actividad Principal del Cte, segun la ACTIVIDADESFR
	Par_ActFOMUR        	INT(11),        	-- Actividad Fomur del Cte, segun la ACTIVIDADESFOMUR
	Par_PromotorIni         INT(11),        	-- ID del promotos Inicio
	Par_PromotorActual      INT(11),        	-- ID del promotor actual
	Par_ProspectoID       	INT(11),        	-- Id de prospecto del cliente en caso de serlo

	Par_EsMenorEdad         CHAR(1),      		-- El cliente es menor de edad S, N
	Par_CorpRelacionado     INT(11),        	-- Es el dato de corporativo relacionado a el cliente
	Par_RegistroHacienda    CHAR(1),      		-- Esta registrado en hacienda
	Par_NegocioAfiliadoID   INT(11),        	-- ID del negocio afiliado
	Par_InstitNominaID      INT(11),        	-- ID de la nomina afiliado

	Par_Observaciones       VARCHAR(500),   	-- Observaciones
	Par_NoEmpleado          VARCHAR(20),    	-- ID del empleado que dio de alta
	Par_TipoEmpleado        VARCHAR(1),     	-- Tipo de empleado que dio la alta
	Par_ExtTelefonoPart     VARCHAR(7),     	-- Extension del telefono particular
	Par_ExtTelefonoTrab     VARCHAR(7),     	-- Extencion del telefono de trabajo

	Par_EjecutivoCap        CHAR(5),      		-- Ejecutivo de captacion 0 No Asignado
	Par_PromotorExtInv      CHAR(5),      		-- Promotor Extreno de inversion 0 No Asignado
	Par_TipoPuesto          INT(11),       		-- Tipo de Puesto de Empleados Nomina
	Par_FechaIniTrabajo     DATE,       		-- Fecha de inicio en el trabajo actual
	Par_UbicaNegocioID      INT(11),      		-- ID de la ubicacion del negocio, relacion con CATUBICANEGOCIO

	Par_FEA           		VARCHAR(250),		-- Pais Asignado FEA
	Par_PaisFEA         	INT(11),			-- ID Pais Asignado FEA
	Par_FechaCons       	DATE,				-- Fecha constitucion RFC
	Par_PaisConstitucionID	INT(11),			-- Pais de constitucion campo para Personas Morales

	Par_CorreoAlterPM		VARCHAR(50),		-- Correo alternativo para Persona Moral
	Par_NombreNotario		VARCHAR(150),		-- Nombre del notario campo para Persona Morales
	Par_NumNotario			INT(11),			-- Numero del notario campo para Personas Morales
	Par_InscripcionReg		VARCHAR(50),		-- Numero de inscripcion en el registro publico campo para Personas Morales
	Par_EscrituraPubPM		VARCHAR(20),		-- Escritura Publica Persona Moral
	Par_PaisNacionalidad	INT(11),			-- Pais de nacionalidad del cliente

	Par_EmpresaID           INT(11),        	-- Empresa ID
	Par_Salida            	CHAR(1),      		-- Sucursal salida
	INOUT Par_NumErr      	INT(11),        	-- Numero de error
	INOUT Par_ErrMen      	VARCHAR(400),   	-- Mensaje de error

	INOUT   Par_ClienteID   INT(11),        	-- ClienteID que genero error
  /* Parametros de Auditoria */
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN
    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT(11);            -- Entero con valor cero
    DECLARE Salida_NO			CHAR(1);			-- Constante con valor NO (N)
    DECLARE Salida_SI           CHAR(1);			-- Constante con valor SI (S)
    DECLARE Tipo_MovReg			CHAR(2);			-- Tipo de movimiento para registro de cliernte en la bitracora
    DECLARE Var_CampoGenerico	INT(11);			-- Constante para Campo generico
    
    -- Declaracion de Variables
    DECLARE Var_Control       	VARCHAR(20);		-- Constante para la variable de control
    DECLARE Var_Consecutivo		INT(11);			-- Variable Valor Consecutivo
    DECLARE Var_UsuarioID		INT(11);			-- Numero de usuario
    
    -- Asignacion de valor a constantes
    SET Entero_Cero             := 0;               -- Entero con valor cero
    SET Salida_NO 				:= 'N';				-- Constante con valor NO (N)
    SET Salida_SI 				:= 'S';				-- Constante con valor SI (S)
    SET Tipo_MovReg				:= 'RC';
    SET Var_CampoGenerico		:= 0;				-- Campo generico

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr   := 999;
				SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-BANCLIENTESALT');
				SET Var_Control  := 'SQLEXCEPTION';
			END;
			
		SELECT 		UsuarioID
			INTO 	Var_UsuarioID
			FROM PROMOTORES
			WHERE PromotorID = Par_PromotorActual;
			
		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

	SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);
          IF(Par_Titulo = 'SRITA')  THEN 
          SET Par_Titulo := 'SRITA.' ;
          END IF;
	
		 IF(Par_Titulo = 'C.P')  THEN 
          SET Par_Titulo := 'C. P.' ;
          END IF;
	


		
		CALL CLIENTESALT(
			Par_SucursalOri,			Par_TipoPersona,			Par_Titulo,				Par_PrimerNom,			Par_SegundoNom,
			Par_TercerNom,				Par_ApellidoPat,			Par_ApellidoMat,		Par_FechaNac,			Par_LugarNac,
			Par_estadoID,				Par_Nacion,					Par_PaisResi,			Par_Sexo,				Par_CURP,	
			Par_RFC,					Par_EstadoCivil,			Par_TelefonoCel,		Par_Telefono,			Par_Correo,	
			Par_RazonSocial,			Par_TipoSocID,				Par_RFCpm,				Par_GrupoEmp,			Par_Fax,	
			Par_OcupacionID,			Par_Puesto,					Par_LugardeTrab,		Par_AntTra,				Par_DomicilioTrabajo,
			Par_TelTrabajo,				Par_Clasific,				Par_MotivoApert,		Par_PagaISR,			Par_PagaIVA,
			Par_PagaIDE,				Par_NivelRiesgo,			Par_SecGeneral,			Par_ActBancoMX,			Par_ActINEGI,	
			Par_SecEconomic,			Par_ActFR,					Par_ActFOMUR,			Par_PromotorIni,		Par_PromotorActual,
			Par_ProspectoID,			Par_EsMenorEdad,			Par_CorpRelacionado,	Par_RegistroHacienda,	Par_NegocioAfiliadoID,
			Par_InstitNominaID,			Par_Observaciones,			Par_NoEmpleado,			Par_TipoEmpleado,		Par_ExtTelefonoPart,
			Par_ExtTelefonoTrab,		Par_EjecutivoCap,			Par_PromotorExtInv,		Par_TipoPuesto,			Par_FechaIniTrabajo,
			Par_UbicaNegocioID,			Par_FEA,					Par_PaisFEA,			Par_FechaCons,			Par_PaisConstitucionID,	
			Par_CorreoAlterPM,			Par_NombreNotario,			Par_NumNotario,			Par_InscripcionReg,		Par_EscrituraPubPM,
			Par_PaisNacionalidad,		Par_EmpresaID,				Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_ClienteID,				Var_UsuarioID,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
		);
		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL BITACORAMOVSWSALT (
			Entero_Cero, 			Par_ClienteID, 			Tipo_MovReg,		Entero_Cero,			Entero_Cero,
			Par_PromotorActual, 	Entero_Cero,	 		Entero_Cero,		Salida_NO,				Par_NumErr,
			Par_ErrMen,				Par_EmpresaID, 			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal, 			Aud_NumTransaccion
		);


		SET Var_Control 	:= 'numero';
		SET Var_Consecutivo := LPAD(Par_ClienteID, 10, 0);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;

	IF(Par_Salida = Salida_NO) THEN
			SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
			SET Par_ErrMen := Par_ErrMen;
			SET Par_ClienteID := LPAD(Par_ClienteID, 10, 0);
	END IF;

END TerminaStore$$
