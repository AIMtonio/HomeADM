-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASFIRMABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASFIRMABAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASFIRMABAJ`(
	Par_CuentaAhoID			bigint(12),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
			)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Entero_Cero		int;
	DECLARE	NumeroFirma		int;
	DECLARE	NumeroTrans		int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	NumeroFirma		:= 0;

	Set Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO `HIS-CUENTASFIRMA` (	Fecha,		`CuentaFirmaID`, 	`CuentaAhoID`, 	`PersonaID`,
							`NombreCompleto`,`Tipo`, 			InstrucEspecial, EmpresaID,
							Usuario, 		`FechaActual`, 		`DireccionIP`,  	`ProgramaID`,
							`Sucursal`)
					SELECT 	CURRENT_TIMESTAMP,CuentaFirmaID, 		`CuentaAhoID`, 	`PersonaID`,
							`NombreCompleto`, `Tipo`, 			InstrucEspecial,	EmpresaID,
							`Usuario`, 		`FechaActual`, 		`DireccionIP`,	`ProgramaID`,
							`Sucursal` FROM CUENTASFIRMA WHERE CuentaAhoID = Par_CuentaAhoID;


	DELETE
	FROM 		CUENTASFIRMA
	WHERE 	CuentaAhoID		= Par_CuentaAhoID;


select '000' as NumErr ,
	  'Firmantes  Eliminados' as ErrMen,
	  'cuentaAhoID' as control;

END TerminaStore$$