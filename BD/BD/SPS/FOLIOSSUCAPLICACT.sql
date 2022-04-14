-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSSUCAPLICACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSSUCAPLICACT`;DELIMITER $$

CREATE PROCEDURE `FOLIOSSUCAPLICACT`(
    Par_NombreTabla     varchar(100),
    Par_SucursalID      int,
OUT Par_Folio           bigint
	)
TerminaStore: BEGIN


DECLARE	Entero_Cero		bigint;
DECLARE	Salida_SI		char(1);


Set	Entero_Cero			:= 0;
Set	Salida_SI		:= 'S';

START TRANSACTION;

select FolioID INTO Par_Folio
    from FOLIOSPORSUCAPLIC
    where Tabla         = Par_NombreTabla
      and SucursalID    = Par_SucursalID
    for update;

if Par_Folio is null then
	set	Par_Folio	= 1;
	insert into FOLIOSPORSUCAPLIC values (
		Par_Folio,	Par_SucursalID, Par_NombreTabla	);
else
	update FOLIOSPORSUCAPLIC set
        FolioID	= FolioID + 1
	where	Tabla         = Par_NombreTabla
      and SucursalID    = Par_SucursalID;
end if;

COMMIT;

set Par_Folio := (select	FolioID
                    from FOLIOSPORSUCAPLIC
                    where	Tabla	        = Par_NombreTabla
                      and   SucursalID    = Par_SucursalID);

END TerminaStore$$