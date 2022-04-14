-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAACCESOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAACCESOALT`;DELIMITER $$

CREATE PROCEDURE `BITACORAACCESOALT`(
# =====================================================================================
# ------- STORED PARA EL ALTA DE EN LA BITACORA LOS ACCESOS AL SAFI			  ---------
# =====================================================================================
    Par_SucursalID			BIGINT(12),			-- ID de la sucursal donde accede
    Par_ClaveUsuario		VARCHAR(45),		-- ID del usuario que accede
    Par_Perfil				INT(11),			-- Perfil del usuario(ROL)
    Par_AccesoIP			VARCHAR(20),		-- IP de usuario que accede
    Par_Recurso				VARCHAR(45),		-- Recurso al que accede el usuario

    Par_TipoAcceso			INT(11),			-- Tipo de acceso 1= Acceso exitoso, 2=Acceso fallido, 3= Acceso Recursos
    Par_TipoMetodo			VARCHAR(10),		-- Tipo de metodo del recurso get - post
    Par_DetalleAcceso		VARCHAR(500),		-- Detalle acceso del usuario

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen	  	VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha del sistema
    DECLARE Var_AccesoID		BIGINT(12);			-- ID de registro de acceso
    DECLARE Var_FechaAcceso		DATETIME;			-- Fecha y hora en la que accede
    DECLARE Var_UsuarioID		INT(11);			-- ID del usuario

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE AccesoRecursos     	INT(11);      		-- Tipo de acceso a recursos

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET AccesoRecursos        	:= 3;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-BITACORAACCESOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- VALIDACION PARA SOLO INSERTAR ACCESO A RECURSO DE OPCIONES MENU
        IF(Par_TipoAcceso = AccesoRecursos)THEN
			IF NOT EXISTS(SELECT Recurso FROM OPCIONESMENU WHERE Recurso = Par_Recurso)THEN
				SET Par_NumErr 		:= 0;
				SET Par_ErrMen 		:= 'Alta de Acceso Realizado Exitosamente: ';
				SET Var_Control		:= '';
                LEAVE ManejoErrores;
            END IF;

			SELECT UsuarioID
				INTO Var_UsuarioID
			FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario;

		ELSE
			SELECT UsuarioID, SucursalUsuario, RolID
				INTO Var_UsuarioID, Par_SucursalID, Par_Perfil
			FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario;
        END IF;


        SET Par_ClaveUsuario	:= IFNULL(Par_ClaveUsuario,Cadena_Vacia);
        SET Par_SucursalID 		:= IFNULL(Par_SucursalID,Entero_Cero);
        SET Par_Perfil 			:= IFNULL(Par_Perfil,Entero_Cero);
        SET Par_AccesoIP 		:= IFNULL(Par_AccesoIP,Cadena_Vacia);
        SET Par_Recurso 		:= IFNULL(Par_Recurso,Cadena_Vacia);
        SET Par_TipoAcceso 		:= IFNULL(Par_TipoAcceso,Entero_Cero);
        SET Par_TipoMetodo 		:= IFNULL(Par_TipoMetodo,Cadena_Vacia);
        SET Par_DetalleAcceso 	:= IFNULL(Par_DetalleAcceso,Cadena_Vacia);
        SET Var_UsuarioID 		:= IFNULL(Var_UsuarioID,Entero_Cero);
        SET Aud_DireccionIP 	:= IFNULL(Aud_DireccionIP,Cadena_Vacia);
        SET Aud_ProgramaID 		:= IFNULL(Aud_ProgramaID,'BITACORAACCESOALT');

        SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Var_FechaAcceso 	:= NOW();
		SET Aud_FechaActual		 := NOW();

		CALL FOLIOSAPLICAACT('BITACORAACCESO', Var_AccesoID);

        INSERT INTO `BITACORAACCESO`(
			AccesoID, 		Fecha, 				Hora, 				ClaveUsuario,		SucursalID,
            UsuarioID, 		Perfil, 			AccesoIP, 			Recurso, 		    TipoAcceso,
            TipoMetodo, 	DetalleAcceso,
			EmpresaID, 		Usuario, 			FechaActual, 		DireccionIP, 		ProgramaID,
			Sucursal, 		NumTransaccion
        )VALUES(
			Var_AccesoID,	DATE(Var_FechaAcceso),	date_format(Var_FechaAcceso,'%H:%i:%s'),Par_ClaveUsuario,Par_SucursalID,
            Var_UsuarioID,  Par_Perfil,			Par_AccesoIP,		Par_Recurso,        Par_TipoAcceso,
            Par_TipoMetodo, Par_DetalleAcceso,
            Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
        );


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Alta de Acceso Realizado Exitosamente: ';
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Var_AccesoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$