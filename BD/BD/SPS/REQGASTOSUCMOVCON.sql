-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCMOVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCMOVCON`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCMOVCON`(
	Par_DetReqGasID      int(11),
	Par_NumReqGasID      int(11),
	Par_NumCon      	   int(11),

	Par_EmpresaID        	int(11),
	Aud_Usuario       	int(11),
	Aud_FechaActual     	datetime,
	Aud_DireccionIP     	varchar(20),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
 		)
TerminaStore: BEGIN


DECLARE Cadena_Vacia	char(1);
DECLARE Decimal_Cero 	decimal(12,2);
DECLARE Entero_Cero 	int(1);
DECLARE Entero_Uno 	int(1);
DECLARE Con_Principal	int;
DECLARE Con_DentroPre	int;
DECLARE Est_Aprobado	char(1);
DECLARE Est_Pendiente	char(1);


DECLARE Var_DetReqGasID	int;
DECLARE Var_NumReqGasID 	int;
DECLARE Var_TipoGastoID	int;
DECLARE Var_TipoGastoAnt	int;
DECLARE Var_Observaciones	varchar(50);
DECLARE Var_CentroCostoID	int;
DECLARE Var_PartPresup 	decimal(12,2);
DECLARE Var_MontPresupuest	decimal(12,2);
DECLARE Var_NoPresup		decimal(12,2);
DECLARE Var_MontoAut		decimal(12,2);
DECLARE Var_Estatus 		char(1);
DECLARE Var_FolioPresupID	int;
DECLARE Var_ClaveDispMov 	int;
DECLARE Var_TipoDeposito 	char(1);
DECLARE Var_NoFactura 	varchar(20);
DECLARE Var_NoFacturaFue 	varchar(20);
DECLARE Var_ProveedorID 	int;
DECLARE Var_MontoDispon	decimal(12,2);
DECLARE Var_FechaSistema	date;
DECLARE Var_Sucursal		int;


DECLARE  	CursorReqMov  CURSOR FOR
	select	DetReqGasID,		NumReqGasID,		TipoGastoID,		Observaciones,	CentroCostoID,
			PartPresupuesto,	MontPresupuest,	MontoAutorizado,	Estatus,			FolioPresupID,
			ClaveDispMov,		TipoDeposito,		NoFactura,		ProveedorID
	 from 	REQGASTOSUCURMOV
	 where 	NumReqGasID = Par_NumReqGasID
	  and 	Estatus = Est_Pendiente;

Set Cadena_Vacia 		:= '';
Set Decimal_Cero 		:= 0.00;
Set Entero_Cero 		:= 0;
Set Entero_Uno 		:= 1;
Set Con_Principal 	:= 1;
Set Con_DentroPre 	:= 2;
Set Est_Aprobado		:= 'A';
Set Est_Pendiente		:= 'P';


Set Var_TipoGastoAnt	:= 0;
Set Var_NoFacturaFue	:= '';


if (Con_Principal = Par_NumCon)then
	Drop Table IF EXISTS TMPREQGASTOSMOVS;
	Create Temporary Table TMPREQGASTOSMOVS(
		DetReqGasID int,	NumReqGasID int,	TipoGastoID int,	Observaciones varchar(50),	CentroCostoID int,
		PartPresupuesto decimal(12,2),	MontPresupuest decimal(12,2),	NoPresupuestado decimal(12,2),	MontoAutorizado decimal(12,2),	Estatus char(1),
		FolioPresupID int, 	ClaveDispMov int,		TipoDeposito char(1),	NoFactura varchar(20), ProveedorID int
	);
	Open  CursorReqMov;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorReqMov  Into
				Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,	Var_Observaciones,	Var_CentroCostoID,
				Var_PartPresup,		Var_MontPresupuest,	Var_MontoAut,		Var_Estatus,		Var_FolioPresupID,	Var_ClaveDispMov,
				Var_TipoDeposito,		Var_NoFactura,		Var_ProveedorID;



			if(Var_Estatus = Est_Pendiente)then
				Set Var_Sucursal := (select SucursalID from REQGASTOSUCUR where NumReqGasID = Var_NumReqGasID);
				Set Var_FechaSistema := (select FechaSistema from PARAMETROSSIS);

				if(Var_TipoGastoAnt <> Var_TipoGastoID)then
					Set Var_MontoDispon := (select MontoDispon
										from PRESUCURDET D,
											 PRESUCURENC E
									    where  MesPresupuesto		= (month(Var_FechaSistema))
											and AnioPresupuesto	= (year(Var_FechaSistema))
											and SucursalOrigen 	= Var_Sucursal
											and D.Estatus  		= Est_Aprobado
											and Concepto 			= Var_TipoGastoID
											and 	EncabezadoID 		= E.FolioID);
					Set Var_MontoDispon	:= ifnull(Var_MontoDispon, Entero_Cero);
					Set Var_NoPresup		:= Entero_Cero;
				end if;

				Set Var_TipoGastoAnt	:= Var_TipoGastoID;
				Set Var_PartPresup 	:= Var_MontoDispon;
				if(Var_MontPresupuest <= Var_MontoDispon)then
					Set Var_MontoDispon	:= Var_MontoDispon - Var_MontPresupuest;
				else
					Set Var_NoPresup		:= Var_MontPresupuest - Var_MontoDispon;
					Set Var_MontoDispon	:= Entero_Cero;
				end if;
			end if;
			insert into TMPREQGASTOSMOVS values (
				Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,					Var_Observaciones,	Var_CentroCostoID,
				Var_PartPresup,		Var_MontPresupuest,	ifnull(Var_NoPresup,Entero_Cero),	Var_MontoAut,			Var_Estatus,
				Var_FolioPresupID,	Var_ClaveDispMov,		Var_TipoDeposito,					Var_NoFactura,		Var_ProveedorID);

		End Loop;
		END;
		Close CursorReqMov;

		select 	DetReqGasID,		NumReqGasID,		TipoGastoID,		Observaciones,	CentroCostoID,
				PartPresupuesto,	MontPresupuest,	NoPresupuestado, 	MontoAutorizado,	Estatus,
				FolioPresupID, 	ClaveDispMov,		TipoDeposito,		NoFactura,		ProveedorID
		from TMPREQGASTOSMOVS;

		Drop Table IF EXISTS TMPREQGASTOSMOVS;

