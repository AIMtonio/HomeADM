-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRECUENTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRECUENTALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRECUENTALT`(

    Par_SolicitudID         varchar(10),
	Par_Consecutivo	    		int(11),
	Par_FecActualizacion		date,
	Par_RegImpugnado		varchar(45),
	Par_ClaveOtorgante		varchar(45),
	Par_NomOtorgante		varchar(45),
	Par_CuentaActual		varchar(45),
	Par_TipRespons			varchar(45),
	Par_TipoCuenta			varchar(45),
	Par_TipoCredito			varchar(45),

	Par_ClaveUniMon			varchar(45),
	Par_ValActValuacion		decimal(14,2),
	Par_NumeroPagos			int(11),
	Par_FrecuenciaPagos		varchar(5),
	Par_MontoPagar			decimal(14,2),
	Par_FecApeCuenta		date,
	Par_FecUltPago			date,
	Par_FecUltCompra		date,
	Par_FecCieCuenta		date,
	Par_FecRespote			date,

	Par_UltFecSalCero		date,
	Par_Garantia			varchar(100),
	Par_CreditoMaximo		decimal(14,2),
	Par_SaldoActual			decimal(14,2),
	Par_LimiteCredito		decimal(14,2),
	Par_SaldoVencido		decimal(14,2),
	Par_NumPagVencidos		int(11),
	Par_Cuenta				varchar(45),
	Par_MOP0				int(11),
	Par_MOP1				int(11),

	Par_MOP2				int(11),
	Par_MOP3				int(11),
	Par_MOP4				int(11),
	Par_ClavePreven			varchar(45),
	Par_TotalPagosRep		decimal(14,2) ,
	Par_FecAntHisPagos		date,
	Par_PagoActual			varchar(2),
	Par_PeorAtraso			int,
	Par_FechaPeorAtraso		date,
	Par_SalVenPeorAtraso	int,


	Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350)


	)
TerminaStore: BEGIN

DECLARE varControl		varchar(50);
DECLARE varConsecutivo	int(11);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		varchar(30);
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '--';
Set Entero_Cero			:= 0;
set Salida_SI			:='S';
set Var_NO				:='N';
set varConsecutivo		:= 0;



set varConsecutivo := (select ifnull(Max(Consecutivo),Entero_Cero) + 1 from CIRCULOCRECUENT where fk_SolicitudID = Par_SolicitudID);

insert into CIRCULOCRECUENT(
	fk_SolicitudID,		Consecutivo,		FecActualizacion, 	RegImpugnado,		ClaveOtorgante,
	NomOtorgante,		CuentaActual, 		TipRespons,	 		TipoCuenta,			TipoCredito,
	ClveUniMon,			ValActValuacion,	NumeroPagos,		FrecuenciaPagos,	MontoPagar,
	FecApeCuenta,		FecUltPago,			FecUltCompra,		FecCieCuenta,		FecRespote,
	UltFecSalCero,		Garantia, 			CreditoMaximo,		SaldoActual,		LimiteCredito,
	SaldoVencido,		NumPagVencidos,		Cuenta,				MOP0,				MOP1,
	MOP2,				MOP3,				MOP4,				ClavePreven,		TotalPagosRep,
	FecAntHisPagos,		PagoActual,			PeorAtraso,			FechaPeorAtraso,	SalVenPeorAtraso)
values (
	Par_SolicitudID,    varConsecutivo,      	Par_FecActualizacion, Par_RegImpugnado,	  Par_ClaveOtorgante,
	Par_NomOtorgante,	Par_CuentaActual,	  	Par_TipRespons,		Par_TipoCuenta,		  Par_TipoCredito,
	Par_ClaveUniMon,	Par_ValActValuacion, 	Par_NumeroPagos,	    Par_FrecuenciaPagos,  Par_MontoPagar,
	Par_FecApeCuenta,	Par_FecUltPago,	  	  	Par_FecUltCompra,	  	Par_FecCieCuenta,	  Par_FecRespote,
	Par_UltFecSalCero,	Par_Garantia,		 	Par_CreditoMaximo,    	Par_SaldoActual,      	Par_LimiteCredito,
	Par_SaldoVencido,   Par_NumPagVencidos,  	Par_Cuenta, 			Par_MOP0,			  	Par_MOP1,
	Par_MOP2,			Par_MOP3,			  	Par_MOP4,			    Par_ClavePreven,	  	Par_TotalPagosRep,
	Par_FecAntHisPagos,	Par_PagoActual,			Par_PeorAtraso,			Par_FechaPeorAtraso,	Par_SalVenPeorAtraso);

set Par_NumErr  := 000;
set Par_ErrMen  := concat('La Cadena de cuentas se ha insertado correctamente: ',Par_SolicitudID);
set varControl	:= 'fk_SolicitudID';

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$