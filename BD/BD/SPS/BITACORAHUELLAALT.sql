-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAHUELLAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAHUELLAALT`;DELIMITER $$

CREATE PROCEDURE `BITACORAHUELLAALT`(
-- SP PARA EL ALTA DE BITACORA DE HUELLLA EN EL USO DE LOS USUARIOS O CLIENTES
    Par_NumTransaccion     BIGINT,		-- NUMERO TRANSACCION DE LA OPERACION
    Par_TipoOperacion      INT(11),		-- TIPO DE OPERACION QUE SE REALIZO
    Par_DescriOperacion	   VARCHAR(200),	-- DESCRIPCION DE LA OPERACION REALIZADA
    Par_TipoUsuario        CHAR(1),		-- TIPO DE USUARIO (CLIENTE O USUARIO)
    Par_ClienteUsuario     INT(11),		-- ID DEL CLIENTE O USUARIO
    Par_Fecha              DATE,		-- FECHA QUE SE REALIZO LA OPERACION

    Par_CajaID             INT(11),		-- CAJA ID DE DONDE SE UTILIZO LA HUELLA DIGITAL
    Par_SucursalOperacion  INT(11),		-- SUCURSAL ID DONDE SE UTILIZO LA HUELLA DIGITAL
    Par_Salida             CHAR(1),		-- PARAMETRO DE SALIDA
    INOUT Par_NumErr       INT,			-- PARAMETRO DE NUMERO DE ERROR
    INOUT Par_ErrMen       VARCHAR(400),	-- PARAMETRO DE MENSAJE ERROR

    Par_EmpresaID          INT(11),		-- PARAMETRO DE AUDITORIA
    Aud_Usuario            INT(11),		-- PARAMETRO DE AUDITORIA
    Aud_FechaActual        DATETIME,		-- PARAMETRO DE AUDITORIA
    Aud_DireccionIP        VARCHAR(15),		-- PARAMETRO DE AUDITORIA
    Aud_ProgramaID         VARCHAR(50),  	-- PARAMETRO DE AUDITORIA

    Aud_Sucursal           INT(11),		-- PARAMETRO DE AUDITORIA
    Aud_NumTransaccion     BIGINT(20)		-- PARAMETRO DE AUDITORIA
)
TerminaStore:BEGIN


	DECLARE Cadena_Vacia    CHAR(1);		-- CADENA VACIA
	DECLARE Entero_Cero     INT(11);		-- ENTERO CERO
	DECLARE Var_Control     VARCHAR(50);		-- VARIABLE DE CONTROL
    DECLARE Str_SI			CHAR(1);	-- STRING DE SI
    DECLARE Fecha_Vacia		DATE;			-- FECHA VACIA

	SET Cadena_Vacia        := '';
	SET Entero_Cero         := 0;
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
	SET Par_NumErr  		:= 1;
	SET Par_ErrMen  		:= Cadena_Vacia;
    SET Str_SI				:= 'S';
    SET Fecha_Vacia			:= '1900-01-01';

    ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-BITACORAHUELLAALT');
				END;

	IF(IFNULL(Par_NumTransaccion,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Transaccion esta Vacio.';
			SET Var_Control  := 'numTransaccion' ;
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoOperacion,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Tipo de Operacion esta Vacio.';
			SET Var_Control  := 'tipoOperacion' ;
			LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_DescriOperacion,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Descripcion de la operacion esta Vacia.';
			SET Var_Control  := 'sucursal' ;
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoUsuario,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Tipo esta Vacio.';
			SET Var_Control  := 'tipo' ;
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClienteUsuario,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El Cliente esta Vacio.';
			SET Var_Control  := 'clienteID' ;
			LEAVE ManejoErrores;
	END IF;

    IF NOT EXISTS(SELECT ClienteID
				FROM CLIENTES
				WHERE ClienteID=Par_ClienteUsuario)THEN
		SET	Par_NumErr 	:= 5;
		SET	Par_ErrMen	:= CONCAT("El Cliente ",Par_ClienteUsuario,  "no Existe");
        SET Var_Control := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Fecha,Fecha_Vacia))= Fecha_Vacia THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'La Fecha esta Vacia.';
			SET Var_Control  := 'fecha' ;
			LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_SucursalOperacion,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Sucursal esta Vacia.';
			SET Var_Control  := 'sucursal' ;
			LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT SucursalID
				FROM SUCURSALES
				WHERE SucursalID=Par_SucursalOperacion)THEN
		SET	Par_NumErr 	:= 9;
		SET	Par_ErrMen	:= CONCAT("La Sucursal",Par_SucursalOperacion,"Indicada no Existe");
        SET Var_Control := 'sucursal' ;
        LEAVE ManejoErrores;
    END IF;

    INSERT INTO BITACORAHUELLA (
                    NumeroTransaccion,  	TipoOperacion,   	DescriOperacion,		TipoUsuario,    	 	ClienteUsuario,
                    Fecha,                  CajaID,         	SucursalOperacion, 		EmpresaID,				Usuario,
                    FechaActual,  			DireccionIP,        ProgramaID,       		Sucursal,  				NumTransaccion)
            VALUES  (
                    Par_NumTransaccion, 	Par_TipoOperacion,  Par_DescriOperacion,	Par_TipoUsuario,    Par_ClienteUsuario,
                    Par_Fecha,    			Par_CajaID,        	Par_SucursalOperacion, 	Par_EmpresaID, 		Aud_Usuario,
                    Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID,     	Aud_Sucursal, 		Aud_NumTransaccion);

		SET	Par_NumErr 	:= 0;
		SET	Par_ErrMen	:= CONCAT("Operacion realizada correctamente");

END ManejoErrores;
 IF (Par_Salida = Str_SI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;
END TerminaStore$$