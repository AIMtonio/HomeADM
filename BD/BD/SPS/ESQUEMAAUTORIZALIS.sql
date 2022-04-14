-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTORIZALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTORIZALIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMAAUTORIZALIS`(
	Par_Producto        INT(11),
	Par_CicloIni        INT(11),
	Par_CicloFin        INT(11),
	Par_MontoIni        DECIMAL(18,2),
	Par_MontoFin        DECIMAL(18,2),
	Par_MontoMax        DECIMAL(18,2),
	Par_NumLis		    tinyint unsigned,

	Par_EmpresaID       int(11),
	Aud_Usuario         int(11),
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int(11),
	Aud_NumTransaccion  bigint(20)
		)
TerminaStore: BEGIN


DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);
DECLARE Lis_Principal           char(1);
DECLARE Lis_PorProducto         char(1);



Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';
Set Lis_Principal           := 1;
Set Lis_PorProducto         := 2;



IF (Par_NumLis = Lis_Principal) then
    select  EsquemaID       ,ProducCreditoID    ,CicloInicial   ,CicloFinal     ,MontoInicial
            ,MontoFinal     ,MontoMaximo
    from ESQUEMAAUTORIZA
    order by ProducCreditoID, CicloInicial, CicloFinal, MontoInicial, MontoFinal, MontoMaximo ;
END IF;



IF (Par_NumLis = Lis_PorProducto) then
    select  EsquemaID       ,ProducCreditoID    ,CicloInicial   ,CicloFinal     ,FORMAT(MontoInicial,2)
            ,FORMAT(MontoFinal,2)     ,FORMAT(MontoMaximo,2)
    from ESQUEMAAUTORIZA
    where   ProducCreditoID = Par_Producto
    order by CicloInicial, CicloFinal, MontoInicial, MontoFinal, MontoMaximo;
END IF;

END TerminaStore$$