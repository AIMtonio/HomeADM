-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASASCOMERCIALESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASASCOMERCIALESCON`;
DELIMITER $$

CREATE PROCEDURE `CASASCOMERCIALESCON`(
-- =====================================================================================
-- ----------------- SP PARA CONSULTAR LAS CASAS COMERCIALES  ---------------------
-- =====================================================================================
	Par_CasaID		INT,
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		 INT(11),
	Aud_NumTransaccion	 BIGINT(20)

	)
TerminaStore: BEGIN
-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Con_Principal	INT(11);
DECLARE	Con_Foranea		INT(11);

-- Seteo de Constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Con_Principal	:= 1;
SET	Con_Foranea		:= 2;

IF(Par_NumCon = Con_Principal) THEN
	SELECT CasaComercialID,		NombreCasaCom,		TipoDispersionCasa,		InstitucionID,
			CuentaCLABE,		Estatus,			RFC
	FROM CASASCOMERCIALES
	WHERE CasaComercialID = Par_CasaID;
END if;

END TerminaStore$$