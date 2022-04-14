-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESFOMURLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTIVIDADESFOMURLIS`;DELIMITER $$

CREATE PROCEDURE `ACTIVIDADESFOMURLIS`(
    Par_ActividadBMXID  VARCHAR(15),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Lis_Principal 	INT(11);
DECLARE	Lis_FiltroFomur	INT(11);
DECLARE Condicion		VARCHAR(200);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Principal		:= 1;
SET	Lis_FiltroFomur		:= 2;


SET Condicion :=( SELECT FM.Descripcion
					FROM ACTIVIDADESBMX	BMX
					LEFT OUTER JOIN ACTIVIDADESFOMUR AS FM  ON BMX.ActividadFOMUR = FM.ActividadFOMURID
					WHERE BMX.ActividadBMXID 	= Par_ActividadBMXID);


IF(Par_NumLis = Lis_Principal) THEN
	IF  (IFNULL(Condicion,Cadena_Vacia) != Cadena_Vacia)THEN
		SELECT	 FM.ActividadFOMURID, CONCAT(CAST(FM.ActividadFOMURID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FM.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
			FROM ACTIVIDADESBMX	BMX
			LEFT OUTER JOIN ACTIVIDADESFOMUR AS FM  ON BMX.ActividadFOMUR = FM.ActividadFOMURID
			WHERE BMX.ActividadBMXID 	= Par_ActividadBMXID;
	ELSE
		SELECT	 FM.ActividadFOMURID,  CONCAT(CAST(FM.ActividadFOMURID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FM.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
			FROM CLIENTES C
            INNER JOIN ACTIVIDADESFOMUR AS FM	ON C.ActividadFOMURID = FM.ActividadFOMURID
            INNER JOIN ACTIVIDADESBMX	AS BM	ON C.ActividadBancoMX = BM.ActividadBMXID
            WHERE BM.ActividadBMXID 	= Par_ActividadBMXID;
	END IF;
END IF;


IF(Par_NumLis = Lis_FiltroFomur) THEN
	SELECT FM.ActividadFOMURID,  CONCAT(CAST(FM.ActividadFOMURID AS CHAR CHARACTER SET utf8 ),".- ",CAST(SUBSTRING(FM.Descripcion,1,100)AS CHAR CHARACTER SET utf8))
		FROM ACTIVIDADESFOMUR FM,
			ACTIVIDADESBMX BM
		WHERE BM.ACTIVIDADBMXID = Par_ActividadBMXID
			AND (FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,6)
			OR FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,5)
			OR FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,4)
			OR FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,3)
			OR FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,2)
			OR FM.FamiliaBANXICO LIKE SUBSTRING(Par_ActividadBMXID,1,1));
END IF;

END TerminaStore$$