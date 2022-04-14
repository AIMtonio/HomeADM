-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERACIONDIVISAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERACIONDIVISAALT`;
DELIMITER $$


CREATE PROCEDURE `OPERACIONDIVISAALT`(
	Par_MonedaID			int,
	Par_NumeroMovimiento	bigint,
	Par_Fecha			date,
	Par_MontoMN			float,
	Par_MontoDivisa		float,
	Par_TipoCambio		double,
	Par_Origen			char(1),
	Par_TipoOperacion		char(1),
	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(30),
	Par_Empresa			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN

INSERT INTO `OPERACIONDIVISA`	(
			`MonedaID`,					`NumeroMovimiento`,				`Fecha`,					`MontoMN`,					`MontoDivisa`,
			`TipoCambio`,				`Origen`,						`TipoOperacion`,			`Descripcion`,				`Referencia`,
			`EmpresaID`,				`Usuario`,						`FechaActual`,				`DireccionIP`,				`ProgramaID`,
			`Sucursal`,					`NumTransaccion`)
values (
			Par_MonedaID,		Par_NumeroMovimiento,	Par_Fecha,			Par_MontoMN, 		Par_MontoDivisa,
			Par_TipoCambio, 	Par_Origen, 			Par_TipoOperacion, 	Par_Descripcion,	Par_Referencia,
			Par_Empresa,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$
