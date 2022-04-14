-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLINEASCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPLINEASCREDALT`;
DELIMITER $$

CREATE PROCEDURE `TMPLINEASCREDALT`(


	Par_ClienteID 			int,
	Par_CuentaID 			bigint(12),
	Par_MonedaID 			int,
	Par_SucursalID 		int,
	Par_FolioContrato 		varchar(15),
	Par_FechaInicio		date,
	Par_FechaVencimiento 	date,
	Par_ProductoCreditoID 	int,
	Par_Solicitado			decimal(12,2),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint,
	out NumLineaCreditoID	char(12),
	out NumErr			int,
	out ErrMen			varchar(100)
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia		char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;
DECLARE		LineaCredito		int;
DECLARE		Estatus_Inactiva	char(1);

DECLARE		NumLineaCredito	char(11);

DECLARE		Verifica			int;
DECLARE     	i                		int;
DECLARE      	j                		int;
DECLARE      	Modulo2          	int;
DECLARE      	consecutivo      	int;
DECLARE      	NumVerificador   	char(1);
DECLARE Var_CobraComAnual	CHAR(1);		-- Variable que indica si cobra comisión anual

DECLARE Var_TipoComAnual	CHAR(1);		-- Variable que indica el tipo de cobro de comisión anual
DECLARE	Var_ValorComAnual	DECIMAL(14,2);	-- Variable para el valor monto o porcentaje de la comisión anual
DECLARE Con_NO				CHAR(1);		-- Constante NO
DECLARE Con_SI				CHAR(1);		-- Constante SI
DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero
DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set	Estatus_Inactiva	:= 'I';
SET Con_NO				:= 'N';
SET Con_SI				:= 'S';
SET	Decimal_Cero		:= 0.0;
SET Fecha_Vacia			:= '1900-01-01';


Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(ifnull( Aud_Usuario, Entero_Cero)) = Entero_Cero then
	set NumErr := 1 ;
	set ErrMen := 'El Usuario no esta logeado';
	LEAVE TerminaStore;
end if;

if (ifnull( Par_clienteID, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr :=  2 ;
	set ErrMen := 	'El ID de Cliente esta Vacio.' ;
	LEAVE TerminaStore;
end if;

if (ifnull( Par_SucursalID, Cadena_Vacia)) = Cadena_Vacia then
	set NumErr :=  3 ;
	set ErrMen := 	'La sucursal esta Vacia.' ;
	LEAVE TerminaStore;
end if;

set consecutivo := (SELECT ifnull(COUNT(*),0)+1 FROM LINEASCREDITO);
set NumLineaCredito := CONCAT((SELECT LPAD(Par_SucursalID,3,0)),(SELECT LPAD(consecutivo,7,0)));
set NumLineaCreditoID := CONCAT(NumLineaCredito,'8');

	-- Obtiene los parametros de la linea de crédito parametrizada en el producto de crédito
	SELECT	CobraComAnual,		TipoComAnual, 		ValorComAnual
	INTO 	Var_CobraComAnual,	Var_TipoComAnual,	Var_ValorComAnual
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID = Par_ProductoCreditoID;

	SET Aud_FechaActual := NOW();
	INSERT LINEASCREDITO (
		LineaCreditoID,		ClienteID,				CuentaID, 				MonedaID, 				SucursalID,
		FolioContrato,		FechaInicio,			FechaVencimiento,		ProductoCreditoID,		Solicitado,
		Autorizado,			Dispuesto,				Pagado,					SaldoDisponible,		SaldoDeudor,
		Estatus,			NumeroCreditos,			CobraComAnual,			TipoComAnual,			ValorComAnual,
		ComisionCobrada,	EsAgropecuario,			TipoLineaAgroID,		EsRevolvente,			ManejaComAdmon,
		ForCobComAdmon,		PorcentajeComAdmon,		ManejaComGarantia,		ForCobComGarantia,		PorcentajeComGarantia,
		FechaRechazo,		UsuarioRechazo,			MontoUltimoIncremento,	FechaReactivacion,		UsuarioReactivacion,
		SaldoComAnual,		FechaCancelacion,		FechaBloqueo,			FechaDesbloqueo,		FechaAutoriza,
		UsuarioAutoriza,	UsuarioBloqueo,			UsuarioDesbloq,			UsuarioCancela,			MotivoBloqueo,
		MotivoDesbloqueo,	MotivoCancela,			IdenCreditoCNBV,
		EmpresaID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
		Sucursal,			NumTransaccion)
	VALUES (
		NumLineaCreditoID,	Par_ClienteID,			Par_CuentaID,			Par_MonedaID,			Par_SucursalID,
		Par_FolioContrato,	Par_FechaInicio,		Par_FechaVencimiento,	Par_ProductoCreditoID,	Par_Solicitado,
		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
		Estatus_Inactiva,	Entero_Cero,			Var_CobraComAnual,		Var_TipoComAnual,		Var_ValorComAnual,
		Con_NO,				Con_NO,					Entero_Cero,			Con_NO,					Con_NO,
		Cadena_Vacia,		Entero_Cero,			Con_NO,					Cadena_Vacia,			Entero_Cero,
		Fecha_Vacia,		Entero_Cero,			Decimal_Cero,			Fecha_Vacia,			Entero_Cero,
		Entero_Cero,		Fecha_Vacia,			Fecha_Vacia,			Fecha_Vacia,			Fecha_Vacia,
		Entero_Cero,		Entero_Cero,			Entero_Cero,			Entero_Cero,			Cadena_Vacia,
		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

set NumErr := 0 ;
set ErrMen :=  concat("Linea de credito Agregada: ", convert(NumLineaCreditoID, CHAR));



END TerminaStore$$