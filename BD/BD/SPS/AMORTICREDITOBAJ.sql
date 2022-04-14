-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOBAJ`(

    Par_CreditoID       bigint(12),
    Par_Salida          char(1),
    inout Par_NumErr    int(11),
    inout Par_ErrMen    varchar(400),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
        )
TerminaStore: BEGIN


DECLARE SalidaNO    char(1);
DECLARE SalidaSI    char(1);


Set SalidaNO        :='N';
set SalidaSI        := 'S';


  DELETE FROM AMORTICREDITO where CreditoID = Par_CreditoID;

    if(Par_Salida =SalidaSI) then
            select '001' as NumErr,
            'Amortizaciones Eliminadas.' as ErrMen,
            'creditoID' as control;
             LEAVE TerminaStore;
        end if;
        if(Par_Salida =SalidaNO) then
            set Par_NumErr := 0;
            set Par_ErrMen := 'Amortizaciones Eliminadas.' ;
            LEAVE TerminaStore;
        end if;

END TerminaStore$$