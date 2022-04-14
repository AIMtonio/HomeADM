-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBINICIACONTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBINICIACONTAPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBINICIACONTAPRO`(
	Par_NumProceso		int,

	Par_Salida			char(1),
inout Par_NumErr		int,
inout Par_ErrMen		varchar(150)

)
TerminaStore:BEGIN
	DECLARE Cadena_Vacia	char(1);
	DECLARE Entero_Cero		int(11);
	DECLARE Decimal_Cero	decimal(12,2);
	DECLARE Salida_SI		char(1);
	DECLARE Pro_Inicia		int;
	DECLARE Pro_CierreDia	int;
	DECLARE Pro_CierreMes	int;
	DECLARE Est_Activa		int;
	DECLARE Est_Bloqueada	int;

	Set	Cadena_Vacia	:= '';
	Set Entero_Cero		:= 0;
	Set Decimal_Cero	:= 0.00;
	Set Pro_Inicia		:= 1;
	Set Pro_CierreDia	:= 1;
	Set Pro_CierreMes	:= 2;
	Set Est_Activa		:= 7;
	Set Est_Bloqueada	:= 8;

	if ( Par_NumProceso = Pro_CierreDia) then
		UPDATE TARJETADEBITO	SET
			NoDispoDiario		=	Entero_Cero,
			MontoDispoDiario	=	Decimal_Cero,
			NoCompraDiario		=	Entero_Cero,
			MontoCompraDiario	= 	Decimal_Cero
			WHERE Estatus = Est_Activa OR Estatus = Est_Bloqueada;
	end if;

	if ( Par_NumProceso = Pro_CierreMes) then
		UPDATE TARJETADEBITO	SET
			NoDispoDiario		=	Entero_Cero,
			MontoDispoDiario	=	Decimal_Cero,
			NoCompraDiario		=	Entero_Cero,
			MontoCompraDiario	= 	Decimal_Cero,

			NoDispoMes			= 	Entero_Cero,
			MontoDispoMes		= 	Decimal_Cero,
			NoConsultaSaldoMes	=	Entero_Cero,
			NoCompraMes			=	Entero_Cero,
			MontoCompraMes		= 	Decimal_Cero
		WHERE Estatus = Est_Activa OR Estatus = Est_Bloqueada;
	end if;



	Set Par_NumErr	:= 0;
	Set Par_ErrMen 	:= 'Proceso Finalizado Exitosamente';

	if (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr,
			Par_ErrMen;
	end if;

END TerminaStore$$