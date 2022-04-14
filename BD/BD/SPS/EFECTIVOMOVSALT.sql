-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EFECTIVOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EFECTIVOMOVSALT`;DELIMITER $$

CREATE PROCEDURE `EFECTIVOMOVSALT`(

	Par_CuentaAhoID			BIGINT(12),
	Par_NumeroMov			BIGINT(20),
	Par_Fecha				DATE,
	Par_NatMovimiento		CHAR(1),
	Par_CantidadMov			DECIMAL(12,2),
	Par_DescripcionMov		VARCHAR(150),
	Par_ReferenciaMov		VARCHAR(50),
	Par_TipoMovAhoID		CHAR(4),
	Par_MonedaID			INT,
	Par_ClienteID			INT,

	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

		)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Cero			float;
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Fecha				DATE;
	DECLARE	No_Considerado		CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Float_Cero			:= 0.0;

	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET	No_Considerado		:= 'N';


	INSERT EFECTIVOMOVS (
			CuentasAhoID,			ClienteID,				NumeroMov,			Fecha,				NatMovimiento,
			CantidadMov, 			DescripcionMov, 		ReferenciaMov, 		TipoMovAhoID, 		MonedaID,
			Estatus, 				EmpresaID, 				Usuario, 			FechaActual, 		DireccionIP,
			ProgramaID, 			Sucursal, 				NumTransaccion)

		VALUES(
			Par_CuentaAhoID,		Par_ClienteID,			Aud_NumTransaccion,		Par_Fecha,			Par_NatMovimiento,
			Par_CantidadMov,		Par_DescripcionMov,		Par_ReferenciaMov,		Par_TipoMovAhoID,	Par_MonedaID,
			No_Considerado,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

END TerminaStore$$