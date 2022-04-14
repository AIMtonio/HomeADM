DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNACIONSOLICITUDESPRO`; 
DELIMITER $$


CREATE  PROCEDURE `ASIGNACIONSOLICITUDESPRO`(
	Par_SolicitudCreditoID		INT(11),		-- Parametro de entrada con el numero de la solicitud del credito
	Par_UsuarioExcluir          INT(11),        -- Parametro de usuario a excluir en el proceso


	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
		)
TerminaStore: BEGIN



-- Declaracion de constantes
DECLARE Entero_Uno              INT(11);   -- Entero 1
DECLARE Entero_Dos              INT(11);   -- Entero 2
DECLARE Entero_Tres             INT(11);   -- Entero 3
DECLARE Entero_Cuatro           INT(11);   -- Entero 4
DECLARE Entero_Cinco            INT(11);   -- Entero 5
DECLARE Salida_SI    	        CHAR(1);   -- Salida si
DECLARE SI_ProcesoAuto          CHAR(1);   -- Si es parte de un proceso automatico de asignacion de solicitud de credito
DECLARE Entero_Cero		        INT(1);    -- Entero cero
DECLARE Estatus_Activo	        CHAR(1);   -- Estatus activo    
DECLARE Salida_NO               CHAR(1);   -- Salida no
DECLARE Cadena_Vacia            CHAR(1);   -- CAdena vacia


-- Declaracion de variables
DECLARE Var_UsuarioID           INT(11);        -- Variable usuario id
DECLARE Par_NumErr              INT;            -- Par error
DECLARE Par_ErrMen              VARCHAR(400);   -- Par mensaje error
DECLARE Var_numeroAnalistas     INT(11);        -- Numero de analistas
DECLARE Var_ProducCreditoID     INT(11);        -- Producto de credito
DECLARE Var_TipoCredito			CHAR(1);        -- Tipo de credito
DECLARE Var_EsRiesgoComun       CHAR(1);        -- Valida si es de tipo riesgo comun
DECLARE Var_TipoGarantiaID      INT(11);        -- Valida tipo de garantia Hipotecaria 
DECLARE Var_TipoAsignacion      INT(11);        -- Valida el tipo de asignacion sobre el catalogo CATASIGNASOLICITUD
DECLARE Var_ProductoID          INT(11);        -- Valida el producto de credito sobre el tipo de asignacion
DECLARE Var_TipoAsignacionPr    INT(11);        -- Valida el tipo de asignacion de la forma parametrizable
DECLARE Var_Hora		        TIME;	        -- Control de Retorno en pantalla
DECLARE Var_SucursalID          INT(11);        -- ID de la sucursal en donde se libera la solicitud
DECLARE Var_DifMatriz           INT(11);
 
SET Cadena_Vacia            := '';
SET Entero_Cero		        := 0;
SET Estatus_Activo       	:= 'A';
SET Salida_NO		        := 'N';
SET Salida_SI               := 'S';	
SET SI_ProcesoAuto          := 'S';
SET Entero_Uno              := 1;
SET Entero_Dos              := 2;
SET Entero_Tres             := 3;
SET Entero_Cuatro           := 4;
SET Entero_Cinco            := 5;	

ManejoErrores:BEGIN 

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP- ASIGNACIONSOLICITUDESPRO.');
	END;

	SELECT 	Pro.ProducCreditoID, Sol.TipoCredito
			INTO 	Var_ProducCreditoID,Var_TipoCredito
			FROM PRODUCTOSCREDITO Pro,
				SOLICITUDCREDITO Sol
			WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
			AND Sol.solicitudCreditoID = Par_SolicitudCreditoID;

	SELECT Estatus
			INTO Var_EsRiesgoComun
			FROM RIESGOCOMUNCLICRE
			WHERE 	SolicitudCreditoID = Par_SolicitudCreditoID LIMIT 1;

    SELECT  Gar.TipoGarantiaID
			INTO  Var_TipoGarantiaID
			FROM GARANTIAS   Gar
			LEFT JOIN  ASIGNAGARANTIAS Gas
			ON Gar.GarantiaID = Gas.GarantiaID,
			TIPOGARANTIAS    Tga
			WHERE Gar.TipoGarantiaID =  Tga.TipoGarantiasID 	AND Gas.SolicitudCreditoID =Par_SolicitudCreditoID ORDER BY Gar.TipoGarantiaID LIMIT 1;

	SET Var_TipoGarantiaID := IFNULL(Var_TipoGarantiaID,Entero_Cero);
	SET Var_TipoAsignacionPr:=Entero_Uno;
	SET Var_ProductoID:=Entero_Cero;

		-- Restructura 
	IF(Var_TipoCredito= 'R') THEN
		SET Var_TipoAsignacionPr:=Entero_Dos;
		-- Riesgo Comun
		ELSE IF(IFNULL(Var_EsRiesgoComun,Cadena_Vacia)<>Cadena_Vacia)THEN
			    SET Var_TipoAsignacionPr:=Entero_Tres;
			-- Personas Relacionadas
			ELSE IF(Var_TipoCredito= 'R') THEN 
					SET Var_TipoAsignacionPr:=Entero_Cuatro;
				-- Garantia Hipotecaria
				ELSE IF(Var_TipoGarantiaID=Entero_Tres) THEN
					    SET Var_TipoAsignacionPr:=Entero_Cinco;
					-- Por Producto
					    ELSE
						SET Var_ProductoID:=Var_ProducCreditoID;
				END IF;
			END IF;
		END IF;	
	END IF;	

    SET Var_DifMatriz:=(SELECT DifHorarMatriz FROM SUCURSALES WHERE SucursalID=Aud_Sucursal);
	SET Var_DifMatriz:= (IFNULL(Var_DifMatriz,Entero_Cero));
    SET Var_Hora       := (SELECT DATE_FORMAT(NOW( ), "%H:%i:%S" ));
    SET Var_SucursalID := (SELECT SucursalID FROM SUCURSALES WHERE Var_Hora BETWEEN  HoraInicioOper AND HoraFinOper AND SucursalID=Aud_Sucursal);
	SET Var_SucursalID :=(IFNULL(Var_SucursalID,Entero_Cero));

	   	-- DELETE LOS TEMPORALES CON EL NUMERO DE TRANSACCION 
	DELETE FROM  TMPUSUARIOSSOLICITUDES WHERE NumTransaccion=Aud_NumTransaccion;
	DELETE FROM  TMPUSUARIOSACTANALISIS  WHERE NumTransaccion=Aud_NumTransaccion;

    -- Extraer el tipo de asignacion en la tabla ANALISTASASIGNACION
    SET Var_tipoAsignacion:= (SELECT TipoAsignacionID FROM ANALISTASASIGNACION WHERE TipoAsignacionID=Var_TipoAsignacionPr AND ProductoID=Var_ProductoID LIMIT 1);


    -- Validar el tipo asignacion tiene por lo menos un analista designado para su revision.
    IF(IFNULL(Var_tipoAsignacion,Entero_Cero)) <> Entero_Cero AND Var_SucursalID<>Entero_Cero  THEN

		    -- Extrae todos los usuarios con el tipo de asignacion correspondiente.
		    INSERT INTO TMPUSUARIOSACTANALISIS
			( UsuarioID,NombreCompleto,NumTransaccion)
			SELECT  Sol.UsuarioID,Usu.NombreCompleto,Aud_NumTransaccion
			FROM    ANALISTASASIGNACION Sol
			INNER JOIN USUARIOS Usu ON Usu.UsuarioID=Sol.UsuarioID
			WHERE Sol.TipoAsignacionID  = Var_tipoAsignacion AND Sol.ProductoID=Var_ProductoID AND Usu.EstatusAnalisis=Estatus_Activo AND Sol.UsuarioID<>Par_UsuarioExcluir;


            SET Var_numeroAnalistas:=(SELECT count(*) FROM TMPUSUARIOSACTANALISIS WHERE NumTransaccion=Aud_NumTransaccion);

			-- Valida que existan analistas activos, en caso contrario envia la solicitud de credito a un analista virtual
			IF(IFNULL(Var_numeroAnalistas, Entero_Cero)) = Entero_Cero THEN
				CALL SOLICITUDESASIGNACIONESALT(Entero_Cero,        Par_SolicitudCreditoID,          Var_TipoAsignacionPr,          Var_ProductoID,       SI_ProcesoAuto,
												Salida_NO,          Par_NumErr,			             Par_ErrMen,			        Par_EmpresaID,        Aud_Usuario,	       
												Aud_FechaActual,    Aud_DireccionIP,    	         Aud_ProgramaID,		        Aud_Sucursal,         Aud_NumTransaccion);
				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;
			ELSE
				-- Extrae todos los usuarios con el tipo de asignacion correspondiente y realiza el conteo del numero de solicitudes sin importar el tipo de asignacion.
				INSERT INTO TMPUSUARIOSSOLICITUDES
					( UsuarioID,                NumSolicitudes,                                                         NombreCompleto,                 NumTransaccion )
				SELECT  Usu.UsuarioID,            IFNULL(count(Sol.SolicitudCreditoID),Entero_Cero) AS totalSolicitudes,  Usu.NombreCompleto,             Aud_NumTransaccion 
				FROM    TMPUSUARIOSACTANALISIS  Usu
				LEFT   JOIN SOLICITUDESASIGNADAS  Sol ON Usu.UsuarioID=Sol.UsuarioID
				WHERE  Usu.NumTransaccion=Aud_NumTransaccion
				 GROUP BY Usu.UsuarioID,Usu.NombreCompleto;
			
				-- Extrae al usuario con menos solicitudes asignadas
				SET Var_UsuarioID=(SELECT UsuarioID FROM TMPUSUARIOSSOLICITUDES WHERE NumTransaccion=Aud_NumTransaccion  ORDER BY NumSolicitudes,NombreCompleto ASC LIMIT 1);

				CALL SOLICITUDESASIGNACIONESALT(Var_UsuarioID,        Par_SolicitudCreditoID,          Var_TipoAsignacionPr,          Var_ProductoID,       SI_ProcesoAuto,
												Salida_NO,            Par_NumErr,			           Par_ErrMen,			          Par_EmpresaID,        Aud_Usuario,	       
												Aud_FechaActual,      Aud_DireccionIP,    	           Aud_ProgramaID,		          Aud_Sucursal,         Aud_NumTransaccion);
				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

			END IF;

      
    ELSE 
        -- Almacena regsitro con el usuario VIRTUAL
	CALL SOLICITUDESASIGNACIONESALT(Entero_Cero,        Par_SolicitudCreditoID,          Var_TipoAsignacionPr,          Var_ProductoID,       SI_ProcesoAuto,
                                    Salida_NO,          Par_NumErr,			             Par_ErrMen,			        Par_EmpresaID,        Aud_Usuario,	       
                                    Aud_FechaActual,    Aud_DireccionIP,    	         Aud_ProgramaID,		        Aud_Sucursal,         Aud_NumTransaccion);
		IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
		END IF;
          
    END IF;	

	-- DELETE LOS TEMPORALES CON EL NUMERO DE TRANSACCION 
	DELETE FROM  TMPUSUARIOSSOLICITUDES WHERE NumTransaccion=Aud_NumTransaccion;
	DELETE FROM  TMPUSUARIOSACTANALISIS  WHERE NumTransaccion=Aud_NumTransaccion;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Proceso Asignacion Exitoso.';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$