-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGALISTASPLDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGALISTASPLDCON`;DELIMITER $$

CREATE PROCEDURE `CARGALISTASPLDCON`(

	Par_CargaListasID	INT(11),
    Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
			)
TerminaStore: BEGIN


DECLARE Var_FolioVig		INT;
DECLARE Var_FechaSistema	DATE;


DECLARE	Entero_Cero			INT;
DECLARE	Con_ListasNeg 		INT;
DECLARE	Con_ListasPBloq 	INT;
DECLARE	TipoLN			 	VARCHAR(3);
DECLARE	TipoLPB			 	VARCHAR(3);
DECLARE	EstEnProceso	 	CHAR(1);


SET	Entero_Cero			:= 0;
SET	Con_ListasNeg		:= 1;
SET	Con_ListasPBloq		:= 2;
SET	TipoLN				:= 'LN';
SET	TipoLPB				:= 'LPB';
SET	EstEnProceso		:= 'P';

SELECT FechaSistema INTO Var_FechaSistema
	FROM PARAMETROSSIS;


IF(Par_NumCon = Con_ListasNeg) THEN
	SELECT CargaListasID,		RutaArchivo,		FechaCarga,			Estatus
	  FROM CARGALISTASPLD
		WHERE TipoLista = TipoLN
			AND FechaCarga  = Var_FechaSistema
			AND Estatus=EstEnProceso;
END IF;


IF(Par_NumCon = Con_ListasPBloq) THEN
	SELECT CargaListasID,		RutaArchivo,		FechaCarga,			Estatus
	  FROM CARGALISTASPLD
		WHERE TipoLista = TipoLPB
			AND FechaCarga  = Var_FechaSistema
			AND Estatus=EstEnProceso;
END IF;

END TerminaStore$$