end if;


if (Con_DentroPre = Par_NumCon)then
	Drop Table IF EXISTS TMPREQGASTOSMOVS;
	Create Temporary Table TMPREQGASTOSMOVS(
		DetReqGasID int,	NumReqGasID int,	TipoGastoID int,	Observaciones varchar(50),	CentroCostoID int,
		PartPresupuesto decimal(12,2),	MontPresupuest decimal(12,2),	NoPresupuestado decimal(12,2),	MontoAutorizado decimal(12,2),	Estatus char(1),
		FolioPresupID int, 	ClaveDispMov int,		TipoDeposito char(1),	NoFactura varchar(20), ProveedorID int
	);
	Open  CursorReqMov;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorReqMov  Into
				Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,	Var_Observaciones,	Var_CentroCostoID,
				Var_PartPresup,		Var_MontPresupuest,	Var_MontoAut,		Var_Estatus,		Var_FolioPresupID,	Var_ClaveDispMov,
				Var_TipoDeposito,		Var_NoFactura,		Var_ProveedorID;


			if(Var_Estatus = Est_Pendiente)then
				Set Var_Sucursal := (select SucursalID from REQGASTOSUCUR where NumReqGasID = Var_NumReqGasID);
				Set Var_FechaSistema := (select FechaSistema from PARAMETROSSIS);

				if(Var_TipoGastoAnt <> Var_TipoGastoID)then
					Set Var_MontoDispon := (select MontoDispon
										from PRESUCURDET D,
											 PRESUCURENC E
									    where  MesPresupuesto		= (month(Var_FechaSistema))
											and AnioPresupuesto	= (year(Var_FechaSistema))
											and SucursalOrigen 	= Var_Sucursal
											and D.Estatus  		= Est_Aprobado
											and Concepto 			= Var_TipoGastoID
											and 	EncabezadoID 		= E.FolioID);
					Set Var_MontoDispon	:= ifnull(Var_MontoDispon, Entero_Cero);
					Set Var_NoPresup		:= Entero_Cero;
				end if;

				Set Var_TipoGastoAnt	:= Var_TipoGastoID;
				Set Var_PartPresup 	:= Var_MontoDispon;
				if(Var_MontPresupuest <= Var_MontoDispon)then
					Set Var_MontoDispon	:= Var_MontoDispon - Var_MontPresupuest;
				else
					Set Var_NoPresup		:= Var_MontPresupuest - Var_MontoDispon;
					Set Var_MontoDispon	:= Entero_Cero;
					Set Var_NoFacturaFue	:= Var_NoFactura;
					Delete from TMPREQGASTOSMOVS where NoFactura = Var_NoFactura;
				end if;

				if(ifnull(Var_NoFactura,Cadena_Vacia) <>Cadena_Vacia)then
					if(ifnull(Var_NoFactura,Cadena_Vacia) <> Var_NoFacturaFue)then
						insert into TMPREQGASTOSMOVS values (
							Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,					Var_Observaciones,	Var_CentroCostoID,
							Var_PartPresup,		Var_MontPresupuest,	ifnull(Var_NoPresup,Entero_Cero),	Var_MontoAut,			Var_Estatus,
							Var_FolioPresupID,	Var_ClaveDispMov,		Var_TipoDeposito,					Var_NoFactura,		Var_ProveedorID);
					end if;
				else
					insert into TMPREQGASTOSMOVS values (
						Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,					Var_Observaciones,	Var_CentroCostoID,
						Var_PartPresup,		Var_MontPresupuest,	ifnull(Var_NoPresup,Entero_Cero),	Var_MontoAut,			Var_Estatus,
						Var_FolioPresupID,	Var_ClaveDispMov,		Var_TipoDeposito,					Var_NoFactura,		Var_ProveedorID);
				end if;
			else
				insert into TMPREQGASTOSMOVS values (
					Var_DetReqGasID,		Var_NumReqGasID,		Var_TipoGastoID,					Var_Observaciones,	Var_CentroCostoID,
					Var_PartPresup,		Var_MontPresupuest,	ifnull(Var_NoPresup,Entero_Cero),	Var_MontoAut,			Var_Estatus,
					Var_FolioPresupID,	Var_ClaveDispMov,		Var_TipoDeposito,					Var_NoFactura,		Var_ProveedorID);

			end if;
		End Loop;
		END;
		Close CursorReqMov;

		select	DetReqGasID,		NumReqGasID,		TipoGastoID,		Observaciones,	CentroCostoID,
				PartPresupuesto,	MontPresupuest,	NoPresupuestado, 	MontoAutorizado,	Estatus,
				FolioPresupID, 	ClaveDispMov,		TipoDeposito,		NoFactura,		ProveedorID
		 from 	TMPREQGASTOSMOVS
		 where 	NumReqGasID = Par_NumReqGasID
		 and 	NoPresupuestado <= Entero_Cero;

		Drop Table IF EXISTS TMPREQGASTOSMOVS;
end if;

END TerminaStore$$