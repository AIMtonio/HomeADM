-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRELIMITEQUITASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRELIMITEQUITASLIS`;DELIMITER $$

CREATE PROCEDURE `CRELIMITEQUITASLIS`(
    Par_ProducCreditoID     int(11),
    Par_NumLis              tinyint unsigned,

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN





DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Lis_Principal   int;



Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set Lis_Principal   := 1;

if(Par_NumLis = Lis_Principal) then

    select  ProducCreditoID,    ClavePuestoID,          LimMontoCap,    LimPorcenCap,
            LimMontoIntere,     LimPorcenIntere,        LimMontoMorato, LimPorcenMorato,
            LimMontoAccesorios, LimPorcenAccesorios,    NumMaxCondona
        from CRELIMITEQUITAS
        where ProducCreditoID   = Par_ProducCreditoID;

end if;

END$$