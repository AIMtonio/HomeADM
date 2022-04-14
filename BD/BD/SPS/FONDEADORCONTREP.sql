-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEADORCONTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEADORCONTREP`;DELIMITER $$

CREATE PROCEDURE `FONDEADORCONTREP`(
	Par_CreditoFondeoID	int(11),
	Par_NomInstitucion  varchar(200),
	Par_Fecha 			varchar(50),

	Par_EmpresaID      	int,
	Aud_Usuario        	int,
	Aud_FechaActual    	datetime,
	Aud_DireccionIP    	varchar(15),
	Aud_ProgramaID     	varchar(50),
	Aud_Sucursal       	int,
	Aud_NumTransaccion 	bigint
	)
BEGIN

DECLARE Var_DirecCompletaSuc	varchar(200);
DECLARE Var_RepLegal			varchar(200);
DECLARE Var_NombreIns			varchar(200);
DECLARE var_Montoletras			varchar(200);
DECLARE Var_MunicipioNom		varchar(200);
DECLARE Var_EstadoNom			varchar(200);
DECLARE Var_Calle				varchar(200);
DECLARE Var_Num					varchar(200);
DECLARE Var_Col					varchar(200);
DECLARE Var_Municipio			varchar(200);
DECLARE Var_EstadoID			varchar(200);
DECLARE Var_CP					varchar(200);
DECLARE Var_NumCtaInstit		varchar(20);
DECLARE Var_CuentaClabe			varchar(18);
DECLARE Var_NombreTitular		varchar(50);
DECLARE Var_NombreInstitucion	varchar(50);
DECLARE Var_Monto				decimal(14,2);
DECLARE Var_Fecha				varchar(20);
DECLARE Var_Ins					int(11);
DECLARE Var_NombreInstitFon		varchar(100);
DECLARE Var_FechaInicio			date;

	select Suc.Calle, Suc.Numero, Suc.Colonia, Suc.MunicipioID, Suc.EstadoID,
		   Suc.CP,	  Par.NombreRepresentante
	  into Var_Calle, Var_Num,    Var_Col,     Var_Municipio,   Var_EstadoID,
		   Var_CP,    Var_RepLegal
		from SUCURSALES Suc,
			PARAMETROSSIS Par
			where SucursalID=Aud_Sucursal;
	select Mun.Nombre,Est.Nombre
		into Var_MunicipioNom,Var_EstadoNom
		from MUNICIPIOSREPUB Mun,
			 ESTADOSREPUB Est
			where   Mun.EstadoID   =Var_EstadoID
				and Est.EstadoID   =Mun.EstadoID
				and Mun.MunicipioID=Var_Municipio;

		select  I.NumCtaInstit,	 I.CuentaClabe,   I.NombreTitular,  C.Monto,         Ins.Nombre,
				C.FechaVencimien,I.InstitutFondID,case I.TipoFondeador when 'M' then
														(select RazonSocInstFo from INSTITUTFONDEO where InstitutFondID=C.InstitutFondID)
														else (select NombreInstitFon from INSTITUTFONDEO where InstitutFondID=C.InstitutFondID)end,
				C.FechaInicio
				into Var_NumCtaInstit,Var_CuentaClabe,Var_NombreTitular,Var_Monto,Var_NombreInstitucion,
					 Var_Fecha,Var_Ins,Var_NombreInstitFon,Var_FechaInicio
		from INSTITUTFONDEO I
		inner join CREDITOFONDEO C on I.InstitutFondID=C.InstitutFondID
		inner  join INSTITUCIONES Ins on Ins.InstitucionID=I.IDInstitucion
			where C.CreditoFondeoID=Par_CreditoFondeoID;
	select  FUNCIONNUMLETRAS (Var_Monto) into var_Montoletras;
	select Var_RepLegal,    Var_Calle,	      	Var_Num,       		Var_Col,         Var_CP,
		   Var_MunicipioNom,Var_EstadoNom,    	var_Montoletras , 	Var_NumCtaInstit,
		   Var_CuentaClabe, Var_NombreTitular,	Var_NombreInstitucion,format(Var_Monto, 2)as Var_Monto ,Var_Fecha,
		   Var_Ins,			Var_NombreInstitFon,Var_FechaInicio;

END$$