-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSFERBANCOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSFERBANCOCON`;DELIMITER $$

CREATE PROCEDURE `TRANSFERBANCOCON`(
	Par_FolioID         	int,
	Par_NumCon				int,

	Par_EmpresaID       	int(11),
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(60),
	Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN
DECLARE Var_TransferBancoID INT;

DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Folios      int;




Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Folios      := 1;



if(Par_NumCon = Con_Folios) then
   set  Var_TransferBancoID := (select TransferBancoID from TRANSFERBANCO  where PolizaID=Par_FolioID limit 1);
	select 	CT.DenominacionID, 	DE.NombreLetra, DE.Valor,
		case when DE.DenominacionID = 7 then
			convert(format(CT.Cantidad/1,0),char)
			 when DE.DenominacionID = 6 then
			convert(format(CT.Cantidad/20,0),char)
			 when DE.DenominacionID = 5 then
			convert(format(CT.Cantidad/50,0),char)
		     when DE.DenominacionID = 4 then
			convert(format(CT.Cantidad/100,0),char)
			 when DE.DenominacionID = 3 then
			convert(format(CT.Cantidad/200,0),char)
			 when DE.DenominacionID = 2 then
			convert(format(CT.Cantidad/500,0),char)
			 when DE.DenominacionID = 1 then
			convert(format(CT.Cantidad/1000,0),char)
		end AS Cantidad,
		CT.Cantidad as Monto,TransferBancoID
		from TRANSFERBANCO CT
			left outer JOIN DENOMINACIONES DE on CT.DenominacionID = DE.DenominacionID
		where TransferBancoID = Var_TransferBancoID;
end if;
END TerminaStore$$