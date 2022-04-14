-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOASIGBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOASIGBAJ`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOASIGBAJ`(
    Par_InstitutFondeoID INT(11),
    Par_LineaFondeoID    INT(11),
    Par_CreditoFondeoID  BIGINT(20),
    Par_FechaAsig        DATE,

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

     Par_EmpresaID          INT(11),
     Aud_Usuario            INT(11),
     Aud_FechaActual        DATETIME,
     Aud_DireccionIP        VARCHAR(15),
     Aud_ProgramaID         VARCHAR(50),
     Aud_Sucursal           INT,
     Aud_NumTransaccion     BIGINT          )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Salida_SI       CHAR(1);
DECLARE Salida_NO       CHAR(1);





SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';

IF(IFNULL(Par_InstitutFondeoID,Entero_Cero)) = Entero_Cero THEN
    IF (Par_Salida = Salida_SI) THEN
        SELECT '001' AS NumErr,
             'La Institucion de Fondeo esta Vacia.' AS ErrMen,
             'institutFondID' AS control,
              0 AS consecutivo;
    ELSE
        SET Par_NumErr:=    1;
        SET Par_ErrMen:=    'La Institucion de Fondeo esta Vacia.';
    END IF;
    LEAVE TerminaStore;
END IF;

IF(NOT EXISTS(SELECT * FROM CREDITOFONDEOASIG
                        WHERE InstitutFondeoID    = Par_InstitutFondeoID
                        AND   LineaFondeoID       = Par_LineaFondeoID
                        AND   CreditoFondeoID     = Par_CreditoFondeoID
                        AND   FechaAsignacion     = Par_FechaAsig) ) THEN

    INSERT INTO  `HIS-CREDFONASIG`
     (InstitutFondeoID,LineaFondeoID,CreditoFondeoID,
      SaldoCapFon,PorcenExtra,CantIntegra,CreditoID,MontoCredito,SaldoCapCre,
      FechaAsignacion,UsuarioAsigna,FormaSeleccion,CondicionesCum,EmpresaID,
      Usuario,FechaActual,DireccionIP,ProgramaID,Sucursal,NumTransaccion)

    SELECT InstitutFondeoID,LineaFondeoID,CreditoFondeoID,
           SaldoCapFon,PorcenExtra,CantIntegra,CreditoID,MontoCredito,SaldoCapCre,
           FechaAsignacion,UsuarioAsigna,FormaSeleccion,CondicionesCum,EmpresaID,
           Usuario,FechaActual,DireccionIP,ProgramaID,Sucursal,NumTransaccion
    FROM CREDITOFONDEOASIG;

    TRUNCATE CREDITOFONDEOASIG;

ELSE

    TRUNCATE CREDITOFONDEOASIG;

END IF;

IF (Par_Salida = Salida_SI) THEN
    SELECT  '000' AS NumErr,
            CONCAT("Asignacion de Credito de Fondeo Asignado: ", CONVERT(Par_InstitutFondeoID, CHAR))  AS ErrMen,
            'lineaFondeoID' AS Control,
            Par_InstitutFondeoID AS Consecutivo;
ELSE
    SET Par_NumErr:=    0;
    SET Par_ErrMen:=    CONCAT("Credito de Fondeo  Agregado: ", CONVERT(Par_InstitutFondeoID, CHAR));
END IF;


END TerminaStore$$