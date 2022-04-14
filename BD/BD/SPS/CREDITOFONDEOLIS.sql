-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOLIS`;
DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOLIS`(
	Par_DesLinFondeo	varchar(100),
	Par_LineaFondeoID  int,
	Par_InstitutFondeoID int,
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     int;
DECLARE Est_Vigente     char(1);

DECLARE Lis_Principal   int;
DECLARE Lis_Foranea     int;
DECLARE Lis_DetLin      int;
DECLARE Lis_NoPagados   int;
DECLARE Lis_VigentesWS  int;
DECLARE Lis_FolioPasFondeo	INT(10);	-- Lista de credito pasivos 

Set Entero_Cero     := 0;
Set Est_Vigente     := 'N';
Set Lis_Principal   := 1;
Set Lis_Foranea     := 2;
Set Lis_DetLin      := 3;
set Lis_NoPagados   := 4;
set Lis_VigentesWS  := 5;
set Lis_FolioPasFondeo	:= 6;	-- Lista de credito pasivos 


if(Par_NumLis = Lis_Principal) then
	select CF.CreditoFondeoID as CreditoFondeoID, CF.Folio as Folio,  I.NombreInstitFon as NombreInstitFon
		from 	CREDITOFONDEO CF,
				INSTITUTFONDEO I
			where 	CF.InstitutFondID = I.InstitutFondID
			 and 	I.NombreInstitFon like concat ('%',Par_DesLinFondeo,'%')
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Foranea) then
	select CF.CreditoFondeoID as CreditoFondeoID, CF.Folio as Folio,  I.NombreInstitFon as NombreInstitFon
		from 	CREDITOFONDEO CF,
				INSTITUTFONDEO I
			where 	CF.InstitutFondID = I.InstitutFondID
             and 	I.NombreInstitFon like concat ('%',Par_DesLinFondeo,'%')
             and    CF.LineaFondeoID = Par_LineaFondeoID
             and    CF.InstitutFondID = Par_InstitutFondeoID
	limit 0, 15;
end if;

if(Par_NumLis = Lis_DetLin) then
	select CF.CreditoFondeoID , CF.Folio
		from 	CREDITOFONDEO CF
			where 	CF.CreditoFondeoID like concat('%',Par_DesLinFondeo,'%')
	limit 0, 15;
end if;

if(Par_NumLis = Lis_NoPagados) then
	select CF.CreditoFondeoID as CreditoFondeoID, CF.Folio as Folio,  I.NombreInstitFon as NombreInstitFon
		from 	CREDITOFONDEO CF,
				INSTITUTFONDEO I
			where 	CF.InstitutFondID = I.InstitutFondID
             and 	I.NombreInstitFon like concat ('%',Par_DesLinFondeo,'%')
             and    CF.LineaFondeoID = Par_LineaFondeoID
             and    CF.InstitutFondID = Par_InstitutFondeoID
			 and    CF.Estatus!='P'
	limit 0, 15;
end if;

if(Par_NumLis = Lis_VigentesWS) then
	select Cre.CreditoFondeoID as CreditoFondeoID,
          convert(Cre.FechaVencimien, char(10)) as FecVencim,
          format(Cre.Monto, 2) as MontoFondeo
		from 	CREDITOFONDEO Cre,
				INSTITUTFONDEO Ins
			where Cre.InstitutFondID = Ins.InstitutFondID
           and Cre.Estatus = Est_Vigente
           and ifnull(Ins.ClienteID, Entero_Cero) = Par_InstitutFondeoID order by  FecVencim
	limit 0, 30 ;
end if;

IF(Par_NumLis = Lis_FolioPasFondeo) THEN
	SELECT CF.CreditoFondeoID AS CreditoFondeoID, CF.Folio as Folio,  I.NombreInstitFon AS NombreInstitFon
		FROM 	CREDITOFONDEO CF,
				INSTITUTFONDEO I
			where 	CF.InstitutFondID = I.InstitutFondID
				AND I.NombreInstitFon LIKE concat ('%',Par_DesLinFondeo,'%')
				AND CF.LineaFondeoID = Par_LineaFondeoID
				AND CF.InstitutFondID = Par_InstitutFondeoID
				AND CF.Estatus!='P'
	LIMIT 0, 15;
END IF;

END TerminaStore$$