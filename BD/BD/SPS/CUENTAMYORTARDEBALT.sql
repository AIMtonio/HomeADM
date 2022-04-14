-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAMYORTARDEBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAMYORTARDEBALT`;
DELIMITER $$


CREATE PROCEDURE `CUENTAMYORTARDEBALT`(
    Par_ConceptoTarDebID        INT(11),
    Par_Cuenta                  VARCHAR(12),
    Par_Nomenclatura            VARCHAR(30),
    Par_NomenclaturaCR          VARCHAR(30),

    Par_Salida                  CHAR(1),
    INOUT Par_NumErr            INT(11),
    INOUT Par_ErrMen            VARCHAR(100),

    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT,
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
		)

TerminaStore: BEGIN


DECLARE Str_SI                  CHAR(1);
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Entero_Cero             INT;


DECLARE Var_Control             VARCHAR(50);
DECLARE Var_ConceptoCajaID      VARCHAR(50);


SET Str_SI          := 'S';
SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;


SET Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores:BEGIN


    IF NOT EXISTS(SELECT ConceptoTarDebID
                    FROM CONCEPTOSTARDEB
                    WHERE ConceptoTarDebID  = Par_ConceptoTarDebID)THEN
        SET Par_NumErr 	:= 1;
        SET Par_ErrMen	:= CONCAT("El Concepto Tarjeta Debito ",Par_ConceptoTarDebID, " no Existe");
        SET Var_Control := 'tipoCaja';
        LEAVE ManejoErrores;
    END IF;

    IF EXISTS(SELECT ConceptoTarDebID
                FROM CUENTASMAYORTARDEB
                WHERE ConceptoTarDebID = Par_ConceptoTarDebID)THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT("El Concepto Tarjeta Debito  ",Par_ConceptoTarDebID, " ya Existe");
        SET Var_Control := 'tipoCaja' ;
        LEAVE ManejoErrores;
    END IF;

    IF (Par_Cuenta = Cadena_Vacia)THEN
        SET Par_NumErr 	:= 3;
        SET	Par_ErrMen	:= CONCAT("La Cuenta esta Vacia");
        SET Var_Control := 'tipoCuenta' ;
        LEAVE ManejoErrores;
    END IF;

    IF (Par_Nomenclatura = Cadena_Vacia)THEN
        SET	Par_NumErr 	:= 4;
        SET	Par_ErrMen	:= CONCAT("La Nomenclatura de la Cuenta esta Vacia");
        SET Var_Control := 'nomenclatura' ;
        LEAVE ManejoErrores;
    END IF;

    IF (Par_NomenclaturaCR = Cadena_Vacia)THEN
        SET	Par_NumErr 	:= 5;
        SET	Par_ErrMen	:= CONCAT("La Nomenclatura del Centro de Costos esta Vacia");
        SET Var_Control := 'nomenclaturaCR' ;
        LEAVE ManejoErrores;
    END IF;

    INSERT INTO CUENTASMAYORTARDEB(
                ConceptoTarDebID,   Cuenta,     Nomenclatura,   NomenclaturaCR,
                EmpresaID,          Usuario,    FechaActual,    DireccionIP,
                ProgramaID,         Sucursal,   NumTransaccion)

        VALUES (Par_ConceptoTarDebID,  Par_Cuenta,     Par_Nomenclatura,   Par_NomenclaturaCR,
                Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

       SET	Par_NumErr 	:= 0;
	    SET	Par_ErrMen	:= CONCAT("Cuenta Agregada Exitosamente");

	END ManejoErrores;
	IF (Par_Salida = Str_SI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;
END TerminaStore$$