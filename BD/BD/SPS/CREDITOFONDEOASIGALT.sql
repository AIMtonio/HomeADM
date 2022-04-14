-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOASIGALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOASIGALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOASIGALT`(
    Par_InstitutFondeoID INT(11),
    Par_LineaFondeoID    INT(11),
    Par_CreditoFondeoID  BIGINT(20),
    Par_SaldoCapFon      DECIMAL(14,2),
    Par_CreditoID        BIGINT(12),
    Par_MontoCredito     DECIMAL(14,2),
    Par_SaldoCapCre      DECIMAL(14,2),
    Par_FechaAsignacion  DATE,
    Par_UsuarioAsigna    INT(11),
    Par_FormaSeleccion   VARCHAR(15),
    Par_CondicionesCum   VARCHAR(400),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

     Par_EmpresaID          INT(11),
     Aud_Usuario            INT(11),
     Aud_FechaActual        DATETIME,
     Aud_DireccionIP        VARCHAR(15),
     Aud_ProgramaID         VARCHAR(50),
     Aud_Sucursal           INT(11),
     Aud_NumTransaccion     BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Salida_SI       CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE Manual         VARCHAR(15);
DECLARE Automatico      VARCHAR(15);
DECLARE Aut             VARCHAR(15);
DECLARE Man             VARCHAR(15);




SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET   Manual           := 'MANUAL';
SET   Automatico       := 'AUTOMATICO';
SET   Man              := 'M';
SET   Aut              := 'A';
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

IF(Par_FormaSeleccion=Manual)THEN
    SET Par_FormaSeleccion := Man;
    SET Par_CondicionesCum := Manual;
END IF;

IF(Par_FormaSeleccion=Automatico)THEN
    SET Par_FormaSeleccion := Aut;
    SET Par_CondicionesCum := CONCAT("PRODUCTO DE CREDITO LINEA DE FONDEO :",Par_LineaFondeoID);
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();

INSERT INTO CREDITOFONDEOASIG (InstitutFondeoID,LineaFondeoID,CreditoFondeoID,
                                SaldoCapFon,CreditoID,MontoCredito,SaldoCapCre,FechaAsignacion,
                                UsuarioAsigna,FormaSeleccion,CondicionesCum,EmpresaID,Usuario,
                                FechaActual,DireccionIP,ProgramaID,Sucursal,NumTransaccion)
   VALUES (
    Par_InstitutFondeoID,Par_LineaFondeoID,Par_CreditoFondeoID,Par_SaldoCapFon,Par_CreditoID,
    Par_MontoCredito,Par_SaldoCapCre,Par_FechaAsignacion,Par_UsuarioAsigna,Par_FormaSeleccion,
    Par_CondicionesCum,Par_EmpresaID,Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
     Aud_Sucursal,Aud_NumTransaccion);

IF (Par_Salida = Salida_SI) THEN
    SELECT  '000' AS NumErr,
            CONCAT("Asignacion de Credito de Fondeo Correcto: ", CONVERT(Par_InstitutFondeoID, CHAR))  AS ErrMen,
            'lineaFondeoID' AS Control,
            Par_InstitutFondeoID AS Consecutivo;
ELSE
    SET Par_NumErr:=    0;
    SET Par_ErrMen:=    CONCAT("Credito de Fondeo  Agregado: ", CONVERT(Par_InstitutFondeoID, CHAR));
END IF;


END TerminaStore$$