-- APPWCUENTASDESTINOACT

DELIMITER ;

DROP PROCEDURE IF EXISTS APPWCUENTASDESTINOACT;

DELIMITER $$

CREATE PROCEDURE `APPWCUENTASDESTINOACT`(
	-- Store para actualizar un dato de un cliente destino en la app wallet
    Par_ClienteID                        INT(11),        -- ID Del cliente .
    Par_CuentaCLABE						 CHAR(18),       -- Clabe .
    Par_AliasCtaDestino                  VARCHAR(100),   -- Alias
    Par_MontoLimite                      DECIMAL(14,2),  -- MontoLimite .

    Par_Salida 					    	 CHAR(1),			    -- Parámetro que espera recibir por valor una “S” o una “N”
	INOUT Par_NumErr 			  		 INT(11), 			    -- Parámetro que dentro del sp recibe un numero de control de respuesta
	INOUT Par_ErrMen 			  		 VARCHAR(400), 			-- Parámetro que dentro del sp recibe un valor,De exito o error

    -- Parametros de Auditoria
      Par_EmpresaID				  		INT(11),			    -- Parametro de auditoria ID de la empresa
      Aud_Usuario				    	INT(11),			    -- Parametro de auditoria ID del usuario
      Aud_FechaActual			  		DATETIME,			    -- Parametro de auditoria Feha actual
      Aud_DireccionIP			  		VARCHAR(15),		  	-- Parametro de auditoria Direccion IP
      Aud_ProgramaID			  		VARCHAR(50),		  	-- Parametro de auditoria Programa
      Aud_Sucursal				  		INT(11),			    -- Parametro de auditoria ID de la sucursal
      Aud_NumTransaccion				BIGINT(20)		    	-- Parametro de auditoria Numero de la transaccion

)
TerminaStore: BEGIN

	 -- Declaracione de variables
    DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema
    DECLARE Var_Control 			VARCHAR(50); 	-- Control en Pantalla

    -- Declaracion de Constantes
    DECLARE	Cadena_Vacia			CHAR(1);
    DECLARE	Fecha_Vacia				DATE;
    DECLARE	Entero_Cero				INT;
    DECLARE SalidaSI				char(1);

    DECLARE NumeroUsuario     	  	INT;			-- Variable numero de usuario
    DECLARE N_Usuario     	  		INT;			-- Variable numero de usuario


    -- Asignacion de Constantes
    SET	Cadena_Vacia			:= '';				-- Cadena Vacia
    SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
    SET Entero_Cero				:= 0;				-- Entero en Cero
    SET SalidaSI				:='S';				-- Salida opcion SI

  ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
           BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									'esto le ocasiona. Ref: SP-APPWCUENTASDESTINOACT');
			SET Var_Control	:='SQLEXCEPTION';
    END;

     IF(Par_ClienteID = Cadena_Vacia)THEN
    SET Par_NumErr  :=1;
    SET Par_ErrMen  := "El ID del cliente esta vacio";
    SET Var_Control := Cadena_Vacia;
    LEAVE	ManejoErrores;
  END IF;


  IF(Par_ClienteID = Cadena_Vacia)THEN
    SET Par_NumErr  :=1;
    SET Par_ErrMen  := "La clabe del cliente esta vacio";
    SET Var_Control := Cadena_Vacia;
    LEAVE	ManejoErrores;
  END IF;

  IF(Par_AliasCtaDestino = Cadena_Vacia)THEN
    SET Par_NumErr  :=2;
    SET Par_ErrMen  := "El Alias esta vacio";
    SET Var_Control := Cadena_Vacia;
    LEAVE	ManejoErrores;
  END IF;

  IF(Par_MontoLimite = Cadena_Vacia)THEN
    SET Par_NumErr  :=4;
    SET Par_ErrMen  := "El monto de la transferencia esta vacio";
    SET Var_Control := Cadena_Vacia;
    LEAVE	ManejoErrores;
  END IF;

  SET Aud_FechaActual := CURRENT_TIMESTAMP();

  UPDATE CUENTASTRANSFER SET
    ClienteID			=	Par_ClienteID,
    Clabe		        =	Par_CuentaCLABE,
    Alias 	            =	Par_AliasCtaDestino,
    MontoLimite 		=	Par_MontoLimite,
    Usuario 			=	Aud_Usuario,
    FechaActual 		= 	Aud_FechaActual,
    DireccionIP 		= 	Aud_DireccionIP,
    ProgramaID			=	Aud_ProgramaID,
    Sucursal 			=	Aud_Sucursal,
    NumTransaccion		= 	Aud_NumTransaccion

     WHERE (ClienteID = Par_ClienteID);

        SET	Par_NumErr 	:= 0;
        SET	Par_ErrMen	:= "Usuario  actualizado exitosamente";

  END ManejoErrores;

  IF (Par_Salida = SalidaSI) THEN
  SELECT
    Par_NumErr	AS NumErr,
    Par_ErrMen 	AS ErrMen,
    Var_Control AS control,
    Par_UsuarioID AS consecutivo;
  END IF;
END  TerminaStore$$