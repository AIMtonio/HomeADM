-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `IMPUESTOSMOD`;
DELIMITER $$


CREATE PROCEDURE `IMPUESTOSMOD`(

    Par_ImpuestoID      INT(11),
    Par_Descripcion     VARCHAR(70),
    Par_DescripCorta    VARCHAR(10),
    Par_Tasa            DECIMAL(12,4),
    Par_GravaRetiene    CHAR(1),
    Par_BaseCalculo     CHAR(1),
    Par_ImpuestoCalculo INT(11),
    Par_CtaEnTransito   VARCHAR(25),
    Par_CtaRealizado    VARCHAR(25),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(350),

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

    )

TerminaStore: BEGIN


DECLARE  Entero_Cero       INT;
DECLARE  Decimal_Cero      DECIMAL(12,2);
DECLARE  Cadena_Vacia      CHAR(1);
DECLARE  Salida_SI         CHAR(1);
DECLARE  Salida_NO         CHAR(1);
DECLARE  Var_Control       VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);


SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := '999';
                    SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                             'esto le ocasiona. Ref: SP-IMPUESTOSMOD');
                    SET Var_Control := 'sqlException' ;
                END;



IF(NOT EXISTS(SELECT ImpuestoID
            FROM IMPUESTOS
            WHERE ImpuestoID = Par_ImpuestoID)) THEN
        SET Par_NumErr := 001;
        SET Par_ErrMen := 'El Impuesto no existe.';
        SET Var_Control:= 'impuestoID';
    LEAVE ManejoErrores;
END IF;

-- valida la Cuenta Constable Tránsito
CALL CUENTASCONTABLESVAL(	Par_CtaEnTransito,	Salida_NO,		    Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
							Aud_NumTransaccion);
-- Validamos la respuesta
IF(Par_NumErr <> Entero_Cero) THEN
	SET Par_NumErr := 002;
    SET Par_ErrMen := concat(Par_ErrMen, ', Cuenta en Tránsito');
	SET Var_Control:= 'ctaEnTransito' ;
    LEAVE ManejoErrores;
END IF;

-- valida la Cuenta Constable Realizado
CALL CUENTASCONTABLESVAL(	Par_CtaRealizado,	Salida_NO,		    Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
							Aud_NumTransaccion);
-- Validamos la respuesta
IF(Par_NumErr <> Entero_Cero) THEN
	SET Par_NumErr := 003;
    SET Par_ErrMen := concat(Par_ErrMen, ', Cuenta Realizado');
	SET Var_Control:= 'ctaRealizado' ;
    LEAVE ManejoErrores;
END IF;


SET Aud_FechaActual := CURRENT_TIMESTAMP();

UPDATE IMPUESTOS SET
    Descripcion     = Par_Descripcion,
    DescripCorta    = Par_DescripCorta,
    Tasa            = Par_Tasa,
    GravaRetiene    = Par_GravaRetiene,
    BaseCalculo     = Par_BaseCalculo,
    ImpuestoCalculo = Par_ImpuestoCalculo,
    CtaEnTransito   = Par_CtaEnTransito,
    CtaRealizado    = Par_CtaRealizado,

    EmpresaID       = Aud_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

WHERE ImpuestoID = Par_ImpuestoID;


    SET Par_NumErr := 000;
    SET Par_ErrMen := CONCAT('Impuesto Modificado Exitosamente: ',CONVERT(Par_ImpuestoID,CHAR));
    SET Var_Control:= 'impuestoID' ;
    SET Var_Consecutivo := Par_ImpuestoID;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$
