-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPLDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPLDCON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSPLDCON`(

	Par_FolioID			INT(11),
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


DECLARE Var_FolioVig	INT;


DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_RepLimExc	INT;
DECLARE	Con_PorFolio	INT;
DECLARE	Con_FolioVig	INT;
DECLARE EstatusVig		CHAR(1);
DECLARE SiExiste		CHAR(1);
DECLARE NoExiste		CHAR(1);


SET	Entero_Cero			:= 0;
SET	Con_Principal		:= 1;
SET Con_RepLimExc		:= 2;
SET Con_PorFolio		:= 3;
SET Con_FolioVig		:= 4;
SET EstatusVig			:='V';
SET SiExiste			:='S';
SET NoExiste			:='N';


IF(Par_NumCon = Con_Principal) THEN
	SELECT
		FolioID, 	ClaveEntCasfim,		ClaveOrgSupervisor,	ClaveOrgSupervisorExt,	FechaVigencia,
        Estatus
	  FROM PARAMETROSPLD
		WHERE Estatus = EstatusVig;
END IF;


IF(Par_NumCon = Con_PorFolio) THEN
	SELECT IFNULL(FolioID,Entero_Cero) INTO Var_FolioVig
	  FROM PARAMETROSPLD
		WHERE Estatus = EstatusVig;

	SELECT
		FolioID, 	ClaveEntCasfim,		ClaveOrgSupervisor,	ClaveOrgSupervisorExt,	FechaVigencia,
        Estatus,    Var_FolioVig AS FolioVigente
	  FROM PARAMETROSPLD
		WHERE FolioID = Par_FolioID;
END IF;


IF(Par_NumCon = Con_FolioVig) THEN
	SELECT IFNULL(FolioID,Entero_Cero) INTO Var_FolioVig
	  FROM PARAMETROSPLD
		WHERE Estatus = EstatusVig;

	IF(Var_FolioVig!=Entero_Cero)THEN
		SELECT SiExiste AS FolioVigente, Var_FolioVig AS FolioID;
	ELSE
		SELECT NoExiste AS FolioVigente, Var_FolioVig AS FolioID;
    END IF;

END IF;

END TerminaStore$$