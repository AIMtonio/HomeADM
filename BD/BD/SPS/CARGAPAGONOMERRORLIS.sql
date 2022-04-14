-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAPAGONOMERRORLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAPAGONOMERRORLIS`;DELIMITER $$

CREATE PROCEDURE `CARGAPAGONOMERRORLIS`(
	Par_FolioCargaID    int(11),
    Par_NumLis          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Lis_Fallo       int;
DECLARE Lis_Exito       int;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Lis_Fallo       := 1;

if(Par_NumLis = Lis_Fallo) then
    select Car.FolioCargaID,Car.CreditoID,concat(convert(Car.EmpresaNominaID,char),'-',Ins.NombreInstit)as EmpresaNominaID, Car.DescripcionError
        from CARGAPAGONOMERROR Car inner join INSTITNOMINA Ins
	on (Car.EmpresaNominaID= Ins.InstitNominaID)
		where FolioCargaID = Par_FolioCargaID;
end if;
END$$