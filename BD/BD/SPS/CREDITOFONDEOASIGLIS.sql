-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOASIGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOASIGLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOASIGLIS`(
   Par_InstitutFondID       INT(11),
   Par_LineaFondeoID        INT(11),
   Par_CreditoID            BIGINT(12),
   Par_FechaAsig            DATE,
   Par_CantidadIntegrar     DECIMAL(14,2),
    Par_TipoConsulta        INT(1),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN

DECLARE Var_FechaSis     DATE;
DECLARE Principal           INT(1);

SET Principal           := 1;

IF(Par_TipoConsulta = Principal) THEN

    TRUNCATE TMPCREDFONDAS;
    TRUNCATE TMPCREDFONASIG;

    SELECT FechaSistema INTO Var_FechaSis
        FROM PARAMETROSSIS;

    IF(Par_FechaAsig = Var_FechaSis) THEN
    CALL ASIGCREFONACPRO(Par_InstitutFondID,     Par_LineaFondeoID,      Par_CreditoID,      Par_FechaAsig,      Par_CantidadIntegrar,
                            Par_TipoConsulta,    Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                            Aud_ProgramaID,      Aud_Sucursal,           Aud_NumTransaccion);
    ELSE IF(Par_FechaAsig < Var_FechaSis) THEN
    CALL ASIGCREFONANTPRO(Par_InstitutFondID,     Par_LineaFondeoID,      Par_CreditoID,      Par_FechaAsig,      Par_CantidadIntegrar,
                            Par_TipoConsulta,    Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                            Aud_ProgramaID,      Aud_Sucursal,           Aud_NumTransaccion);
         END IF;
    END IF;
END IF;

END TerminaStore$$