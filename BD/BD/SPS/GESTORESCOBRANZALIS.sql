-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GESTORESCOBRANZALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GESTORESCOBRANZALIS`;DELIMITER $$

CREATE PROCEDURE `GESTORESCOBRANZALIS`(
	Par_Nombre			VARCHAR(45),
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


    DECLARE Lis_Gestores	INT(11);
    DECLARE Est_A			VARCHAR(1);
    DECLARE Est_B			VARCHAR(1);
    DECLARE Est_Activo		VARCHAR(10);
    DECLARE Est_Baja		VARCHAR(10);
    DECLARE Gestor_Interno	CHAR(10);
    DECLARE Gestor_I		CHAR(1);
    DECLARE Gestor_Externo	CHAR(10);
    DECLARE Gestor_E		CHAR(1);


    SET Lis_Gestores 	:= 1;
    SET Est_A			:= 'A';
    SET Est_B			:= 'B';
    SET Est_Activo		:= 'ACTIVO';
    SET Est_Baja		:= 'BAJA';
    SET Gestor_Interno	:= 'INTERNO';
    SET Gestor_I		:= 'I';
    SET Gestor_Externo	:= 'EXTERNO';
    SET Gestor_E		:= 'E';

	IF(Par_NumLis = Lis_Gestores) THEN
		SELECT GestorID, NombreCompleto,
				CASE Estatus WHEN Est_A THEN Est_Activo WHEN Est_B THEN Est_Baja END AS Estatus,
                CASE TipoGestor WHEN Gestor_I THEN Gestor_Interno WHEN Gestor_E THEN Gestor_Externo END AS TipoGestor
			FROM GESTORESCOBRANZA
			WHERE  Nombre LIKE CONCAT("%", Par_Nombre, "%")
				OR ApellidoPaterno LIKE CONCAT("%", Par_Nombre, "%")
				OR ApellidoMaterno LIKE CONCAT("%", Par_Nombre, "%")
			ORDER BY Estatus
			LIMIT 0,15;
	END IF;


END TerminaStore$$