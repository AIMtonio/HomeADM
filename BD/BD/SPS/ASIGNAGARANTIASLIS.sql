-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNAGARANTIASLIS`;DELIMITER $$

CREATE PROCEDURE `ASIGNAGARANTIASLIS`(

    Par_SolicitudID         BIGINT(20),
    Par_Credito             BIGINT(12),
    Par_NumLis              TINYINT UNSIGNED,

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE Entero_Cero             INT(11);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE GarantAutorizada        CHAR(1);
DECLARE Lis_Principal           CHAR(1);


SET Cadena_Vacia                    := '';
SET Fecha_Vacia                 := '1900-01-01';
SET Entero_Cero                 := 0;
SET Str_SI                      := 'S';
SET Str_NO                      := 'N';
SET GarantAutorizada                := 'U';
SET Lis_Principal                   := 1;


IF(Par_NumLis = Lis_Principal) THEN
    SET Par_SolicitudID := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID = Par_Credito);

    SELECT  Gar.GarantiaID ,CASE WHEN IFNULL(Gar.GaranteNombre, Cadena_Vacia) = Cadena_Vacia    AND  Cli.ClienteID > Entero_Cero        THEN    Cli.NombreCompleto
                             WHEN IFNULL(Gar.GaranteNombre, Cadena_Vacia) = Cadena_Vacia    AND  Pro.ProspectoID > Entero_Cero  THEN Pro.NombreCompleto
                                                                                                                ELSE    Gar.GaranteNombre
                             END AS  GaranteNombre
            ,FORMAT(Gar.ValorComercial,2) AS ValorComercial
            ,Gar.Observaciones
            ,Gar.NoIdentificacion
            ,Gar.SerieFactura
    FROM ASIGNAGARANTIAS Asi
    LEFT JOIN  GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
    LEFT JOIN CLIENTES Cli ON Cli.ClienteID= Gar.ClienteID
    LEFT JOIN PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID
    WHERE   Asi.SolicitudCreditoID = Par_SolicitudID
        AND Asi.Estatus = GarantAutorizada;


END IF;

END TerminaStore$$