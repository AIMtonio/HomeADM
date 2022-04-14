-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMOVSLIS`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSMOVSLIS`(
	/*SP para listar los movimientos de los creditos*/
	Par_CreditoID			BIGINT(12),
	Par_NumLista			TINYINT UNSIGNED,
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TERMINASTORE: BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Con_Movs			INT;
	DECLARE Con_MovsRep 		INT;
	DECLARE Con_MovsCont 		INT;

	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Movs		:= 1;
	SET Con_MovsRep 	:= 2;
	SET Con_MovsCont 	:= 3;


	IF(Con_Movs = Par_NumLista)THEN

		SELECT	Mov.AmortiCreID,	Mov.FechaOperacion,	Mov.Descripcion,	Tip.Descripcion AS TipoMovCreID,	Mov.NatMovimiento,
				FORMAT(ROUND(Mov.Cantidad,2),2)
				FROM	CREDITOSMOVS Mov,
						TIPOSMOVSCRE Tip
				WHERE	Mov.CreditoID 	= Par_CreditoID
				AND		Mov.TipoMovCreID 	= Tip.TipoMovCreID
				ORDER BY Mov.FechaOperacion;
	END IF;


	IF(Par_NumLista = Con_MovsRep)THEN

		SELECT	AmortiCreID,	Transaccion,	FechaOperacion,	FechaAplicacion,	Descripcion,
				TipoMovCreID,	NatMovimiento,	MonedaID,		Cantidad,			Descripcion,
				Referencia
				FROM CREDITOSMOVS
				WHERE CreditoID = Par_CreditoID;
	END IF;

	IF(Con_MovsCont = Par_NumLista)THEN

		SELECT	Mov.AmortiCreID,	Mov.FechaOperacion,	Mov.Descripcion,	Tip.Descripcion AS TipoMovCreID,	Mov.NatMovimiento,
				FORMAT(ROUND(Mov.Cantidad,2),2)
				FROM	CREDITOSCONTMOVS Mov,
						TIPOSMOVSCRE Tip
				WHERE	Mov.CreditoID 	= Par_CreditoID
				AND		Mov.TipoMovCreID 	= Tip.TipoMovCreID
				ORDER BY Mov.FechaOperacion;
	END IF;

END TERMINASTORE$$