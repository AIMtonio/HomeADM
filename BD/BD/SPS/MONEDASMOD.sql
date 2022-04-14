-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONEDASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONEDASMOD`;
DELIMITER $$

CREATE PROCEDURE `MONEDASMOD`(
    Par_MonedaId                INT(11),
    Par_EmpresaID               INT(11),
    Par_Descripcion             VARCHAR(80),
    Par_DescriCorta             VARCHAR(45),
    Par_Simbolo                 VARCHAR(45),

    Par_TipCamComVen            DECIMAL(14,6),
    Par_TipCamVenVen            DECIMAL(14,6),
    Par_TipCamComInt            DECIMAL(14,6),
    Par_TipCamVenInt            DECIMAL(14,6),
    Par_TipoMoneda              CHAR(1),

    Par_TipCamFixCom            DECIMAL(14,6),
    Par_TipCamFixVen            DECIMAL(14,6),
    Par_TipCamDof               DECIMAL(14,6),
    Par_EqCNBVUIF               VARCHAR(3),
    Par_EqBuroCred              VARCHAR(5),

    Par_MonedaCNBV          	VARCHAR(5),
    /* Parametros de Auditoria */
    Par_Salida                  CHAR(1),
    INOUT Par_NumErr            INT(11),
    INOUT Par_ErrMen            VARCHAR(400),
    Aud_Usuario                 INT(11),

    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
)
TerminaStore: BEGIN

-- DELCARACION DE CONSTANTES
DECLARE Entero_Cero       		INT;
DECLARE Cadena_Vacia	  		CHAR(1);
DECLARE Flotante_cero     		DECIMAL(14,6);
DECLARE Fecha_Vacia				DATE;

DECLARE Var_MonedaId      		INT(11);
DECLARE Var_EmpresaID     		INT(11);
DECLARE Var_Descripcion   		VARCHAR(80);
DECLARE Var_DescriCorta   		VARCHAR(45);
DECLARE Var_Simbolo       		VARCHAR(45);
DECLARE Var_TipCamComVen  		DECIMAL(14,6);
DECLARE Var_TipCamVenVen  		DECIMAL(14,6);
DECLARE Var_TipCamComInt  		DECIMAL(14,6);
DECLARE Var_TipCamVenInt  		DECIMAL(14,6);
DECLARE Var_TipoMoneda    		CHAR(1);
DECLARE Var_TipCamFixCom  		DECIMAL(14,6);
DECLARE Var_TipCamFixVen  		DECIMAL(14,6);
DECLARE Var_TipCamDof     		DECIMAL(14,6);
DECLARE Var_EqCNBVUIF     		VARCHAR(3);
DECLARE Var_EqBuroCred    		VARCHAR(5);
DECLARE Var_FechaRegistro 		DATE;
DECLARE Var_Control       		VARCHAR(200);

DECLARE SalidaSI         		CHAR(1);
DECLARE SalidaNO         		CHAR(1);

-- ASINGAN VALORES A CONSTANTES
SET Entero_Cero             	:= 0;
SET Cadena_Vacia				:= '';
SET Flotante_cero           	:= 0.0000;
SET SalidaSI                	:= 'S';
SET SalidaNO                	:= 'N';
SET Fecha_Vacia					:= '1900-01-01';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-MONEDASMOD');
            SET Var_Control := 'SQLEXCEPTION';
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

	SET Aud_FechaActual := NOW();

	SET Var_FechaRegistro := (SELECT  FechaSistema FROM PARAMETROSSIS);

	CALL HISMONEDASALT(
		Par_MonedaId,		SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	UPDATE MONEDAS SET
		EmpresaID		= Par_EmpresaID,
		Descripcion		= Par_Descripcion,
		DescriCorta		= Par_DescriCorta,
		Simbolo			= Par_Simbolo,
		TipCamComVen	= Par_TipCamComVen,

		TipCamVenVen	= Par_TipCamVenVen,
		TipCamComInt	= Par_TipCamComInt,
		TipCamVenInt	= Par_TipCamVenInt,
		TipoMoneda		= Par_TipoMoneda,
		TipCamFixCom	= Par_TipCamFixCom,

		TipCamFixVen	= Par_TipCamFixVen,
		TipCamDof		= Par_TipCamDof,
		EqCNBVUIF		= Par_EqCNBVUIF,
		EqBuroCred		= Par_EqBuroCred,
		MonedaCNBV		= Par_MonedaCNBV,

		FechaRegistro	= Var_FechaRegistro,
		FechaActBanxico	= Fecha_Vacia,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,

		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE MonedaId = Par_MonedaId ;

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT("Se ha Modificado la Divisa: ",Par_MonedaId);
	SET Var_Control := 'monedaId';

 END ManejoErrores;  -- En del Handler de Errores

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_MonedaId AS consecutivo;
END IF;

END TerminaStore$$