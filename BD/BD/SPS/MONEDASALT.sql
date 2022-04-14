-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONEDASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONEDASALT`;DELIMITER $$

CREATE PROCEDURE `MONEDASALT`(
	Par_EmpresaID        	INT(11),
	Par_Descripcion      	VARCHAR(80),
	Par_DescriCorta      	VARCHAR(45),
	Par_Simbolo          	VARCHAR(45),
	Par_TipCamComVen     	DECIMAL(14,6),

	Par_TipCamVenVen     	DECIMAL(14,6),
	Par_TipCamComInt     	DECIMAL(14,6),
	Par_TipCamVenInt     	DECIMAL(14,6),
	Par_TipoMoneda       	CHAR(1),
	Par_TipCamFixCom     	DECIMAL(14,6),

	Par_TipCamFixVen     	DECIMAL(14,6),
	Par_TipCamDof        	DECIMAL(14,6),
	Par_EqCNBVUIF        	VARCHAR(3),
	Par_EqBuroCre        	VARCHAR(5),
	Par_MonedaCNBV          VARCHAR(5),

	Par_Salida           	CHAR(1),
	INOUT Par_NumErr     	INT(11),
	INOUT Par_ErrMen     	VARCHAR(400),
	/* Parametros de Auditoria */
	Aud_Usuario          	INT(11),
	Aud_FechaActual      	DATETIME,

	Aud_DireccionIP      	VARCHAR(15),
	Aud_ProgramaID       	VARCHAR(50),
	Aud_Sucursal         	INT(11),
	Aud_NumTransaccion   	BIGINT(20)
)
TerminaStore: BEGIN

DECLARE Var_FechaSistema	DATE;


DECLARE Entero_Cero			INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Flotante_cero   	DECIMAL(14,6);
DECLARE Var_MonedaId		INT(11);
DECLARE SalidaSI        	CHAR(1);
DECLARE SalidaNO        	CHAR(1);
DECLARE Var_Control			CHAR(15);

SET Entero_Cero 			:= 0;
SET Cadena_Vacia			:= '';
SET Fecha_Vacia				:= '1900-01-01';
SET Flotante_cero 			:= 0.0000;
SET SalidaSI        		:= 'S';
SET SalidaNO        		:= 'N';
SET Var_MonedaId 			:= 0;

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-MONEDASALT');
	    	SET Var_Control:= 'SQLEXCEPTION' ;
        END;

	IF(IFNULL(Par_EmpresaID, Entero_Cero)) = Entero_Cero THEN
	    SET Par_NumErr :='001';
	    SET Par_ErrMen := 'La Empresa esta vacia.';
	    SET Var_Control:= 'empresaID' ;
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
	    SET Par_NumErr :='002';
	    SET Par_ErrMen := 'La Descripcion esta vacia.';
	    SET Var_Control:= 'descripcion' ;
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DescriCorta, Cadena_Vacia)) = Cadena_Vacia THEN
	    SET Par_NumErr := '003';
	    SET Par_ErrMen := 'La Descripcion Corta esta vacia.';
	    SET Var_Control := 'descriCorta';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Simbolo, Cadena_Vacia)) = Cadena_Vacia THEN
	    SET Par_NumErr := '004';
	    SET Par_ErrMen := 'El Simbolo esta vacio.';
	    SET Var_Control := 'simbolo';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamComVen, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr := '005';
	    SET Par_ErrMen := 'El Tipo de Cambio de Compra en Ventanilla esta vacio.';
	    SET Var_Control := 'tipCamComVen';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamVenVen, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='007';
	    SET Par_ErrMen :='El Tipo de Cambio de Venta en Ventanilla esta vacio.';
	    SET Var_Control :='tipCamVenVen';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamComInt, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='008';
	    SET Par_ErrMen :='El Tipo de Cambio de Compra en Operaciones internas esta vacio.';
	    SET Var_Control :='tipCamComInt';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamVenInt, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='009';
	    SET Par_ErrMen :='El Tipo de Cambio de Venta en Operaciones internas esta vacio.';
	    SET Var_Control :='tipCamVenInt';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamFixCom, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='010';
	    SET Par_ErrMen :='El Tipo de Cambio de Compra Fix esta vacio.';
	    SET Var_Control :='tipCamFixCom';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamFixVen, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='011';
	    SET Par_ErrMen :='El Tipo de Cambio de Venta Fix esta vacio.';
	    SET Var_Control :='tipCamFixVen';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EqCNBVUIF, Cadena_Vacia)) = Cadena_Vacia THEN
	    SET Par_NumErr := '012';
	    SET Par_ErrMen := 'El Equivalente CNBV esta vacio.';
	    SET Var_Control := 'eqCNBVUIF';
	    LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipCamDof, Flotante_cero)) = Flotante_cero THEN
	    SET Par_NumErr :='013';
	    SET Par_ErrMen := 'El Tipo de Cambio DOF esta vacio.';
	    SET Var_Control := 'tipCamDof' ;
	    LEAVE ManejoErrores;
	END IF;

	SET Var_MonedaId		:= (SELECT IFNULL(MAX(MonedaId), 0) + 1 FROM MONEDAS);
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_FechaSistema	:= IFNULL(Var_FechaSistema, Fecha_Vacia);

	SET Aud_FechaActual := NOW();

	INSERT INTO MONEDAS(
		MonedaId,				EmpresaID,				Descripcion,			DescriCorta,			Simbolo,
		TipCamComVen,			TipCamVenVen,			TipCamComInt,			TipCamVenInt,			TipoMoneda,
		TipCamFixCom,			TipCamFixVen,			TipCamDof,				EqCNBVUIF,				EqBuroCred,
		MonedaCNBV,				FechaRegistro,			Usuario,				FechaActual,			DireccionIP,
		ProgramaID,				Sucursal,				NumTransaccion)
	VALUES(
		Var_MonedaId,			Par_EmpresaID,			Par_Descripcion,		Par_DescriCorta,		Par_Simbolo,
		Par_TipCamComVen,		Par_TipCamVenVen,		Par_TipCamComInt,		Par_TipCamVenInt,		Par_TipoMoneda,
		Par_TipCamFixCom,		Par_TipCamFixVen,		Par_TipCamDof,			Par_EqCNBVUIF,			Par_EqBuroCre,
		Par_MonedaCNBV,			Var_FechaSistema,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Divisa Agregada: ',Var_MonedaId);
	SET Var_Control := 'monedaId';

END ManejoErrores;  -- En del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_MonedaId AS consecutivo;
	END IF;
END TerminaStore$$