-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSAPLICAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSAPLICAACT`;
DELIMITER $$


CREATE PROCEDURE `FOLIOSAPLICAACT`(
	Par_NombreTabla	varchar(100),
OUT	Par_Folio		bigint
	)

TerminaStore: BEGIN


DECLARE	Entero_Cero		bigint;
DECLARE	Salida_SI		char(1);


Set	Entero_Cero			:= 0;
Set	Salida_SI		:= 'S';


select	FolioID INTO Par_Folio
		from FOLIOSAPLIC
		where	Tabla	= Par_NombreTabla
        for update;

if Par_Folio is null then
	set	Par_Folio	= 1;
	insert into FOLIOSAPLIC values (
		Par_Folio,	Par_NombreTabla	);
else
	update FOLIOSAPLIC set
		FolioID	= LAST_INSERT_ID(FolioID + 1)
		where	Tabla	= Par_NombreTabla;

	select	LAST_INSERT_ID() INTO Par_Folio;
end if;

END TerminaStore$$
