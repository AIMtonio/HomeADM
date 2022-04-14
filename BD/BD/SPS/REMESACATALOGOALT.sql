-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REMESACATALOGOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESACATALOGOALT`;
DELIMITER $$


CREATE PROCEDURE `REMESACATALOGOALT`(
	Par_Nombre				VARCHAR(200),
	Par_NombreCorto			VARCHAR(50),
	Par_CuentaCompleta		VARCHAR(25),
	Par_CentroCostos     	VARCHAR(30),

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


DECLARE Var_RemesaCatalogoID INT(11);
DECLARE Cons_Detalle 		CHAR(1);

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
									'esto le ocasiona. Ref: SP-REMESACATALOGOALT');
    END;


	IF(IFNULL(Par_Nombre,Cadena_Vacia)) = Cadena_Vacia THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '001' AS NumErr,
				 'El Nombre de la Remesadora esta Vacio.' AS ErrMen,
				 'nombre' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'El Nombre de la Remesadora esta Vacio.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_NombreCorto,Cadena_Vacia)) = Cadena_Vacia THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '002' AS NumErr,
				 'El Nombre Corto de la Remesadora esta Vacio.' AS ErrMen,
				 'nombreCorto' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'El Nombre Corto de la Remesadora esta Vacio.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_CuentaCompleta,Cadena_Vacia)) = Cadena_Vacia THEN
		if (Par_Salida = Salida_SI) THEN
			SELECT '003' AS NumErr,
				 'La Cuenta Contable esta Vacia.' AS ErrMen,
				 'CuentaContable' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'La Cuenta Contable esta Vacia.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;

	IF( NOT EXISTS (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaCompleta))  THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '004' AS NumErr,
				 'La Cuenta Contable no Existe.' AS ErrMen,
				 'cuentaCompleta' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'La Cuenta Contable no Existe.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;

	IF( NOT EXISTS (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaCompleta AND Grupo = Cons_Detalle))  THEN
		if (Par_Salida = Salida_SI) then
			SELECT '005' AS NumErr,
				 'La Cuenta Contable no es de Tipo Detalle.' AS ErrMen,
				 'cuentaCompleta' AS control,
				  0 AS consecutivo;
		ELSE
			SET	Par_NumErr := 5;
			SET	Par_ErrMen := 'La Cuenta Contable no es de Tipo Detalle.' ;
		END IF;
		LEAVE TerminaStore;
	END IF;
	CALL FOLIOSAPLICAACT('REMESACATALOGO', Var_RemesaCatalogoID);
	INSERT INTO REMESACATALOGO(
		RemesaCatalogoID,	Nombre,		NombreCorto,	CuentaCompleta,	CCostosRemesa,
        Estatus,			EmpresaID,	Usuario,		FechaActual,	DireccionIP,
		ProgramaID,			Sucursal,	NumTransaccion)
	VALUES(
		Var_RemesaCatalogoID,	Par_Nombre,		Par_NombreCorto,	Par_CuentaCompleta,	Par_CentroCostos,
        Estatus_Activo,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion
	);

 IF (Par_Salida = Salida_SI) THEN
 	SELECT  0 AS NumErr,
			CONCAT("Remesadora Agregada: ",CONVERT(Var_RemesaCatalogoID,CHAR)) AS ErrMen,
			'remesaCatalogoID' AS control,
			Var_RemesaCatalogoID AS consecutivo;
ELSE
			SET	Par_NumErr := 0;
			SET	Par_ErrMen := CONCAT("Remesadora Agregada: ",CONVERT(Var_RemesaCatalogoID,CHAR));
END IF;

 END;
END TerminaStore$$