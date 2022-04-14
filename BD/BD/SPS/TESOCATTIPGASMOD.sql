-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCATTIPGASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOCATTIPGASMOD`;DELIMITER $$

CREATE PROCEDURE `TESOCATTIPGASMOD`(
	Par_TipoGastoID		INT(11),
	Par_Descripcion 	VARCHAR(100),
	Par_CuentaComple	VARCHAR(25),
	Par_CajaChica		CHAR(1),
    Par_RepresentaActivo	CHAR(1),

	Par_TipoActivoID		INT(11),
	Par_Estatus				CHAR(1),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Entero_Cero       	INT;
DECLARE Decimal_Cero      	DECIMAL(12,2);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE var_CuentaComple 	VARCHAR(25);
DECLARE tipoGasto    		INT;



-- Declaracion de constantes
SET Entero_Cero 	:=0;
SET Cadena_Vacia	:= '';
SET Decimal_Cero 	:=0.00;
SET tipoGasto 		:= (SELECT TipoGastoID  FROM TESOCATTIPGAS WHERE TipoGastoID=Par_TipoGastoID);

SET var_CuentaComple :=(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaComple);

IF(NOT EXISTS(SELECT TipoGastoID
			FROM TESOCATTIPGAS
			WHERE TipoGastoID = Par_TipoGastoID)) THEN
	SELECT '001' AS NumErr,
		 'El Tipo de Gasto no existe.' AS ErrMen,
		 'tipoGastoID' AS control,
		  Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_TipoGastoID,Entero_Cero)) = Entero_Cero THEN
	SELECT '002' AS NumErr,
		 'El Tipo de Gasto esta vacio.' AS ErrMen,
		 'tipoGastoID' AS control,
		  Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '003' AS NumErr,
		 'La Descripcion esta Vacia.' AS ErrMen,
		 'descripcion' AS control,
		  Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;
IF(IFNULL(Par_CuentaComple,Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '004' AS NumErr,
		 'La Cuenta Contable esta Vacia.' AS ErrMen,
		 'cuentaCompleta' AS control,
		  Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;
IF(IFNULL(var_CuentaComple,Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '005' AS NumErr,
		 'La cuenta contable no existe.' AS ErrMen,
		 'descripcion' AS control,
		  Entero_Cero AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(Par_RepresentaActivo = 'S')THEN
	IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID) THEN
		SELECT '006' AS NumErr,
		 'No Existe el Tipo de Activo' AS ErrMen,
		 'tipoActivoID' AS control,
		  Cadena_Vacia AS consecutivo;

    END IF;

	IF NOT EXISTS(SELECT TipoActivoID FROM TIPOSACTIVOS WHERE TipoActivoID = Par_TipoActivoID AND Estatus = "A") THEN
		SELECT '007' AS NumErr,
		 'El Tipo de Activo no esta Activo' AS ErrMen,
		 'tipoActivoID' AS control,
		  Cadena_Vacia AS consecutivo;

    END IF;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();


UPDATE TESOCATTIPGAS  SET

Descripcion		= Par_Descripcion,
CuentaCompleta  	= Par_CuentaComple,
CajaChica		=Par_CajaChica,
RepresentaActivo = Par_RepresentaActivo,
TipoActivoID	= Par_TipoActivoID,
Estatus			= Par_Estatus,

EmpresaID		= Aud_EmpresaID,
Usuario			= Aud_Usuario,
FechaActual		= Aud_FechaActual,
DireccionIP		= Aud_DireccionIP,
ProgramaID		= Aud_ProgramaID,
Sucursal			= Aud_Sucursal,
NumTransaccion 	= Aud_NumTransaccion
WHERE TipoGastoID = Par_TipoGastoID;


SELECT '000' AS NumErr ,

		  CONCAT('Tipo de Gasto Modificado Exitosamente.',tipoGasto) AS ErrMen,
		  'tipoGastoID' AS control,
			Par_TipoGastoID AS Consecutivo;

END TerminaStore$$