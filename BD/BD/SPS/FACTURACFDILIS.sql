-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURACFDILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURACFDILIS`;DELIMITER $$

CREATE PROCEDURE `FACTURACFDILIS`(
	Par_FolioFiscal		char(40),
	Par_FechaInicio		varchar(12),
	Par_FechaFin		varchar(12),
	Par_RFCReceptor		varchar(30),
	Par_Estatus			char(1),
	Par_NumLis			int(11),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Cadena_Vacia	char(1);
DECLARE Con_ListaFolio		int(11);
DECLARE Con_GridFolio		int(11);
DECLARE Con_GridFecha		int(11);


DECLARE Var_Sentencia	varchar(500);


SET Cadena_Vacia	:='';
SET Con_ListaFolio	:=1;
SET Con_GridFolio	:=2;
SET Con_GridFecha	:=3;

ManejoErrores:BEGIN
	if(Con_ListaFolio=Par_NumLis) then
		SELECT FolioFiscal, RFCReceptor, RazonSocialReceptor
		FROM FACTURACFDI WHERE FolioFiscal like concat("%",Par_FolioFiscal,"%")
		limit 0,15;
	end if;

	if(Con_GridFolio=Par_NumLis) then
		SELECT
			FacturaID,	FolioFiscal,		date(FechaEmision),	RFCEmisor,	RazonSocialEmisor,
			RFCReceptor,	RazonSocialReceptor,TotalFactura,	Estatus,	MotivoCancelacion,
			Periodo, 	ClienteID, 		SucursalCliente
		FROM FACTURACFDI WHERE FolioFiscal=Par_FolioFiscal ;
	end if;

	if(Con_GridFecha=Par_NumLis) then
		SET Var_Sentencia	:=concat("SELECT FacturaID, FolioFiscal,date(FechaEmision),RFCEmisor,
			RazonSocialEmisor,RFCReceptor,RazonSocialReceptor,TotalFactura,Estatus,MotivoCancelacion,
			Periodo, ClienteID, SucursalCliente
			FROM FACTURACFDI WHERE FechaEmision>='",Par_FechaInicio,"' and FechaEmision<='",Par_FechaFin,"'");

		 if(ifnull(Par_RFCReceptor,Cadena_Vacia)!=Cadena_Vacia ) then
		 	set Var_Sentencia := concat(Var_Sentencia," and RFCReceptor='",Par_RFCReceptor,"'");
		 end if;
		 if(ifnull(Par_Estatus,Cadena_Vacia)!=Cadena_Vacia) then
		 	set Var_Sentencia := concat(Var_Sentencia," and Estatus='",Par_Estatus,"'");
		 end if;
		 set Var_Sentencia	:=concat(Var_Sentencia,";");

		SET @Sentencia	= (Var_Sentencia);
		PREPARE STFACTURACFDILIS FROM @Sentencia;
		EXECUTE STFACTURACFDILIS;
		DEALLOCATE PREPARE STFACTURACFDILIS;
	end if;
END ManejoErrores;

END TerminaStore$$