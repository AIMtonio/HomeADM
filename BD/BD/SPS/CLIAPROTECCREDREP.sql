-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCREDREP`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCREDREP`(




	Par_ClienteID			INT(11),

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Rep_Principal		INT;


DECLARE Var_Sentencia	VARCHAR(9000);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Rep_Principal		:= 1;


if(Par_NumRep = Rep_Principal) then

	set Var_Sentencia :=  'SELECT  Pro.CreditoID, Pro.MontoAdeudo, Pro.MontoAplicaCred';

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CLIAPROTECCRED Pro');

	if(ifnull(Par_ClienteID,Entero_Cero) != Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE Pro.ClienteID = ', Par_ClienteID);
    end if;

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by  Pro.CreditoID;');

	set @Sentencia	= (Var_Sentencia);

	PREPARE STCLIAPROTECCREDREP FROM @Sentencia;
	EXECUTE STCLIAPROTECCREDREP;

	DEALLOCATE PREPARE STCLIAPROTECCREDREP;

end if;



END TerminaStore$$