-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORROBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAHORROBAJ`;DELIMITER $$

CREATE PROCEDURE `TASASAHORROBAJ`(
	Par_TasaAhorroID		int(11),


	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Entero_Cero		int;

Set	Entero_Cero			:= 0;

if(ifnull(Par_TasaAhorroID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Numero de Tasa de Ahorro esta Vacio.' as ErrMen,
		 'tasaAhorroID' as control,
		 Entero_Cero as consecutivo;
	LEAVE TerminaStore;
end if;
	Set Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO `HIS-TASASAHORRO` (Fecha,		TasaAhorroID,	TipoCuentaID,	TipoPersona,
						  MonedaID,		MontoInferior,	MontoSuperior,  	Tasa,
						  Usuario,		EmpresaID,		FechaActual,	DireccionIP,
						  ProgramaID,	Sucursal,		NumTransaccion
						)
		SELECT 	CURRENT_TIMESTAMP,	TasaAhorroID,	TipoCuentaID,	TipoPersona,
				MonedaID,			MontoInferior,	MontoSuperior,  	Tasa,
				EmpresaID,			`Usuario`, 		`FechaActual`, 	`DireccionIP`,
				`ProgramaID`, 		`Sucursal` , 	NumTransaccion
		FROM 		TASASAHORRO 	WHERE 	TasaAhorroID = Par_TasaAhorroID;


	DELETE
	FROM 		TASASAHORRO
	WHERE 	TasaAhorroID		= Par_TasaAhorroID;


select '000' as NumErr ,
		  concat('Tasa de Ahorro Eliminada Exitosamente: ',convert(Par_TasaAhorroID,char)) as ErrMen,
	  'tasaAhorroID' as control,
	  Par_TasaAhorroID as consecutivo;

END TerminaStore$$