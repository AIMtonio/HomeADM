-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREMESINVERSIONES
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREMESINVERSIONES`;DELIMITER $$

CREATE PROCEDURE `CIERREMESINVERSIONES`(

	Par_FechaSis		DATE,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore:BEGIN


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	Fecha_Vacia		DATE;


	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;
	SET	Fecha_Vacia		:= '1900-01-01';


	INSERT INTO HISINVERSIONES(
			FechaCorte,		 InversionID, 		CuentaAhoID,		ClienteID,			TipoInversionID,
			FechaInicio,	 FechaVencimiento,	Monto,				Plazo,				Tasa,
			TasaISR,		 TasaNeta,			InteresGenerado,	InteresRecibir,		InteresRetener,
			Estatus,	 	 UsuarioID,			Reinvertir,			EstatusImpresion,	InversionRenovada,
			MonedaID,	 	 Etiqueta,			SaldoProvision,		ValorGat,			Beneficiario,
			ValorGatReal,	 FechaVenAnt,		ISRReal,			EmpresaID,			Usuario,
           		FechaActual,	 DireccionIP,		ProgramaID,			Sucursal,		 	NumTransaccion)
	   SELECT
			Par_FechaSis,	 InversionID,	 	CuentaAhoID, 		ClienteID,			TipoInversionID,
			FechaInicio,	 FechaVencimiento,	Monto,				Plazo,				Tasa,
			TasaISR,		 TasaNeta,			InteresGenerado,	InteresRecibir,		InteresRetener,
			Estatus,		 UsuarioID,			Reinvertir,			EstatusImpresion,	InversionRenovada,
			MonedaID,		 Etiqueta,			SaldoProvision,		ValorGat,			Beneficiario,
			ValorGatReal,	 FechaVenAnt,		ISRReal,			Par_EmpresaID,		Aud_Usuario,
            		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			FROM INVERSIONES;

END TerminaStore$$