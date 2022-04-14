-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAASIGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCARTERAASIGLIS`;DELIMITER $$

CREATE PROCEDURE `COBCARTERAASIGLIS`(

	Par_NombreGestor	VARCHAR(45),
    Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Lis_Asigna		INT(11);
    DECLARE Est_A			VARCHAR(1);
    DECLARE Est_B			VARCHAR(1);
    DECLARE Est_Activo		VARCHAR(10);
    DECLARE Est_Baja		VARCHAR(10);


    SET Lis_Asigna	 	:= 1;
    SET Est_A			:= 'A';
    SET Est_B			:= 'B';
    SET Est_Activo		:= 'ACTIVO';
    SET Est_Baja		:= 'BAJA';

	IF(Par_NumLis = Lis_Asigna) THEN
		SELECT cob.FolioAsigID, ges.NombreCompleto, cob.FechaAsig
		FROM COBCARTERAASIG cob
			LEFT JOIN GESTORESCOBRANZA ges
				ON cob.GestorID = ges.GestorID
		WHERE ges.NombreCompleto  LIKE CONCAT("%", Par_NombreGestor, "%")
			AND cob.EstatusAsig = Est_A
		LIMIT 0,15;
	END IF;


END TerminaStore$$