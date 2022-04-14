DELIMITER ;
DROP PROCEDURE IF EXISTS `ANALISTASASIGNACIONALT`; 
DELIMITER $$

CREATE PROCEDURE `ANALISTASASIGNACIONALT`(
	Par_UsuarioID				INT(11),		-- ID de Rol del Usuario
	Par_TipoAsignacionID      	INT(11),		-- ID tipo de asignacion
	Par_ProductoID              INT(11),        -- ID del producto
	
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
	DECLARE     Var_UsuarioID	     INT(11);    -- Id del Usuario
	DECLARE     Var_TipoAsignacionID INT(11);    -- Id tipo se asignacion
	DECLARE		ConsecutivoID	     INT(11);		-- ID Analista asignacion
    DECLARE     Var_ProductoID       INT(11);    -- ID producto credito
    DECLARE 	Var_Control		VARCHAR(100);	 -- Control de Retorno en pantalla
    DECLARE     Var_usuarioExist      INT(11);   -- Verificar si el usuario ya esta asignado
    DECLARE     EsAnalista      CHAR(1);         -- ES Analista
	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
	DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
	DECLARE		Entero_Cero		INT(11);	-- entero en cero
    DECLARE 	Salida_SI 		CHAR(1);	-- Salida SI
    DECLARE     Entero_Uno       INT(11);   -- Entero uno
    DECLARE     Tipo_Analista         CHAR(1);   -- Tipo Analista

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Var_Control		:= '';
	SET Salida_SI		:= 'S';
	SET	Entero_Uno		:= 1;
	SET Tipo_Analista   :='A';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-ANALISTASASIGNACIONALT');
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
			SET Par_ErrMen    := 'Tipo de asignacion està vacio.';
			SET Var_Control   := 'tipoAsignacionID';

			LEAVE ManejoErrores;
		END IF;
       --  


       -- Extrae el usuario en la tabla USUARIOS y el tipo de asignacio en la tabla CATASIGNASOLICITUD
		SET Var_UsuarioID		 := (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Par_UsuarioID);
		SET Var_TipoAsignacionID := (SELECT TipoAsignacionID FROM CATASIGNASOLICITUD WHERE TipoAsignacionID=Par_TipoAsignacionID);

	    -- Valida al usuario
  		IF(IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Usuario no existe.';
			SET Var_Control	:= 'usuarioIDi';

			LEAVE ManejoErrores;
		END IF;

        -- seteea con A en caso de que el usuario sea de tipo analista
		SET EsAnalista:=(SELECT P.TipoPerfil  FROM USUARIOS U INNER JOIN PERFILESANALISTAS P ON U.RolID=P.RolID 
			                    WHERE P.TipoPerfil=Tipo_Analista AND U.UsuarioID=Var_UsuarioID);


        -- Valida que el usuario sea de tipo analista
        IF(IFNULL(EsAnalista,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'El usuario no es un analista de credito';
			SET Var_Control	:= 'usuarioIDi';
			LEAVE ManejoErrores;
		END IF;

        --  EXtrae al usuario en caso de existir en la tabla ANALISTASASIGNACION
		SET Var_usuarioExist:= (SELECT UsuarioID FROM ANALISTASASIGNACION WHERE UsuarioID=Par_UsuarioID AND TipoAsignacionID=Par_TipoAsignacionID AND ProductoID=Par_ProductoID);

        --  Valida que el usuario no se encuentre en la tabla  ANALISTASASIGNACION con una misma asignacion
        IF(IFNULL(Var_usuarioExist,Entero_Cero) <> Entero_Cero ) THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'Analista ya asignado';
			SET Var_Control	:= 'usuarioIDi';
			LEAVE ManejoErrores;
		END IF;


        -- Valida el tipo de asignacion de que exista en el catalogo
		IF(IFNULL(Var_TipoAsignacionID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'El Tipo de asignacion no existe.';
			SET Var_Control	:= 'tipoAsignacionID';
			LEAVE ManejoErrores;
		END IF;



       --  Entero uno se refiere a que el tipo de asignacion es por producto y por el cual entra en la condicion.
		IF(Var_TipoAsignacionID = Entero_Uno) THEN

				IF(IFNULL(Par_ProductoID, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr      := 007;
					SET Par_ErrMen    := 'Producto credito està vacio.';
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
		
		SET ConsecutivoID := (SELECT IFNULL(MAX(AnalistasAsigID),Entero_Cero) + 1  FROM ANALISTASASIGNACION);


	


		SET Aud_FechaActual := NOW();

		INSERT INTO ANALISTASASIGNACION (
			AnalistasAsigID,	        UsuarioID,                  TipoAsignacionID,		   ProductoID,                      FechaAsignacion, 
		    EmpresaID,			    	Usuario,					FechaActual,				DireccionIP,				    ProgramaID,		
		    Sucursal,				    NumTransaccion		)
		VALUES(
			ConsecutivoID,				Var_UsuarioID,				Var_TipoAsignacionID,       Var_ProductoID,                 Aud_FechaActual ,
			Par_EmpresaID,			    Aud_Usuario,		    	Aud_FechaActual,			Aud_DireccionIP,		    	Aud_ProgramaID,			
		    Aud_Sucursal,			    Aud_NumTransaccion		);


		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;



		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen := 'Catalogo Asignacion Grabado Exitosamente.';
	    SET Var_Control:= 'tipoAsignacionID';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$