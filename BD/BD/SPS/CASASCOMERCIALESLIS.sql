-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASASCOMERCIALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASASCOMERCIALESLIS`;
DELIMITER $$

CREATE PROCEDURE `CASASCOMERCIALESLIS`(
	Par_NombreCasa		 	VARCHAR(200),		-- ID de la Casa Comercial
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		 	INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	 	BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE		Cadena_Vacia	CHAR(1);			-- Constante Cadena Vacia ''
DECLARE		Fecha_Vacia		DATE;				-- Constante Fecha Vacia '1900-01-01'
DECLARE		Entero_Cero		INT(11);			-- Constante Entero Cero 0
DECLARE		Lis_Principal	INT(11);			-- Lista Principal 1
DECLARE		Lis_CasaAct		INT(11);			-- Lista de Casas Activas 2
DECLARE		Est_Activo		CHAR(11);			-- Constante Estatus Activo 'A'

-- Seteo de Constantes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Lis_Principal			:= 1;
SET Lis_CasaAct				:= 2;
SET Est_Activo				:= 'A';

IF(Par_NumLis = Lis_Principal) THEN

	SELECT DISTINCT CAS.CasaComercialID, CAS.NombreCasaCom
	    FROM CASASCOMERCIALES CAS
	    WHERE CAS.NombreCasaCom	LIKE	CONCAT("%", Par_NombreCasa, "%")
	    LIMIT 0, 15;

END IF;

IF(Par_NumLis = Lis_CasaAct) THEN

	SELECT DISTINCT CAS.CasaComercialID, CAS.NombreCasaCom
	    FROM CASASCOMERCIALES CAS
	    WHERE CAS.NombreCasaCom	LIKE	CONCAT("%", Par_NombreCasa, "%")
	    	AND Estatus = Est_Activo
	    LIMIT 0, 15;

END IF;

END TerminaStore$$