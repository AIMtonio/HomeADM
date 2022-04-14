-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCATTIPGASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOCATTIPGASCON`;DELIMITER $$

CREATE PROCEDURE `TESOCATTIPGASCON`(
	Par_TipoGasto 		INT,
	Par_NumCon			TINYINT UNSIGNED,


	Aud_EmpresaID			INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN



-- Declaracion de constantes
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE Con_Foranea		INT;
DECLARE Con_CajaChica	INT;

-- Asignacion de constantes
SET	Entero_Cero		:= 0;
SET	Con_Principal	:= 1;
SET Con_Foranea		:= 2;
SET Con_CajaChica	:= 3;

-- consulta principal
IF(Par_NumCon = Con_Principal) THEN

SELECT 	TipoGastoID, 	Descripcion, CuentaCompleta,	CajaChica, 	RepresentaActivo,
		TipoActivoID,	Estatus
    FROM TESOCATTIPGAS
    WHERE TipoGastoID	=	Par_TipoGasto;

END IF;




END TerminaStore$$