-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASTRANSFERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASTRANSFERCON`;
DELIMITER $$

CREATE PROCEDURE `CAJASTRANSFERCON`(
	Par_FolioID         	int,
	Par_NumCon			int,

	Par_EmpresaID       	int(11),
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(60),
	Aud_Sucursal        	int,
	Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Folios      int;
DECLARE Con_ticket      int;
DECLARE 	varCajaPrin	  char(2);
DECLARE 	varBovedaCen	  char(2);
DECLARE 	varCaAtenPub	  char(2);

DECLARE Con_InfFolioWS			INT(11);			-- Consulta para obtener la imformacion del folio  de recepcion de efectivo para el ws de operacion en ventanilla 


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Folios      := 1;
Set Con_ticket      := 2;
Set	varCajaPrin	  := 'CP';
Set	varBovedaCen	  := 'BG';
Set	varCaAtenPub	  := 'CA';

SET Con_InfFolioWS		:= 3;			-- Consulta para obtener la imformacion del folio  de recepcion de efectivo para el ws de operacion en ventanilla 



if(Par_NumCon = Con_Folios) then
	select SucursalOrigen, CajaOrigen, DenominacionID, Cantidad, PolizaID
		from CAJASTRANSFER
		where CajasTransferID = Par_FolioID;
end if;


if(Par_NumCon = Con_ticket) then
	select 	CT.DenominacionID, 	DE.NombreLetra, 		DE.Valor,
		case when DE.DenominacionID = 7 then
			convert(format(CT.Cantidad,2),char)
		 else convert(format(CT.Cantidad,0),char)  end AS Cantidad,	(DE.Valor*CT.Cantidad) as Monto,
			CASE WHEN CV.TipoCaja = varCajaPrin THEN 'CAJA PRINCIPAL DE SUCURSAL'
								ELSE CASE WHEN CV.TipoCaja = varBovedaCen THEN 'BOVEDA CENTRAL'
								ELSE CASE WHEN CV.TipoCaja = varCaAtenPub THEN 'CAJA DE ATENCION AL PUBLICO'
								ELSE CV.TipoCaja END	END END	AS TipoCajaDes,
			US.NombreCompleto
		from CAJASTRANSFER CT
			left outer JOIN CAJASVENTANILLA CV on CT.CajaDestino = CV.CajaID
			left outer JOIN DENOMINACIONES DE on CT.DenominacionID = DE.DenominacionID
			left outer JOIN USUARIOS US on CV.UsuarioID = US.UsuarioID
		where CajasTransferID = Par_FolioID;
end if;

	-- Consulta para obtener la imformacion del folio  de recepcion de efectivo para el ws de operacion en ventanilla 
	IF(Par_NumCon = Con_InfFolioWS) THEN
		SELECT SucursalOrigen,		CajaOrigen,		SucursalDestino,		CajaDestino,	NombreSucurs,	PolizaID
			FROM CAJASTRANSFER CAJ
			INNER JOIN SUCURSALES SUC ON SUC.SucursalID = CAJ.SucursalOrigen
			WHERE CajasTransferID = Par_FolioID
			LIMIT 1;
	END IF;

END TerminaStore$$