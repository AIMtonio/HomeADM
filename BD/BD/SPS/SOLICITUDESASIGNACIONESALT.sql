DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDESASIGNACIONESALT`; 
DELIMITER $$

CREATE PROCEDURE `SOLICITUDESASIGNACIONESALT`(
	Par_UsuarioID				INT(11),		-- ID de Rol del Usuario
    Par_SolicitudCreditoID      INT(11),		-- ID de la solicitud de credito
	Par_TipoAsignacionID      	INT(11),		-- ID tipo de asignacion
	Par_ProductoID              INT(11),        -- ID del producto
	Par_AsignacionAuto          CHAR(1),        -- Indica si la solicitud paso por el proceso de asignacion analista automatico

	
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

	-- Declaracion de Variables
	DECLARE     Var_TipoAsignacionID int(11);      -- Id tipo se asignacion
	DECLARE		ConsecutivoID	     INT(11);      -- ID Analista asignacion
    DECLARE     Var_ProductoID       INT(11);      -- ID producto credito
    DECLARE 	Var_Control		     VARCHAR(100); -- Control de Retorno en pantalla
    DECLARE     Var_SolicitudID      int(11);      -- Verificar si el usuario ya esta asignado
	DECLARE     Var_FechaSis         DATE;         -- Fecha del sistema


	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	 CHAR(1);	-- cadena vacia
	DECLARE		Entero_Cero		 INT(11);	-- entero en cero
    DECLARE 	Salida_SI 		 CHAR(1);	-- Salida SI
    DECLARE     Entero_Uno       INT(11);   -- Entero uno
	DECLARE     Estatus_Asignada CHAR(1);   -- Entero uno
	DECLARE     Salida_NO            CHAR(1);      -- Salida no
    DECLARE     Est_Asignado       CHAR(1);      -- Estatus en Analisis

	-- Asignacion de Constantes
	SET	Cadena_Vacia	 := '';
	SET	Entero_Cero		 := 0;
	SET Var_Control		 := '';
	SET Salida_SI		 := 'S';
	SET	Entero_Uno		 := 1;
	SET Estatus_Asignada := 'A';
	SET Est_Asignado     := 'G';
	SET Salida_NO		 := 'N';




	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-SOLICITUDESASIGNACIONESALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Asignacion de Variables
		SET	ConsecutivoID	:= 0;

        SET Var_ProductoID:=Entero_Cero;

       -- Valida que el parametro usuario no se encuentre vacio
		IF(IFNULL(Par_UsuarioID, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 001;
			SET Par_ErrMen    := 'Campo usuario vacio.';
			SET Var_Control   := 'usuarioIDi';

			LEAVE ManejoErrores;
		END IF;

        -- Valida que el parametro no se encuentre vacio
		IF(IFNULL(Par_TipoAsignacionID, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 002;
			SET Par_ErrMen    := 'Tipo de asignacion vacio.';
			SET Var_Control   := 'tipoAsignacionID';

			LEAVE ManejoErrores;
		END IF;

        --  EXtrae al usuario en caso de existir en la tabla SOLICITUDESASIGNADAS
		SET Var_solicitudID:= (SELECT SolicitudCreditoID FROM SOLICITUDESASIGNADAS WHERE SolicitudCreditoID=Par_SolicitudCreditoID);

        --  Valida que el usuario no se encuentre en la tabla  SOLICITUDESASIGNADAS con una misma asignacion
        IF(IFNULL(Var_SolicitudID,Entero_Cero) <> Entero_Cero ) THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Solicitud ya asignada a un analista';
			SET Var_Control	:= 'usuarioIDi';
			LEAVE ManejoErrores;
		END IF;


		SET Var_TipoAsignacionID := (SELECT TipoAsignacionID FROM CATASIGNASOLICITUD WHERE TipoAsignacionID=Par_TipoAsignacionID);

        -- Valida el tipo de asignacion de que exista en el catalogo
		IF(IFNULL(Var_TipoAsignacionID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'El Tipo de asignacion no existe.';
			SET Var_Control	:= 'tipoAsignacionID';
			LEAVE ManejoErrores;
		END IF;



        --  Entero uno se refiere a que el tipo de asignacion es por producto.
		IF(Var_TipoAsignacionID = Entero_Uno) THEN

				IF(IFNULL(Par_ProductoID, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr      := 007;
					SET Par_ErrMen    := 'Producto credito vacio.';
					SET Var_Control   := 'productoID';

					LEAVE ManejoErrores;
				END IF;

				SET Var_ProductoID:= (SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoID);

	            -- Valida producto de credito
	   	        IF(IFNULL(Var_ProductoID,Entero_Cero) = Entero_Cero ) THEN 
					SET Par_NumErr  := 008;
					SET Par_ErrMen  := 'Producto de credito no existe';
					SET Var_Control	:= 'productoID';

					LEAVE ManejoErrores;
		        END IF; 


		         SET Var_ProductoID:= (SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Par_ProductoID AND RequiereAnalisiCre='S');

	            -- valida el producto de credito 
		        IF(IFNULL(Var_ProductoID,Entero_Cero) = Entero_Cero ) THEN 
					SET Par_NumErr  := 0079;
					SET Par_ErrMen  := 'Producto de credito no requiere analisis de credito';
					SET Var_Control	:= 'productoID';

					LEAVE ManejoErrores;
				END IF; 
		END IF;
		
        	  SET ConsecutivoID := (SELECT IFNULL(MAX(SolicitudAsignaID),Entero_Cero) + 1  FROM SOLICITUDESASIGNADAS);

		SET Aud_FechaActual := NOW();
        SET Var_FechaSis:=(SELECT FechaSistema FROM PARAMETROSSIS);
		 INSERT INTO SOLICITUDESASIGNADAS 
		            (SolicitudAsignaID,          UsuarioID,          SolicitudCreditoID,            TipoAsignacionID,             ProductoID,
					 AsignacionAuto,             FechaAsignacion,    Estatus,                       EmpresaID,                    Usuario,                    
				     FechaActual,                DireccionIP,        ProgramaID,                    Sucursal,                     NumTransaccion) 
                VALUES 
				    (ConsecutivoID,              Par_UsuarioID,      Par_SolicitudCreditoID,               Var_tipoAsignacionID,        Var_ProductoID,
					Par_AsignacionAuto,          Var_FechaSis,    Estatus_Asignada,                     Par_EmpresaID,                Aud_Usuario,                 
					Aud_FechaActual,             Aud_DireccionIP,    Aud_ProgramaID,                       Aud_Sucursal,                 Aud_NumTransaccion);

		CALL ESTATUSSOLCREDITOSALT(
		Par_SolicitudCreditoID,    Entero_Cero,          Est_Asignado,              Cadena_Vacia,            Cadena_Vacia,
		Salida_NO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,        
		Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,            Aud_NumTransaccion);	

		IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
		END IF;


		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen := 'Solicitud de Credito Asignado Exitosamente.';
	    SET Var_Control:= 'solicitudCreditoID';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$