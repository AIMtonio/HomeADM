-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREMESASMOD
DELIMITER ;
DROP procedure IF EXISTS `PAGOREMESASMOD`;
DELIMITER $$

CREATE PROCEDURE `PAGOREMESASMOD`(
	Par_RemesaFolio		varchar(45),
	
    Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
BEGIN

	DECLARE Entero_Cero  			INT;
	DECLARE Entero_Incremento     	INT;
	DECLARE Par_NumErr 				INT(11);
	DECLARE Par_ErrMen				VARCHAR(400);
	
	SET Entero_Cero     			:=0;
	SET Entero_Incremento			:=1;
	SET Par_NumErr					:=0;
	SET Par_ErrMen    				:='Modificación de registro exitosa';

	UPDATE PAGOREMESAS SET 
		NumeroImpresiones = ifnull(NumeroImpresiones,Entero_Cero) + Entero_Incremento,
		EmpresaID = Par_EmpresaID,
		Usuario = Aud_Usuario,
		FechaActual = Aud_FechaActual,
		DireccionIP =Aud_DireccionIP,
		ProgramaID = Aud_ProgramaID,
		Sucursal = Aud_Sucursal 
	where 
		RemesaFolio = Par_RemesaFolio;
	
	SELECT 
		convert(Par_NumErr, CHAR(3)) AS NumErr,
		Par_ErrMen	AS ErrMen, 
		NumeroImpresiones, 
		RemesaFolio 
	from 
		PAGOREMESAS 
	where 
		RemesaFolio = Par_RemesaFolio;
	
END$$