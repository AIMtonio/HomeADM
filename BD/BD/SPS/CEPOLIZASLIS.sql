-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEPOLIZASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEPOLIZASLIS`;DELIMITER $$

CREATE PROCEDURE `CEPOLIZASLIS`(
	Par_FechaCreacion		varchar(10),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		Bigint(20)
)
TerminaStore:BEGIN
-- Declaracion de Constantes
DECLARE	DecimalCero			varchar(6);
DECLARE	FechaVacia			varchar(10);
DECLARE	CadenaVacia			char(1);
DECLARE Tipo				int(2);
DECLARE	Moneda				char(3);
DECLARE	ConsePoliza			int(2);
DECLARE ConseDetalle		int(2);
DECLARE	ConseComprobante	int(2);
DECLARE FechaFinMes			varchar(10);

-- Asignacion de Constantes
Set	DecimalCero			:= '0.0000';
Set	FechaVacia			:= '1900-01-01';
Set	CadenaVacia			:= '';
Set	Tipo				:= 1;
Set	Moneda				:= 'MXN';
Set	ConsePoliza			:= 1;
Set	ConseDetalle		:= 2;
Set	ConseComprobante	:= 3;
Set FechaFinMes			:=	LAST_DAY(Par_FechaCreacion);

drop table if exists TEMPCEPOLIZAS;

create temporary table TEMPCEPOLIZAS ( 	PolizaID		BIGINT(20),
										Consecutivo		INT(11),
										Fecha  			DATE,
										ConceptoPoliza	VARCHAR(150),
										Tipo			INT(11),
										CuentaCompleta	VARCHAR(50),
										ConceptoDetalle	VARCHAR(80),
										Debe			DECIMAL(14,4),
										Haber			DECIMAL(14,4),
										Moneda			CHAR(3),
										FolioUUID		VARCHAR(100),
										TotalFactura	DECIMAL(14,4),
										RFC				CHAR(13),
										DesCorta		VARCHAR(250),
										index (PolizaID),
										index (Consecutivo));


insert into TEMPCEPOLIZAS
  (select pc.PolizaID,ConsePoliza, MAX(pc.Fecha) AS Fecha, MAX(pc.Concepto) AS Concepto, MAX(con.Tipo) AS Tipo, CadenaVacia,CadenaVacia,DecimalCero,DecimalCero,Moneda,CadenaVacia,DecimalCero,CadenaVacia,MAX(cc.DescriCorta) AS DescriCorta
    from `HIS-POLIZACONTA` pc
      inner join `HIS-DETALLEPOL` dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta
    group by pc.PolizaID)
  union
  (select pc.PolizaID,ConsePoliza,MAX(pc.Fecha) AS Fecha, MAX(pc.Concepto) AS Concepto, MAX(con.Tipo) AS Tipo, CadenaVacia,CadenaVacia,DecimalCero,DecimalCero,Moneda,CadenaVacia,DecimalCero,CadenaVacia,MAX(cc.DescriCorta) AS DescriCorta
    from POLIZACONTABLE pc
      inner join DETALLEPOLIZA dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta
    group by pc.PolizaID);

insert into TEMPCEPOLIZAS
  (select pc.PolizaID,ConseDetalle,FechaVacia,CadenaVacia,con.Tipo,dp.CuentaCompleta,dp.Descripcion,ifnull(dp.Cargos,DecimalCero),ifnull(dp.Abonos,DecimalCero),Moneda,CadenaVacia,DecimalCero,CadenaVacia,cc.DescriCorta
    from `HIS-POLIZACONTA` pc
      inner join `HIS-DETALLEPOL` dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta)
  union
  (select pc.PolizaID,ConseDetalle,FechaVacia,CadenaVacia,con.Tipo,dp.CuentaCompleta,dp.Descripcion,ifnull(dp.Cargos,DecimalCero),ifnull(dp.Abonos,DecimalCero),Moneda,CadenaVacia,DecimalCero,CadenaVacia,cc.DescriCorta
    from POLIZACONTABLE pc
      inner join DETALLEPOLIZA dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta);

insert into TEMPCEPOLIZAS
  (select pc.PolizaID,ConseComprobante,FechaVacia,CadenaVacia,MAX(con.Tipo) AS Tipo,CadenaVacia,CadenaVacia,DecimalCero,DecimalCero,CadenaVacia, MAX(dp.FolioUUID) AS FolioUUID, SUM(dp.TotalFactura) AS TotalFactura,MAX(dp.RFC) as RFC,MAX(cc.DescriCorta) AS DescriCorta
    from `HIS-POLIZACONTA` pc
      inner join `HIS-DETALLEPOL` dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta
    group by  pc.PolizaID)
  union
  (select pc.PolizaID,ConseComprobante,FechaVacia,CadenaVacia,MAX(con.Tipo) AS Tipo,CadenaVacia,CadenaVacia,DecimalCero,DecimalCero,CadenaVacia,MAX(dp.FolioUUID) AS FolioUUID, SUM(dp.TotalFactura) AS TotalFactura,MAX(dp.RFC) as RFC,MAX(cc.DescriCorta) AS DescriCorta
      from POLIZACONTABLE pc
      inner join DETALLEPOLIZA dp on pc.PolizaID=dp.PolizaID and dp.Fecha>=Par_FechaCreacion and dp.Fecha<=FechaFinMes
      inner join CONCEPTOSCONTA con on pc.ConceptoID=con.ConceptoContaID
      inner join CUENTASCONTABLES cc on dp.CuentaCompleta=cc.CuentaCompleta
    group by pc.PolizaID);


select PolizaID,		Consecutivo,		Fecha,	ConceptoPoliza,	Tipo,
	   CuentaCompleta,	ConceptoDetalle,	IFNULL(round(Debe,2), DecimalCero) as Debe,	IFNULL(round(Haber,2),DecimalCero) AS Haber,			Moneda,
	   FolioUUID,		TotalFactura,RFC,	DesCorta
	from TEMPCEPOLIZAS
	order by PolizaID,Consecutivo;

END TerminaStore$$