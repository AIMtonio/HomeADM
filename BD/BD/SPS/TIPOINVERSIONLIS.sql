-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINVERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOINVERSIONLIS`;
DELIMITER $$


CREATE PROCEDURE `TIPOINVERSIONLIS`(
	Par_Descripcion	VARCHAR(100),
	Par_MonedaID	INT,
	Par_NumLis		INT,
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)

TerminaStore: BEGIN

	DECLARE Lis_Principal			INT;
	DECLARE Lis_Secundaria			INT;
	DECLARE Lis_TiposInver			INT;
	DECLARE Lis_PorMoneda			INT;
    DECLARE Lis_TiposInverAct		INT(11);		-- Lista los tipos de inversiones activos
    DECLARE Lis_ComboTipInverAct	INT(11);		-- Lista Combo de los tipos de inversiones activos
    DECLARE Estatus_Activo			CHAR(2);		-- Estatus Activo

	SET	Lis_Principal			:= 1;
	SET	Lis_Secundaria			:= 2;
	SET	Lis_TiposInver			:= 3;
	SET	Lis_PorMoneda			:= 4;

    SET Lis_TiposInverAct 		:= 5;
    SET Lis_ComboTipInverAct	:= 6;
    SET Estatus_Activo		:= 'A';

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoInversionID, Descripcion
		FROM CATINVERSION
		WHERE  Descripcion LIKE concat("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Lis_Secundaria) THEN
		SELECT cat.TipoInversionID, cat.Descripcion
		FROM CATINVERSION cat, MONEDAS mon
		WHERE  cat.Descripcion LIKE concat("%", Par_Descripcion, "%")
		AND cat.MonedaID = Par_MonedaID
		AND cat.MonedaID = mon.MonedaID
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_TiposInver) THEN
		SELECT TipoInversionID, Descripcion
		FROM CATINVERSION
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Pormoneda) THEN
		SELECT cat.TipoInversionID, cat.Descripcion
		FROM CATINVERSION cat
		WHERE	cat.MonedaID = Par_MonedaID;
	END IF;

	IF(Par_NumLis = Lis_TiposInverAct) THEN
		SELECT	TipoInversionID, Descripcion
		FROM	CATINVERSION
		WHERE	Descripcion LIKE concat("%", Par_Descripcion, "%")
        AND		Estatus = Estatus_Activo
		LIMIT 0, 15;
	END IF;

    IF(Par_NumLis = Lis_ComboTipInverAct) THEN
		SELECT	TipoInversionID, Descripcion
		FROM	CATINVERSION
        WHERE	Estatus = Estatus_Activo
		LIMIT 0, 15;
	END IF;

END TerminaStore$$