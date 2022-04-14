-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTIALIS`;DELIMITER $$

CREATE PROCEDURE `GARANTIALIS`(

    Par_Observaciones   VARCHAR(70),
	Par_ClienteID		INT(11),
	Par_ProspectoID		INT(11),
	Par_GaranteNombre	VARCHAR (40),
    Par_TipoLis         INT(11),

    Aud_EmpresaID	    INT(11),
    Aud_Usuario	        INT(11),
    Aud_FechaActual		DATETIME,
    Aud_DireccionIP		VARCHAR(15),
    Aud_ProgramaID	    VARCHAR(70),
    Aud_Sucursal	    INT(11),
    Aud_NumTransaccion	BIGINT(20)

		)
TerminaStore: BEGIN


	DECLARE Lis_Cliente 	INT(11);
	DECLARE Lis_Prospecto 	INT(11);
	DECLARE Lis_CliPro		INT(11);
	DECLARE Cadena_Vacia	CHAR(1);


	SET Lis_Cliente		:=1;
	SET Lis_Prospecto	:=2;
	SET Lis_CliPro		:=3;
	SET Cadena_Vacia	:='';


    IF(Par_TipoLis = Lis_Cliente) THEN
        SELECT
        GarantiaID,	 Observaciones, ValorComercial
        FROM GARANTIAS WHERE Observaciones LIKE CONCAT("%", Par_Observaciones, "%")LIMIT 0,15;
	END IF;

	IF(Par_TipoLis = Lis_Prospecto) THEN
		SELECT
        GarantiaID,	 Observaciones, ValorComercial
        FROM GARANTIAS WHERE Observaciones LIKE CONCAT("%", Par_Observaciones, "%")LIMIT 0,15;
    END IF;


	IF(Par_TipoLis = Lis_CliPro) THEN
      SELECT LPAD(CONVERT(Gar.GarantiaID, CHAR), 10, 0) AS GarantiaID,
		CASE
			WHEN IFNULL(GaranteNombre,Cadena_Vacia) != Cadena_Vacia
				THEN GaranteNombre
			WHEN IFNULL(Cli.NombreCompleto,Cadena_Vacia)  != Cadena_Vacia
				THEN Cli.NombreCompleto
			WHEN IFNULL(Pro.NombreCompleto,Cadena_Vacia)  != Cadena_Vacia
				THEN Pro.NombreCompleto
		END AS GaranteNombre,
		LEFT(Gar.Observaciones,30) AS Observaciones
			FROM GARANTIAS Gar
			LEFT JOIN  CLIENTES Cli ON Gar.ClienteID = Cli.ClienteID
			LEFT JOIN  PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID
		WHERE GaranteNombre  LIKE CONCAT("%",Par_GaranteNombre,"%")
		 	OR Cli.NombreCompleto LIKE CONCAT("%",Par_GaranteNombre,"%")
			OR Pro.NombreCompleto LIKE CONCAT("%",Par_GaranteNombre,"%")
	 	LIMIT 0,15;
    END IF;


END TerminaStore$$