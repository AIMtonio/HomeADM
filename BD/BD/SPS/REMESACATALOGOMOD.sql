-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REMESACATALOGOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESACATALOGOMOD`;
DELIMITER $$


CREATE PROCEDURE `REMESACATALOGOMOD`(
	Par_RemesaCatalogoID	INT(11),
	Par_Nombre				VARCHAR(200),
	Par_NombreCorto			VARCHAR(50),
	Par_CuentaCompleta		VARCHAR(25),
	Par_CentroCostos     	VARCHAR(30),

	Par_Estatus				CHAR(2),			-- Estatus del Tipo de Servicio \nA.-Activo\n I.-Inactivo.
	Par_EmpresaID       	INT,
	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT,
	INOUT	Par_ErrMen  	VARCHAR(350),


	Aud_Usuario         	INT,
	Aud_FechaActual  	   	DATETIME,
	Aud_DireccionIP    	 	VARCHAR(15),
	Aud_ProgramaID   	   	VARCHAR(50),
	Aud_Sucursal        	INT,
	Aud_NumTransaccion  	BIGINT
	)

TerminaStore: BEGIN

DECLARE	Estatus_Activo		CHAR(1);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Salida_SI 			CHAR(1);
DECLARE Salida_NO 			CHAR(1);

DECLARE Cons_Detalle 		CHAR(1);

DECLARE ExisteCuenta 		VARCHAR(15);

SET	Estatus_Activo		:='A';
SET	Cadena_Vacia		:='';
SET	Fecha_Vacia			:='1900-01-01';
SET	Entero_Cero			:=0;
SET Salida_SI 			:='S';
SET Salida_NO 			:='N';
SET Cons_Detalle 		:='D';
SET Aud_FechaActual := CURRENT_TIMESTAMP();
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-REMESACATALOGOMOD');
    END;

   	IF(IFNULL(Par_RemesaCatalogoID,Entero_Cero)) = Entero_Cero THEN
		if (Par_Salida = Salida_SI) THEN
			SELECT '001' AS NumErr,
				 'El Numero de la Remesadora esta Vacio.' AS ErrMen,
				 'remesaCatalogoID' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'El Numero de la Remesadora esta Vacio.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_Nombre,Cadena_Vacia)) = Cadena_Vacia THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '002' AS NumErr,
				 'El Nombre de la Remesa esta Vacio.' AS ErrMen,
				 'nombre' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'El Nombre de la Remesa esta Vacio.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_NombreCorto,Cadena_Vacia)) = Cadena_Vacia THEN
		if (Par_Salida = Salida_SI) THEN
			SELECT '003' AS NumErr,
				 'El Nombre Corto de la Remesadora esta Vacio.' AS ErrMen,
				 'nombreCExisteCuentaorto' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'El Nombre Corto de la Remesadora esta Vacio.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_CuentaCompleta,Cadena_Vacia)) = Cadena_Vacia THEN
		if (Par_Salida = Salida_SI) THEN
			SELECT '004' AS NumErr,
				 'La Cuenta Contable esta Vacia.' AS ErrMen,
				 'cuentaCompleta' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'La Cuenta Contable esta Vacia.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;

	IF( NOT EXISTS (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaCompleta))  THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '005' AS NumErr,
				 'La Cuenta Contable no Existe.' AS ErrMen,
				 'cuentaCompleta' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 5;
			SET	Par_ErrMen := 'La Cuenta Contable no Existe.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;
	IF( NOT EXISTS (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaCompleta AND Grupo = Cons_Detalle))  THEN
		if (Par_Salida = Salida_SI) THEN
			SELECT '006' AS NumErr,
				 'La Cuenta Contable no es de Tipo Detalle.' AS ErrMen,
				 'cuentaCompleta' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 6;
			SET	Par_ErrMen := 'La Cuenta Contable no es de Tipo Detalle.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;

    UPDATE REMESACATALOGO  SET
	Nombre			= Par_Nombre,
	NombreCorto		= Par_NombreCorto,
	CuentaCompleta	= Par_CuentaCompleta,
	CCostosRemesa 	= Par_CentroCostos,
    Estatus			= Par_Estatus,

	EmpresaID		= Par_EmpresaID,
	Usuario			= Aud_Usuario,
	FechaActual		= Aud_FechaActual,
	DireccionIP		= Aud_DireccionIP,
	ProgramaID		= Aud_ProgramaID,
	Sucursal 			= Aud_Sucursal,
	NumTransaccion 	= Aud_NumTransaccion
	WHERE RemesaCatalogoID = Par_RemesaCatalogoID;

 IF (Par_Salida = Salida_SI) THEN
 	SELECT  0 AS NumErr,
			CONCAT("Remesadora Modificada: ",CONVERT(Par_RemesaCatalogoID,CHAR)) AS ErrMen,
			'remesaCatalogoID' AS control,
			Par_RemesaCatalogoID AS consecutivo;
ELSE
			SET	Par_NumErr	:= 0;
			SET	Par_ErrMen	:= CONCAT("Remesadora Modificada: ",CONVERT(Par_RemesaCatalogoID,CHAR)) ;
END IF;

 END;
END TerminaStore$$