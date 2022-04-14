-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGCREDITOALT`;
DELIMITER $$


CREATE PROCEDURE `RESPAGCREDITOALT`(
    Par_TranRespaldo        BIGINT,
    Par_CuentaAhoID         BIGINT(12),
    Par_CreditoID           BIGINT(12),
    Par_MontoPagado         DOUBLE(12,2),

    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )

TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSistema    DATE;
DECLARE Var_NumRegistros    INT;
DECLARE Var_MontoPago		DECIMAL(16,2);

DECLARE Entero_Cero         INT;
DECLARE SalidaSi            CHAR(1);
DECLARE Cadena_Vacia        CHAR;
DECLARE Decimal_Cero        DECIMAL;


SET Entero_Cero         :=0;
SET SalidaSi            :='S';
SET Cadena_Vacia        :='';
SET Decimal_Cero        :=0.0;

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-RESPAGCREDITOALT');
    END;

    IF(Par_TranRespaldo = Entero_Cero)THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := CONCAT("El Numero de Transaccion esta vacio");
            LEAVE ManejoErrores;
        END IF;

    IF(Par_CreditoID = Entero_Cero)THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := CONCAT("El Credito esta vacio");
            LEAVE ManejoErrores;
        END IF;
    IF(Par_MontoPagado = Decimal_Cero)THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := CONCAT("El Monto esta vacio");
            LEAVE ManejoErrores;
        END IF;

 SET Var_FechaSistema   :=(SELECT FechaSistema
                                FROM PARAMETROSSIS);

    SELECT COUNT(CreditoID), sum(MontoPagado)
	INTO Var_NumRegistros, Var_MontoPago
	FROM RESPAGCREDITO
	WHERE CreditoID = Par_CreditoID
	AND TranRespaldo = Par_TranRespaldo;

	IF Var_NumRegistros > Entero_Cero THEN

        SET Par_MontoPagado := Par_MontoPagado + Var_MontoPago;

		DELETE FROM RESPAGCREDITO
		WHERE CreditoID = Par_CreditoID
		AND TranRespaldo = Par_TranRespaldo;
	END IF;

 INSERT INTO RESPAGCREDITO (
            TranRespaldo,   CuentaAhoID,    CreditoID,      MontoPagado,    FechaPago,
            EmpresaID,      Usuario,        FechaActual,    DireccionIP,    ProgramaID,
            Sucursal,       NumTransaccion)
    VALUES  (
            Par_TranRespaldo,   Par_CuentaAhoID,    Par_CreditoID,      Par_MontoPagado,    Var_FechaSistema,
            Par_EmpresaID,      Aud_Usuario ,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion);

            SET Par_NumErr  := 0;
            SET Par_ErrMen  := CONCAT("Respaldado Existosamente");
END ManejoErrores;

END TerminaStore$$