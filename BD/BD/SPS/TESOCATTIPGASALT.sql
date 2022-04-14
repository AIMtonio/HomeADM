-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCATTIPGASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOCATTIPGASALT`;DELIMITER $$

CREATE PROCEDURE `TESOCATTIPGASALT`(
-- Descripción
    Par_Descripcion 		VARCHAR(100), -- Descripción del producto
    Par_CuentaComple		VARCHAR(25),  -- Cuenta contable
	Par_CajaChica 			CHAR(1),      -- Caja de empresa
    Par_RepresentaActivo	CHAR(1),	  -- Valor que representa un activo
	Par_TipoActivoID		INT(11),	  --

	Par_Estatus				CHAR(1),	  -- Estatus del producto
    Par_Salida				CHAR(1),	  -- Parametro de salida
    INOUT Par_NumErr		INT(11),	  -- Retorna numero de Error
	INOUT Par_ErrMen		VARCHAR(400), -- Retorna Mensaje de Error

	Aud_EmpresaID			INT,		  -- Parametro de auditoria
	Aud_Usuario				INT,          -- Parametro de auditoria
	Aud_FechaActual			DATETIME,     -- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),  -- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),  -- Parametro de auditoria
	Aud_Sucursal			INT,          -- Parametro de auditoria
	Aud_NumTransaccion		BIGINT        -- Parametro de auditoriat

		)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE	tipoGasto			INT;          -- Indica tipo de gasto
DECLARE var_CuentaComple 	VARCHAR(25);  -- Varible para cuenta completa.
DECLARE VarControl          CHAR(15);     -- Variable para el campo donde retornara el puntero
DECLARE consecutivo         VARCHAR(50);  -- Variable para el valor para el ID

-- Declaracion de constantes
DECLARE Entero_Cero       	BIGINT;		  -- Constante para valor cero
DECLARE	Cadena_Vacia		CHAR(1);      -- Constante cadena vacia
DECLARE Con_Str_SI          CHAR(1);	  -- Constante para el valor SI
-- Asignacion de valore a variables
SET Entero_Cero 		:=	0;
SET Cadena_Vacia		:= '';
SET Con_Str_SI          :='S';

SET var_CuentaComple :=(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaComple);

ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						 'esto le ocasiona. Ref: SP-TESOCATTIPGASALT');
				SET VarControl = 'sqlException' ;
			END;


IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
		  SET Par_NumErr :=	001;
		  SET Par_ErrMen :='La Descripcion esta Vacia.';
		  SET VarControl :='descripcion';
		  LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_CuentaComple,Cadena_Vacia)) = Cadena_Vacia THEN
		 SET Par_NumErr :=002;
		 SET Par_ErrMen :='La Cuenta Contable esta Vacia';
		 SET Varcontrol :='cuentaCompleta';
		 LEAVE ManejoErrores;
END IF;
-- se agrego nueva condicion
IF(IFNULL(var_CuentaComple,Cadena_Vacia)) = Cadena_Vacia THEN
		 SET Par_NumErr :=003;
		 SET Par_ErrMen :='La Cuenta Contable no existe en el catalogo';
		 SET Varcontrol :='cuentaCompleta';
		 LEAVE ManejoErrores;
END IF;

IF(Par_RepresentaActivo = 'S')THEN
	IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = IFNULL(Par_TipoActivoID,Entero_Cero)) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'No Existe el Tipo de Activo';
		SET Varcontrol := 'tipoActivoID';
		LEAVE ManejoErrores;
    END IF;

	IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = IFNULL(Par_TipoActivoID,Entero_Cero) AND Estatus = "A") THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'El Tipo de Activo no esta Activo';
		SET Varcontrol := 'tipoActivoID';
		LEAVE ManejoErrores;
    END IF;
END IF;
	IF (Par_RepresentaActivo = 'N')THEN
		SET Par_TipoActivoID = IFNULL(Par_TipoActivoID,Entero_Cero);
    END IF;


SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET tipoGasto := (SELECT IFNULL(MAX(TipoGastoID),Entero_Cero) + 1
FROM TESOCATTIPGAS);


INSERT INTO TESOCATTIPGAS (
	TipoGastoID,		Descripcion,			CuentaCompleta, 	CajaChica,			RepresentaActivo,
	TipoActivoID,		Estatus,
    EmpresaID,			Usuario,				FechaActual,	    DireccionIP,		ProgramaID,
	Sucursal,			NumTransaccion
)VALUES(
	tipoGasto,			Par_Descripcion,		Par_CuentaComple, 	Par_CajaChica,		Par_RepresentaActivo,
	Par_TipoActivoID,	Par_Estatus,
    Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,		Aud_NumTransaccion);
SET Par_NumErr :=0;
SET Par_ErrMen :=CONCAT('Tipo de Gasto Registrado Exitosmente.',CONVERT(tipoGasto, CHAR));
SET Varcontrol :='tipoGastoID';
SET consecutivo :=tipoGasto;
END ManejoErrores;
IF(Par_Salida =Con_Str_SI) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		VarControl AS control,
		consecutivo AS consecutivo;
	END IF;

END TerminaStore$$