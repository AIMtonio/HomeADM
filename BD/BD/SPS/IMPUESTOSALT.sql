-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `IMPUESTOSALT`;
DELIMITER $$


CREATE PROCEDURE `IMPUESTOSALT`(

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


DECLARE  NumImpuestoID     INT;
DECLARE  Entero_Cero       INT;
DECLARE  Decimal_Cero      DECIMAL(12,4);
DECLARE  Cadena_Vacia      CHAR(1);
DECLARE  Salida_SI         CHAR(1);
DECLARE  Salida_NO         CHAR(1);


DECLARE  Var_Control       VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);
DECLARE  Var_CtaEnTransito VARCHAR(50);
DECLARE  Var_CtaRealizado  VARCHAR(50);


SET NumImpuestoID       := 0;
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
                                             'esto le ocasiona. Ref: SP-IMPUESTOSALT');
                    SET Var_Control := 'sqlException';
                END;



    IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'La Descripcion Esta Vacia.';
            SET Var_Control := 'descripcion' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_DescripCorta,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'La Descripcion Corta Esta Vacia.';
            SET Var_Control := 'descripCorta' ;
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_Tasa,Decimal_Cero)) = Decimal_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'La Tasa Esta Vacia.';
            SET Var_Control := 'tasa' ;
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_GravaRetiene,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'Retiene esta Vacio.';
            SET Var_Control := 'gravaRetiene' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_BaseCalculo,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'La base del calculo esta vacio.';
            SET Var_Control := 'baseCalculoS';
        LEAVE ManejoErrores;
    END IF;

    SET Par_ImpuestoCalculo := IFNULL(Par_ImpuestoCalculo, Entero_Cero);

    -- valida la Cuenta Constable Tránsito
    CALL CUENTASCONTABLESVAL(	Par_CtaEnTransito,	Salida_NO,		    Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
                                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
                                Aud_NumTransaccion);
    -- Validamos la respuesta
    IF(Par_NumErr <> Entero_Cero) THEN
        SET Par_NumErr := 006;
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
        SET Par_NumErr := 007;
        SET Par_ErrMen := concat(Par_ErrMen, ', Cuenta Realizado');
        SET Var_Control:= 'ctaRealizado' ;
        LEAVE ManejoErrores;
    END IF;


    SET NumImpuestoID:= (SELECT IFNULL(MAX(ImpuestoID),Entero_Cero) + 1
    FROM IMPUESTOS);

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO IMPUESTOS (
        ImpuestoID,         Descripcion,            DescripCorta,       Tasa,               GravaRetiene,
        BaseCalculo,        ImpuestoCalculo,        CtaEnTransito,      CtaRealizado,       EmpresaID,
        Usuario,            FechaActual,            DireccionIP,        ProgramaID,         Sucursal,
        NumTransaccion)
    VALUES (
        NumImpuestoID,      Par_Descripcion,        Par_DescripCorta,   Par_Tasa,           Par_GravaRetiene,
        Par_BaseCalculo,    Par_ImpuestoCalculo,    Par_CtaEnTransito,  Par_CtaRealizado,   Aud_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

        SET Par_NumErr := 000;
        SET Par_ErrMen := CONCAT("Impuesto Agregado Exitosamente: ", CONVERT(NumImpuestoID, CHAR));
        SET Var_Control := 'impuestoID' ;
        SET Var_Consecutivo := NumImpuestoID;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$
