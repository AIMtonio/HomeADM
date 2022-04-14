-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESFRLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVIDADESFRLIS`;DELIMITER $$

CREATE PROCEDURE `ACTIVIDADESFRLIS`(
	Par_ActividadBMXID	VARCHAR(15),
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Lis_Principal 	INT(11);
DECLARE	Lis_FiltroFR	INT(11);
DECLARE Condicion		VARCHAR(200);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Principal		:= 1;
SET	Lis_FiltroFR		:= 2;

SET Condicion :=(	SELECT FR.Descripcion
						FROM ACTIVIDADESBMX	BMX
						LEFT OUTER JOIN ACTIVIDADESFR AS FR
													ON BMX.ActividadFR = FR.ActividadFRID
						WHERE BMX.ActividadBMXID	= Par_ActividadBMXID);


IF(Par_NumLis = Lis_Principal) THEN
	IF(ifnull(Condicion,Cadena_Vacia) != Cadena_Vacia)THEN
		SELECT	 FR.ActividadFRID, CONCAT(CAST(FR.ActividadFRID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FR.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
			FROM ACTIVIDADESBMX	BMX
			LEFT OUTER JOIN ACTIVIDADESFR AS FR  ON BMX.ActividadFR = FR.ActividadFRID
			WHERE BMX.ActividadBMXID 	= Par_ActividadBMXID;
	ELSE
		SELECT	 FR.ActividadFRID,  CONCAT(CAST(FR.ActividadFRID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FR.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
			FROM CLIENTES 	C
			INNER JOIN ACTIVIDADESFR	AS FR	ON C.ActividadFR = FR.ActividadFRID
			INNER JOIN ACTIVIDADESBMX	AS BM	ON C.ActividadBancoMX = BM.ActividadBMXID
			WHERE BM.ActividadBMXID 	= Par_ActividadBMXID;
	END IF;
END IF;


IF(Par_NumLis = Lis_FiltroFR) THEN
	SELECT FR.ActividadFRID,  CONCAT(CAST(FR.ActividadFRID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FR.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
		FROM ACTIVIDADESFR FR,
			ACTIVIDADESBMX BM
		WHERE BM.ACTIVIDADBMXID = Par_ActividadBMXID
			AND (FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,6)
			OR FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,5)
			OR FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,4)
			OR FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,3)
			OR FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,2)
			OR FR.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,1));
END IF;

END TerminaStore$$