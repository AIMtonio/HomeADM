-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCLIENTESWSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCLIENTESWSACT`;DELIMITER $$

CREATE PROCEDURE `CRCBCLIENTESWSACT`(
	-- SP que actualiza Datos del Cliente mediante el WS de Actualiza Cliente de CREDICLUB =====
	Par_ClienteID			INT(11),			-- Numero del Cliente
    Par_TelefonoCelular		VARCHAR(20), 		-- Telefono Celular del Cliente
	Par_Telefono			VARCHAR(20), 		-- Telefono Oficial del Cliente
	Par_Correo				VARCHAR(50), 		-- Correo Electronico del Cliente
    Par_NumAct				TINYINT UNSIGNED,	-- Numero de Actualizacion

    Par_Salida				CHAR(1), 			-- Indica mensaje de Salida
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Descripcion de Error

	Par_EmpresaID		    INT(11),			-- Parametro de Auditoria
	Aud_Usuario			    INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		  	DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

 )
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estatus				CHAR(1);		-- Estatus del Cliente
    DECLARE Var_TelefonoCelular		VARCHAR(20);	-- Telefono Celular Actual del Cliente
	DECLARE Var_Telefono			VARCHAR(20);	-- Telefono Particular Actual del Cliente
    DECLARE Var_Correo				VARCHAR(50);	-- Correo Electronico Actual del Cliente
    DECLARE Var_EjecutaCierre		CHAR(1);		-- indica si se esta realizando el cierre de dia

	-- Declaracion de Constantes
	DECLARE Entero_Cero             INT(11);
    DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Fecha_Vacia             DATE;
    DECLARE SalidaSI                CHAR(1);

    DECLARE SalidaNO                CHAR(1);
    DECLARE SimbInterrogacion		VARCHAR(1);
    DECLARE Estatus_Inactivo    	CHAR(1);
    DECLARE ActualizaCte			INT(11);
	DECLARE ValorCierre				VARCHAR(30);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					 -- Entero Cero
	SET Cadena_Vacia		:= '';					 -- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   			 -- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		 -- Fecha Vacia
    SET SalidaSI           	:= 'S';        			 -- El Store SI genera una Salida

    SET	SalidaNO 	   	   	:= 'N';	      			 -- El Store NO genera una Salida
    SET SimbInterrogacion	:= '?';					 -- Simbolo de interrogacion
    SET Estatus_Inactivo    := 'I';          	 	 -- Estatus del Cliente: Inactivo
    SET ActualizaCte		:= 1;					 -- Consulta para Actualizar Datos del Cliente
    SET ValorCierre			:= 'EjecucionCierreDia';  -- INDICA SI SE REALIZA EL CIERRE DE DIA.

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
						'esto le ocasiona. Ref: SP-CRCBCLIENTESWSACT');
			END;

			SET Par_TelefonoCelular		:= REPLACE(Par_TelefonoCelular, SimbInterrogacion, Cadena_Vacia);
			SET Par_Telefono			:= REPLACE(Par_Telefono, SimbInterrogacion, Cadena_Vacia);
			SET Par_Correo				:= REPLACE(Par_Correo, SimbInterrogacion, Cadena_Vacia);
			SET Aud_Usuario				:= REPLACE(Aud_Usuario, SimbInterrogacion, Entero_Cero);
            SET Aud_Sucursal			:= REPLACE(Aud_Sucursal, SimbInterrogacion, Entero_Cero);

			SET Par_TelefonoCelular		:= IFNULL(Par_TelefonoCelular,Cadena_Vacia);
			SET Par_Telefono			:= IFNULL(Par_Telefono,Cadena_Vacia);
			SET Par_Correo				:= IFNULL(Par_Correo,Cadena_Vacia);

            SELECT 		TelefonoCelular,		Telefono,		Correo
				INTO 	Var_TelefonoCelular,	Var_Telefono,	Var_Correo
				FROM CLIENTES WHERE ClienteID = Par_ClienteID;


            SET Var_TelefonoCelular		:= IFNULL(Var_TelefonoCelular,Cadena_Vacia);
			SET Var_Telefono			:= IFNULL(Var_Telefono,Cadena_Vacia);
			SET Var_Correo				:= IFNULL(Var_Correo,Cadena_Vacia);
			SET Var_EjecutaCierre 		:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

			-- Validamos que no se este ejecutando el cierre de dia
			IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
				SET Par_NumErr  := 800;
				SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NumAct = ActualizaCte) THEN

				-- Se obtiene el Estatus del Cliente
				SET Var_Estatus		:= (SELECT Estatus FROM CLIENTES  WHERE ClienteID = Par_ClienteID);

                -- Se obtiene el Numero de Empresa
				SET Par_EmpresaID := (SELECT EmpresaDefault FROM PARAMETROSSIS LIMIT 1);

				IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr	:= 001;
					SET Par_ErrMen  := 'El Numero de Cliente esta Vacio.';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_Estatus =  Estatus_Inactivo)THEN
					SET Par_NumErr	:= 002;
					SET Par_ErrMen	:= 'El Cliente se Encuentra Inactivo.' ;
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT ClienteID
								FROM CLIENTES
								WHERE ClienteID = Par_ClienteID)THEN
					SET Par_NumErr	:= 003;
					SET Par_ErrMen	:= 'El Numero de Cliente No Existe.' ;
					LEAVE ManejoErrores;
				END IF;

                IF(Aud_Usuario = Entero_Cero)THEN
					SET Par_NumErr	:= 004;
					SET Par_ErrMen  := 'El Usuario esta Vacio.';
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS
								WHERE UsuarioID = Aud_Usuario) THEN
					SET Par_NumErr	:= 005;
					SET Par_ErrMen  := 'El Usuario No Existe.';
					LEAVE ManejoErrores;
				END IF;

				IF(Aud_Sucursal = Entero_Cero)THEN
					SET Par_NumErr	:= 006;
					SET Par_ErrMen  := 'La Sucursal esta Vacia.';
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES
								WHERE SucursalID = Aud_Sucursal) THEN
					SET Par_NumErr	:= 007;
					SET Par_ErrMen  := 'La Sucursal No Existe.';
					LEAVE ManejoErrores;
				END IF;

				-- Se obtiene la Fecha Actual
				SET Aud_FechaActual := NOW();

				UPDATE CLIENTES
					SET TelefonoCelular	= CASE WHEN Par_TelefonoCelular != Cadena_Vacia THEN Par_TelefonoCelular ELSE Var_TelefonoCelular END,
						Telefono    	= CASE WHEN Par_Telefono != Cadena_Vacia THEN Par_Telefono ELSE Var_Telefono END,
						Correo  		= CASE WHEN Par_Correo != Cadena_Vacia THEN Par_Correo ELSE Var_Correo END,

						EmpresaID		= Par_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual 	= Aud_FechaActual,
						DireccionIP 	= Aud_DireccionIP,
						ProgramaID  	= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion

					WHERE ClienteID    = Par_ClienteID;

				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := 'Cliente Modificado Exitosamente';
			END IF;

    END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
		 SELECT Par_NumErr	AS codigoRespuesta,
				Par_ErrMen  AS mensajeRespuesta;
	END IF;


 END TerminaStore$$